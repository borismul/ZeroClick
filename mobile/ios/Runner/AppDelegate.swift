import Flutter
import UIKit
import CoreLocation
import CoreMotion
import WatchConnectivity
import ActivityKit

@main
@objc class AppDelegate: FlutterAppDelegate, CLLocationManagerDelegate, WCSessionDelegate {

    // MARK: - Properties
    private var backgroundChannel: FlutterMethodChannel?
    private var debugChannel: FlutterMethodChannel?
    private var locationManager: CLLocationManager!
    private var motionManager: CMMotionActivityManager!
    private var wcSession: WCSession?

    // API config
    private var apiBaseUrl: String?
    private var userEmail: String?
    private var activeCarId: String?  // Set by Flutter when Bluetooth identifies car

    // Drive state
    private var isDriving = false
    private var isActivelyTracking = false
    private var lastLocation: CLLocation?
    private var driveStartTime: Date?
    private var pingTimer: Timer?
    private var totalDistanceMeters: Double = 0

    // Debounce
    private var lastApiCallTime: Date?
    private var lastPingTime: Date?

    // MARK: - Debug Logging
    private func debugLog(_ tag: String, _ message: String) {
        print("[\(tag)] \(message)")
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

        // Check if launched for location
        if launchOptions?[.location] != nil {
            print("[App] Launched by iOS for location update")
        }

        // Setup Flutter channels
        if let controller = window?.rootViewController as? FlutterViewController {
            // Debug channel for sending logs to Flutter
            debugChannel = FlutterMethodChannel(
                name: "nl.borism.mileage/debug",
                binaryMessenger: controller.binaryMessenger
            )

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
                        // Save email to iCloud Keychain (syncs to Watch)
                        KeychainHelper.shared.saveEmail(email)
                        // Sync to Watch via WatchConnectivity (token will be sent separately)
                        self?.syncToWatch(email: email, apiUrl: baseUrl, token: nil)
                        print("[Config] API: \(baseUrl), User: \(email)")
                        result(true)
                    } else {
                        result(false)
                    }
                case "setAuthToken":
                    if let args = call.arguments as? [String: Any],
                       let token = args["token"] as? String {
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
                            print("[Config] Access + refresh tokens saved to iCloud Keychain")
                        } else {
                            print("[Config] Access token saved to iCloud Keychain")
                        }
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
                case "setActiveCarId":
                    if let args = call.arguments as? [String: Any] {
                        self?.activeCarId = args["carId"] as? String
                        print("[Config] Active car ID: \(self?.activeCarId ?? "nil")")
                        result(true)
                    } else {
                        result(false)
                    }
                case "notifyWatchTripStarted":
                    self?.notifyWatchTripStarted()
                    result(true)
                case "startTrip":
                    self?.startDriveTracking()
                    result(true)
                case "endTrip":
                    self?.stopDriveTracking()
                    result(true)
                default:
                    result(FlutterMethodNotImplemented)
                }
            }
        }

        // Load saved config
        apiBaseUrl = UserDefaults.standard.string(forKey: "api_base_url")
        userEmail = UserDefaults.standard.string(forKey: "user_email")

        // Setup WatchConnectivity
        setupWatchConnectivity()

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
                let appState = UIApplication.shared.applicationState.rawValue
                debugLog("Motion", "Started DRIVING - triggering startDriveTracking()")
                debugLog("Motion", "App state: \(appState) (0=active, 1=inactive, 2=background)")
                startDriveTracking()
            }
        } else if activity.stationary && activity.confidence != .low {
            if isDriving {
                debugLog("Motion", "Stopped driving (stationary)")
                // Don't immediately stop - wait for a few stationary readings
                // The backend handles this via parked_count
            }
        } else if (activity.walking || activity.running) && activity.confidence != .low {
            if isDriving {
                debugLog("Motion", "Stopped driving (walking/running)")
                isDriving = false
                stopDriveTracking()
            }
        }
    }

    // MARK: - Drive Tracking

    private func startDriveTracking() {
        debugLog("Drive", "startDriveTracking() called, isActivelyTracking: \(isActivelyTracking)")

        guard !isActivelyTracking else {
            debugLog("Drive", "Already tracking - skipping")
            return
        }

        isActivelyTracking = true
        driveStartTime = Date()
        totalDistanceMeters = 0

        // Switch to high accuracy FIRST
        setHighAccuracy()

        debugLog("Drive", "Starting Live Activity...")
        // Start Live Activity (shows on Lock Screen + Dynamic Island + Watch Smart Stack)
        startLiveActivity()

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

        debugLog("Drive", "Tracking started")
    }

    private func stopDriveTracking() {
        guard isActivelyTracking else { return }

        debugLog("Drive", "stopDriveTracking() called")

        isActivelyTracking = false
        pingTimer?.invalidate()
        pingTimer = nil
        setLowAccuracy()

        // End Live Activity
        endLiveActivity()

        // Send end event
        if let location = lastLocation ?? locationManager.location {
            callEndTripAPI(lat: location.coordinate.latitude, lng: location.coordinate.longitude)
        }

        // Notify Flutter
        backgroundChannel?.invokeMethod("onTripEnded", arguments: ["status": "ended"])

        debugLog("Drive", "Tracking stopped")
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
            updateLiveActivity(distanceKm: distanceKm, durationMinutes: durationMinutes, avgSpeed: avgSpeed)

            sendPing()
        }

        lastLocation = location
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

        var urlString = "\(baseUrl)/webhook/ping?user=\(email.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? email)"
        // Add car_id if known (from Bluetooth detection)
        if let carId = activeCarId {
            urlString += "&car_id=\(carId.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? carId)"
        }
        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: ["lat": lat, "lng": lng])

        print("[API] Start trip: \(lat), \(lng)")

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                print("[API] Error: \(error.localizedDescription)")
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("[API] Response: \(httpResponse.statusCode)")
                if httpResponse.statusCode == 200 {
                    // Notify watch that trip started
                    self?.notifyWatchTripStarted()
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

        var urlString = "\(baseUrl)/webhook/end?user=\(email.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? email)"
        if let carId = activeCarId {
            urlString += "&car_id=\(carId.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? carId)"
        }
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

    // MARK: - WatchConnectivity

    private func setupWatchConnectivity() {
        guard WCSession.isSupported() else {
            print("[Watch] WatchConnectivity not supported")
            return
        }
        wcSession = WCSession.default
        wcSession?.delegate = self
        wcSession?.activate()
        print("[Watch] WatchConnectivity activated")
    }

    private func syncToWatch(email: String, apiUrl: String, token: String?) {
        guard let session = wcSession, session.isPaired, session.isWatchAppInstalled else {
            print("[Watch] Watch not paired or app not installed")
            return
        }

        var context: [String: Any] = [
            "userEmail": email,
            "apiUrl": apiUrl
        ]
        if let token = token {
            context["authToken"] = token
        }

        do {
            try session.updateApplicationContext(context)
            print("[Watch] Synced context to watch: \(email)")
        } catch {
            print("[Watch] Failed to sync: \(error.localizedDescription)")
        }
    }

    private func syncTokenToWatch(token: String) {
        guard let session = wcSession, session.isPaired, session.isWatchAppInstalled else {
            print("[Watch] Watch not paired or app not installed")
            return
        }

        // Use transferUserInfo for token updates (guaranteed delivery)
        session.transferUserInfo(["authToken": token])
        print("[Watch] Token transferred to watch")
    }

    private func notifyWatchTripStarted() {
        print("[Watch] notifyWatchTripStarted() called")
        print("[Watch] wcSession: \(wcSession != nil ? "exists" : "nil")")

        guard let session = wcSession else {
            print("[Watch] WCSession is nil!")
            return
        }

        print("[Watch] isPaired: \(session.isPaired), isWatchAppInstalled: \(session.isWatchAppInstalled)")

        guard session.isPaired, session.isWatchAppInstalled else {
            print("[Watch] Watch not paired or app not installed")
            return
        }

        print("[Watch] Notifying watch - reachable: \(session.isReachable)")

        // Always queue transferUserInfo for reliable background delivery
        session.transferUserInfo(["tripStarted": true, "timestamp": Date().timeIntervalSince1970])
        print("[Watch] Queued trip start via transferUserInfo")

        // Also try sendMessage if reachable for immediate delivery
        if session.isReachable {
            session.sendMessage(["tripStarted": true], replyHandler: nil, errorHandler: { error in
                print("[Watch] Error sending trip start: \(error.localizedDescription)")
            })
            print("[Watch] Sent trip start via sendMessage")
        }

        // Also update applicationContext so watch gets it on next activation
        var context = session.applicationContext
        context["tripActive"] = true
        context["tripStartedAt"] = Date().timeIntervalSince1970
        try? session.updateApplicationContext(context)
        print("[Watch] Updated applicationContext")
    }

    // MARK: - WCSessionDelegate

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("[Watch] Activation complete: \(activationState.rawValue)")
        if let error = error {
            print("[Watch] Activation error: \(error.localizedDescription)")
        }

        // Sync current config to watch on activation
        if activationState == .activated, let email = userEmail, let apiUrl = apiBaseUrl, !email.isEmpty {
            syncToWatch(email: email, apiUrl: apiUrl, token: nil)
        }
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        print("[Watch] Session inactive")
    }

    func sessionDidDeactivate(_ session: WCSession) {
        print("[Watch] Session deactivated")
        // Reactivate for switching watches
        session.activate()
    }

    // Handle messages from Watch (token requests)
    func session(_ session: WCSession, didReceiveMessage message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void) {
        print("[Watch] Received message: \(message)")

        if message["request"] as? String == "authToken" {
            // Get fresh token from Flutter via method channel
            DispatchQueue.main.async {
                self.backgroundChannel?.invokeMethod("getAuthToken", arguments: nil) { result in
                    if let token = result as? String, !token.isEmpty {
                        print("[Watch] Sending token to watch")
                        replyHandler(["authToken": token])
                    } else {
                        print("[Watch] No token available")
                        replyHandler([:])
                    }
                }
            }
        } else {
            replyHandler([:])
        }
    }

    // MARK: - Live Activity

    private var currentActivityStorage: Any?

    private func startLiveActivity() {
        guard #available(iOS 16.2, *) else {
            debugLog("LiveActivity", "iOS 16.2+ required")
            return
        }

        debugLog("LiveActivity", "startLiveActivity() called, isMainThread: \(Thread.isMainThread)")

        // Request background time to ensure we can complete the Live Activity setup
        var backgroundTaskId: UIBackgroundTaskIdentifier = .invalid
        backgroundTaskId = UIApplication.shared.beginBackgroundTask(withName: "StartLiveActivity") {
            self.debugLog("LiveActivity", "Background task expired")
            UIApplication.shared.endBackgroundTask(backgroundTaskId)
            backgroundTaskId = .invalid
        }

        debugLog("LiveActivity", "Background task started: \(backgroundTaskId.rawValue)")

        // Ensure we're on main thread for Live Activity operations
        let startActivity = { [weak self] in
            Task {
                await self?.startLiveActivityAsync()
                // End background task when done
                if backgroundTaskId != .invalid {
                    self?.debugLog("LiveActivity", "Ending background task")
                    UIApplication.shared.endBackgroundTask(backgroundTaskId)
                }
            }
        }

        if Thread.isMainThread {
            startActivity()
        } else {
            DispatchQueue.main.async {
                startActivity()
            }
        }
    }

    @available(iOS 16.2, *)
    private func startLiveActivityAsync() async {
        debugLog("LiveActivity", "startLiveActivityAsync() starting")

        // Check availability
        let authInfo = ActivityAuthorizationInfo()
        debugLog("LiveActivity", "areActivitiesEnabled: \(authInfo.areActivitiesEnabled), frequentPushesEnabled: \(authInfo.frequentPushesEnabled)")

        guard authInfo.areActivitiesEnabled else {
            debugLog("LiveActivity", "Not enabled in Settings - check Settings > Mileage > Live Activities")
            return
        }

        // End existing activities first
        let existingActivities = Activity<TripActivityAttributes>.activities
        debugLog("LiveActivity", "Ending \(existingActivities.count) existing activities")
        for activity in existingActivities {
            await activity.end(nil, dismissalPolicy: .immediate)
        }
        currentActivityStorage = nil

        // Small delay to ensure previous activities are fully dismissed
        try? await Task.sleep(nanoseconds: 100_000_000) // 100ms

        // Create new activity
        let attributes = TripActivityAttributes(
            tripId: UUID().uuidString,
            carName: activeCarId ?? "Auto"
        )

        let state = TripActivityAttributes.ContentState(
            distanceKm: 0,
            durationMinutes: 0,
            avgSpeed: 0,
            startTime: driveStartTime ?? Date(),
            isActive: true
        )

        debugLog("LiveActivity", "Requesting new activity...")

        do {
            let activity = try Activity.request(
                attributes: attributes,
                content: .init(state: state, staleDate: nil),
                pushType: nil
            )
            currentActivityStorage = activity
            debugLog("LiveActivity", "Started successfully: \(activity.id)")
        } catch {
            debugLog("LiveActivity", "Failed to start: \(error.localizedDescription)")
            // Retry once after a short delay
            try? await Task.sleep(nanoseconds: 500_000_000) // 500ms
            debugLog("LiveActivity", "Retrying...")
            do {
                let activity = try Activity.request(
                    attributes: attributes,
                    content: .init(state: state, staleDate: nil),
                    pushType: nil
                )
                currentActivityStorage = activity
                debugLog("LiveActivity", "Retry succeeded: \(activity.id)")
            } catch {
                debugLog("LiveActivity", "Retry also failed: \(error.localizedDescription)")
            }
        }
    }

    private func updateLiveActivity(distanceKm: Double, durationMinutes: Int, avgSpeed: Double) {
        guard #available(iOS 16.2, *),
              let activity = currentActivityStorage as? Activity<TripActivityAttributes> else { return }

        Task {
            let state = TripActivityAttributes.ContentState(
                distanceKm: distanceKm,
                durationMinutes: durationMinutes,
                avgSpeed: avgSpeed,
                startTime: activity.content.state.startTime,
                isActive: true
            )
            await activity.update(ActivityContent(state: state, staleDate: nil))
        }
    }

    private func endLiveActivity() {
        debugLog("LiveActivity", "endLiveActivity() called")

        guard #available(iOS 16.2, *),
              let activity = currentActivityStorage as? Activity<TripActivityAttributes> else {
            debugLog("LiveActivity", "No active activity to end")
            return
        }

        Task { [weak self] in
            let state = TripActivityAttributes.ContentState(
                distanceKm: activity.content.state.distanceKm,
                durationMinutes: activity.content.state.durationMinutes,
                avgSpeed: activity.content.state.avgSpeed,
                startTime: activity.content.state.startTime,
                isActive: false
            )
            await activity.end(
                ActivityContent(state: state, staleDate: nil),
                dismissalPolicy: .after(.now + 300)
            )
            self?.debugLog("LiveActivity", "Ended successfully")
        }
        currentActivityStorage = nil
    }
}
