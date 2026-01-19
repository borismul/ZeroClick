import CoreMotion

/// Concrete implementation of MotionActivityHandlerProtocol.
/// Handles all CMMotionActivityManager interactions including setup,
/// activity monitoring, and state change detection.
class MotionActivityHandler: MotionActivityHandlerProtocol {

    // MARK: - Properties

    weak var delegate: MotionActivityHandlerDelegate?
    private var motionManager: CMMotionActivityManager!
    private(set) var currentState: MotionState = .unknown
    private(set) var isAutomotive: Bool = false

    // MARK: - Setup

    func setupMotionManager() {
        motionManager = CMMotionActivityManager()
        print("[MotionHandler] Motion manager initialized")
    }

    // MARK: - Activity Updates

    func startActivityUpdates() {
        guard motionManager != nil else {
            print("[MotionHandler] Cannot start - setupMotionManager() not called")
            return
        }

        guard CMMotionActivityManager.isActivityAvailable() else {
            print("[MotionHandler] Activity not available on this device")
            return
        }

        motionManager.startActivityUpdates(to: .main) { [weak self] activity in
            guard let activity = activity else { return }
            self?.processActivity(activity)
        }
        print("[MotionHandler] Activity updates started")
    }

    func stopActivityUpdates() {
        guard motionManager != nil else { return }

        motionManager.stopActivityUpdates()
        print("[MotionHandler] Activity updates stopped")
    }

    // MARK: - Activity Processing

    private func processActivity(_ activity: CMMotionActivity) {
        // Ignore low confidence activities
        guard activity.confidence != .low else { return }

        let previousState = currentState
        let wasAutomotive = isAutomotive

        // Determine new state from activity
        let newState = mapActivityToState(activity)

        // Update state if changed
        if newState != previousState {
            currentState = newState
            delegate?.motionHandler(self, didChangeState: newState)
        }

        // Handle automotive detection
        if activity.automotive {
            if !wasAutomotive {
                isAutomotive = true
                print("[MotionHandler] Automotive detected")
                delegate?.motionHandler(self, didDetectAutomotive: true)
            }
        } else if activity.stationary {
            // Stationary: log but DON'T immediately set isAutomotive = false
            // Backend handles this via parked_count
            print("[MotionHandler] Stationary detected (backend handles stop)")
        } else if activity.walking || activity.running {
            // Walking/running: immediately end automotive
            if wasAutomotive {
                isAutomotive = false
                print("[MotionHandler] Walking/running detected - ending automotive")
                delegate?.motionHandler(self, didDetectAutomotive: false)
            }
        }
    }

    private func mapActivityToState(_ activity: CMMotionActivity) -> MotionState {
        // Priority order matters: automotive first, then movement types
        if activity.automotive {
            return .automotive
        } else if activity.running {
            return .running
        } else if activity.walking {
            return .walking
        } else if activity.stationary {
            return .stationary
        } else {
            return .unknown
        }
    }
}
