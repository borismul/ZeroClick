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

    /// Sets up the motion activity manager
    func setupMotionManager()

    /// Starts monitoring for motion activity updates
    func startActivityUpdates()

    /// Stops monitoring for motion activity updates
    func stopActivityUpdates()
}

// MARK: - MotionActivityHandlerDelegate

/// Delegate protocol for receiving motion activity events.
/// Uses AnyObject constraint to enable weak references.
protocol MotionActivityHandlerDelegate: AnyObject {
    /// Called when automotive motion detection changes
    /// - Parameters:
    ///   - handler: The handler that detected the change
    ///   - isAutomotive: Whether automotive motion is now detected
    func motionHandler(_ handler: MotionActivityHandlerProtocol, didDetectAutomotive isAutomotive: Bool)

    /// Called when the motion state changes
    /// - Parameters:
    ///   - handler: The handler that detected the change
    ///   - state: The new motion state
    func motionHandler(_ handler: MotionActivityHandlerProtocol, didChangeState state: MotionState)
}
