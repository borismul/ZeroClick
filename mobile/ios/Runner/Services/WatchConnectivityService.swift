import WatchConnectivity
import OSLog

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
        Logger.watch.info("WatchConnectivityService initialized")
    }

    // MARK: - Setup

    /// Initialize WatchConnectivity session
    func setup() {
        guard WCSession.isSupported() else {
            Logger.watch.warning("WatchConnectivity not supported")
            return
        }
        session = WCSession.default
        session?.delegate = self
        session?.activate()
        Logger.watch.info("WatchConnectivity session activated")
    }

    // MARK: - Sync Methods

    /// Sync user config to watch via applicationContext
    func syncConfig(email: String, apiUrl: String, token: String?) {
        guard let session = session, session.isPaired, session.isWatchAppInstalled else {
            Logger.watch.debug("Watch not paired or app not installed")
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
            Logger.watch.info("Synced context to watch: \(email, privacy: .private)")
        } catch {
            Logger.watch.error("Failed to sync context: \(error.localizedDescription)")
        }
    }

    /// Send auth token to watch via transferUserInfo (guaranteed delivery)
    func syncToken(_ token: String) {
        guard let session = session, session.isPaired, session.isWatchAppInstalled else {
            Logger.watch.debug("Watch not paired or app not installed")
            return
        }

        // Use transferUserInfo for token updates (guaranteed delivery)
        session.transferUserInfo(["authToken": token])
        Logger.watch.info("Token transferred to watch")
    }

    /// Notify watch that a trip has started
    /// Uses multiple channels for reliability: transferUserInfo, sendMessage, applicationContext
    func notifyTripStarted() {
        Logger.watch.debug("notifyTripStarted() called, session: \(self.session != nil ? "exists" : "nil")")

        guard let session = session else {
            Logger.watch.error("WCSession is nil")
            return
        }

        Logger.watch.debug("isPaired: \(session.isPaired), isWatchAppInstalled: \(session.isWatchAppInstalled)")

        guard session.isPaired, session.isWatchAppInstalled else {
            Logger.watch.debug("Watch not paired or app not installed")
            return
        }

        Logger.watch.info("Notifying watch of trip start - reachable: \(session.isReachable)")

        // Always queue transferUserInfo for reliable background delivery
        session.transferUserInfo(["tripStarted": true, "timestamp": Date().timeIntervalSince1970])
        Logger.watch.debug("Queued trip start via transferUserInfo")

        // Also try sendMessage if reachable for immediate delivery
        if session.isReachable {
            session.sendMessage(["tripStarted": true], replyHandler: nil, errorHandler: { error in
                Logger.watch.error("Error sending trip start: \(error.localizedDescription)")
            })
            Logger.watch.debug("Sent trip start via sendMessage")
        }

        // Also update applicationContext so watch gets it on next activation
        var context = session.applicationContext
        context["tripActive"] = true
        context["tripStartedAt"] = Date().timeIntervalSince1970
        try? session.updateApplicationContext(context)
        Logger.watch.debug("Updated applicationContext")
    }

    /// Update trip active state in applicationContext
    func updateTripActiveState(_ isActive: Bool) {
        guard let session = session, session.isPaired, session.isWatchAppInstalled else {
            Logger.watch.debug("Watch not paired or app not installed")
            return
        }

        var context = session.applicationContext
        context["tripActive"] = isActive
        if !isActive {
            context.removeValue(forKey: "tripStartedAt")
        }
        try? session.updateApplicationContext(context)
        Logger.watch.info("Updated tripActive to \(isActive)")
    }

    // MARK: - WCSessionDelegate

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        Logger.watch.info("Activation complete: \(activationState.rawValue)")
        if let error = error {
            Logger.watch.error("Activation error: \(error.localizedDescription)")
        }

        if activationState == .activated {
            delegate?.watchConnectivityServiceDidActivate(self)
        }
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        Logger.watch.info("Session became inactive")
    }

    func sessionDidDeactivate(_ session: WCSession) {
        Logger.watch.info("Session deactivated - reactivating")
        // Reactivate for switching watches
        session.activate()
    }

    /// Handle messages from Watch (token requests)
    func session(_ session: WCSession, didReceiveMessage message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void) {
        Logger.watch.debug("Received message from watch")

        if message["request"] as? String == "authToken" {
            delegate?.watchConnectivityService(self, requestsAuthToken: { token in
                if let token = token, !token.isEmpty {
                    Logger.watch.info("Sending token to watch")
                    replyHandler(["authToken": token])
                } else {
                    Logger.watch.warning("No token available for watch")
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
