import CoreMotion

// MARK: - MotionState

/// Represents the current motion state of the device.
/// Maps from CMMotionActivity to a cleaner enum representation.
enum MotionState {
    case unknown
    case stationary
    case walking
    case running
    case automotive
}

// MARK: - MotionActivityHandlerProtocol

/// Protocol defining the interface for motion activity detection services.
/// Enables dependency injection and testability by allowing mock implementations.
protocol MotionActivityHandlerProtocol: AnyObject {
    /// Delegate to receive motion state change notifications
    var delegate: MotionActivityHandlerDelegate? { get set }

    /// The current motion state detected by the handler
    var currentState: MotionState { get }

    /// Whether the device is currently in automotive motion
    var isAutomotive: Bool { get }

    // MARK: - Confidence and Debounce Configuration

    /// Minimum confidence level required to accept activity updates (default: .medium)
    /// Activities below this threshold are ignored to reduce false positives
    var minimumConfidence: CMMotionActivityConfidence { get set }

    /// Time to wait before confirming automotive start (default: 2.0 seconds)
    /// Prevents false trip starts from brief automotive detections
    var automotiveDebounceSeconds: TimeInterval { get set }

    /// Time to wait before confirming automotive end (default: 3.0 seconds)
    /// Prevents false trip ends from momentary stationary/walking states (e.g., traffic stops)
    var nonAutomotiveDebounceSeconds: TimeInterval { get set }

    /// Sets up the motion activity manager
    func setupMotionManager()

    /// Starts monitoring for motion activity updates
    func startActivityUpdates()

    /// Stops monitoring for motion activity updates
    func stopActivityUpdates()

    /// Cancels any pending debounce timer and resets pending state
    func cancelPendingDebounce()
}

// MARK: - MotionActivityHandlerDelegate

/// Delegate protocol for receiving motion activity events.
/// Uses AnyObject constraint to enable weak references.
protocol MotionActivityHandlerDelegate: AnyObject {
    /// Called immediately when automotive motion detection changes (before debounce)
    /// - Parameters:
    ///   - handler: The handler that detected the change
    ///   - isAutomotive: Whether automotive motion is now detected
    func motionHandler(_ handler: MotionActivityHandlerProtocol, didDetectAutomotive isAutomotive: Bool)

    /// Called after debounce period confirms the automotive state change
    /// Use this method to trigger trip start/stop actions to avoid false triggers
    /// - Parameters:
    ///   - handler: The handler that confirmed the change
    ///   - isAutomotive: Whether automotive motion is confirmed
    func motionHandler(_ handler: MotionActivityHandlerProtocol, didConfirmAutomotive isAutomotive: Bool)

    /// Called when the motion state changes
    /// - Parameters:
    ///   - handler: The handler that detected the change
    ///   - state: The new motion state
    func motionHandler(_ handler: MotionActivityHandlerProtocol, didChangeState state: MotionState)
}
