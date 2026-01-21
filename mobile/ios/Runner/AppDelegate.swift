import Flutter
import UIKit
import CoreLocation
import UserNotifications
import OSLog

@main
@objc class AppDelegate: FlutterAppDelegate {

    // MARK: - Services

    private var locationService: LocationTrackingServiceProtocol!
    private var motionHandler: MotionActivityHandlerProtocol!
    private var liveActivityManager: LiveActivityManagerProtocol!
    private var watchService: WatchConnectivityServiceProtocol!

    // MARK: - Flutter Channels

    private var backgroundChannel: FlutterMethodChannel?
    private var debugChannel: FlutterMethodChannel?

    // MARK: - API Config

    private var apiBaseUrl: String?
    private var userEmail: String?
    private var activeCarId: String?  // Set by Flutter when Bluetooth identifies car

    // MARK: - Drive State

    private var isDriving = false
    private var isActivelyTracking = false
    private var lastLocation: CLLocation?
    private var driveStartTime: Date?
    private var pingTimer: Timer?
    private var totalDistanceMeters: Double = 0

    // MARK: - Debounce

    private var lastApiCallTime: Date?
    private var lastPingTime: Date?

    // MARK: - Debug Logging

    private func debugLog(_ tag: String, _ message: String) {
        // Use appropriate logger based on tag
        switch tag {
        case "Drive", "Trip":
            Logger.trip.info("\(message)")
        case "Motion":
            Logger.motion.debug("\(message)")
        case "Location":
            Logger.location.debug("\(message)")
        case "API":
            Logger.api.debug("\(message)")
        case "App", "Monitor", "Config", "Notification":
            Logger.app.info("\(message)")
        default:
            Logger.app.debug("[\(tag)] \(message)")
        }
        DispatchQueue.main.async { [weak self] in
            self?.debugChannel?.invokeMethod("log", arguments: [
                "tag": tag,
                "message": message
            ])
        }
    }

    // MARK: - App Lifecycle

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)

        // Set notification center delegate for flutter_local_notifications
        UNUserNotificationCenter.current().delegate = self

        // Check if launched for location
        if launchOptions?[.location] != nil {
            Logger.app.info("Launched by iOS for location update")
        }

        // Setup Flutter channels
        if let controller = window?.rootViewController as? FlutterViewController {
            setupFlutterChannels(controller: controller)
        }

        // Load saved config
        apiBaseUrl = UserDefaults.standard.string(forKey: "api_base_url")
        userEmail = UserDefaults.standard.string(forKey: "user_email")

        // Setup services
        setupServices()

        // Only start monitoring if onboarding already complete
        let onboardingComplete = UserDefaults.standard.bool(forKey: "flutter.onboarding_complete")
        if onboardingComplete {
            startServices()
        } else {
            Logger.app.info("Waiting for onboarding to complete")
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    // MARK: - Flutter Channel Setup

    private func setupFlutterChannels(controller: FlutterViewController) {
        // Debug channel for sending logs to Flutter
        debugChannel = FlutterMethodChannel(
            name: "com.zeroclick/debug",
            binaryMessenger: controller.binaryMessenger
        )

        backgroundChannel = FlutterMethodChannel(
            name: "com.zeroclick/background",
            binaryMessenger: controller.binaryMessenger
        )

        backgroundChannel?.setMethodCallHandler { [weak self] (call, result) in
            switch call.method {
            case "setApiConfig":
                self?.handleSetApiConfig(call: call, result: result)
            case "setAuthToken":
                self?.handleSetAuthToken(call: call, result: result)
            case "startBackgroundMonitoring":
                self?.startServices()
                result(true)
            case "stopBackgroundMonitoring":
                self?.stopServices()
                result(true)
            case "isMonitoring":
                result(self?.locationService?.isMonitoring ?? false)
            case "isActivelyTracking":
                result(self?.isActivelyTracking ?? false)
            case "setActiveCarId":
                if let args = call.arguments as? [String: Any] {
                    self?.activeCarId = args["carId"] as? String
                    Logger.app.info("Active car ID: \(self?.activeCarId ?? "nil", privacy: .public)")
                    result(true)
                } else {
                    result(false)
                }
            case "notifyWatchTripStarted":
                self?.watchService.notifyTripStarted()
                result(true)
            case "startTrip":
                // Flutter already shows notification, skip native one
                self?.startDriveTracking(showNotification: false)
                result(true)
            case "endTrip":
                self?.stopDriveTracking()
                result(true)
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }

    private func handleSetApiConfig(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let baseUrl = args["baseUrl"] as? String,
              let email = args["userEmail"] as? String else {
            result(false)
            return
        }

        apiBaseUrl = baseUrl
        userEmail = email
        UserDefaults.standard.set(baseUrl, forKey: "api_base_url")
        UserDefaults.standard.set(email, forKey: "user_email")
        // Save email to iCloud Keychain (syncs to Watch)
        KeychainHelper.shared.saveEmail(email)
        // Sync to Watch via WatchConnectivity (token will be sent separately)
        watchService.syncConfig(email: email, apiUrl: baseUrl, token: nil)
        Logger.app.info("API config set: \(baseUrl, privacy: .public), User: \(email, privacy: .private)")
        result(true)
    }

    private func handleSetAuthToken(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let token = args["token"] as? String else {
            result(false)
            return
        }

        // Save access token to iCloud Keychain (syncs to Watch automatically)
        if token.isEmpty {
            KeychainHelper.shared.deleteToken()
        } else {
            KeychainHelper.shared.saveToken(token)
        }
        // Save refresh token if provided
        if let refreshToken = args["refreshToken"] as? String {
            if refreshToken.isEmpty {
                KeychainHelper.shared.deleteRefreshToken()
            } else {
                KeychainHelper.shared.saveRefreshToken(refreshToken)
            }
            Logger.api.info("Access + refresh tokens saved to iCloud Keychain")
        } else {
            Logger.api.info("Access token saved to iCloud Keychain")
        }
        result(true)
    }

    // MARK: - Service Setup

    private func setupServices() {
        // Create services
        locationService = LocationTrackingService()
        locationService.delegate = self

        motionHandler = MotionActivityHandler()
        motionHandler.delegate = self

        liveActivityManager = createLiveActivityManager()

        watchService = WatchConnectivityService()
        watchService.delegate = self
        watchService.setup()
    }

    private func startServices() {
        locationService.setupLocationManager()
        motionHandler.setupMotionManager()
        locationService.startMonitoring()
        motionHandler.startActivityUpdates()
        Logger.app.info("Background services started")
    }

    private func stopServices() {
        locationService.stopMonitoring()
        motionHandler.stopActivityUpdates()
        stopDriveTracking()
        Logger.app.info("Background services stopped")
    }

    // MARK: - Notifications

    private func showTripStartedNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Rit wordt getrackt"
        content.body = "Je rit wordt nu automatisch geregistreerd"
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: "trip_tracking_\(UUID().uuidString)",
            content: content,
            trigger: nil  // Show immediately
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                self.debugLog("Notification", "Failed to show notification: \(error)")
            } else {
                self.debugLog("Notification", "Trip tracking notification shown")
            }
        }
    }

    // MARK: - Drive Tracking

    private func startDriveTracking(showNotification: Bool = true) {
        debugLog("Drive", "startDriveTracking() called, isActivelyTracking: \(isActivelyTracking)")

        guard !isActivelyTracking else {
            debugLog("Drive", "Already tracking - skipping")
            return
        }

        isActivelyTracking = true
        driveStartTime = Date()
        totalDistanceMeters = 0

        // Switch to high accuracy FIRST
        locationService.setHighAccuracy()

        // Show push notification for trip tracking (skip if Flutter already showed one)
        if showNotification {
            showTripStartedNotification()
        }

        debugLog("Drive", "Starting Live Activity...")
        // Start Live Activity (shows on Lock Screen + Dynamic Island + Watch Smart Stack)
        liveActivityManager.startActivity(carName: activeCarId ?? "Auto", startTime: driveStartTime ?? Date())

        // Wait 2 sec for fresh GPS before first ping
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            guard let self = self, self.isActivelyTracking else { return }
            if let location = self.locationService.lastLocation {
                self.callStartTripAPI(lat: location.coordinate.latitude, lng: location.coordinate.longitude)
            }
        }

        // Start ping timer - 15s for better GPS trail resolution
        pingTimer?.invalidate()
        pingTimer = Timer.scheduledTimer(withTimeInterval: 15.0, repeats: true) { [weak self] _ in
            self?.sendPing()
        }

        // Notify Flutter
        backgroundChannel?.invokeMethod("onCarDetected", arguments: [
            "deviceName": "Motion",
            "latitude": lastLocation?.coordinate.latitude ?? 0,
            "longitude": lastLocation?.coordinate.longitude ?? 0
        ])

        debugLog("Drive", "Tracking started")
    }

    private func stopDriveTracking() {
        guard isActivelyTracking else { return }

        debugLog("Drive", "stopDriveTracking() called")

        isActivelyTracking = false
        pingTimer?.invalidate()
        pingTimer = nil
        locationService.setLowAccuracy()

        // End Live Activity
        liveActivityManager.endActivity()

        // Send end event
        if let location = lastLocation ?? locationService.lastLocation {
            callEndTripAPI(lat: location.coordinate.latitude, lng: location.coordinate.longitude)
        }

        // Notify Flutter
        backgroundChannel?.invokeMethod("onTripEnded", arguments: ["status": "ended"])

        debugLog("Drive", "Tracking stopped")
    }

    private func sendPing() {
        guard isActivelyTracking else { return }
        guard let location = locationService.lastLocation else {
            Logger.location.debug("No location available for ping")
            return
        }

        // Debounce - 12s (80% of 15s ping interval)
        if let lastPing = lastPingTime, Date().timeIntervalSince(lastPing) < 12 {
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

    // MARK: - API Calls

    private func callStartTripAPI(lat: Double, lng: Double) {
        guard let baseUrl = apiBaseUrl, let email = userEmail, !email.isEmpty else {
            Logger.api.warning("No API config available")
            return
        }

        // Debounce
        if let lastCall = lastApiCallTime, Date().timeIntervalSince(lastCall) < 30 {
            Logger.api.debug("Start trip debounced")
            return
        }
        lastApiCallTime = Date()

        var urlString = "\(baseUrl)/webhook/ping?user=\(email.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? email)"
        // Add car_id if known (from Bluetooth detection)
        if let carId = activeCarId {
            urlString += "&car_id=\(carId.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? carId)"
        }
        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // Add Bearer token for authentication
        if let token = KeychainHelper.shared.getToken(), !token.isEmpty {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        request.httpBody = try? JSONSerialization.data(withJSONObject: ["lat": lat, "lng": lng])

        Logger.api.info("Start trip: \(lat, privacy: .public), \(lng, privacy: .public)")

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                Logger.api.error("Start trip error: \(error.localizedDescription)")
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                Logger.api.debug("Start trip response: \(httpResponse.statusCode)")
                if httpResponse.statusCode == 200 {
                    // Notify watch that trip started
                    self?.watchService.notifyTripStarted()
                }
            }
        }.resume()
    }

    private func callPingAPI(lat: Double, lng: Double) {
        guard let baseUrl = apiBaseUrl, let email = userEmail, !email.isEmpty else { return }

        var urlString = "\(baseUrl)/webhook/ping?user=\(email.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? email)"
        if let carId = activeCarId {
            urlString += "&car_id=\(carId.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? carId)"
        }
        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // Add Bearer token for authentication
        if let token = KeychainHelper.shared.getToken(), !token.isEmpty {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        request.httpBody = try? JSONSerialization.data(withJSONObject: ["lat": lat, "lng": lng])

        Logger.api.debug("Ping: \(lat, privacy: .public), \(lng, privacy: .public)")

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                Logger.api.error("Ping error: \(error.localizedDescription)")
                return
            }

            // Check if trip ended by backend
            if let data = data,
               let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let status = json["status"] as? String {
                if status == "finalized" || status == "cancelled" || status == "skipped" {
                    Logger.api.info("Trip ended by backend: \(status, privacy: .public)")
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

        var urlString = "\(baseUrl)/webhook/end?user=\(email.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? email)"
        if let carId = activeCarId {
            urlString += "&car_id=\(carId.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? carId)"
        }
        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // Add Bearer token for authentication
        if let token = KeychainHelper.shared.getToken(), !token.isEmpty {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        request.httpBody = try? JSONSerialization.data(withJSONObject: ["lat": lat, "lng": lng])

        Logger.api.info("End trip: \(lat, privacy: .public), \(lng, privacy: .public)")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                Logger.api.error("End trip error: \(error.localizedDescription)")
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                Logger.api.debug("End trip response: \(httpResponse.statusCode)")
            }
        }.resume()
    }
}

// MARK: - LocationTrackingServiceDelegate

extension AppDelegate: LocationTrackingServiceDelegate {
    func locationService(_ service: LocationTrackingServiceProtocol, didUpdateLocation location: CLLocation) {
        // During active tracking, accumulate distance and update Live Activity
        if isActivelyTracking {
            if let previous = lastLocation {
                let distance = location.distance(from: previous)
                // Only count if reasonable (< 1km between updates, good accuracy)
                if distance < 1000 && location.horizontalAccuracy < 50 {
                    totalDistanceMeters += distance
                }
            }

            // Update Live Activity with current stats
            let distanceKm = totalDistanceMeters / 1000.0
            let durationMinutes = Int(Date().timeIntervalSince(driveStartTime ?? Date()) / 60)
            let avgSpeed = durationMinutes > 0 ? (distanceKm / (Double(durationMinutes) / 60.0)) : 0

            liveActivityManager.updateActivity(state: TripActivityState(
                distanceKm: distanceKm,
                durationMinutes: durationMinutes,
                avgSpeed: avgSpeed,
                startTime: driveStartTime ?? Date(),
                isActive: true
            ))

            sendPing()
        }
        lastLocation = location
    }

    func locationService(_ service: LocationTrackingServiceProtocol, didFailWithError error: Error) {
        Logger.location.error("Location error: \(error.localizedDescription)")
    }

    func locationService(_ service: LocationTrackingServiceProtocol, didChangeAuthorization status: CLAuthorizationStatus) {
        Logger.location.info("Authorization status: \(status.rawValue)")
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            locationService.startMonitoring()
            motionHandler.startActivityUpdates()
        }
    }
}

// MARK: - MotionActivityHandlerDelegate

extension AppDelegate: MotionActivityHandlerDelegate {
    func motionHandler(_ handler: MotionActivityHandlerProtocol, didDetectAutomotive isAutomotive: Bool) {
        // Immediate detection - logging only, no trip state changes
        // Trip control moved to didConfirmAutomotive for debouncing
        debugLog("Motion", "Detected \(isAutomotive ? "automotive" : "non-automotive") (awaiting confirmation)")
    }

    func motionHandler(_ handler: MotionActivityHandlerProtocol, didConfirmAutomotive isAutomotive: Bool) {
        // Debounced confirmation of automotive state - control trip start/stop here
        if isAutomotive && !isDriving {
            isDriving = true
            let appState = UIApplication.shared.applicationState.rawValue
            debugLog("Motion", "CONFIRMED driving - triggering startDriveTracking()")
            debugLog("Motion", "App state: \(appState) (0=active, 1=inactive, 2=background)")
            startDriveTracking()
        } else if !isAutomotive && isDriving {
            debugLog("Motion", "CONFIRMED stopped driving")
            isDriving = false
            stopDriveTracking()
        }
    }

    func motionHandler(_ handler: MotionActivityHandlerProtocol, didChangeState state: MotionState) {
        // Could log state changes here if needed
    }
}

// MARK: - WatchConnectivityServiceDelegate

extension AppDelegate: WatchConnectivityServiceDelegate {
    func watchConnectivityService(_ service: WatchConnectivityServiceProtocol, requestsAuthToken completion: @escaping (String?) -> Void) {
        DispatchQueue.main.async {
            self.backgroundChannel?.invokeMethod("getAuthToken", arguments: nil) { result in
                completion(result as? String)
            }
        }
    }

    func watchConnectivityServiceDidActivate(_ service: WatchConnectivityServiceProtocol) {
        if let email = userEmail, let apiUrl = apiBaseUrl, !email.isEmpty {
            watchService.syncConfig(email: email, apiUrl: apiUrl, token: nil)
        }
    }
}
