import Foundation

// MARK: - TripActivityState

/// Data for updating the Live Activity display
/// This is the service-level representation used by LiveActivityManager
struct TripActivityState {
    /// Current distance in kilometers
    let distanceKm: Double
    /// Trip duration in minutes
    let durationMinutes: Int
    /// Average speed in km/h
    let avgSpeed: Double
    /// Trip start time
    let startTime: Date
    /// Whether the trip is still active
    let isActive: Bool
}

// MARK: - LiveActivityManagerProtocol

/// Protocol defining the interface for Live Activity management.
/// Handles Lock Screen and Dynamic Island display for active trips.
/// Requires iOS 16.2+ for ActivityKit support.
protocol LiveActivityManagerProtocol: AnyObject {
    /// Whether a Live Activity is currently running
    var isActivityRunning: Bool { get }

    /// Start a new Live Activity for a trip
    /// - Parameters:
    ///   - carName: Display name for the car (e.g., "Audi A3" or "Auto")
    ///   - startTime: When the trip started
    func startActivity(carName: String, startTime: Date)

    /// Update the Live Activity with current trip stats
    /// - Parameter state: Current trip state
    func updateActivity(state: TripActivityState)

    /// End the Live Activity
    /// - Parameter keepVisibleForSeconds: How long to keep visible after ending (default 300)
    func endActivity(keepVisibleForSeconds: TimeInterval)
}

// MARK: - Default Parameter Extension

extension LiveActivityManagerProtocol {
    /// End the Live Activity with default visibility duration (5 minutes)
    func endActivity() {
        endActivity(keepVisibleForSeconds: 300)
    }
}
