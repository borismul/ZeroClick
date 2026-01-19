import CoreLocation
@testable import Runner

/// Mock location service for testing
/// Allows injecting GPS coordinates and controlling location updates
class MockLocationTrackingService: LocationTrackingServiceProtocol {
    weak var delegate: LocationTrackingServiceDelegate?

    // MARK: - Protocol Properties

    var isMonitoring: Bool = false
    var lastLocation: CLLocation?

    // MARK: - Test Control Properties

    var setupCalled = false
    var startMonitoringCalled = false
    var stopMonitoringCalled = false
    var highAccuracyEnabled = false
    var lowAccuracyEnabled = false

    // Track all locations sent
    var locationHistory: [CLLocation] = []

    // MARK: - Protocol Methods

    func setupLocationManager() {
        setupCalled = true
    }

    func startMonitoring() {
        startMonitoringCalled = true
        isMonitoring = true
    }

    func stopMonitoring() {
        stopMonitoringCalled = true
        isMonitoring = false
    }

    func setHighAccuracy() {
        highAccuracyEnabled = true
        lowAccuracyEnabled = false
    }

    func setLowAccuracy() {
        lowAccuracyEnabled = true
        highAccuracyEnabled = false
    }

    // MARK: - Test Injection Methods

    /// Inject a location update (simulates GPS)
    func injectLocation(lat: Double, lng: Double, accuracy: Double = 10.0) {
        let location = CLLocation(
            coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lng),
            altitude: 0,
            horizontalAccuracy: accuracy,
            verticalAccuracy: accuracy,
            timestamp: Date()
        )
        injectLocation(location)
    }

    /// Inject a CLLocation directly
    func injectLocation(_ location: CLLocation) {
        lastLocation = location
        locationHistory.append(location)
        delegate?.locationService(self, didUpdateLocation: location)
    }

    /// Inject a sequence of locations with delay
    func injectLocationSequence(_ locations: [CLLocation], intervalSeconds: TimeInterval = 1.0) {
        for (index, location) in locations.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + intervalSeconds * Double(index)) {
                self.injectLocation(location)
            }
        }
    }

    /// Simulate authorization change
    func injectAuthorizationChange(_ status: CLAuthorizationStatus) {
        delegate?.locationService(self, didChangeAuthorization: status)
    }

    /// Simulate error
    func injectError(_ error: Error) {
        delegate?.locationService(self, didFailWithError: error)
    }

    /// Reset all state for next test
    func reset() {
        isMonitoring = false
        lastLocation = nil
        setupCalled = false
        startMonitoringCalled = false
        stopMonitoringCalled = false
        highAccuracyEnabled = false
        lowAccuracyEnabled = false
        locationHistory.removeAll()
    }
}
