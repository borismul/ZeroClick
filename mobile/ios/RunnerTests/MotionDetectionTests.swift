import XCTest
import CoreMotion
@testable import Runner

/// Tests for motion detection confidence thresholds and debouncing logic
/// Verifies that rapid motion state oscillation doesn't cause false trip starts/stops
class MotionDetectionTests: XCTestCase {

    var motionHandler: MotionActivityHandler!
    var mockDelegate: MockMotionDelegate!

    override func setUp() {
        super.setUp()
        motionHandler = MotionActivityHandler()
        mockDelegate = MockMotionDelegate()
        motionHandler.delegate = mockDelegate
        // Don't call setupMotionManager() - tests call processActivity directly
    }

    override func tearDown() {
        motionHandler.cancelPendingDebounce()
        motionHandler = nil
        mockDelegate = nil
        super.tearDown()
    }

    // MARK: - Confidence Threshold Tests

    func testLowConfidenceIgnored() {
        // Given: Default minimum confidence is .medium
        XCTAssertEqual(motionHandler.minimumConfidence, .medium)

        // When: Low confidence automotive activity
        let activity = TestableMotionActivity(
            automotive: true,
            stationary: false,
            walking: false,
            running: false,
            confidence: .low
        )
        motionHandler.processActivity(activity)

        // Then: No state change (ignored)
        XCTAssertEqual(mockDelegate.didDetectAutomotiveCalls.count, 0,
                       "Low confidence activity should be ignored")
        XCTAssertFalse(motionHandler.isAutomotive)
    }

    func testMediumConfidenceAccepted() {
        // Given: Default minimum confidence is .medium
        XCTAssertEqual(motionHandler.minimumConfidence, .medium)

        // When: Medium confidence automotive activity
        let activity = TestableMotionActivity(
            automotive: true,
            stationary: false,
            walking: false,
            running: false,
            confidence: .medium
        )
        motionHandler.processActivity(activity)

        // Then: State change detected
        XCTAssertEqual(mockDelegate.didDetectAutomotiveCalls.count, 1)
        XCTAssertTrue(mockDelegate.didDetectAutomotiveCalls[0])
        XCTAssertTrue(motionHandler.isAutomotive)
    }

    func testHighConfidenceAccepted() {
        // Given: Default minimum confidence is .medium
        XCTAssertEqual(motionHandler.minimumConfidence, .medium)

        // When: High confidence automotive activity
        let activity = TestableMotionActivity(
            automotive: true,
            stationary: false,
            walking: false,
            running: false,
            confidence: .high
        )
        motionHandler.processActivity(activity)

        // Then: State change detected
        XCTAssertEqual(mockDelegate.didDetectAutomotiveCalls.count, 1)
        XCTAssertTrue(mockDelegate.didDetectAutomotiveCalls[0])
        XCTAssertTrue(motionHandler.isAutomotive)
    }

    func testCustomThresholdRejectsMedium() {
        // Given: Minimum confidence set to .high
        motionHandler.minimumConfidence = .high

        // When: Medium confidence automotive activity
        let activity = TestableMotionActivity(
            automotive: true,
            stationary: false,
            walking: false,
            running: false,
            confidence: .medium
        )
        motionHandler.processActivity(activity)

        // Then: Ignored because below threshold
        XCTAssertEqual(mockDelegate.didDetectAutomotiveCalls.count, 0,
                       "Medium confidence should be rejected when threshold is .high")
        XCTAssertFalse(motionHandler.isAutomotive)
    }

    // MARK: - Debounce Tests

    func testAutomotiveDebounce() {
        // Given: Short debounce time for testing
        motionHandler.automotiveDebounceSeconds = 0.1

        // When: Automotive detected
        let activity = TestableMotionActivity(automotive: true, confidence: .high)
        motionHandler.processActivity(activity)

        // Then: Immediate detection
        XCTAssertEqual(mockDelegate.didDetectAutomotiveCalls.count, 1)
        XCTAssertTrue(mockDelegate.didDetectAutomotiveCalls[0])

        // But no confirmation yet
        XCTAssertEqual(mockDelegate.didConfirmAutomotiveCalls.count, 0)

        // Wait for debounce
        let expectation = expectation(description: "Debounce fires")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0)

        // Then: Confirmation received
        XCTAssertEqual(mockDelegate.didConfirmAutomotiveCalls.count, 1,
                       "Should receive confirmation after debounce period")
        XCTAssertTrue(mockDelegate.didConfirmAutomotiveCalls[0])
    }

    func testRapidOscillationIgnored() {
        // Given: Short debounce time for testing
        motionHandler.automotiveDebounceSeconds = 0.1
        motionHandler.nonAutomotiveDebounceSeconds = 0.2

        // Start as automotive
        let automotiveActivity = TestableMotionActivity(automotive: true, confidence: .high)
        motionHandler.processActivity(automotiveActivity)
        XCTAssertTrue(motionHandler.isAutomotive)

        // Wait for initial automotive confirmation
        let startExpectation = expectation(description: "Start confirmed")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            startExpectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
        mockDelegate.didConfirmAutomotiveCalls.removeAll()

        // When: Rapid oscillation automotive -> stationary -> automotive (within debounce period)
        let stationaryActivity = TestableMotionActivity(stationary: true, confidence: .high)
        motionHandler.processActivity(stationaryActivity)

        // Immediately back to automotive (before debounce fires)
        motionHandler.processActivity(automotiveActivity)

        // Then: Trip continues (no confirmed end)
        XCTAssertTrue(motionHandler.isAutomotive)

        // Wait for potential debounce
        let endExpectation = expectation(description: "Debounce period")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            endExpectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)

        // No non-automotive confirmation should have been sent
        let nonAutomotiveConfirmations = mockDelegate.didConfirmAutomotiveCalls.filter { !$0 }
        XCTAssertEqual(nonAutomotiveConfirmations.count, 0,
                       "Rapid oscillation should not confirm non-automotive state")
    }

    func testWalkingEndsTrip() {
        // Given: Trip is active
        motionHandler.automotiveDebounceSeconds = 0.1
        motionHandler.nonAutomotiveDebounceSeconds = 0.1
        let automotiveActivity = TestableMotionActivity(automotive: true, confidence: .high)
        motionHandler.processActivity(automotiveActivity)
        XCTAssertTrue(motionHandler.isAutomotive)

        // Wait for automotive confirmation
        let startExpectation = expectation(description: "Start confirmed")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            startExpectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
        mockDelegate.didConfirmAutomotiveCalls.removeAll()

        // When: Walking detected
        let walkingActivity = TestableMotionActivity(walking: true, confidence: .high)
        motionHandler.processActivity(walkingActivity)

        // Then: Immediate detection
        XCTAssertFalse(motionHandler.isAutomotive)
        XCTAssertEqual(mockDelegate.didDetectAutomotiveCalls.last, false)

        // Wait for debounce
        let endExpectation = expectation(description: "Debounce fires")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            endExpectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)

        // Then: Confirmed end
        let nonAutomotiveConfirmations = mockDelegate.didConfirmAutomotiveCalls.filter { !$0 }
        XCTAssertEqual(nonAutomotiveConfirmations.count, 1,
                       "Walking should confirm non-automotive state after debounce")
    }

    func testStationaryDebounceDelaysEnd() {
        // Given: Trip is active with longer debounce
        motionHandler.automotiveDebounceSeconds = 0.1
        motionHandler.nonAutomotiveDebounceSeconds = 0.2
        let automotiveActivity = TestableMotionActivity(automotive: true, confidence: .high)
        motionHandler.processActivity(automotiveActivity)

        // Wait for automotive confirmation
        let startExpectation = expectation(description: "Start confirmed")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            startExpectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
        mockDelegate.didConfirmAutomotiveCalls.removeAll()

        // When: Stationary detected
        let stationaryActivity = TestableMotionActivity(stationary: true, confidence: .high)
        motionHandler.processActivity(stationaryActivity)

        // Check immediately after (before debounce)
        XCTAssertFalse(motionHandler.isAutomotive, "isAutomotive should update immediately")

        // No confirmation yet
        let immediateConfirmations = mockDelegate.didConfirmAutomotiveCalls.filter { !$0 }
        XCTAssertEqual(immediateConfirmations.count, 0,
                       "Should not confirm immediately - wait for debounce")

        // Wait for debounce
        let endExpectation = expectation(description: "Debounce fires")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            endExpectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)

        // Then: Confirmed
        let finalConfirmations = mockDelegate.didConfirmAutomotiveCalls.filter { !$0 }
        XCTAssertEqual(finalConfirmations.count, 1,
                       "Should confirm non-automotive after debounce period")
    }

    // MARK: - Integration Scenario Tests

    func testWalkToCarScenario() {
        // Given: Default debounce settings
        motionHandler.automotiveDebounceSeconds = 0.1

        // When: Walking detected first (approaching car)
        let walkingActivity = TestableMotionActivity(walking: true, confidence: .high)
        motionHandler.processActivity(walkingActivity)

        // Then: No automotive yet
        XCTAssertFalse(motionHandler.isAutomotive)

        // When: Gets in car - automotive detected
        let automotiveActivity = TestableMotionActivity(automotive: true, confidence: .high)
        motionHandler.processActivity(automotiveActivity)

        // Then: Trip starts (immediate detection)
        XCTAssertTrue(motionHandler.isAutomotive)
        XCTAssertTrue(mockDelegate.didDetectAutomotiveCalls.contains(true))

        // Wait for confirmation
        let expectation = expectation(description: "Debounce fires")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)

        // Confirmed automotive
        XCTAssertTrue(mockDelegate.didConfirmAutomotiveCalls.contains(true),
                      "Walk to car scenario should confirm trip start")
    }

    func testTrafficScenario() {
        // Given: Trip is active
        motionHandler.automotiveDebounceSeconds = 0.1
        motionHandler.nonAutomotiveDebounceSeconds = 0.2
        let automotiveActivity = TestableMotionActivity(automotive: true, confidence: .high)
        motionHandler.processActivity(automotiveActivity)
        XCTAssertTrue(motionHandler.isAutomotive)

        // Wait for initial automotive confirmation
        let startExpectation = expectation(description: "Start confirmed")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            startExpectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
        mockDelegate.didConfirmAutomotiveCalls.removeAll()

        // When: Stop in traffic (stationary)
        let stationaryActivity = TestableMotionActivity(stationary: true, confidence: .high)
        motionHandler.processActivity(stationaryActivity)

        // Traffic light turns green - automotive again (within debounce)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.motionHandler.processActivity(automotiveActivity)
        }

        // Wait for potential debounce
        let endExpectation = expectation(description: "Traffic scenario complete")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            endExpectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)

        // Then: Trip continues - no false end
        XCTAssertTrue(motionHandler.isAutomotive,
                      "Traffic stop should not end trip")
        let nonAutomotiveConfirmations = mockDelegate.didConfirmAutomotiveCalls.filter { !$0 }
        XCTAssertEqual(nonAutomotiveConfirmations.count, 0,
                       "Traffic scenario should not confirm trip end")
    }

    func testParkingScenario() {
        // Given: Trip is active
        motionHandler.automotiveDebounceSeconds = 0.1
        motionHandler.nonAutomotiveDebounceSeconds = 0.1
        let automotiveActivity = TestableMotionActivity(automotive: true, confidence: .high)
        motionHandler.processActivity(automotiveActivity)

        // Wait for automotive confirmation
        let startExpectation = expectation(description: "Start confirmed")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            startExpectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
        mockDelegate.didConfirmAutomotiveCalls.removeAll()

        // When: Parking (stationary for longer than debounce)
        let stationaryActivity = TestableMotionActivity(stationary: true, confidence: .high)
        motionHandler.processActivity(stationaryActivity)

        // Wait beyond debounce period
        let endExpectation = expectation(description: "Parking detected")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            endExpectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)

        // Then: Trip ends
        XCTAssertFalse(motionHandler.isAutomotive)
        let nonAutomotiveConfirmations = mockDelegate.didConfirmAutomotiveCalls.filter { !$0 }
        XCTAssertEqual(nonAutomotiveConfirmations.count, 1,
                       "Parking should confirm trip end after debounce")
    }

    func testCancelPendingDebounce() {
        // Given: Debounce is pending
        motionHandler.automotiveDebounceSeconds = 0.1
        motionHandler.nonAutomotiveDebounceSeconds = 0.3
        let automotiveActivity = TestableMotionActivity(automotive: true, confidence: .high)
        motionHandler.processActivity(automotiveActivity)

        // Wait for automotive confirmation
        let startExpectation = expectation(description: "Start confirmed")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            startExpectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
        mockDelegate.didConfirmAutomotiveCalls.removeAll()

        // Start non-automotive debounce
        let stationaryActivity = TestableMotionActivity(stationary: true, confidence: .high)
        motionHandler.processActivity(stationaryActivity)

        // When: Cancel is called
        motionHandler.cancelPendingDebounce()

        // Wait past normal debounce time
        let cancelExpectation = expectation(description: "Debounce would have fired")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            cancelExpectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)

        // Then: No confirmation sent
        let nonAutomotiveConfirmations = mockDelegate.didConfirmAutomotiveCalls.filter { !$0 }
        XCTAssertEqual(nonAutomotiveConfirmations.count, 0,
                       "Cancelled debounce should not confirm")
    }
}

// MARK: - Test Helpers

/// Mock delegate to capture motion handler callbacks
class MockMotionDelegate: MotionActivityHandlerDelegate {
    var didDetectAutomotiveCalls: [Bool] = []
    var didConfirmAutomotiveCalls: [Bool] = []
    var didChangeStateCalls: [MotionState] = []

    func motionHandler(_ handler: MotionActivityHandlerProtocol, didDetectAutomotive isAutomotive: Bool) {
        didDetectAutomotiveCalls.append(isAutomotive)
    }

    func motionHandler(_ handler: MotionActivityHandlerProtocol, didConfirmAutomotive isAutomotive: Bool) {
        didConfirmAutomotiveCalls.append(isAutomotive)
    }

    func motionHandler(_ handler: MotionActivityHandlerProtocol, didChangeState state: MotionState) {
        didChangeStateCalls.append(state)
    }
}

/// Testable CMMotionActivity subclass that allows setting read-only properties
/// CMMotionActivity properties are normally read-only, this allows testing
class TestableMotionActivity: CMMotionActivity {
    private let _automotive: Bool
    private let _stationary: Bool
    private let _walking: Bool
    private let _running: Bool
    private let _confidence: CMMotionActivityConfidence

    init(automotive: Bool = false,
         stationary: Bool = false,
         walking: Bool = false,
         running: Bool = false,
         confidence: CMMotionActivityConfidence = .high) {
        self._automotive = automotive
        self._stationary = stationary
        self._walking = walking
        self._running = running
        self._confidence = confidence
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    override var automotive: Bool { _automotive }
    override var stationary: Bool { _stationary }
    override var walking: Bool { _walking }
    override var running: Bool { _running }
    override var confidence: CMMotionActivityConfidence { _confidence }
}
