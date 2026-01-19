@testable import Runner

/// Mock Watch Connectivity service for testing
/// Verifies Watch communication without WCSession
class MockWatchConnectivityService: WatchConnectivityServiceProtocol {
    weak var delegate: WatchConnectivityServiceDelegate?

    // MARK: - Protocol Properties

    var isPaired: Bool = true
    var isWatchAppInstalled: Bool = true
    var isReachable: Bool = true

    // MARK: - Test Control Properties

    var setupCalled = false
    var syncConfigCalled = false
    var syncTokenCalled = false
    var notifyTripStartedCalled = false
    var updateTripActiveStateCalled = false

    var lastSyncedEmail: String?
    var lastSyncedApiUrl: String?
    var lastSyncedToken: String?
    var lastTripActiveState: Bool?

    var tripStartNotificationCount = 0

    // MARK: - Protocol Methods

    func setup() {
        setupCalled = true
    }

    func syncConfig(email: String, apiUrl: String, token: String?) {
        syncConfigCalled = true
        lastSyncedEmail = email
        lastSyncedApiUrl = apiUrl
        lastSyncedToken = token
    }

    func syncToken(_ token: String) {
        syncTokenCalled = true
        lastSyncedToken = token
    }

    func notifyTripStarted() {
        notifyTripStartedCalled = true
        tripStartNotificationCount += 1
    }

    func updateTripActiveState(_ isActive: Bool) {
        updateTripActiveStateCalled = true
        lastTripActiveState = isActive
    }

    // MARK: - Test Injection Methods

    /// Simulate watch requesting auth token
    func simulateTokenRequest() {
        delegate?.watchConnectivityService(self, requestsAuthToken: { token in
            // Token received from delegate
        })
    }

    /// Simulate activation complete
    func simulateActivation() {
        delegate?.watchConnectivityServiceDidActivate(self)
    }

    /// Reset for next test
    func reset() {
        setupCalled = false
        syncConfigCalled = false
        syncTokenCalled = false
        notifyTripStartedCalled = false
        updateTripActiveStateCalled = false
        lastSyncedEmail = nil
        lastSyncedApiUrl = nil
        lastSyncedToken = nil
        lastTripActiveState = nil
        tripStartNotificationCount = 0
    }
}
