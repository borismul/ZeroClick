import WatchConnectivity

// MARK: - WatchConnectivityServiceProtocol

/// Protocol defining the interface for Watch Connectivity management.
/// Handles WCSession communication for token sync and trip notifications.
protocol WatchConnectivityServiceProtocol: AnyObject {
    /// Delegate for receiving callbacks from Watch Connectivity events
    var delegate: WatchConnectivityServiceDelegate? { get set }

    /// Whether the Watch is paired with this iPhone
    var isPaired: Bool { get }

    /// Whether the Watch app is installed
    var isWatchAppInstalled: Bool { get }

    /// Whether the Watch is currently reachable (interactive messaging available)
    var isReachable: Bool { get }

    /// Initialize WatchConnectivity session
    func setup()

    /// Sync user config to watch via applicationContext
    /// - Parameters:
    ///   - email: User email
    ///   - apiUrl: API base URL
    ///   - token: Optional auth token
    func syncConfig(email: String, apiUrl: String, token: String?)

    /// Send auth token to watch via transferUserInfo (guaranteed delivery)
    /// - Parameter token: Auth token
    func syncToken(_ token: String)

    /// Notify watch that a trip has started
    /// Uses multiple channels for reliability: transferUserInfo, sendMessage, applicationContext
    func notifyTripStarted()

    /// Update trip active state in applicationContext
    /// - Parameter isActive: Whether a trip is currently active
    func updateTripActiveState(_ isActive: Bool)
}

// MARK: - WatchConnectivityServiceDelegate

/// Delegate protocol for Watch Connectivity callbacks
protocol WatchConnectivityServiceDelegate: AnyObject {
    /// Called when watch requests auth token
    /// - Parameters:
    ///   - service: The calling service
    ///   - completion: Call with token string or nil if unavailable
    func watchConnectivityService(
        _ service: WatchConnectivityServiceProtocol,
        requestsAuthToken completion: @escaping (String?) -> Void
    )

    /// Called when WCSession activation completes
    /// - Parameter service: The calling service
    func watchConnectivityServiceDidActivate(_ service: WatchConnectivityServiceProtocol)
}

// MARK: - Default Delegate Extension

extension WatchConnectivityServiceDelegate {
    /// Default implementation - does nothing
    func watchConnectivityServiceDidActivate(_ service: WatchConnectivityServiceProtocol) {
        // Optional callback - no action needed by default
    }
}
