import Foundation

/// Coordinate with accuracy information
public struct Coordinate: Sendable, Equatable {
    public let latitude: Double
    public let longitude: Double
    public let accuracy: Double  // horizontal accuracy in meters

    public init(lat: Double, lng: Double, accuracy: Double = 10.0) {
        self.latitude = lat
        self.longitude = lng
        self.accuracy = accuracy
    }
}

/// Configuration for distance calculation filtering
public struct DistanceFilterConfig: Sendable {
    /// Maximum distance between consecutive points (meters) - filters GPS jumps
    public let maxJumpDistance: Double
    /// Maximum acceptable accuracy (meters) - filters poor GPS readings
    public let maxAccuracy: Double

    public static let `default` = DistanceFilterConfig(maxJumpDistance: 1000, maxAccuracy: 50)

    public init(maxJumpDistance: Double, maxAccuracy: Double) {
        self.maxJumpDistance = maxJumpDistance
        self.maxAccuracy = maxAccuracy
    }
}

/// Result of distance calculation with metadata
public struct DistanceResult: Sendable {
    public let totalMeters: Double
    public let pointsUsed: Int
    public let pointsFiltered: Int

    public var totalKilometers: Double { totalMeters / 1000.0 }
}

/// Pure logic distance calculator - no iOS dependencies
public struct DistanceCalculator: Sendable {

    private static let earthRadiusMeters: Double = 6_371_000

    /// Haversine formula for distance between two coordinates
    public static func haversineDistance(from: Coordinate, to: Coordinate) -> Double {
        let lat1 = from.latitude * .pi / 180
        let lat2 = to.latitude * .pi / 180
        let deltaLat = (to.latitude - from.latitude) * .pi / 180
        let deltaLon = (to.longitude - from.longitude) * .pi / 180

        let a = sin(deltaLat / 2) * sin(deltaLat / 2) +
                cos(lat1) * cos(lat2) * sin(deltaLon / 2) * sin(deltaLon / 2)
        let c = 2 * atan2(sqrt(a), sqrt(1 - a))

        return earthRadiusMeters * c
    }

    /// Calculate total distance from a sequence of coordinates with filtering
    public static func calculateDistance(
        coordinates: [Coordinate],
        config: DistanceFilterConfig = .default
    ) -> DistanceResult {
        guard coordinates.count >= 2 else {
            return DistanceResult(totalMeters: 0, pointsUsed: coordinates.count, pointsFiltered: 0)
        }

        var totalDistance: Double = 0
        var pointsUsed = 1  // First point always counts
        var pointsFiltered = 0
        var lastValidCoord = coordinates[0]

        // Skip first point if it has poor accuracy
        if lastValidCoord.accuracy > config.maxAccuracy {
            pointsFiltered += 1
            pointsUsed = 0
            // Find first valid point
            for coord in coordinates.dropFirst() {
                if coord.accuracy <= config.maxAccuracy {
                    lastValidCoord = coord
                    pointsUsed = 1
                    break
                }
                pointsFiltered += 1
            }
        }

        for coord in coordinates.dropFirst() {
            // Filter poor accuracy
            if coord.accuracy > config.maxAccuracy {
                pointsFiltered += 1
                continue
            }

            let distance = haversineDistance(from: lastValidCoord, to: coord)

            // Filter GPS jumps
            if distance > config.maxJumpDistance {
                pointsFiltered += 1
                continue
            }

            totalDistance += distance
            lastValidCoord = coord
            pointsUsed += 1
        }

        return DistanceResult(
            totalMeters: totalDistance,
            pointsUsed: pointsUsed,
            pointsFiltered: pointsFiltered
        )
    }

    /// Simulate incremental distance accumulation (mimics iOS app behavior)
    public static func simulateTrip(
        coordinates: [Coordinate],
        config: DistanceFilterConfig = .default
    ) -> [Double] {
        var distances: [Double] = []
        var totalDistance: Double = 0
        var lastValidCoord: Coordinate?

        for coord in coordinates {
            if coord.accuracy > config.maxAccuracy {
                distances.append(totalDistance)
                continue
            }

            if let previous = lastValidCoord {
                let distance = haversineDistance(from: previous, to: coord)
                if distance < config.maxJumpDistance {
                    totalDistance += distance
                }
            }

            lastValidCoord = coord
            distances.append(totalDistance)
        }

        return distances
    }
}

// MARK: - Route Generators for Testing

public struct RouteGenerator {

    /// Generate a straight line route between two points
    public static func straightLine(
        from: Coordinate,
        to: Coordinate,
        pointCount: Int,
        accuracy: Double = 10.0
    ) -> [Coordinate] {
        guard pointCount >= 2 else { return [] }

        var coords: [Coordinate] = []
        for i in 0..<pointCount {
            let fraction = Double(i) / Double(pointCount - 1)
            let lat = from.latitude + (to.latitude - from.latitude) * fraction
            let lng = from.longitude + (to.longitude - from.longitude) * fraction
            coords.append(Coordinate(lat: lat, lng: lng, accuracy: accuracy))
        }
        return coords
    }

    /// Generate a circular route
    public static func circle(
        center: Coordinate,
        radiusMeters: Double,
        pointCount: Int,
        accuracy: Double = 10.0
    ) -> [Coordinate] {
        var coords: [Coordinate] = []
        let radiusDegrees = radiusMeters / 111_000  // rough meters to degrees

        for i in 0..<pointCount {
            let angle = 2.0 * .pi * Double(i) / Double(pointCount)
            let lat = center.latitude + radiusDegrees * cos(angle)
            let lng = center.longitude + radiusDegrees * sin(angle) / cos(center.latitude * .pi / 180)
            coords.append(Coordinate(lat: lat, lng: lng, accuracy: accuracy))
        }
        // Close the circle
        coords.append(coords[0])
        return coords
    }

    /// Generate a route with GPS drift (stationary but noisy)
    public static func stationaryWithDrift(
        center: Coordinate,
        driftMeters: Double,
        pointCount: Int,
        accuracy: Double = 10.0
    ) -> [Coordinate] {
        var coords: [Coordinate] = []
        let driftDegrees = driftMeters / 111_000

        for _ in 0..<pointCount {
            let lat = center.latitude + Double.random(in: -driftDegrees...driftDegrees)
            let lng = center.longitude + Double.random(in: -driftDegrees...driftDegrees)
            coords.append(Coordinate(lat: lat, lng: lng, accuracy: accuracy))
        }
        return coords
    }

    /// Generate route with varying accuracy
    public static func withVaryingAccuracy(
        baseRoute: [Coordinate],
        accuracyPattern: [Double]
    ) -> [Coordinate] {
        return baseRoute.enumerated().map { index, coord in
            let accuracy = accuracyPattern[index % accuracyPattern.count]
            return Coordinate(lat: coord.latitude, lng: coord.longitude, accuracy: accuracy)
        }
    }
}

// MARK: - Known Locations

public struct KnownLocations {
    // Rotterdam area
    public static let rotterdamCentral = Coordinate(lat: 51.9244, lng: 4.4777)
    public static let rotterdamSouth = Coordinate(lat: 51.8920, lng: 4.4848)
    public static let schiedam = Coordinate(lat: 51.9194, lng: 4.3889)

    // Amsterdam
    public static let amsterdamCentral = Coordinate(lat: 52.3791, lng: 4.9003)

    // International
    public static let londonBigBen = Coordinate(lat: 51.5007, lng: -0.1246)
    public static let parisEiffel = Coordinate(lat: 48.8584, lng: 2.2945)
    public static let newYorkTimesSquare = Coordinate(lat: 40.7580, lng: -73.9855)
    public static let sydneyOpera = Coordinate(lat: -33.8568, lng: 151.2153)
    public static let tokyoTower = Coordinate(lat: 35.6586, lng: 139.7454)

    // Edge cases
    public static let equatorPrime = Coordinate(lat: 0.0, lng: 0.0)
    public static let northPole = Coordinate(lat: 89.9, lng: 0.0)
    public static let dateLine = Coordinate(lat: 0.0, lng: 179.9)
}
