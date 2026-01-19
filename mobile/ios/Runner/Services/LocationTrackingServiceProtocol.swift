import CoreLocation

// MARK: - LocationTrackingServiceProtocol

/// Protocol defining the interface for location tracking services.
/// Enables dependency injection and testability by allowing mock implementations.
protocol LocationTrackingServiceProtocol: AnyObject {
    /// Delegate to receive location updates and authorization changes
    var delegate: LocationTrackingServiceDelegate? { get set }

    /// Whether the service is currently monitoring for location updates
    var isMonitoring: Bool { get }

    /// The most recent location received from Core Location
    var lastLocation: CLLocation? { get }

    /// Sets up the location manager with appropriate configuration
    func setupLocationManager()

    /// Starts monitoring for location updates (requires authorization)
    func startMonitoring()

    /// Stops all location monitoring
    func stopMonitoring()

    /// Switches to high accuracy mode for active tracking
    func setHighAccuracy()

    /// Switches to low accuracy mode for battery conservation
    func setLowAccuracy()
}

// MARK: - LocationTrackingServiceDelegate

/// Delegate protocol for receiving location service events.
/// Uses AnyObject constraint to enable weak references.
protocol LocationTrackingServiceDelegate: AnyObject {
    /// Called when a new location is received
    /// - Parameters:
    ///   - service: The service that received the location
    ///   - location: The new location
    func locationService(_ service: LocationTrackingServiceProtocol, didUpdateLocation location: CLLocation)

    /// Called when a location error occurs
    /// - Parameters:
    ///   - service: The service that encountered the error
    ///   - error: The error that occurred
    func locationService(_ service: LocationTrackingServiceProtocol, didFailWithError error: Error)

    /// Called when location authorization status changes
    /// - Parameters:
    ///   - service: The service reporting the change
    ///   - status: The new authorization status
    func locationService(_ service: LocationTrackingServiceProtocol, didChangeAuthorization status: CLAuthorizationStatus)
}
