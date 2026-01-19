@testable import Runner

/// Mock Live Activity manager for testing
/// Verifies Live Activity lifecycle without ActivityKit
class MockLiveActivityManager: LiveActivityManagerProtocol {

    // MARK: - Protocol Properties

    var isActivityRunning: Bool = false

    // MARK: - Test Control Properties

    var startActivityCalled = false
    var updateActivityCalled = false
    var endActivityCalled = false

    var lastCarName: String?
    var lastStartTime: Date?
    var lastState: TripActivityState?
    var lastKeepVisibleDuration: TimeInterval?

    // Track all updates
    var stateUpdates: [TripActivityState] = []

    // MARK: - Protocol Methods

    func startActivity(carName: String, startTime: Date) {
        startActivityCalled = true
        isActivityRunning = true
        lastCarName = carName
        lastStartTime = startTime
    }

    func updateActivity(state: TripActivityState) {
        updateActivityCalled = true
        lastState = state
        stateUpdates.append(state)
    }

    func endActivity(keepVisibleForSeconds: TimeInterval) {
        endActivityCalled = true
        isActivityRunning = false
        lastKeepVisibleDuration = keepVisibleForSeconds
    }

    // MARK: - Test Helpers

    /// Get total distance from all updates
    var totalDistanceKm: Double {
        return lastState?.distanceKm ?? 0
    }

    /// Get update count
    var updateCount: Int {
        return stateUpdates.count
    }

    /// Reset for next test
    func reset() {
        isActivityRunning = false
        startActivityCalled = false
        updateActivityCalled = false
        endActivityCalled = false
        lastCarName = nil
        lastStartTime = nil
        lastState = nil
        lastKeepVisibleDuration = nil
        stateUpdates.removeAll()
    }
}
