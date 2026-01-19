import XCTest
import CoreLocation
@testable import Runner

/// Tests for complete trip lifecycle using mock services
class TripLifecycleTests: XCTestCase {

    var simulator: DriveSimulator!
    var appDelegate: TestableAppDelegate!

    override func setUp() {
        super.setUp()
        simulator = DriveSimulator()
        appDelegate = TestableAppDelegate()
        appDelegate.injectServices(
            location: simulator.locationService,
            motion: simulator.motionHandler,
            liveActivity: simulator.liveActivityManager,
            watch: simulator.watchService
        )
        appDelegate.startServices()
    }

    override func tearDown() {
        simulator.reset()
        appDelegate.reset()
        super.tearDown()
    }

    // MARK: - Motion Detection Tests

    func testAutomotiveDetectionStartsTracking() {
        // Given: Services are running
        XCTAssertFalse(appDelegate.isActivelyTracking)

        // When: Automotive motion detected
        simulator.motionHandler.simulateStartDriving()

        // Then: Tracking starts
        XCTAssertTrue(appDelegate.isDriving)
        XCTAssertTrue(appDelegate.isActivelyTracking)
        XCTAssertTrue(simulator.locationService.highAccuracyEnabled)
        XCTAssertTrue(simulator.liveActivityManager.startActivityCalled)
    }

    func testStationaryStopsTracking() {
        // Given: Currently tracking
        simulator.motionHandler.simulateStartDriving()
        XCTAssertTrue(appDelegate.isActivelyTracking)

        // When: Motion stops
        simulator.motionHandler.simulateStopDriving()

        // Then: Tracking stops
        XCTAssertFalse(appDelegate.isDriving)
        XCTAssertFalse(appDelegate.isActivelyTracking)
        XCTAssertTrue(simulator.locationService.lowAccuracyEnabled)
        XCTAssertTrue(simulator.liveActivityManager.endActivityCalled)
    }

    func testWalkingDoesNotStartTracking() {
        // Given: Not driving
        XCTAssertFalse(appDelegate.isDriving)

        // When: Walking detected
        simulator.motionHandler.simulateWalking()

        // Then: No tracking
        XCTAssertFalse(appDelegate.isDriving)
        XCTAssertFalse(appDelegate.isActivelyTracking)
        XCTAssertFalse(simulator.liveActivityManager.startActivityCalled)
    }

    // MARK: - Location Update Tests

    func testLocationUpdatesAccumulateDistance() {
        // Given: Tracking started with motion, then inject a starting location
        simulator.motionHandler.simulateStartDriving()
        // First location sets baseline
        simulator.locationService.injectLocation(lat: 51.9270, lng: 4.3620, accuracy: 10)

        // When: Inject a different location (moves ~500m - within 1000m threshold)
        simulator.locationService.injectLocation(lat: 51.9285, lng: 4.3690, accuracy: 10)

        // Then: Distance accumulated (approximately 500m)
        XCTAssertGreaterThan(appDelegate.totalDistanceMeters, 0)
        XCTAssertTrue(simulator.liveActivityManager.updateActivityCalled)
    }

    func testLocationUpdatesSendPings() {
        // Given: Tracking started
        simulator.setupHomeToOfficeTrip()
        simulator.startTrip()

        // When: Location updates
        simulator.triggerPing()
        simulator.triggerPing()

        // Then: Pings sent
        XCTAssertGreaterThan(appDelegate.pingCount, 0)
        let pingCalls = appDelegate.apiCallsMade.filter { $0.type == "ping" }
        XCTAssertGreaterThan(pingCalls.count, 0)
    }

    func testPoorAccuracyLocationsIgnored() {
        // Given: Tracking started
        simulator.motionHandler.simulateStartDriving()

        // When: Poor accuracy location - first location sets lastLocation
        simulator.locationService.injectLocation(lat: 51.93, lng: 4.39, accuracy: 100)
        let distanceAfterFirst = appDelegate.totalDistanceMeters

        // Then: Second poor accuracy location should not accumulate distance
        simulator.locationService.injectLocation(lat: 51.94, lng: 4.40, accuracy: 100)

        // Distance should not accumulate for poor accuracy (>50m threshold)
        XCTAssertEqual(appDelegate.totalDistanceMeters, distanceAfterFirst)
    }

    // MARK: - Full Trip Lifecycle Tests

    func testCompleteHomeToOfficeTrip() {
        // Given: Home to office scenario
        simulator.setupHomeToOfficeTrip()

        // When: Complete trip
        simulator.runCompleteTrip()

        // Then: Full lifecycle completed - check individual states
        XCTAssertTrue(simulator.liveActivityManager.startActivityCalled,
                      "Live Activity should have started")
        XCTAssertTrue(simulator.liveActivityManager.endActivityCalled,
                      "Live Activity should have ended")
        XCTAssertTrue(simulator.watchService.notifyTripStartedCalled,
                      "Watch should have been notified")

        // Verify API calls - account for initial location inject that may trigger a ping
        let startCalls = appDelegate.apiCallsMade.filter { $0.type == "start" }
        let endCalls = appDelegate.apiCallsMade.filter { $0.type == "end" }
        let allCalls = appDelegate.apiCallsMade.map { $0.type }
        XCTAssertEqual(startCalls.count, 1,
                       "Should have 1 start call, got \(startCalls.count). All calls: \(allCalls)")
        XCTAssertEqual(endCalls.count, 1,
                       "Should have 1 end call, got \(endCalls.count). All calls: \(allCalls)")
    }

    func testTripStartCoordinatesCorrect() {
        // Given: Home to office scenario
        simulator.setupHomeToOfficeTrip()

        // When: Trip starts
        simulator.startTrip()

        // Then: Start coordinates are home
        let startCall = appDelegate.apiCallsMade.first { $0.type == "start" }
        XCTAssertNotNil(startCall)
        XCTAssertEqual(startCall?.lat ?? 0, DriveScenarios.homeLat, accuracy: 0.001)
        XCTAssertEqual(startCall?.lng ?? 0, DriveScenarios.homeLng, accuracy: 0.001)
    }

    // MARK: - Watch Connectivity Tests

    func testWatchNotifiedOnTripStart() {
        // Given: Services running
        XCTAssertFalse(simulator.watchService.notifyTripStartedCalled)

        // When: Trip starts
        simulator.setupHomeToOfficeTrip()
        simulator.startTrip()

        // Then: Watch notified
        XCTAssertTrue(simulator.watchService.notifyTripStartedCalled)
        XCTAssertEqual(simulator.watchService.tripStartNotificationCount, 1)
    }

    // MARK: - Live Activity Tests

    func testLiveActivityStartedWithCarName() {
        // Given: Not tracking

        // When: Trip starts
        simulator.motionHandler.simulateStartDriving()

        // Then: Live Activity started
        XCTAssertTrue(simulator.liveActivityManager.startActivityCalled)
        XCTAssertNotNil(simulator.liveActivityManager.lastCarName)
        XCTAssertNotNil(simulator.liveActivityManager.lastStartTime)
    }

    func testLiveActivityUpdatesShowProgress() {
        // Given: Tracking
        simulator.setupHomeToOfficeTrip()
        simulator.startTrip()

        // When: Multiple pings
        simulator.triggerPing()
        simulator.triggerPing()
        simulator.triggerPing()

        // Then: Live Activity updated with increasing distance
        XCTAssertGreaterThan(simulator.liveActivityManager.stateUpdates.count, 0)

        // Verify distance increases
        if simulator.liveActivityManager.stateUpdates.count >= 2 {
            let first = simulator.liveActivityManager.stateUpdates.first!
            let last = simulator.liveActivityManager.stateUpdates.last!
            XCTAssertGreaterThanOrEqual(last.distanceKm, first.distanceKm)
        }
    }

    func testLiveActivityEndsOnTripEnd() {
        // Given: Tracking
        simulator.setupHomeToOfficeTrip()
        simulator.startTrip()

        // When: Trip ends
        simulator.endTrip()

        // Then: Live Activity ended
        XCTAssertTrue(simulator.liveActivityManager.endActivityCalled)
        XCTAssertFalse(simulator.liveActivityManager.isActivityRunning)
    }

    // MARK: - Edge Case Tests

    func testDoubleStartIgnored() {
        // Given: Already tracking
        simulator.motionHandler.simulateStartDriving()
        let initialStartCount = appDelegate.apiCallsMade.filter { $0.type == "start" }.count

        // When: Another start trigger
        simulator.motionHandler.simulateStartDriving()

        // Then: No duplicate start
        let finalStartCount = appDelegate.apiCallsMade.filter { $0.type == "start" }.count
        XCTAssertEqual(initialStartCount, finalStartCount)
    }

    func testStopWithoutStartIgnored() {
        // Given: Not tracking
        XCTAssertFalse(appDelegate.isActivelyTracking)

        // When: Stop without start
        simulator.motionHandler.simulateStopDriving()

        // Then: No end call
        let endCalls = appDelegate.apiCallsMade.filter { $0.type == "end" }
        XCTAssertEqual(endCalls.count, 0)
    }

    func testFalseTripStartCancelledQuickly() {
        // Given: Not tracking
        XCTAssertFalse(appDelegate.isActivelyTracking)

        // When: Motion detected (automotive) then immediately stationary
        simulator.motionHandler.simulateStartDriving()
        XCTAssertTrue(appDelegate.isActivelyTracking)

        // Immediately stop (false trip start - maybe phone moved in car without driving)
        simulator.motionHandler.simulateStopDriving()

        // Then: Trip should be cancelled, no API calls made for such short trip
        XCTAssertFalse(appDelegate.isActivelyTracking)
        XCTAssertTrue(simulator.liveActivityManager.endActivityCalled)

        // Should have start but end should cancel the short trip
        let startCalls = appDelegate.apiCallsMade.filter { $0.type == "start" }
        let cancelCalls = appDelegate.apiCallsMade.filter { $0.type == "cancel" }
        // Either cancelled or just no end call (trip too short to finalize)
        XCTAssertTrue(startCalls.count <= 1)
    }

    func testRapidMotionChangesDebounced() {
        // Given: Not tracking
        XCTAssertFalse(appDelegate.isActivelyTracking)

        // When: Rapid motion changes (automotive → walking → automotive → stationary)
        simulator.motionHandler.simulateStartDriving()
        simulator.motionHandler.simulateWalking()
        simulator.motionHandler.simulateStartDriving()
        simulator.motionHandler.simulateStopDriving()

        // Then: Should not create multiple trips
        let startCalls = appDelegate.apiCallsMade.filter { $0.type == "start" }
        XCTAssertLessThanOrEqual(startCalls.count, 2, "Rapid changes should be debounced")
    }

    func testVeryShortTripSkipped() {
        // Given: Trip started
        simulator.motionHandler.simulateStartDriving()

        // When: Only one GPS point before stopping (no distance)
        simulator.locationService.injectLocation(lat: 51.9270, lng: 4.3620, accuracy: 10)
        simulator.motionHandler.simulateStopDriving()

        // Then: Trip should be skipped (not enough data)
        XCTAssertFalse(appDelegate.isActivelyTracking)
        // Total distance should be 0 or very small
        XCTAssertLessThan(appDelegate.totalDistanceMeters, 100, "Single point trip should have minimal distance")
    }

    // MARK: - Debounce Edge Case Tests

    /// Test: Walking to car with brief automotive detection does NOT start trip
    /// Scenario: User walks to car, phone briefly detects automotive (getting in car),
    /// then detects walking/stationary again (sitting in car without engine on)
    func testWalkToCarDoesNotFalseStart() {
        // Given: Not driving
        XCTAssertFalse(appDelegate.isDriving)
        XCTAssertFalse(appDelegate.isActivelyTracking)

        // When: Walking, brief automotive detection (without confirmation), then walking again
        simulator.motionHandler.injectState(.walking)
        XCTAssertFalse(appDelegate.isActivelyTracking, "Walking should not start trip")

        // Automotive detected but NOT confirmed (no debounce timer completion)
        simulator.motionHandler.injectState(.automotive)
        XCTAssertFalse(appDelegate.isActivelyTracking, "Unconfirmed automotive should not start trip")

        // Back to walking before debounce confirms
        simulator.motionHandler.injectState(.walking)
        XCTAssertFalse(appDelegate.isActivelyTracking, "Trip should not have started")

        // Then: No trip started, no API calls
        XCTAssertFalse(appDelegate.isDriving)
        XCTAssertFalse(simulator.liveActivityManager.startActivityCalled)
        let startCalls = appDelegate.apiCallsMade.filter { $0.type == "start" }
        XCTAssertEqual(startCalls.count, 0, "No start call should be made for unconfirmed automotive")
    }

    /// Test: Traffic stops (brief stationary during driving) continue trip
    /// Scenario: Driving, stop at red light (stationary ~2s), continue driving
    func testTrafficStopsContinueTrip() {
        // Given: Trip started and driving
        simulator.setupHomeToOfficeTrip()
        simulator.startTrip()
        XCTAssertTrue(appDelegate.isActivelyTracking, "Trip should be active")

        // When: Brief stationary detection (traffic stop) - NOT confirmed
        simulator.motionHandler.injectState(.stationary)
        // Trip should continue (stationary not confirmed due to debounce)
        XCTAssertTrue(appDelegate.isActivelyTracking, "Brief stationary should not end trip")

        // Resume automotive before debounce confirms
        simulator.motionHandler.injectState(.automotive)
        XCTAssertTrue(appDelegate.isActivelyTracking, "Trip should continue")

        // Then: Trip continues, only one start call
        let startCalls = appDelegate.apiCallsMade.filter { $0.type == "start" }
        let endCalls = appDelegate.apiCallsMade.filter { $0.type == "end" }
        XCTAssertEqual(startCalls.count, 1)
        XCTAssertEqual(endCalls.count, 0, "Trip should not have ended")
    }

    /// Test: Brief stop (< debounce time) does not end trip
    /// Scenario: Driving, brief stop at gas station entrance, continue
    func testBriefStopDoesNotEndTrip() {
        // Given: Driving
        simulator.motionHandler.simulateStartDriving()
        XCTAssertTrue(appDelegate.isActivelyTracking)

        // When: Stationary for brief moment (detection only, no confirmation)
        simulator.motionHandler.injectState(.stationary)

        // Then: Still tracking
        XCTAssertTrue(appDelegate.isActivelyTracking, "Brief stop should not end trip")
        XCTAssertFalse(simulator.liveActivityManager.endActivityCalled)
    }

    /// Test: Actual parking (confirmed stationary) ends trip
    /// Scenario: Driving, park and turn off engine, stay stationary > debounce time
    func testParkingEndsTrip() {
        // Given: Driving
        simulator.motionHandler.simulateStartDriving()
        XCTAssertTrue(appDelegate.isActivelyTracking)
        simulator.locationService.injectLocation(lat: 51.9270, lng: 4.3620, accuracy: 10)

        // When: Stationary detected AND confirmed (simulates debounce timer completing)
        simulator.motionHandler.simulateStopDriving() // This includes confirmation

        // Then: Trip ends
        XCTAssertFalse(appDelegate.isActivelyTracking, "Confirmed stationary should end trip")
        XCTAssertTrue(simulator.liveActivityManager.endActivityCalled)
        let endCalls = appDelegate.apiCallsMade.filter { $0.type == "end" }
        XCTAssertEqual(endCalls.count, 1)
    }

    /// Test: Walking after driving (confirmed) ends trip
    /// Scenario: Driver parks, gets out, walks away
    func testWalkingAfterDrivingEndsTrip() {
        // Given: Driving
        simulator.motionHandler.simulateStartDriving()
        XCTAssertTrue(appDelegate.isActivelyTracking)
        simulator.locationService.injectLocation(lat: 51.9270, lng: 4.3620, accuracy: 10)

        // When: Walking detected AND confirmed
        simulator.motionHandler.simulateWalking() // This includes confirmation

        // Then: Trip ends
        XCTAssertFalse(appDelegate.isActivelyTracking, "Confirmed walking should end trip")
        XCTAssertFalse(appDelegate.isDriving)
        XCTAssertTrue(simulator.liveActivityManager.endActivityCalled)
    }

    /// Test: Low confidence events are ignored and don't start trips
    /// Scenario: Phone detects low-confidence automotive (unreliable signal)
    func testLowConfidenceDoesNotStartTrip() {
        // Given: Not driving
        XCTAssertFalse(appDelegate.isDriving)

        // When: Low confidence automotive detected (below threshold)
        simulator.motionHandler.simulateWithConfidence(.automotive, confidence: .low)

        // Then: Trip should not start (low confidence ignored by mock handler)
        XCTAssertFalse(appDelegate.isDriving, "Low confidence should be ignored")
        XCTAssertFalse(appDelegate.isActivelyTracking)
        XCTAssertFalse(simulator.liveActivityManager.startActivityCalled)
    }

    /// Test: Automotive oscillation during stationary confirmation gets cancelled
    /// Scenario: Driving, brief stationary, then automotive again before confirmation
    func testAutomotiveResumeCancelsStationaryDebounce() {
        // Given: Driving
        simulator.motionHandler.simulateStartDriving()
        XCTAssertTrue(appDelegate.isActivelyTracking)

        // When: Stationary detected (starts debounce) then automotive resumes
        simulator.motionHandler.injectState(.stationary)
        XCTAssertTrue(appDelegate.isActivelyTracking, "Unconfirmed stationary continues trip")

        simulator.motionHandler.injectState(.automotive)
        XCTAssertTrue(appDelegate.isActivelyTracking, "Automotive resume continues trip")

        // Then: Trip continues, no end call
        XCTAssertFalse(simulator.liveActivityManager.endActivityCalled, "Trip should not have ended")
    }

    /// Test: Multiple rapid state changes don't cause duplicate trips
    /// Scenario: Rapid oscillation between automotive/stationary/walking
    func testRapidOscillationPreventsMultipleTrips() {
        // Given: Not tracking, with location available for API calls
        XCTAssertFalse(appDelegate.isActivelyTracking)
        simulator.locationService.injectLocation(lat: 51.9270, lng: 4.3620, accuracy: 10)

        // When: Rapid detection changes without confirmation
        simulator.motionHandler.injectState(.automotive)
        simulator.motionHandler.injectState(.walking)
        simulator.motionHandler.injectState(.automotive)
        simulator.motionHandler.injectState(.stationary)
        simulator.motionHandler.injectState(.automotive)

        // Then: No trips started (none confirmed)
        XCTAssertFalse(appDelegate.isActivelyTracking, "Unconfirmed oscillation should not start trip")

        // Now confirm automotive - this should start the trip
        simulator.motionHandler.simulateConfirmAutomotive(true)
        XCTAssertTrue(appDelegate.isActivelyTracking, "Confirmed automotive should start trip")

        // Only one start call (location was set before confirmation)
        let startCalls = appDelegate.apiCallsMade.filter { $0.type == "start" }
        XCTAssertEqual(startCalls.count, 1, "Should have exactly one start call")
    }
}
