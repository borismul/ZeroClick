import XCTest
import CoreLocation
@testable import Runner

/// Tests for distance calculation with many GPS points and various scenarios
class DistanceCalculationTests: XCTestCase {

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

    // MARK: - Many Points Tests

    func testDistanceWith100Points() {
        // Given: Start tracking
        simulator.motionHandler.simulateStartDriving()

        // Generate 100 points along a straight line (~10km total)
        let startLat = 51.9270
        let startLng = 4.3620
        let latStep = 0.0009  // ~100m per step
        let lngStep = 0.0012  // ~100m per step

        // When: Inject 100 location updates
        for i in 0..<100 {
            let lat = startLat + (Double(i) * latStep)
            let lng = startLng + (Double(i) * lngStep)
            simulator.locationService.injectLocation(lat: lat, lng: lng, accuracy: 10)
        }

        // Then: Distance should be approximately 10km (100 points * ~100m each)
        let distanceKm = appDelegate.totalDistanceMeters / 1000.0
        XCTAssertGreaterThan(distanceKm, 8.0, "Should have at least 8km with 100 points")
        XCTAssertLessThan(distanceKm, 20.0, "Should be less than 20km")

        // Verify Live Activity was updated many times
        XCTAssertGreaterThan(simulator.liveActivityManager.stateUpdates.count, 90)
    }

    func testDistanceWith500Points() {
        // Given: Start tracking
        simulator.motionHandler.simulateStartDriving()

        // Generate 500 points (~50km highway trip)
        let startLat = 51.9270
        let startLng = 4.3620
        let latStep = 0.0009
        let lngStep = 0.0012

        // When: Inject 500 location updates
        for i in 0..<500 {
            let lat = startLat + (Double(i) * latStep)
            let lng = startLng + (Double(i) * lngStep)
            simulator.locationService.injectLocation(lat: lat, lng: lng, accuracy: 10)
        }

        // Then: Should handle 500 points efficiently
        let distanceKm = appDelegate.totalDistanceMeters / 1000.0
        XCTAssertGreaterThan(distanceKm, 40.0, "Should have substantial distance")
        XCTAssertEqual(simulator.liveActivityManager.stateUpdates.count, 500)
    }

    func testDistanceWith1000Points() {
        // Given: Start tracking
        simulator.motionHandler.simulateStartDriving()

        // Generate 1000 points (long trip)
        let startLat = 51.9270
        let startLng = 4.3620

        // When: Inject 1000 location updates
        for i in 0..<1000 {
            let lat = startLat + (Double(i) * 0.0005)  // Smaller steps
            let lng = startLng + (Double(i) * 0.0007)
            simulator.locationService.injectLocation(lat: lat, lng: lng, accuracy: 10)
        }

        // Then: Should handle 1000 points without issues
        XCTAssertGreaterThan(appDelegate.totalDistanceMeters, 0)
        XCTAssertEqual(appDelegate.pingCount, 1000)
    }

    // MARK: - Route Pattern Tests

    func testZigZagRoute() {
        // Given: Start tracking
        simulator.motionHandler.simulateStartDriving()

        let baseLat = 51.9270
        let baseLng = 4.3620

        // When: Inject zigzag pattern (simulates city driving)
        for i in 0..<50 {
            let lat = baseLat + (Double(i) * 0.002)
            // Zigzag: alternate east and west
            let lngOffset = (i % 2 == 0) ? 0.003 : -0.003
            let lng = baseLng + (Double(i) * 0.001) + lngOffset
            simulator.locationService.injectLocation(lat: lat, lng: lng, accuracy: 10)
        }

        // Then: Distance accumulated (zigzag adds more distance than straight line)
        let distanceKm = appDelegate.totalDistanceMeters / 1000.0
        XCTAssertGreaterThan(distanceKm, 5.0, "Zigzag route should have substantial distance")
    }

    func testCircularRoute() {
        // Given: Start tracking
        simulator.motionHandler.simulateStartDriving()

        let centerLat = 51.9270
        let centerLng = 4.3620
        let radius = 0.01  // ~1km radius

        // When: Inject circular route (36 points around circle)
        for i in 0..<36 {
            let angle = Double(i) * (2.0 * .pi / 36.0)
            let lat = centerLat + (radius * cos(angle))
            let lng = centerLng + (radius * sin(angle))
            simulator.locationService.injectLocation(lat: lat, lng: lng, accuracy: 10)
        }

        // Then: Distance should be approximately circumference (2 * pi * 1km = ~6.28km)
        let distanceKm = appDelegate.totalDistanceMeters / 1000.0
        XCTAssertGreaterThan(distanceKm, 4.0, "Circular route should be ~6km")
        XCTAssertLessThan(distanceKm, 10.0, "Should not exceed reasonable bounds")
    }

    func testReturnToStartRoute() {
        // Given: Start tracking
        simulator.motionHandler.simulateStartDriving()

        // When: Go somewhere and return (points <1km apart to avoid GPS jump filter)
        let points: [(Double, Double)] = [
            (51.9270, 4.3620),  // Start
            (51.9280, 4.3680),  // Point 1 (~500m)
            (51.9290, 4.3740),  // Point 2
            (51.9300, 4.3800),  // Furthest point
            (51.9290, 4.3740),  // Return point 2
            (51.9280, 4.3680),  // Return point 1
            (51.9270, 4.3620),  // Back to start
        ]

        for (lat, lng) in points {
            simulator.locationService.injectLocation(lat: lat, lng: lng, accuracy: 10)
        }

        // Then: Distance should count both directions
        let distanceKm = appDelegate.totalDistanceMeters / 1000.0
        XCTAssertGreaterThan(distanceKm, 1.0, "Round trip should count both ways")
    }

    // MARK: - Edge Cases

    func testVeryClosePoints() {
        // Given: Start tracking
        simulator.motionHandler.simulateStartDriving()

        let baseLat = 51.9270
        let baseLng = 4.3620

        // When: Inject many points that are very close (< 10m apart)
        for i in 0..<100 {
            let lat = baseLat + (Double(i) * 0.00001)  // ~1m steps
            let lng = baseLng + (Double(i) * 0.00001)
            simulator.locationService.injectLocation(lat: lat, lng: lng, accuracy: 5)
        }

        // Then: Small distances still accumulated
        XCTAssertGreaterThan(appDelegate.totalDistanceMeters, 0)
        // Total should be roughly 100 * ~1.5m = ~150m
        XCTAssertLessThan(appDelegate.totalDistanceMeters, 500)
    }

    func testGPSJumpsFiltered() {
        // Given: Start tracking
        simulator.motionHandler.simulateStartDriving()

        // Set initial location
        simulator.locationService.injectLocation(lat: 51.9270, lng: 4.3620, accuracy: 10)
        let distanceAfterFirst = appDelegate.totalDistanceMeters

        // When: GPS jump > 1000m (should be filtered)
        simulator.locationService.injectLocation(lat: 52.0000, lng: 4.5000, accuracy: 10)

        // Then: Distance should NOT include the jump (>1000m filter)
        XCTAssertEqual(appDelegate.totalDistanceMeters, distanceAfterFirst,
                       "GPS jumps > 1000m should be filtered out")
    }

    func testMixedAccuracyPoints() {
        // Given: Start tracking
        simulator.motionHandler.simulateStartDriving()

        // When: Mix of good and bad accuracy points
        simulator.locationService.injectLocation(lat: 51.9270, lng: 4.3620, accuracy: 10)  // Good
        simulator.locationService.injectLocation(lat: 51.9280, lng: 4.3650, accuracy: 100) // Bad - ignored
        simulator.locationService.injectLocation(lat: 51.9290, lng: 4.3680, accuracy: 15)  // Good
        simulator.locationService.injectLocation(lat: 51.9300, lng: 4.3710, accuracy: 200) // Bad - ignored
        simulator.locationService.injectLocation(lat: 51.9310, lng: 4.3740, accuracy: 20)  // Good

        // Then: Only good accuracy points contribute to distance
        // Distance should be based on points 1, 3, 5 (skipping 2, 4)
        let distanceKm = appDelegate.totalDistanceMeters / 1000.0
        XCTAssertGreaterThan(distanceKm, 0)
        // Should be less than if all points counted
        XCTAssertLessThan(distanceKm, 2.0)
    }

    func testStationaryPoints() {
        // Given: Start tracking
        simulator.motionHandler.simulateStartDriving()

        // When: Multiple points at same location (stationary in traffic)
        for _ in 0..<20 {
            simulator.locationService.injectLocation(lat: 51.9270, lng: 4.3620, accuracy: 10)
        }

        // Then: Distance should be 0 (no movement)
        XCTAssertEqual(appDelegate.totalDistanceMeters, 0, accuracy: 1.0,
                       "Stationary points should not accumulate distance")
    }

    // MARK: - Real-World Route Simulations

    func testRotterdamToAmsterdam() {
        // Given: Start tracking
        simulator.motionHandler.simulateStartDriving()

        // Simulate highway route with points <1km apart (to avoid GPS jump filter)
        // Generate 60 points for a ~60km trip
        let startLat = 51.9270
        let startLng = 4.3620
        let endLat = 52.3700
        let endLng = 4.8900

        // 60 points means each step is ~1km
        let steps = 60
        for i in 0..<steps {
            let progress = Double(i) / Double(steps - 1)
            let lat = startLat + (endLat - startLat) * progress
            let lng = startLng + (endLng - startLng) * progress
            simulator.locationService.injectLocation(lat: lat, lng: lng, accuracy: 10)
        }

        // Then: Distance should be substantial (straight line is ~55km)
        let distanceKm = appDelegate.totalDistanceMeters / 1000.0
        XCTAssertGreaterThan(distanceKm, 45.0, "Rotterdam-Amsterdam straight line should be ~55km")
        XCTAssertLessThan(distanceKm, 70.0, "Should not exceed 70km")
    }

    func testCityDrivingWithStops() {
        // Given: Start tracking
        simulator.motionHandler.simulateStartDriving()

        // City driving: drive, stop, drive, stop pattern
        let segments: [[(Double, Double)]] = [
            // Segment 1: Home to traffic light
            [(51.9270, 4.3620), (51.9275, 4.3640), (51.9280, 4.3660)],
            // Stop at traffic light (3 pings at same location)
            [(51.9280, 4.3660), (51.9280, 4.3660), (51.9280, 4.3660)],
            // Segment 2: Continue to next stop
            [(51.9285, 4.3680), (51.9290, 4.3700), (51.9295, 4.3720)],
            // Stop at intersection
            [(51.9295, 4.3720), (51.9295, 4.3720)],
            // Segment 3: Final stretch
            [(51.9300, 4.3740), (51.9305, 4.3760), (51.9310, 4.3780)],
        ]

        // When: Drive with stops
        for segment in segments {
            for (lat, lng) in segment {
                simulator.locationService.injectLocation(lat: lat, lng: lng, accuracy: 10)
            }
        }

        // Then: Distance accumulated from moving segments only
        let distanceKm = appDelegate.totalDistanceMeters / 1000.0
        XCTAssertGreaterThan(distanceKm, 0.5, "Should have accumulated distance")
        XCTAssertLessThan(distanceKm, 3.0, "Should be a short city trip")
    }

    // MARK: - Performance Tests

    func testPerformanceWith10000Points() {
        // Given: Start tracking
        simulator.motionHandler.simulateStartDriving()

        // When: Inject 10,000 points
        measure {
            for i in 0..<10000 {
                let lat = 51.9270 + (Double(i) * 0.0001)
                let lng = 4.3620 + (Double(i) * 0.0001)
                simulator.locationService.injectLocation(lat: lat, lng: lng, accuracy: 10)
            }
        }

        // Then: Should complete quickly (performance measured by XCTest)
        XCTAssertGreaterThan(appDelegate.totalDistanceMeters, 0)
    }

    // MARK: - Distance Accuracy Tests

    func testKnownDistanceAccuracy() {
        // Given: Start tracking
        simulator.motionHandler.simulateStartDriving()

        // Two points that are exactly 500m apart (within 1km filter)
        // At latitude 51.9, 1 degree longitude = ~66km
        // So 0.00758 degrees longitude = ~500m
        let startLat = 51.9270
        let startLng = 4.3620
        let endLng = 4.3620 + 0.00758  // ~500m east

        // When: Move 500m east
        simulator.locationService.injectLocation(lat: startLat, lng: startLng, accuracy: 5)
        simulator.locationService.injectLocation(lat: startLat, lng: endLng, accuracy: 5)

        // Then: Distance should be approximately 500m (within 10% tolerance)
        XCTAssertEqual(appDelegate.totalDistanceMeters, 500, accuracy: 50,
                       "500m movement should measure ~500m")
    }

    func testMultipleSegmentsAddUp() {
        // Given: Start tracking
        simulator.motionHandler.simulateStartDriving()

        // Ten 500m segments (should total 5km) - points <1km apart
        let startLat = 51.9270
        var currentLng = 4.3620

        for _ in 0..<10 {
            simulator.locationService.injectLocation(lat: startLat, lng: currentLng, accuracy: 5)
            currentLng += 0.00758  // Move 500m east
        }
        // Final point
        simulator.locationService.injectLocation(lat: startLat, lng: currentLng, accuracy: 5)

        // Then: Total should be ~5km
        let distanceKm = appDelegate.totalDistanceMeters / 1000.0
        XCTAssertEqual(distanceKm, 5.0, accuracy: 0.5, "10 segments of 500m should equal ~5km")
    }

    // MARK: - Edge Cases for Robustness

    func testGPSDriftWhenStationary() {
        // Given: Start tracking at a location
        simulator.motionHandler.simulateStartDriving()

        let baseLat = 51.9270
        let baseLng = 4.3620

        // When: GPS "drifts" slightly (common when stationary)
        for i in 0..<20 {
            // Small random-like drift (within 10m)
            let drift = Double(i % 5) * 0.00001  // ~1m
            simulator.locationService.injectLocation(
                lat: baseLat + drift,
                lng: baseLng + (drift * 0.7),
                accuracy: 10
            )
        }

        // Then: Distance should be minimal (drift is noise)
        XCTAssertLessThan(appDelegate.totalDistanceMeters, 200,
                          "GPS drift should not accumulate significant distance")
    }

    func testRapidStartStopCycles() {
        // Given: Multiple rapid start/stop cycles (traffic lights)
        for cycle in 0..<5 {
            // Start driving
            simulator.motionHandler.simulateStartDriving()

            // Move a bit
            let lat = 51.9270 + (Double(cycle) * 0.002)
            let lng = 4.3620 + (Double(cycle) * 0.003)
            simulator.locationService.injectLocation(lat: lat, lng: lng, accuracy: 10)

            // Stop
            simulator.motionHandler.simulateStopDriving()

            // Reset for next cycle
            appDelegate.reset()
            simulator.reset()
            appDelegate.injectServices(
                location: simulator.locationService,
                motion: simulator.motionHandler,
                liveActivity: simulator.liveActivityManager,
                watch: simulator.watchService
            )
        }

        // Then: No crashes, clean state
        XCTAssertFalse(appDelegate.isActivelyTracking)
        XCTAssertEqual(appDelegate.totalDistanceMeters, 0)
    }

    func testExtremelyFastMovement() {
        // Given: Start tracking
        simulator.motionHandler.simulateStartDriving()

        // When: Very fast updates (simulates highway driving with frequent GPS)
        for i in 0..<100 {
            let lat = 51.9270 + (Double(i) * 0.005)  // ~500m per update (fast!)
            let lng = 4.3620 + (Double(i) * 0.007)
            simulator.locationService.injectLocation(lat: lat, lng: lng, accuracy: 10)
        }

        // Then: Should handle without issues
        XCTAssertGreaterThan(appDelegate.totalDistanceMeters, 0)
        XCTAssertEqual(simulator.liveActivityManager.stateUpdates.count, 100)
    }

    func testLocationAccuracyDegradation() {
        // Given: Start with good accuracy, degrade over time
        simulator.motionHandler.simulateStartDriving()

        let points: [(Double, Double, Double)] = [
            (51.9270, 4.3620, 5),    // Excellent
            (51.9280, 4.3660, 10),   // Good
            (51.9290, 4.3700, 25),   // Moderate
            (51.9300, 4.3740, 60),   // Poor - should be filtered
            (51.9310, 4.3780, 100),  // Very poor - should be filtered
            (51.9320, 4.3820, 15),   // Good again
        ]

        // When: Inject with varying accuracy
        for (lat, lng, accuracy) in points {
            simulator.locationService.injectLocation(lat: lat, lng: lng, accuracy: accuracy)
        }

        // Then: Only good accuracy points contribute
        // Points 1-3 and 6 should contribute (accuracy <= 50)
        // Points 4-5 should be filtered
        let distanceKm = appDelegate.totalDistanceMeters / 1000.0
        XCTAssertGreaterThan(distanceKm, 0.5)
        XCTAssertLessThan(distanceKm, 3.0, "Filtered points should reduce total")
    }

    func testTripAcrossEquator() {
        // Given: Trip crossing equator (tests negative/positive lat handling)
        simulator.motionHandler.simulateStartDriving()

        let points: [(Double, Double)] = [
            (0.5, 36.8),    // North of equator (Kenya)
            (0.3, 36.8),
            (0.1, 36.8),
            (-0.1, 36.8),   // South of equator
            (-0.3, 36.8),
        ]

        // When: Cross equator
        for (lat, lng) in points {
            simulator.locationService.injectLocation(lat: lat, lng: lng, accuracy: 10)
        }

        // Then: Distance should be calculated correctly across equator
        XCTAssertGreaterThan(appDelegate.totalDistanceMeters, 50000,
                             "Should measure ~80km across equator")
    }

    func testNegativeCoordinates() {
        // Given: Trip in southern/western hemisphere (Brazil)
        simulator.motionHandler.simulateStartDriving()

        let points: [(Double, Double)] = [
            (-23.5505, -46.6333),  // Sao Paulo
            (-23.5550, -46.6400),
            (-23.5600, -46.6500),
        ]

        // When: Drive with negative coords
        for (lat, lng) in points {
            simulator.locationService.injectLocation(lat: lat, lng: lng, accuracy: 10)
        }

        // Then: Distance calculated correctly
        XCTAssertGreaterThan(appDelegate.totalDistanceMeters, 500,
                             "Should handle negative coordinates")
    }

    func testHighLatitudeRoute() {
        // Given: Trip near Arctic (Norway)
        simulator.motionHandler.simulateStartDriving()

        let points: [(Double, Double)] = [
            (69.6496, 18.9560),  // Tromso
            (69.6550, 18.9700),
            (69.6600, 18.9850),
        ]

        // When: Drive at high latitude
        for (lat, lng) in points {
            simulator.locationService.injectLocation(lat: lat, lng: lng, accuracy: 10)
        }

        // Then: Distance calculated correctly (longitude degrees are shorter at high lat)
        XCTAssertGreaterThan(appDelegate.totalDistanceMeters, 100)
    }

    func testInterruptedTripStatePreservation() {
        // Given: Trip in progress
        simulator.motionHandler.simulateStartDriving()
        simulator.locationService.injectLocation(lat: 51.9270, lng: 4.3620, accuracy: 10)
        simulator.locationService.injectLocation(lat: 51.9290, lng: 4.3700, accuracy: 10)

        let distanceBeforeInterrupt = appDelegate.totalDistanceMeters
        let trackingBeforeInterrupt = appDelegate.isActivelyTracking

        // When: Trip continues (simulating app returning from background)
        simulator.locationService.injectLocation(lat: 51.9310, lng: 4.3780, accuracy: 10)

        // Then: State preserved and distance continues accumulating
        XCTAssertTrue(trackingBeforeInterrupt)
        XCTAssertGreaterThan(appDelegate.totalDistanceMeters, distanceBeforeInterrupt,
                             "Distance should continue accumulating after resume")
    }

    func testZeroDistanceTrip() {
        // Given: Start and immediately stop at same location
        simulator.motionHandler.simulateStartDriving()
        simulator.locationService.injectLocation(lat: 51.9270, lng: 4.3620, accuracy: 10)
        simulator.motionHandler.simulateStopDriving()

        // Then: Should handle gracefully
        XCTAssertEqual(appDelegate.totalDistanceMeters, 0)
        XCTAssertFalse(appDelegate.isActivelyTracking)
    }

    func testVeryLongTrip() {
        // Given: Very long trip (1000km+)
        simulator.motionHandler.simulateStartDriving()

        // 1000 points, each ~1km apart = ~1000km trip
        for i in 0..<1000 {
            let lat = 40.0 + (Double(i) * 0.009)  // Move north
            let lng = -3.0 + (Double(i) * 0.001)  // Move east
            simulator.locationService.injectLocation(lat: lat, lng: lng, accuracy: 10)
        }

        // Then: Should handle long trips
        let distanceKm = appDelegate.totalDistanceMeters / 1000.0
        XCTAssertGreaterThan(distanceKm, 800, "Should handle 1000km+ trips")
    }
}
