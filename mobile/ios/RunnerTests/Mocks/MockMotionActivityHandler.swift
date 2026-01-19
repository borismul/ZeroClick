import CoreMotion
@testable import Runner

/// Mock motion handler for testing
/// Allows injecting motion states (automotive, stationary, walking) with confidence levels
class MockMotionActivityHandler: MotionActivityHandlerProtocol {
    weak var delegate: MotionActivityHandlerDelegate?

    // MARK: - Protocol Properties

    var currentState: MotionState = .unknown
    var isAutomotive: Bool = false

    // MARK: - Confidence and Debounce Configuration (Protocol)

    var minimumConfidence: CMMotionActivityConfidence = .medium
    var automotiveDebounceSeconds: TimeInterval = 2.0
    var nonAutomotiveDebounceSeconds: TimeInterval = 3.0

    // MARK: - Test Control Properties

    var setupCalled = false
    var startActivityCalled = false
    var stopActivityCalled = false
    var cancelDebounceCalled = false

    // Track all state changes
    var stateHistory: [MotionState] = []

    // Track delegate calls for verification
    var didDetectAutomotiveCalls: [Bool] = []
    var didConfirmAutomotiveCalls: [Bool] = []
    var didChangeStateCalls: [MotionState] = []

    // MARK: - Protocol Methods

    func setupMotionManager() {
        setupCalled = true
    }

    func startActivityUpdates() {
        startActivityCalled = true
    }

    func stopActivityUpdates() {
        stopActivityCalled = true
    }

    func cancelPendingDebounce() {
        cancelDebounceCalled = true
    }

    // MARK: - Test Injection Methods

    /// Simulate starting to drive (automotive motion detected and confirmed)
    /// This simulates the full debounce cycle for trip lifecycle tests
    func simulateStartDriving() {
        simulateWithConfidence(.automotive, confidence: .high)
        // Also fire confirmation (simulates debounce timer completing)
        simulateConfirmAutomotive(true)
    }

    /// Simulate stopping (stationary detected and confirmed)
    /// This simulates the full debounce cycle for trip lifecycle tests
    func simulateStopDriving() {
        simulateWithConfidence(.stationary, confidence: .high)
        // Also fire confirmation (simulates debounce timer completing)
        simulateConfirmAutomotive(false)
    }

    /// Simulate walking (detected and confirmed)
    func simulateWalking() {
        simulateWithConfidence(.walking, confidence: .high)
        // Also fire confirmation (simulates debounce timer completing)
        simulateConfirmAutomotive(false)
    }

    /// Inject any motion state (immediate detection only, no confirmation)
    func injectState(_ state: MotionState) {
        simulateWithConfidence(state, confidence: .high)
    }

    /// Inject motion state with confirmation (full debounce cycle)
    func injectStateWithConfirmation(_ state: MotionState) {
        simulateWithConfidence(state, confidence: .high)
        simulateConfirmAutomotive(state == .automotive)
    }

    /// Simulate state change with specific confidence level
    /// - Parameters:
    ///   - state: The motion state to simulate
    ///   - confidence: The confidence level (low/medium/high)
    func simulateWithConfidence(_ state: MotionState, confidence: CMMotionActivityConfidence) {
        // Check if confidence meets threshold (same logic as real handler)
        guard confidence.rawValue >= minimumConfidence.rawValue else {
            // Below threshold - ignored
            return
        }

        currentState = state
        isAutomotive = (state == .automotive)
        stateHistory.append(state)

        // Notify delegate
        delegate?.motionHandler(self, didDetectAutomotive: isAutomotive)
        didDetectAutomotiveCalls.append(isAutomotive)

        delegate?.motionHandler(self, didChangeState: state)
        didChangeStateCalls.append(state)
    }

    /// Simulate debounce confirmation (call after debounce period)
    /// - Parameter isAutomotive: Whether automotive state is confirmed
    func simulateConfirmAutomotive(_ isAutomotive: Bool) {
        delegate?.motionHandler(self, didConfirmAutomotive: isAutomotive)
        didConfirmAutomotiveCalls.append(isAutomotive)
    }

    /// Reset for next test
    func reset() {
        currentState = .unknown
        isAutomotive = false
        setupCalled = false
        startActivityCalled = false
        stopActivityCalled = false
        cancelDebounceCalled = false
        stateHistory.removeAll()
        didDetectAutomotiveCalls.removeAll()
        didConfirmAutomotiveCalls.removeAll()
        didChangeStateCalls.removeAll()
        minimumConfidence = .medium
        automotiveDebounceSeconds = 2.0
        nonAutomotiveDebounceSeconds = 3.0
    }
}
