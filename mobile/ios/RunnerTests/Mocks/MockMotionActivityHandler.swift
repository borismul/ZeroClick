@testable import Runner

/// Mock motion handler for testing
/// Allows injecting motion states (automotive, stationary, walking)
class MockMotionActivityHandler: MotionActivityHandlerProtocol {
    weak var delegate: MotionActivityHandlerDelegate?

    // MARK: - Protocol Properties

    var currentState: MotionState = .unknown
    var isAutomotive: Bool = false

    // MARK: - Test Control Properties

    var setupCalled = false
    var startActivityCalled = false
    var stopActivityCalled = false

    // Track all state changes
    var stateHistory: [MotionState] = []

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

    // MARK: - Test Injection Methods

    /// Simulate starting to drive (automotive motion detected)
    func simulateStartDriving() {
        currentState = .automotive
        isAutomotive = true
        stateHistory.append(.automotive)
        delegate?.motionHandler(self, didDetectAutomotive: true)
        delegate?.motionHandler(self, didChangeState: .automotive)
    }

    /// Simulate stopping (stationary)
    func simulateStopDriving() {
        currentState = .stationary
        isAutomotive = false
        stateHistory.append(.stationary)
        delegate?.motionHandler(self, didDetectAutomotive: false)
        delegate?.motionHandler(self, didChangeState: .stationary)
    }

    /// Simulate walking
    func simulateWalking() {
        currentState = .walking
        isAutomotive = false
        stateHistory.append(.walking)
        delegate?.motionHandler(self, didDetectAutomotive: false)
        delegate?.motionHandler(self, didChangeState: .walking)
    }

    /// Inject any motion state
    func injectState(_ state: MotionState) {
        currentState = state
        isAutomotive = (state == .automotive)
        stateHistory.append(state)
        delegate?.motionHandler(self, didDetectAutomotive: isAutomotive)
        delegate?.motionHandler(self, didChangeState: state)
    }

    /// Reset for next test
    func reset() {
        currentState = .unknown
        isAutomotive = false
        setupCalled = false
        startActivityCalled = false
        stopActivityCalled = false
        stateHistory.removeAll()
    }
}
