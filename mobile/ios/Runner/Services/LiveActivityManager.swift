import ActivityKit
import UIKit

// MARK: - LiveActivityManager (iOS 16.2+)

/// Manages Live Activities for trip tracking on Lock Screen and Dynamic Island.
/// Extracted from AppDelegate to isolate ActivityKit handling.
@available(iOS 16.2, *)
class LiveActivityManager: LiveActivityManagerProtocol {

    // MARK: - Properties

    /// The currently running Live Activity
    private var currentActivity: Activity<TripActivityAttributes>?

    /// Whether a Live Activity is currently running
    var isActivityRunning: Bool {
        return currentActivity != nil
    }

    // MARK: - Initialization

    init() {
        print("[LiveActivityManager] Initialized (iOS 16.2+)")
    }

    // MARK: - Activity Control

    /// Start a new Live Activity for a trip
    func startActivity(carName: String, startTime: Date) {
        print("[LiveActivityManager] startActivity() called, isMainThread: \(Thread.isMainThread)")

        // Request background time to ensure we can complete the Live Activity setup
        var backgroundTaskId: UIBackgroundTaskIdentifier = .invalid
        backgroundTaskId = UIApplication.shared.beginBackgroundTask(withName: "StartLiveActivity") {
            print("[LiveActivityManager] Background task expired")
            UIApplication.shared.endBackgroundTask(backgroundTaskId)
            backgroundTaskId = .invalid
        }

        print("[LiveActivityManager] Background task started: \(backgroundTaskId.rawValue)")

        // Ensure we're on main thread for Live Activity operations
        let startActivityBlock = { [weak self] in
            Task {
                await self?.startActivityAsync(carName: carName, startTime: startTime)
                // End background task when done
                if backgroundTaskId != .invalid {
                    print("[LiveActivityManager] Ending background task")
                    UIApplication.shared.endBackgroundTask(backgroundTaskId)
                }
            }
        }

        if Thread.isMainThread {
            startActivityBlock()
        } else {
            DispatchQueue.main.async {
                startActivityBlock()
            }
        }
    }

    /// Update the Live Activity with current trip stats
    func updateActivity(state: TripActivityState) {
        guard let activity = currentActivity else { return }

        Task {
            let contentState = TripActivityAttributes.ContentState(
                distanceKm: state.distanceKm,
                durationMinutes: state.durationMinutes,
                avgSpeed: state.avgSpeed,
                startTime: state.startTime,
                isActive: state.isActive
            )
            await activity.update(ActivityContent(state: contentState, staleDate: nil))
        }
    }

    /// End the Live Activity with specified dismissal delay
    func endActivity(keepVisibleForSeconds: TimeInterval) {
        print("[LiveActivityManager] endActivity() called")

        guard let activity = currentActivity else {
            print("[LiveActivityManager] No active activity to end")
            return
        }

        Task { [weak self] in
            let finalState = TripActivityAttributes.ContentState(
                distanceKm: activity.content.state.distanceKm,
                durationMinutes: activity.content.state.durationMinutes,
                avgSpeed: activity.content.state.avgSpeed,
                startTime: activity.content.state.startTime,
                isActive: false
            )
            await activity.end(
                ActivityContent(state: finalState, staleDate: nil),
                dismissalPolicy: .after(.now + keepVisibleForSeconds)
            )
            print("[LiveActivityManager] Ended successfully")
        }
        currentActivity = nil
    }

    // MARK: - Private Methods

    /// Async method to start the Live Activity
    private func startActivityAsync(carName: String, startTime: Date) async {
        print("[LiveActivityManager] startActivityAsync() starting")

        // Check availability
        let authInfo = ActivityAuthorizationInfo()
        print("[LiveActivityManager] areActivitiesEnabled: \(authInfo.areActivitiesEnabled)")

        guard authInfo.areActivitiesEnabled else {
            print("[LiveActivityManager] Not enabled in Settings")
            return
        }

        // End existing activities (don't await - fire and forget)
        let existingActivities = Activity<TripActivityAttributes>.activities
        if !existingActivities.isEmpty {
            print("[LiveActivityManager] Ending \(existingActivities.count) existing activities")
            for activity in existingActivities {
                Task { await activity.end(nil, dismissalPolicy: .immediate) }
            }
        }
        currentActivity = nil

        // Create new activity immediately - no delays
        let attributes = TripActivityAttributes(
            tripId: UUID().uuidString,
            carName: carName
        )

        let state = TripActivityAttributes.ContentState(
            distanceKm: 0,
            durationMinutes: 0,
            avgSpeed: 0,
            startTime: startTime,
            isActive: true
        )

        print("[LiveActivityManager] Requesting new activity...")

        do {
            let activity = try Activity.request(
                attributes: attributes,
                content: .init(state: state, staleDate: nil),
                pushType: nil
            )
            currentActivity = activity
            print("[LiveActivityManager] Started successfully: \(activity.id)")
        } catch {
            print("[LiveActivityManager] Failed: \(error.localizedDescription)")
        }
    }
}

// MARK: - LiveActivityManagerFallback (iOS < 16.2)

/// Fallback implementation for iOS versions prior to 16.2.
/// All methods are no-ops since Live Activities are not supported.
class LiveActivityManagerFallback: LiveActivityManagerProtocol {

    // MARK: - Properties

    /// Always returns false - no Live Activity support
    var isActivityRunning: Bool { false }

    // MARK: - Initialization

    init() {
        print("[LiveActivityManager] Initialized (fallback - iOS 16.2+ required)")
    }

    // MARK: - Activity Control (No-ops)

    func startActivity(carName: String, startTime: Date) {
        print("[LiveActivityManager] iOS 16.2+ required for Live Activities")
    }

    func updateActivity(state: TripActivityState) {
        // No-op
    }

    func endActivity(keepVisibleForSeconds: TimeInterval) {
        // No-op
    }
}

// MARK: - Factory Function

/// Creates the appropriate LiveActivityManager based on iOS version
/// - Returns: LiveActivityManagerProtocol implementation
func createLiveActivityManager() -> LiveActivityManagerProtocol {
    if #available(iOS 16.2, *) {
        return LiveActivityManager()
    } else {
        return LiveActivityManagerFallback()
    }
}
