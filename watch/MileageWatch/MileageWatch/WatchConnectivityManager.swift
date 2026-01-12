import Foundation
import WatchConnectivity
import UserNotifications
import WatchKit

extension Notification.Name {
    static let tripStarted = Notification.Name("tripStarted")
}

class WatchConnectivityManager: NSObject, ObservableObject, WCSessionDelegate {
    static let shared = WatchConnectivityManager()

    @Published var userEmail: String = ""
    @Published var apiUrl: String = "https://mileage-api-ivdikzmo7a-ez.a.run.app"
    @Published var authToken: String = ""
    @Published var isPhoneReachable: Bool = false
    @Published var tripJustStarted: Bool = false

    private var session: WCSession?

    private override init() {
        super.init()

        // Load from UserDefaults first
        userEmail = UserDefaults.standard.string(forKey: "userEmail") ?? ""
        apiUrl = UserDefaults.standard.string(forKey: "apiUrl") ?? "https://mileage-api-ivdikzmo7a-ez.a.run.app"
        authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""

        // Request notification permission
        requestNotificationPermission()

        // Activate WatchConnectivity
        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
            print("[WC] Session activated")
        }
    }

    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("[WC] Notification permission granted")
            }
        }
    }

    /// Handle trip started signal from iPhone
    /// This triggers the workout session to keep the app in foreground
    func handleTripStarted() {
        print("[WC] handleTripStarted() called")

        // Show notification (only if app is in background)
        showTripStartedNotification()

        // Set flag to trigger ViewModel update
        DispatchQueue.main.async {
            self.tripJustStarted = true
            // Post notification to trigger ViewModel refresh
            NotificationCenter.default.post(name: .tripStarted, object: nil)
        }

        // Provide haptic feedback
        WKInterfaceDevice.current().play(.start)
    }

    private func showTripStartedNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Rit Gestart"
        content.body = "Je rit wordt nu getrackt"
        content.sound = .default
        // Use workout category for better visibility
        content.categoryIdentifier = "TRIP_STARTED"

        let request = UNNotificationRequest(
            identifier: "tripStarted-\(Date().timeIntervalSince1970)",
            content: content,
            trigger: nil // Show immediately
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("[WC] Notification error: \(error.localizedDescription)")
            } else {
                print("[WC] Trip started notification shown")
            }
        }
    }

    /// Request fresh auth token - tries multiple sources
    func requestFreshToken(forceFromPhone: Bool = false) async -> String? {
        // 1. Try Keychain first (instant, synced via iCloud) unless forcing from phone
        if !forceFromPhone {
            if let keychainToken = KeychainHelper.shared.getToken(), !keychainToken.isEmpty {
                print("[WC] Got token from Keychain")
                authToken = keychainToken
                return keychainToken
            }
        }

        // 2. Try sendMessage to wake iPhone
        if let session = session {
            print("[WC] Requesting token from iPhone (reachable: \(session.isReachable))...")
            if let token = await requestTokenFromPhone() {
                return token
            }
        }

        // 3. Fall back to cached token
        if !authToken.isEmpty {
            print("[WC] Using cached token")
            return authToken
        }

        print("[WC] No token available")
        return nil
    }

    private func requestTokenFromPhone() async -> String? {
        guard let session = session else { return nil }

        return await withCheckedContinuation { continuation in
            session.sendMessage(["request": "authToken"], replyHandler: { response in
                if let token = response["authToken"] as? String, !token.isEmpty {
                    DispatchQueue.main.async {
                        self.authToken = token
                        UserDefaults.standard.set(token, forKey: "authToken")
                    }
                    print("[WC] Received fresh token from iPhone")
                    continuation.resume(returning: token)
                } else {
                    print("[WC] No token in response")
                    continuation.resume(returning: nil)
                }
            }, errorHandler: { error in
                print("[WC] Error requesting token: \(error.localizedDescription)")
                continuation.resume(returning: nil)
            })
        }
    }

    // MARK: - WCSessionDelegate

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("[WC] Activation complete: \(activationState.rawValue)")
        if let error = error {
            print("[WC] Error: \(error.localizedDescription)")
        }

        DispatchQueue.main.async {
            self.isPhoneReachable = session.isReachable
        }

        // Check for existing application context
        if activationState == .activated {
            let context = session.receivedApplicationContext
            if !context.isEmpty {
                DispatchQueue.main.async {
                    self.processContext(context)
                }
            }
        }
    }

    func sessionReachabilityDidChange(_ session: WCSession) {
        DispatchQueue.main.async {
            self.isPhoneReachable = session.isReachable
        }
        print("[WC] Reachability changed: \(session.isReachable)")
    }

    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String: Any]) {
        print("[WC] Received context: \(applicationContext)")
        DispatchQueue.main.async {
            self.processContext(applicationContext)
        }
    }

    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String: Any] = [:]) {
        print("[WC] Received userInfo: \(userInfo)")
        DispatchQueue.main.async {
            if let token = userInfo["authToken"] as? String {
                self.authToken = token
                UserDefaults.standard.set(token, forKey: "authToken")
                print("[WC] Updated token from userInfo")
            }

            // Handle trip started notification
            if userInfo["tripStarted"] as? Bool == true {
                print("[WC] Trip started via userInfo")
                self.handleTripStarted()
            }
        }
    }

    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        print("[WC] Received message: \(message)")
        DispatchQueue.main.async {
            // Handle trip started notification
            if message["tripStarted"] as? Bool == true {
                print("[WC] Trip started via message")
                self.handleTripStarted()
            }
        }
    }

    private func processContext(_ context: [String: Any]) {
        if let email = context["userEmail"] as? String {
            self.userEmail = email
            UserDefaults.standard.set(email, forKey: "userEmail")
            print("[WC] Saved email: \(email)")
        }

        if let url = context["apiUrl"] as? String {
            self.apiUrl = url
            UserDefaults.standard.set(url, forKey: "apiUrl")
            print("[WC] Saved apiUrl: \(url)")
        }

        if let token = context["authToken"] as? String {
            self.authToken = token
            UserDefaults.standard.set(token, forKey: "authToken")
            print("[WC] Saved token from context")
        }

        // Check if there's an active trip from context
        if context["tripActive"] as? Bool == true {
            print("[WC] Active trip detected from context")
            // This means the watch app was just opened and there's an active trip
            // The ViewModel will pick this up during refresh
        }
    }
}
