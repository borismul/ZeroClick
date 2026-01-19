import CoreLocation

/// Concrete implementation of LocationTrackingServiceProtocol.
/// Handles all CLLocationManager interactions including setup, permissions,
/// accuracy switching, and delegate forwarding.
class LocationTrackingService: NSObject, LocationTrackingServiceProtocol, CLLocationManagerDelegate {

    // MARK: - Properties

    weak var delegate: LocationTrackingServiceDelegate?
    private var locationManager: CLLocationManager!
    private(set) var isMonitoring = false
    private(set) var lastLocation: CLLocation?

    // MARK: - Setup

    func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.activityType = .automotiveNavigation

        // Start with low accuracy to save battery
        setLowAccuracy()
    }

    // MARK: - Monitoring Control

    func startMonitoring() {
        guard locationManager != nil else {
            print("[LocationService] Cannot start - setupLocationManager() not called")
            return
        }

        print("[LocationService] Starting monitoring...")

        let status: CLAuthorizationStatus
        if #available(iOS 14.0, *) {
            status = locationManager.authorizationStatus
        } else {
            status = CLLocationManager.authorizationStatus()
        }

        if status == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        } else if status == .authorizedAlways || status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            locationManager.startMonitoringSignificantLocationChanges()
            isMonitoring = true
            print("[LocationService] Location updates started")
        }
    }

    func stopMonitoring() {
        guard locationManager != nil else { return }

        print("[LocationService] Stopping monitoring...")
        locationManager.stopUpdatingLocation()
        locationManager.stopMonitoringSignificantLocationChanges()
        isMonitoring = false
    }

    // MARK: - Accuracy Control

    func setHighAccuracy() {
        guard locationManager != nil else { return }

        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = kCLDistanceFilterNone
        if #available(iOS 11.0, *) {
            locationManager.showsBackgroundLocationIndicator = true
        }
        print("[LocationService] High accuracy mode")
    }

    func setLowAccuracy() {
        guard locationManager != nil else { return }

        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.distanceFilter = 500
        if #available(iOS 11.0, *) {
            locationManager.showsBackgroundLocationIndicator = false
        }
        print("[LocationService] Low accuracy mode (battery saver)")
    }

    // MARK: - CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        lastLocation = location
        delegate?.locationService(self, didUpdateLocation: location)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("[LocationService] Error: \(error.localizedDescription)")
        delegate?.locationService(self, didFailWithError: error)
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status: CLAuthorizationStatus
        if #available(iOS 14.0, *) {
            status = manager.authorizationStatus
        } else {
            status = CLLocationManager.authorizationStatus()
        }
        print("[LocationService] Authorization: \(status.rawValue)")

        if status == .authorizedAlways || status == .authorizedWhenInUse {
            if !isMonitoring {
                manager.startUpdatingLocation()
                manager.startMonitoringSignificantLocationChanges()
                isMonitoring = true
            }
        }

        delegate?.locationService(self, didChangeAuthorization: status)
    }

    // MARK: - Direct Access

    /// Returns the current location from the location manager.
    /// Useful for getting location on-demand without waiting for delegate callbacks.
    var currentLocation: CLLocation? {
        return locationManager?.location
    }
}
