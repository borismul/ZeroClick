import Flutter
import UIKit
import AVFoundation
import CoreLocation

@main
@objc class AppDelegate: FlutterAppDelegate, CLLocationManagerDelegate {
    private var carPlayChannel: FlutterMethodChannel?
    private var bluetoothChannel: FlutterMethodChannel?
    private var backgroundChannel: FlutterMethodChannel?
    private var isCarPlayConnected = false
    private var lastBluetoothDevice: String?
    private var locationManager: CLLocationManager?
    private var wasBluetoothConnected = false

    // API config - loaded from Flutter
    private var apiBaseUrl: String?
    private var userEmail: String?
    private var lastApiCallTime: Date?
    private var lastPingTime: Date?

    // Active trip tracking
    private var isActivelyTracking = false
    private var pingTimer: Timer?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)

        // Check if we were launched due to a location event
        let launchedForLocation = launchOptions?[.location] != nil
        if launchedForLocation {
            print("[Background] App launched by iOS for location update!")
        }

        // Setup channels
        if let controller = window?.rootViewController as? FlutterViewController {
            carPlayChannel = FlutterMethodChannel(
                name: "nl.borism.mileage/carplay",
                binaryMessenger: controller.binaryMessenger
            )

            carPlayChannel?.setMethodCallHandler { [weak self] (call, result) in
                if call.method == "isCarPlayConnected" {
                    result(self?.isCarPlayConnected ?? false)
                } else {
                    result(FlutterMethodNotImplemented)
                }
            }

            bluetoothChannel = FlutterMethodChannel(
                name: "nl.borism.mileage/bluetooth",
                binaryMessenger: controller.binaryMessenger
            )

            bluetoothChannel?.setMethodCallHandler { [weak self] (call, result) in
                if call.method == "getConnectedDevice" {
                    result(self?.getBluetoothDeviceName())
                } else if call.method == "isBluetoothConnected" {
                    result(self?.lastBluetoothDevice != nil)
                } else {
                    result(FlutterMethodNotImplemented)
                }
            }

            backgroundChannel = FlutterMethodChannel(
                name: "nl.borism.mileage/background",
                binaryMessenger: controller.binaryMessenger
            )

            backgroundChannel?.setMethodCallHandler { [weak self] (call, result) in
                switch call.method {
                case "startBackgroundMonitoring":
                    self?.startBackgroundLocationMonitoring()
                    result(true)
                case "stopBackgroundMonitoring":
                    self?.stopBackgroundLocationMonitoring()
                    result(true)
                case "startActiveTracking":
                    self?.startActiveTracking()
                    result(true)
                case "stopActiveTracking":
                    self?.stopActiveTracking()
                    result(true)
                case "isMonitoring":
                    result(self?.locationManager != nil)
                case "isActivelyTracking":
                    result(self?.isActivelyTracking ?? false)
                case "setApiConfig":
                    if let args = call.arguments as? [String: Any],
                       let baseUrl = args["baseUrl"] as? String,
                       let email = args["userEmail"] as? String {
                        self?.apiBaseUrl = baseUrl
                        self?.userEmail = email
                        // Also save to UserDefaults for persistence
                        UserDefaults.standard.set(baseUrl, forKey: "api_base_url")
                        UserDefaults.standard.set(email, forKey: "user_email")
                        print("[Native] API config set: \(baseUrl), \(email)")
                        result(true)
                    } else {
                        result(false)
                    }
                default:
                    result(FlutterMethodNotImplemented)
                }
            }

            // Load saved API config
            apiBaseUrl = UserDefaults.standard.string(forKey: "api_base_url")
            userEmail = UserDefaults.standard.string(forKey: "user_email")
        }

        // Setup audio session for Bluetooth detection
        setupAudioSession()

        // Listen for screen connect/disconnect (CarPlay)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(screenDidConnect),
            name: UIScreen.didConnectNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(screenDidDisconnect),
            name: UIScreen.didDisconnectNotification,
            object: nil
        )

        // Check if CarPlay is already connected
        checkCarPlayStatus()

        // Start background location monitoring
        startBackgroundLocationMonitoring()

        // Check Bluetooth immediately on launch
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.checkBluetoothAndNotify()
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    // MARK: - Background Location Monitoring

    private func startBackgroundLocationMonitoring() {
        if locationManager != nil {
            print("[Background] Location monitoring already active")
            return
        }

        print("[Background] Starting background location monitoring...")

        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.allowsBackgroundLocationUpdates = true
        locationManager?.pausesLocationUpdatesAutomatically = false
        locationManager?.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager?.distanceFilter = 100

        let status: CLAuthorizationStatus
        if #available(iOS 14.0, *) {
            status = locationManager?.authorizationStatus ?? .notDetermined
        } else {
            status = CLLocationManager.authorizationStatus()
        }

        if status == .notDetermined {
            locationManager?.requestAlwaysAuthorization()
        } else if status == .authorizedAlways || status == .authorizedWhenInUse {
            locationManager?.startMonitoringSignificantLocationChanges()
            locationManager?.startUpdatingLocation()
            print("[Background] Location monitoring started")
        }
    }

    private func stopBackgroundLocationMonitoring() {
        print("[Background] Stopping background location monitoring")
        locationManager?.stopMonitoringSignificantLocationChanges()
        locationManager?.stopUpdatingLocation()
        locationManager = nil
    }

    // MARK: - Active Trip Tracking (continuous GPS during trip)

    private func startActiveTracking() {
        guard !isActivelyTracking else {
            print("[ActiveTracking] Already tracking")
            return
        }

        print("[ActiveTracking] Starting active trip tracking...")
        isActivelyTracking = true

        // Upgrade location manager for continuous tracking
        locationManager?.stopUpdatingLocation()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.distanceFilter = kCLDistanceFilterNone  // Continuous updates
        locationManager?.activityType = .automotiveNavigation

        if #available(iOS 11.0, *) {
            locationManager?.showsBackgroundLocationIndicator = true  // Blue bar - keeps app alive!
        }

        locationManager?.startUpdatingLocation()

        // Start ping timer - send location every 60 seconds
        pingTimer?.invalidate()
        pingTimer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { [weak self] _ in
            self?.sendPingFromNative()
        }

        // Send initial ping
        sendPingFromNative()

        print("[ActiveTracking] Active tracking started with blue bar indicator")
    }

    private func stopActiveTracking() {
        guard isActivelyTracking else {
            print("[ActiveTracking] Not tracking")
            return
        }

        print("[ActiveTracking] Stopping active tracking...")
        isActivelyTracking = false

        // Stop ping timer
        pingTimer?.invalidate()
        pingTimer = nil

        // Downgrade to passive monitoring
        locationManager?.stopUpdatingLocation()
        locationManager?.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager?.distanceFilter = 100

        if #available(iOS 11.0, *) {
            locationManager?.showsBackgroundLocationIndicator = false
        }

        locationManager?.startMonitoringSignificantLocationChanges()
        locationManager?.startUpdatingLocation()

        print("[ActiveTracking] Reverted to passive monitoring")
    }

    private func sendPingFromNative() {
        guard isActivelyTracking else { return }
        guard let location = locationManager?.location else {
            print("[ActiveTracking] No location available for ping")
            return
        }

        // Debounce - don't ping more than once per 50 seconds
        if let lastPing = lastPingTime, Date().timeIntervalSince(lastPing) < 50 {
            print("[ActiveTracking] Ping debounced")
            return
        }
        lastPingTime = Date()

        let lat = location.coordinate.latitude
        let lng = location.coordinate.longitude

        print("[ActiveTracking] Sending ping: \(lat), \(lng)")
        callPingAPI(lat: lat, lng: lng)

        // Also notify Flutter if it's alive
        backgroundChannel?.invokeMethod("onLocationUpdate", arguments: [
            "latitude": lat,
            "longitude": lng
        ])
    }

    private func callPingAPI(lat: Double, lng: Double) {
        guard let baseUrl = apiBaseUrl, let email = userEmail, !email.isEmpty else {
            print("[Native API] No API config for ping")
            return
        }

        let urlString = "\(baseUrl)/webhook/ping?user=\(email.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? email)"

        guard let url = URL(string: urlString) else {
            print("[Native API] Invalid ping URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["lat": lat, "lng": lng]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        print("[Native API] Ping: \(lat), \(lng)")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("[Native API] Ping error: \(error.localizedDescription)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("[Native API] Ping response: \(httpResponse.statusCode)")

                // Check if trip ended
                if let data = data,
                   let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let status = json["status"] as? String {
                    if status == "finalized" || status == "cancelled" || status == "skipped" {
                        print("[Native API] Trip ended: \(status)")
                        DispatchQueue.main.async { [weak self] in
                            self?.stopActiveTracking()
                            self?.backgroundChannel?.invokeMethod("onTripEnded", arguments: ["status": status])
                        }
                    }
                }
            }
        }
        task.resume()
    }

    // MARK: - CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        print("[Background] Location update: \(location.coordinate.latitude), \(location.coordinate.longitude)")

        // Check Bluetooth status on every location update
        checkBluetoothAndNotify()

        // Also check CarPlay
        checkCarPlayStatus()
        if isCarPlayConnected {
            print("[Background] CarPlay is connected!")
            carPlayChannel?.invokeMethod("onCarPlayConnected", arguments: nil)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("[Background] Location error: \(error.localizedDescription)")
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status: CLAuthorizationStatus
        if #available(iOS 14.0, *) {
            status = manager.authorizationStatus
        } else {
            status = CLLocationManager.authorizationStatus()
        }
        print("[Background] Authorization changed: \(status.rawValue)")

        if status == .authorizedAlways || status == .authorizedWhenInUse {
            manager.startMonitoringSignificantLocationChanges()
            manager.startUpdatingLocation()
            print("[Background] Location monitoring started after authorization")
        }
    }

    // MARK: - Bluetooth Check

    private func checkBluetoothAndNotify() {
        let deviceName = getBluetoothDeviceName()
        let isConnected = deviceName != nil

        print("[Background] Bluetooth check - Device: \(deviceName ?? "none"), wasConnected: \(wasBluetoothConnected), isConnected: \(isConnected)")

        if isConnected && !wasBluetoothConnected {
            print("[Background] Bluetooth just connected to: \(deviceName!)")
            lastBluetoothDevice = deviceName
            wasBluetoothConnected = true

            let lat = locationManager?.location?.coordinate.latitude ?? 0
            let lng = locationManager?.location?.coordinate.longitude ?? 0

            // DIRECT API CALL - doesn't rely on Flutter being awake
            callStartTripAPI(deviceName: deviceName!, lat: lat, lng: lng)

            // Start active tracking for continuous GPS during trip
            startActiveTracking()

            // Also try Flutter (might be awake)
            bluetoothChannel?.invokeMethod("onBluetoothConnected", arguments: ["deviceName": deviceName!])
            backgroundChannel?.invokeMethod("onCarDetected", arguments: [
                "deviceName": deviceName!,
                "latitude": lat,
                "longitude": lng
            ])
        } else if !isConnected && wasBluetoothConnected {
            print("[Background] Bluetooth disconnected")
            lastBluetoothDevice = nil
            wasBluetoothConnected = false
            bluetoothChannel?.invokeMethod("onBluetoothDisconnected", arguments: nil)
        }
    }

    private func checkCarPlayStatus() {
        isCarPlayConnected = UIScreen.screens.count > 1
    }

    @objc private func screenDidConnect(_ notification: Notification) {
        guard let screen = notification.object as? UIScreen else { return }
        if screen != UIScreen.main {
            isCarPlayConnected = true
            print("CarPlay connected!")
            carPlayChannel?.invokeMethod("onCarPlayConnected", arguments: nil)
        }
    }

    @objc private func screenDidDisconnect(_ notification: Notification) {
        guard let screen = notification.object as? UIScreen else { return }
        if screen != UIScreen.main {
            isCarPlayConnected = false
            print("CarPlay disconnected!")
            carPlayChannel?.invokeMethod("onCarPlayDisconnected", arguments: nil)
        }
    }

    // MARK: - Bluetooth Audio Detection

    private func setupAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playAndRecord, options: [.allowBluetooth, .allowBluetoothA2DP, .mixWithOthers])
            try session.setActive(true)

            NotificationCenter.default.addObserver(
                self,
                selector: #selector(audioRouteChanged),
                name: AVAudioSession.routeChangeNotification,
                object: nil
            )

            checkBluetoothConnection()
        } catch {
            print("Failed to setup audio session: \(error)")
        }
    }

    private func checkBluetoothConnection() {
        let deviceName = getBluetoothDeviceName()
        if deviceName != lastBluetoothDevice {
            lastBluetoothDevice = deviceName
            wasBluetoothConnected = deviceName != nil
            if let name = deviceName {
                print("Bluetooth connected: \(name)")
                bluetoothChannel?.invokeMethod("onBluetoothConnected", arguments: ["deviceName": name])
            } else if lastBluetoothDevice != nil {
                print("Bluetooth disconnected")
                bluetoothChannel?.invokeMethod("onBluetoothDisconnected", arguments: nil)
            }
        }
    }

    private func getBluetoothDeviceName() -> String? {
        let session = AVAudioSession.sharedInstance()
        let currentRoute = session.currentRoute

        for output in currentRoute.outputs {
            let portType = output.portType
            if portType == .bluetoothA2DP || portType == .bluetoothHFP || portType == .bluetoothLE || portType == .carAudio {
                return output.portName
            }
        }

        for input in currentRoute.inputs {
            let portType = input.portType
            if portType == .bluetoothHFP {
                return input.portName
            }
        }

        return nil
    }

    @objc private func audioRouteChanged(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
              let reason = AVAudioSession.RouteChangeReason(rawValue: reasonValue) else {
            return
        }

        switch reason {
        case .newDeviceAvailable, .oldDeviceUnavailable, .categoryChange, .override, .routeConfigurationChange:
            checkBluetoothConnection()
            checkBluetoothAndNotify()
        default:
            break
        }
    }

    // MARK: - Direct API Call (bypasses Flutter for reliability)

    private func callStartTripAPI(deviceName: String, lat: Double, lng: Double) {
        guard let baseUrl = apiBaseUrl, let email = userEmail, !email.isEmpty else {
            print("[Native API] No API config set, skipping direct call")
            return
        }

        // Debounce - don't call more than once per 30 seconds
        if let lastCall = lastApiCallTime, Date().timeIntervalSince(lastCall) < 30 {
            print("[Native API] Debounced - called recently")
            return
        }
        lastApiCallTime = Date()

        let urlString = "\(baseUrl)/webhook/start?user=\(email.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? email)&device_id=\(deviceName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? deviceName)"

        guard let url = URL(string: urlString) else {
            print("[Native API] Invalid URL: \(urlString)")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(email, forHTTPHeaderField: "X-User-Email")

        let body: [String: Any] = ["lat": lat, "lng": lng]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        print("[Native API] Calling: \(urlString)")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("[Native API] Error: \(error.localizedDescription)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("[Native API] Response: \(httpResponse.statusCode)")
                if let data = data, let body = String(data: data, encoding: .utf8) {
                    print("[Native API] Body: \(body)")
                }
            }
        }
        task.resume()
    }
}
