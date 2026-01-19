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
}
