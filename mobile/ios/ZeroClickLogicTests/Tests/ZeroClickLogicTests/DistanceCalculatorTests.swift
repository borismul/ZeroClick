import Testing
@testable import ZeroClickLogic

// MARK: - Haversine Formula Tests

@Suite("Haversine Distance Calculations", .tags(.core))
struct HaversineTests {

    @Test("Known distances between cities", arguments: [
        // (from, to, expectedKm, tolerancePercent)
        (KnownLocations.rotterdamCentral, KnownLocations.amsterdamCentral, 57.0, 5.0),
        (KnownLocations.londonBigBen, KnownLocations.parisEiffel, 344.0, 5.0),
        (KnownLocations.newYorkTimesSquare, KnownLocations.londonBigBen, 5570.0, 5.0),
        (KnownLocations.sydneyOpera, KnownLocations.tokyoTower, 7820.0, 5.0),
    ])
    func knownDistances(from: Coordinate, to: Coordinate, expectedKm: Double, tolerancePct: Double) {
        let distance = DistanceCalculator.haversineDistance(from: from, to: to)
        let distanceKm = distance / 1000
        let tolerance = expectedKm * tolerancePct / 100

        #expect(abs(distanceKm - expectedKm) < tolerance,
                "Expected ~\(expectedKm)km, got \(distanceKm)km")
    }

    @Test("Zero distance for same point")
    func samePoint() {
        let point = KnownLocations.rotterdamCentral
        let distance = DistanceCalculator.haversineDistance(from: point, to: point)
        #expect(distance == 0)
    }

    @Test("Distance is symmetric")
    func symmetric() {
        let a = KnownLocations.rotterdamCentral
        let b = KnownLocations.amsterdamCentral
        let distanceAB = DistanceCalculator.haversineDistance(from: a, to: b)
        let distanceBA = DistanceCalculator.haversineDistance(from: b, to: a)
        #expect(abs(distanceAB - distanceBA) < 0.001)
    }

    @Test("Short distance accuracy (100m)")
    func shortDistance() {
        let start = Coordinate(lat: 51.9244, lng: 4.4777)
        // Move ~100m north (approx 0.0009 degrees latitude)
        let end = Coordinate(lat: 51.9253, lng: 4.4777)
        let distance = DistanceCalculator.haversineDistance(from: start, to: end)
        #expect(distance > 90 && distance < 110, "Expected ~100m, got \(distance)m")
    }
}

// MARK: - GPS Filter Tests

@Suite("GPS Filtering", .tags(.filtering))
struct GPSFilterTests {

    @Test("Poor accuracy points are filtered", arguments: [
        60.0, 75.0, 100.0, 200.0, 500.0
    ])
    func poorAccuracyFiltered(badAccuracy: Double) {
        let coords = [
            Coordinate(lat: 51.92, lng: 4.47, accuracy: 10),
            Coordinate(lat: 51.93, lng: 4.48, accuracy: badAccuracy),  // Bad - should filter
            Coordinate(lat: 51.94, lng: 4.49, accuracy: 10),
        ]

        let result = DistanceCalculator.calculateDistance(coordinates: coords)

        #expect(result.pointsFiltered >= 1, "Should filter point with \(badAccuracy)m accuracy")
    }

    @Test("Good accuracy points are kept", arguments: [
        5.0, 10.0, 20.0, 30.0, 49.0
    ])
    func goodAccuracyKept(goodAccuracy: Double) {
        let coords = [
            Coordinate(lat: 51.920, lng: 4.470, accuracy: goodAccuracy),
            Coordinate(lat: 51.925, lng: 4.475, accuracy: goodAccuracy),
        ]

        let result = DistanceCalculator.calculateDistance(coordinates: coords)

        #expect(result.pointsFiltered == 0, "Should keep points with \(goodAccuracy)m accuracy")
        #expect(result.totalMeters > 0)
    }

    @Test("GPS jumps over 1km are filtered")
    func gpsJumpFiltered() {
        let coords = [
            Coordinate(lat: 51.92, lng: 4.47, accuracy: 10),
            Coordinate(lat: 52.92, lng: 4.47, accuracy: 10),  // 111km jump!
            Coordinate(lat: 51.93, lng: 4.48, accuracy: 10),
        ]

        let result = DistanceCalculator.calculateDistance(coordinates: coords)

        // The 111km jump should be filtered
        #expect(result.totalMeters < 5000, "Should filter 111km GPS jump, got \(result.totalMeters)m")
    }

    @Test("Reasonable jumps are kept", arguments: [
        100.0, 300.0, 500.0, 800.0, 950.0  // Stay safely under 1km filter
    ])
    func reasonableJumpsKept(jumpMeters: Double) {
        let jumpDegrees = jumpMeters / 111_000
        let coords = [
            Coordinate(lat: 51.920, lng: 4.470, accuracy: 10),
            Coordinate(lat: 51.920 + jumpDegrees, lng: 4.470, accuracy: 10),
        ]

        let result = DistanceCalculator.calculateDistance(coordinates: coords)

        #expect(result.pointsFiltered == 0, "Should keep \(jumpMeters)m jump")
        #expect(abs(result.totalMeters - jumpMeters) < jumpMeters * 0.1)
    }
}

// MARK: - Route Calculation Tests

@Suite("Route Distance Calculations", .tags(.routes))
struct RouteTests {

    @Test("Straight line route accumulates correctly")
    func straightLineRoute() {
        let route = RouteGenerator.straightLine(
            from: KnownLocations.rotterdamCentral,
            to: KnownLocations.schiedam,
            pointCount: 100
        )

        let result = DistanceCalculator.calculateDistance(coordinates: route)
        let directDistance = DistanceCalculator.haversineDistance(
            from: KnownLocations.rotterdamCentral,
            to: KnownLocations.schiedam
        )

        // Route should be very close to direct distance (within 1%)
        #expect(abs(result.totalMeters - directDistance) < directDistance * 0.01)
        #expect(result.pointsFiltered == 0)
    }

    @Test("Circular route returns to start")
    func circularRoute() {
        let route = RouteGenerator.circle(
            center: KnownLocations.rotterdamCentral,
            radiusMeters: 500,
            pointCount: 100
        )

        let result = DistanceCalculator.calculateDistance(coordinates: route)

        // Circumference = 2 * pi * r ≈ 3141m
        let expectedCircumference = 2 * Double.pi * 500
        #expect(abs(result.totalMeters - expectedCircumference) < expectedCircumference * 0.05)
    }

    @Test("Stationary with drift accumulates minimal distance")
    func stationaryWithDrift() {
        let route = RouteGenerator.stationaryWithDrift(
            center: KnownLocations.rotterdamCentral,
            driftMeters: 5,  // Very small drift
            pointCount: 100
        )

        let result = DistanceCalculator.calculateDistance(coordinates: route)

        // Should accumulate very little distance
        #expect(result.totalMeters < 1000, "Stationary drift should be < 1km, got \(result.totalMeters)m")
    }

    @Test("Route with varying accuracy filters bad points")
    func varyingAccuracy() {
        let baseRoute = RouteGenerator.straightLine(
            from: KnownLocations.rotterdamCentral,
            to: KnownLocations.schiedam,
            pointCount: 20
        )

        // Every 3rd point has bad accuracy
        let accuracyPattern = [10.0, 10.0, 100.0]
        let routeWithVaryingAccuracy = RouteGenerator.withVaryingAccuracy(
            baseRoute: baseRoute,
            accuracyPattern: accuracyPattern
        )

        let result = DistanceCalculator.calculateDistance(coordinates: routeWithVaryingAccuracy)

        // Should filter approximately 1/3 of points
        let expectedFiltered = baseRoute.count / 3
        #expect(result.pointsFiltered >= expectedFiltered - 1)
    }
}

// MARK: - Edge Case Tests

@Suite("Edge Cases", .tags(.edge))
struct EdgeCaseTests {

    @Test("Empty coordinate list")
    func emptyList() {
        let result = DistanceCalculator.calculateDistance(coordinates: [])
        #expect(result.totalMeters == 0)
        #expect(result.pointsUsed == 0)
    }

    @Test("Single coordinate")
    func singleCoordinate() {
        let result = DistanceCalculator.calculateDistance(coordinates: [KnownLocations.rotterdamCentral])
        #expect(result.totalMeters == 0)
        #expect(result.pointsUsed == 1)
    }

    @Test("Two identical coordinates")
    func twoIdentical() {
        let point = KnownLocations.rotterdamCentral
        let result = DistanceCalculator.calculateDistance(coordinates: [point, point])
        #expect(result.totalMeters == 0)
    }

    @Test("Crossing equator")
    func crossingEquator() {
        let north = Coordinate(lat: 1.0, lng: 0.0)
        let south = Coordinate(lat: -1.0, lng: 0.0)
        // 222km distance, need 250+ points to keep segments under 1km
        let route = RouteGenerator.straightLine(from: north, to: south, pointCount: 300)

        let result = DistanceCalculator.calculateDistance(coordinates: route)

        // 2 degrees latitude ≈ 222km
        #expect(result.totalMeters > 200_000 && result.totalMeters < 250_000)
    }

    @Test("Crossing prime meridian")
    func crossingPrimeMeridian() {
        let west = Coordinate(lat: 51.5, lng: -1.0)
        let east = Coordinate(lat: 51.5, lng: 1.0)
        // ~140km at this latitude, need 150+ points
        let route = RouteGenerator.straightLine(from: west, to: east, pointCount: 200)

        let result = DistanceCalculator.calculateDistance(coordinates: route)

        #expect(result.totalMeters > 100_000 && result.totalMeters < 200_000)
    }

    @Test("Crossing date line")
    func crossingDateLine() {
        let west = Coordinate(lat: 0.0, lng: 179.0)
        let east = Coordinate(lat: 0.0, lng: -179.0)

        // Direct haversine should handle this correctly
        let distance = DistanceCalculator.haversineDistance(from: west, to: east)

        // Should be ~222km (2 degrees at equator), not 39,780km (358 degrees the wrong way)
        #expect(distance < 300_000, "Should take short path across date line, got \(distance)m")
    }

    @Test("High latitude route (Scandinavia)")
    func highLatitude() {
        // Test at high latitude (northern Norway) with realistic route
        // Tromsø to Hammerfest ~200km
        let route = RouteGenerator.straightLine(
            from: Coordinate(lat: 69.65, lng: 18.96),  // Tromsø
            to: Coordinate(lat: 70.66, lng: 23.68),    // Hammerfest
            pointCount: 250  // Keep segments under 1km
        )

        let result = DistanceCalculator.calculateDistance(coordinates: route)

        // Should be ~200km
        #expect(result.totalMeters > 150_000 && result.totalMeters < 250_000)
        #expect(result.pointsFiltered == 0)
    }

    @Test("Negative coordinates (Southern/Western hemispheres)")
    func negativeCoordinates() {
        let route = RouteGenerator.straightLine(
            from: KnownLocations.sydneyOpera,  // -33.8568, 151.2153
            to: Coordinate(lat: -34.0, lng: 151.0),
            pointCount: 50
        )

        let result = DistanceCalculator.calculateDistance(coordinates: route)

        #expect(result.totalMeters > 10_000 && result.totalMeters < 30_000)
        #expect(result.pointsFiltered == 0)
    }
}

// MARK: - Performance Tests

@Suite("Performance", .tags(.performance))
struct PerformanceTests {

    @Test("1000 points processes quickly")
    func thousandPoints() async {
        let route = RouteGenerator.straightLine(
            from: KnownLocations.rotterdamCentral,
            to: KnownLocations.amsterdamCentral,
            pointCount: 1000
        )

        let result = DistanceCalculator.calculateDistance(coordinates: route)

        #expect(result.pointsUsed == 1000)
        #expect(result.totalMeters > 50_000)
    }

    @Test("10000 points processes quickly")
    func tenThousandPoints() async {
        let route = RouteGenerator.straightLine(
            from: KnownLocations.rotterdamCentral,
            to: KnownLocations.amsterdamCentral,
            pointCount: 10_000
        )

        let result = DistanceCalculator.calculateDistance(coordinates: route)

        #expect(result.pointsUsed == 10_000)
    }

    @Test("100000 points processes in reasonable time")
    func hundredThousandPoints() async {
        let route = RouteGenerator.straightLine(
            from: KnownLocations.rotterdamCentral,
            to: KnownLocations.amsterdamCentral,
            pointCount: 100_000
        )

        let result = DistanceCalculator.calculateDistance(coordinates: route)

        #expect(result.pointsUsed == 100_000)
    }
}

// MARK: - Trip Simulation Tests

@Suite("Trip Simulation", .tags(.simulation))
struct TripSimulationTests {

    @Test("Incremental accumulation matches total")
    func incrementalMatchesTotal() {
        let route = RouteGenerator.straightLine(
            from: KnownLocations.rotterdamCentral,
            to: KnownLocations.schiedam,
            pointCount: 50
        )

        let incremental = DistanceCalculator.simulateTrip(coordinates: route)
        let total = DistanceCalculator.calculateDistance(coordinates: route)

        #expect(incremental.count == route.count)
        #expect(abs(incremental.last! - total.totalMeters) < 1.0)
    }

    @Test("Distance monotonically increases")
    func monotonicallyIncreases() {
        let route = RouteGenerator.straightLine(
            from: KnownLocations.rotterdamCentral,
            to: KnownLocations.amsterdamCentral,
            pointCount: 100
        )

        let distances = DistanceCalculator.simulateTrip(coordinates: route)

        for i in 1..<distances.count {
            #expect(distances[i] >= distances[i-1],
                    "Distance should not decrease: \(distances[i-1]) -> \(distances[i])")
        }
    }

    @Test("Rapid start/stop cycles")
    func rapidStartStop() {
        // Simulate: drive a bit, stop, drive a bit, stop...
        var coords: [Coordinate] = []
        var lat = 51.92

        for cycle in 0..<10 {
            // Drive 500m
            for _ in 0..<5 {
                lat += 0.001
                coords.append(Coordinate(lat: lat, lng: 4.47, accuracy: 10))
            }
            // Stop (same location repeated)
            for _ in 0..<3 {
                coords.append(Coordinate(lat: lat, lng: 4.47, accuracy: 10))
            }
        }

        let result = DistanceCalculator.calculateDistance(coordinates: coords)

        // Should accumulate distance only during driving phases
        #expect(result.totalMeters > 4000 && result.totalMeters < 7000)
    }
}

// MARK: - Real World Scenario Tests

@Suite("Real World Scenarios", .tags(.realworld))
struct RealWorldTests {

    @Test("Commute Rotterdam to Amsterdam")
    func commuteRotterdamAmsterdam() {
        // Simulate a realistic commute with 60 GPS points
        let route = RouteGenerator.straightLine(
            from: KnownLocations.rotterdamCentral,
            to: KnownLocations.amsterdamCentral,
            pointCount: 60  // ~1 point per km
        )

        let result = DistanceCalculator.calculateDistance(coordinates: route)

        // Known distance is ~57km
        #expect(result.totalKilometers > 54 && result.totalKilometers < 60)
    }

    @Test("City driving with stops")
    func cityDrivingWithStops() {
        var coords: [Coordinate] = []
        var lat = 51.92
        var lng = 4.47

        // Simulate city driving: short segments with stops
        for _ in 0..<20 {
            // Drive 200m
            lat += 0.002
            coords.append(Coordinate(lat: lat, lng: lng, accuracy: 10))

            // Turn
            lng += 0.001
            coords.append(Coordinate(lat: lat, lng: lng, accuracy: 10))

            // Stop at light (same point)
            coords.append(Coordinate(lat: lat, lng: lng, accuracy: 10))
        }

        let result = DistanceCalculator.calculateDistance(coordinates: coords)

        // Should have accumulated reasonable city distance
        #expect(result.totalMeters > 3000)
        #expect(result.pointsFiltered == 0)
    }

    @Test("Tunnel with GPS loss")
    func tunnelGPSLoss() {
        var coords: [Coordinate] = []

        // Before tunnel - good GPS
        for i in 0..<10 {
            coords.append(Coordinate(lat: 51.92 + Double(i) * 0.001, lng: 4.47, accuracy: 10))
        }

        // In tunnel - poor GPS
        for i in 0..<5 {
            coords.append(Coordinate(lat: 51.93 + Double(i) * 0.001, lng: 4.47, accuracy: 200))
        }

        // After tunnel - good GPS again
        for i in 0..<10 {
            coords.append(Coordinate(lat: 51.94 + Double(i) * 0.001, lng: 4.47, accuracy: 10))
        }

        let result = DistanceCalculator.calculateDistance(coordinates: coords)

        // Should filter tunnel points
        #expect(result.pointsFiltered >= 5)
        // Should still accumulate distance from good segments
        #expect(result.totalMeters > 1000)
    }
}

// MARK: - Tags

extension Tag {
    @Tag static var core: Self
    @Tag static var filtering: Self
    @Tag static var routes: Self
    @Tag static var edge: Self
    @Tag static var performance: Self
    @Tag static var simulation: Self
    @Tag static var realworld: Self
}
