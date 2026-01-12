import ActivityKit
import Foundation

/// Defines the data structure for the Trip Live Activity
/// This appears on Lock Screen and Dynamic Island during active trips
/// Also automatically mirrors to Apple Watch Smart Stack (watchOS 11+)
public struct TripActivityAttributes: ActivityAttributes {
    /// Dynamic data that changes during the activity
    public struct ContentState: Codable, Hashable {
        /// Current distance in kilometers
        public var distanceKm: Double
        /// Trip duration in minutes
        public var durationMinutes: Int
        /// Average speed in km/h
        public var avgSpeed: Double
        /// Trip start time
        public var startTime: Date
        /// Whether the trip is still active
        public var isActive: Bool

        public init(distanceKm: Double, durationMinutes: Int, avgSpeed: Double, startTime: Date, isActive: Bool) {
            self.distanceKm = distanceKm
            self.durationMinutes = durationMinutes
            self.avgSpeed = avgSpeed
            self.startTime = startTime
            self.isActive = isActive
        }
    }

    /// Static attributes set when activity starts
    public var tripId: String
    public var carName: String

    public init(tripId: String, carName: String) {
        self.tripId = tripId
        self.carName = carName
    }
}
