import Flutter
import UIKit
import CoreLocation
import CoreMotion

@main
@objc class AppDelegate: FlutterAppDelegate, CLLocationManagerDelegate {

    // MARK: - Properties
    private var backgroundChannel: FlutterMethodChannel?
    private var locationManager: CLLocationManager!
    private var motionManager: CMMotionActivityManager!

    // API config
    private var apiBaseUrl: String?
    private var userEmail: String?

    // Drive state
    private var isDriving = false
    private var isActivelyTracking = false
    private var lastLocation: CLLocation?
    private var driveStartTime: Date?
    private var pingTimer: Timer?

    // Debounce
    private var lastApiCallTime: Date?
    private var lastPingTime: Date?

    // MARK: - App Lifecycle

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)

        // Check if launched for location
        if launchOptions?[.location] != nil {
            print("[App] Launched by iOS for location update")
        }

        // Setup Flutter channel
        if let controller = window?.rootViewController as? FlutterViewController {
            backgroundChannel = FlutterMethodChannel(
                name: "nl.borism.mileage/background",
                binaryMessenger: controller.binaryMessenger
            )

            backgroundChannel?.setMethodCallHandler { [weak self] (call, result) in
                switch call.method {
                case "setApiConfig":
                    if let args = call.arguments as? [String: Any],
                       let baseUrl = args["baseUrl"] as? String,
                       let email = args["userEmail"] as? String {
                        self?.apiBaseUrl = baseUrl
                        self?.userEmail = email
                        UserDefaults.standard.set(baseUrl, forKey: "api_base_url")
                        UserDefaults.standard.set(email, forKey: "user_email")
                        print("[Config] API: \(baseUrl), User: \(email)")
                        result(true)
                    } else {
                        result(false)
                    }
                case "startBackgroundMonitoring":
                    self?.startMonitoring()
                    result(true)
                case "stopBackgroundMonitoring":
                    self?.stopMonitoring()
                    result(true)
                case "isMonitoring":
                    result(self?.locationManager != nil)
                case "isActivelyTracking":
                    result(self?.isActivelyTracking ?? false)
                default:
                    result(FlutterMethodNotImplemented)
                }
            }
        }

        // Load saved config
        apiBaseUrl = UserDefaults.standard.string(forKey: "api_base_url")
        userEmail = UserDefaults.standard.string(forKey: "user_email")

        // Start monitoring
        setupLocationManager()
        setupMotionManager()
        startMonitoring()

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    // MARK: - Location Manager Setup

    private func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.activityType = .automotiveNavigation

        // Start with low accuracy to save battery
        setLowAccuracy()
    }

    private func setHighAccuracy() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = kCLDistanceFilterNone
        if #available(iOS 11.0, *) {
            locationManager.showsBackgroundLocationIndicator = true
        }
        print("[Location] High accuracy mode")
    }

    private func setLowAccuracy() {
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.distanceFilter = 500
        if #available(iOS 11.0, *) {
            locationManager.showsBackgroundLocationIndicator = false
        }
        print("[Location] Low accuracy mode (battery saver)")
    }

    // MARK: - Motion Manager Setup

    private func setupMotionManager() {
        motionManager = CMMotionActivityManager()
    }

    // MARK: - Monitoring

    private func startMonitoring() {
        print("[Monitor] Starting...")

        // Request location permission
        let status: CLAuthorizationStatus
        if #available(iOS 14.0, *) {
            status = locationManager.authorizationStatus
        } else {
            status = CLLocationManager.authorizationStatus()
        }

        if status == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        } else if status == .authorizedAlways || status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            locationManager.startMonitoringSignificantLocationChanges()
            startMotionUpdates()
            print("[Monitor] Location updates started")
        }
    }

    private func stopMonitoring() {
        print("[Monitor] Stopping...")
        locationManager.stopUpdatingLocation()
        locationManager.stopMonitoringSignificantLocationChanges()
        motionManager.stopActivityUpdates()
        stopDriveTracking()
    }

    private func startMotionUpdates() {
        guard CMMotionActivityManager.isActivityAvailable() else {
            print("[Motion] Activity not available on this device")
            return
        }

        motionManager.startActivityUpdates(to: .main) { [weak self] activity in
            guard let activity = activity else { return }
            self?.handleMotionActivity(activity)
        }
        print("[Motion] Activity updates started")
    }

    // MARK: - Motion Activity Handling

    private func handleMotionActivity(_ activity: CMMotionActivity) {
        let wasdriving = isDriving

        if activity.automotive && activity.confidence != .low {
            isDriving = true
            if !wasdriving {
                print("[Motion] Started DRIVING")
                startDriveTracking()
            }
        } else if activity.stationary && activity.confidence != .low {
            if isDriving {
                print("[Motion] Stopped driving (stationary)")
                // Don't immediately stop - wait for a few stationary readings
                // The backend handles this via parked_count
            }
        } else if (activity.walking || activity.running) && activity.confidence != .low {
            if isDriving {
                print("[Motion] Stopped driving (walking/running)")
                isDriving = false
                stopDriveTracking()
            }
        }
    }

    // MARK: - Drive Tracking

    private func startDriveTracking() {
        guard !isActivelyTracking else {
            print("[Drive] Already tracking")
            return
        }

        isActivelyTracking = true
        driveStartTime = Date()

        // Switch to high accuracy FIRST
        setHighAccuracy()

        // Wait 2 sec for fresh GPS before first ping
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            guard let self = self, self.isActivelyTracking else { return }
            if let location = self.locationManager.location {
                self.callStartTripAPI(lat: location.coordinate.latitude, lng: location.coordinate.longitude)
            }
        }

        // Start ping timer
        pingTimer?.invalidate()
        pingTimer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { [weak self] _ in
            self?.sendPing()
        }

        // Notify Flutter
        backgroundChannel?.invokeMethod("onCarDetected", arguments: [
            "deviceName": "Motion",
            "latitude": lastLocation?.coordinate.latitude ?? 0,
            "longitude": lastLocation?.coordinate.longitude ?? 0
        ])

        print("[Drive] Tracking started")
    }

    private func stopDriveTracking() {
        guard isActivelyTracking else { return }

        isActivelyTracking = false
        pingTimer?.invalidate()
        pingTimer = nil
        setLowAccuracy()

        // Send end event
        if let location = lastLocation ?? locationManager.location {
            callEndTripAPI(lat: location.coordinate.latitude, lng: location.coordinate.longitude)
        }

        // Notify Flutter
        backgroundChannel?.invokeMethod("onTripEnded", arguments: ["status": "ended"])

        print("[Drive] Tracking stopped")
    }

    private func sendPing() {
        guard isActivelyTracking else { return }
        guard let location = locationManager.location else {
            print("[Ping] No location available")
            return
        }

        // Debounce
        if let lastPing = lastPingTime, Date().timeIntervalSince(lastPing) < 50 {
            return
        }
        lastPingTime = Date()

        callPingAPI(lat: location.coordinate.latitude, lng: location.coordinate.longitude)

        // Also notify Flutter
        backgroundChannel?.invokeMethod("onLocationUpdate", arguments: [
            "latitude": location.coordinate.latitude,
            "longitude": location.coordinate.longitude
        ])
    }

    // MARK: - CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        lastLocation = location

        // During active tracking, send pings on significant movement
        if isActivelyTracking {
            sendPing()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("[Location] Error: \(error.localizedDescription)")
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status: CLAuthorizationStatus
        if #available(iOS 14.0, *) {
            status = manager.authorizationStatus
        } else {
            status = CLLocationManager.authorizationStatus()
        }
        print("[Location] Authorization: \(status.rawValue)")

        if status == .authorizedAlways || status == .authorizedWhenInUse {
            manager.startUpdatingLocation()
            manager.startMonitoringSignificantLocationChanges()
            startMotionUpdates()
        }
    }

    // MARK: - API Calls

    private func callStartTripAPI(lat: Double, lng: Double) {
        guard let baseUrl = apiBaseUrl, let email = userEmail, !email.isEmpty else {
            print("[API] No config")
            return
        }

        // Debounce
        if let lastCall = lastApiCallTime, Date().timeIntervalSince(lastCall) < 30 {
            print("[API] Debounced")
            return
        }
        lastApiCallTime = Date()

        let urlString = "\(baseUrl)/webhook/ping?user=\(email.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? email)"
        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: ["lat": lat, "lng": lng])

        print("[API] Start trip: \(lat), \(lng)")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("[API] Error: \(error.localizedDescription)")
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("[API] Response: \(httpResponse.statusCode)")
            }
        }.resume()
    }

    private func callPingAPI(lat: Double, lng: Double) {
        guard let baseUrl = apiBaseUrl, let email = userEmail, !email.isEmpty else { return }

        let urlString = "\(baseUrl)/webhook/ping?user=\(email.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? email)"
        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: ["lat": lat, "lng": lng])

        print("[API] Ping: \(lat), \(lng)")

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                print("[API] Ping error: \(error.localizedDescription)")
                return
            }

            // Check if trip ended by backend
            if let data = data,
               let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let status = json["status"] as? String {
                if status == "finalized" || status == "cancelled" || status == "skipped" {
                    print("[API] Trip ended by backend: \(status)")
                    DispatchQueue.main.async {
                        self?.isDriving = false
                        self?.stopDriveTracking()
                    }
                }
            }
        }.resume()
    }

    private func callEndTripAPI(lat: Double, lng: Double) {
        guard let baseUrl = apiBaseUrl, let email = userEmail, !email.isEmpty else { return }

        let urlString = "\(baseUrl)/webhook/end?user=\(email.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? email)"
        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: ["lat": lat, "lng": lng])

        print("[API] End trip: \(lat), \(lng)")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("[API] End error: \(error.localizedDescription)")
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("[API] End response: \(httpResponse.statusCode)")
            }
        }.resume()
    }
}
