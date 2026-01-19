import CoreMotion

/// Concrete implementation of MotionActivityHandlerProtocol.
/// Handles all CMMotionActivityManager interactions including setup,
/// activity monitoring, state change detection, and debouncing.
class MotionActivityHandler: MotionActivityHandlerProtocol {

    // MARK: - Properties

    weak var delegate: MotionActivityHandlerDelegate?
    private var motionManager: CMMotionActivityManager!
    private(set) var currentState: MotionState = .unknown
    private(set) var isAutomotive: Bool = false

    // MARK: - Confidence and Debounce Configuration

    /// Minimum confidence level required to accept activity updates (default: .medium)
    var minimumConfidence: CMMotionActivityConfidence = .medium

    /// Time to wait before confirming automotive start (default: 2.0 seconds)
    var automotiveDebounceSeconds: TimeInterval = 2.0

    /// Time to wait before confirming automotive end (default: 3.0 seconds)
    var nonAutomotiveDebounceSeconds: TimeInterval = 3.0

    // MARK: - Debounce State

    /// The pending confirmed automotive state (true = automotive, false = non-automotive)
    private var pendingAutomotiveChange: Bool?

    /// Timer for debounce confirmation
    private var debounceTimer: Timer?

    /// Timestamp of the last state change detection
    private var lastStateChangeTime: Date?

    /// Whether automotive has been confirmed via debounce
    private var confirmedAutomotive: Bool = false

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
        cancelPendingDebounce()
        print("[MotionHandler] Activity updates stopped")
    }

    /// Cancels any pending debounce timer and resets pending state
    func cancelPendingDebounce() {
        debounceTimer?.invalidate()
        debounceTimer = nil
        pendingAutomotiveChange = nil
        print("[MotionHandler] Pending debounce cancelled")
    }

    // MARK: - Activity Processing

    /// Processes a motion activity and updates state accordingly.
    /// Made internal (not private) to allow testing without CMMotionActivityManager.
    func processActivity(_ activity: CMMotionActivity) {
        // Check confidence threshold - ignore activities below minimum confidence
        guard activity.confidence.rawValue >= minimumConfidence.rawValue else {
            print("[MotionHandler] Ignoring activity with confidence \(activity.confidence.rawValue) < \(minimumConfidence.rawValue)")
            return
        }

        let previousState = currentState
        let wasAutomotive = isAutomotive

        // Determine new state from activity
        let newState = mapActivityToState(activity)

        // Update state if changed
        if newState != previousState {
            currentState = newState
            lastStateChangeTime = Date()
            delegate?.motionHandler(self, didChangeState: newState)
        }

        // Handle automotive detection with debouncing
        if activity.automotive {
            if !wasAutomotive {
                isAutomotive = true
                print("[MotionHandler] Automotive detected (immediate)")
                delegate?.motionHandler(self, didDetectAutomotive: true)

                // Start debounce timer for confirmation
                startAutomotiveDebounce(isAutomotive: true)
            } else if pendingAutomotiveChange == false {
                // Was automotive, had pending non-automotive change, but now automotive again
                // Cancel the pending non-automotive change
                cancelPendingDebounce()
                print("[MotionHandler] Automotive resumed - cancelled pending non-automotive debounce")
            }
        } else if activity.stationary || activity.walking || activity.running {
            // Non-automotive activity detected
            if wasAutomotive {
                isAutomotive = false
                print("[MotionHandler] Non-automotive detected: \(newState) (immediate)")
                delegate?.motionHandler(self, didDetectAutomotive: false)

                // Start debounce timer for confirmation (give time to oscillate back to automotive)
                startAutomotiveDebounce(isAutomotive: false)
            }
        }
    }

    // MARK: - Debounce Logic

    private func startAutomotiveDebounce(isAutomotive: Bool) {
        // Cancel any existing debounce timer
        debounceTimer?.invalidate()

        // Set pending state
        pendingAutomotiveChange = isAutomotive

        // Choose debounce duration based on state
        let debounceInterval = isAutomotive ? automotiveDebounceSeconds : nonAutomotiveDebounceSeconds

        print("[MotionHandler] Starting \(isAutomotive ? "automotive" : "non-automotive") debounce for \(debounceInterval)s")

        debounceTimer = Timer.scheduledTimer(withTimeInterval: debounceInterval, repeats: false) { [weak self] _ in
            self?.confirmDebounce()
        }
    }

    private func confirmDebounce() {
        guard let pending = pendingAutomotiveChange else {
            print("[MotionHandler] Debounce fired but no pending state")
            return
        }

        // Check if the current state still matches what we were waiting to confirm
        let currentlyAutomotive = self.isAutomotive

        if pending == currentlyAutomotive {
            // State has remained stable through debounce period - confirm it
            confirmedAutomotive = pending
            print("[MotionHandler] Confirmed \(pending ? "automotive" : "non-automotive") after debounce")
            delegate?.motionHandler(self, didConfirmAutomotive: pending)
        } else {
            // State changed during debounce period - don't confirm
            print("[MotionHandler] State changed during debounce - not confirming (pending: \(pending), current: \(currentlyAutomotive))")
        }

        // Clear pending state
        pendingAutomotiveChange = nil
        debounceTimer = nil
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
