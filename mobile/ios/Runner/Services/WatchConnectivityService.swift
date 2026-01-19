import WatchConnectivity

// MARK: - WatchConnectivityService

/// Manages WatchConnectivity session for iPhone-Watch communication.
/// Handles token synchronization, config sync, and trip notifications.
/// Extracted from AppDelegate to isolate WCSession handling.
class WatchConnectivityService: NSObject, WatchConnectivityServiceProtocol, WCSessionDelegate {

    // MARK: - Properties

    /// Delegate for callbacks (token requests, activation complete)
    weak var delegate: WatchConnectivityServiceDelegate?

    /// The WCSession instance
    private var session: WCSession?

    /// Whether the Watch is paired with this iPhone
    var isPaired: Bool {
        return session?.isPaired ?? false
    }

    /// Whether the Watch app is installed
    var isWatchAppInstalled: Bool {
        return session?.isWatchAppInstalled ?? false
    }

    /// Whether the Watch is currently reachable (interactive messaging available)
    var isReachable: Bool {
        return session?.isReachable ?? false
    }

    // MARK: - Initialization

    override init() {
        super.init()
        print("[WatchConnectivityService] Initialized")
    }

    // MARK: - Setup

    /// Initialize WatchConnectivity session
    func setup() {
        guard WCSession.isSupported() else {
            print("[WatchConnectivityService] WatchConnectivity not supported")
            return
        }
        session = WCSession.default
        session?.delegate = self
        session?.activate()
        print("[WatchConnectivityService] WatchConnectivity activated")
    }

    // MARK: - Sync Methods

    /// Sync user config to watch via applicationContext
    func syncConfig(email: String, apiUrl: String, token: String?) {
        guard let session = session, session.isPaired, session.isWatchAppInstalled else {
            print("[WatchConnectivityService] Watch not paired or app not installed")
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
            print("[WatchConnectivityService] Synced context to watch: \(email)")
        } catch {
            print("[WatchConnectivityService] Failed to sync: \(error.localizedDescription)")
        }
    }

    /// Send auth token to watch via transferUserInfo (guaranteed delivery)
    func syncToken(_ token: String) {
        guard let session = session, session.isPaired, session.isWatchAppInstalled else {
            print("[WatchConnectivityService] Watch not paired or app not installed")
            return
        }

        // Use transferUserInfo for token updates (guaranteed delivery)
        session.transferUserInfo(["authToken": token])
        print("[WatchConnectivityService] Token transferred to watch")
    }

    /// Notify watch that a trip has started
    /// Uses multiple channels for reliability: transferUserInfo, sendMessage, applicationContext
    func notifyTripStarted() {
        print("[WatchConnectivityService] notifyTripStarted() called")
        print("[WatchConnectivityService] session: \(session != nil ? "exists" : "nil")")

        guard let session = session else {
            print("[WatchConnectivityService] WCSession is nil!")
            return
        }

        print("[WatchConnectivityService] isPaired: \(session.isPaired), isWatchAppInstalled: \(session.isWatchAppInstalled)")

        guard session.isPaired, session.isWatchAppInstalled else {
            print("[WatchConnectivityService] Watch not paired or app not installed")
            return
        }

        print("[WatchConnectivityService] Notifying watch - reachable: \(session.isReachable)")

        // Always queue transferUserInfo for reliable background delivery
        session.transferUserInfo(["tripStarted": true, "timestamp": Date().timeIntervalSince1970])
        print("[WatchConnectivityService] Queued trip start via transferUserInfo")

        // Also try sendMessage if reachable for immediate delivery
        if session.isReachable {
            session.sendMessage(["tripStarted": true], replyHandler: nil, errorHandler: { error in
                print("[WatchConnectivityService] Error sending trip start: \(error.localizedDescription)")
            })
            print("[WatchConnectivityService] Sent trip start via sendMessage")
        }

        // Also update applicationContext so watch gets it on next activation
        var context = session.applicationContext
        context["tripActive"] = true
        context["tripStartedAt"] = Date().timeIntervalSince1970
        try? session.updateApplicationContext(context)
        print("[WatchConnectivityService] Updated applicationContext")
    }

    /// Update trip active state in applicationContext
    func updateTripActiveState(_ isActive: Bool) {
        guard let session = session, session.isPaired, session.isWatchAppInstalled else {
            print("[WatchConnectivityService] Watch not paired or app not installed")
            return
        }

        var context = session.applicationContext
        context["tripActive"] = isActive
        if !isActive {
            context.removeValue(forKey: "tripStartedAt")
        }
        try? session.updateApplicationContext(context)
        print("[WatchConnectivityService] Updated tripActive to \(isActive)")
    }

    // MARK: - WCSessionDelegate

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("[WatchConnectivityService] Activation complete: \(activationState.rawValue)")
        if let error = error {
            print("[WatchConnectivityService] Activation error: \(error.localizedDescription)")
        }

        if activationState == .activated {
            delegate?.watchConnectivityServiceDidActivate(self)
        }
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        print("[WatchConnectivityService] Session inactive")
    }

    func sessionDidDeactivate(_ session: WCSession) {
        print("[WatchConnectivityService] Session deactivated")
        // Reactivate for switching watches
        session.activate()
    }

    /// Handle messages from Watch (token requests)
    func session(_ session: WCSession, didReceiveMessage message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void) {
        print("[WatchConnectivityService] Received message: \(message)")

        if message["request"] as? String == "authToken" {
            delegate?.watchConnectivityService(self, requestsAuthToken: { token in
                if let token = token, !token.isEmpty {
                    print("[WatchConnectivityService] Sending token to watch")
                    replyHandler(["authToken": token])
                } else {
                    print("[WatchConnectivityService] No token available")
                    replyHandler([:])
                }
            })
        } else {
            replyHandler([:])
        }
    }
}

// MARK: - Factory Function

/// Creates a WatchConnectivityService instance
/// - Returns: WatchConnectivityServiceProtocol implementation
func createWatchConnectivityService() -> WatchConnectivityServiceProtocol {
    return WatchConnectivityService()
}
