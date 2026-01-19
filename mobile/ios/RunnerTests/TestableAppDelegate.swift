import CoreLocation
@testable import Runner

/// Testable version of AppDelegate that allows service injection
/// Used in XCTests to verify behavior with mock services
class TestableAppDelegate: NSObject {

    // MARK: - Injected Services

    var locationService: LocationTrackingServiceProtocol!
    var motionHandler: MotionActivityHandlerProtocol!
    var liveActivityManager: LiveActivityManagerProtocol!
    var watchService: WatchConnectivityServiceProtocol!

    // MARK: - State (mirrors AppDelegate)

    private(set) var isDriving = false
    private(set) var isActivelyTracking = false
    private(set) var lastLocation: CLLocation?
    private(set) var driveStartTime: Date?
    private(set) var totalDistanceMeters: Double = 0

    // MARK: - Test Observables

    var apiCallsMade: [(type: String, lat: Double, lng: Double)] = []
    var pingCount = 0

    // MARK: - Initialization

    func injectServices(
        location: LocationTrackingServiceProtocol,
        motion: MotionActivityHandlerProtocol,
        liveActivity: LiveActivityManagerProtocol,
        watch: WatchConnectivityServiceProtocol
    ) {
        self.locationService = location
        self.motionHandler = motion
        self.liveActivityManager = liveActivity
        self.watchService = watch

        // Set delegates
        location.delegate = self
        motion.delegate = self
        watch.delegate = self
    }

    func startServices() {
        locationService.setupLocationManager()
        motionHandler.setupMotionManager()
        locationService.startMonitoring()
        motionHandler.startActivityUpdates()
    }

    func stopServices() {
        locationService.stopMonitoring()
        motionHandler.stopActivityUpdates()
        stopDriveTracking()
    }

    // MARK: - Drive Tracking (mirrors AppDelegate logic)

    func startDriveTracking() {
        guard !isActivelyTracking else { return }

        isActivelyTracking = true
        driveStartTime = Date()
        totalDistanceMeters = 0

        locationService.setHighAccuracy()
        liveActivityManager.startActivity(carName: "Test Car", startTime: driveStartTime!)

        // Simulate first ping
        if let location = locationService.lastLocation {
            apiCallsMade.append((type: "start", lat: location.coordinate.latitude, lng: location.coordinate.longitude))
            watchService.notifyTripStarted()
        }
    }

    func stopDriveTracking() {
        guard isActivelyTracking else { return }

        isActivelyTracking = false
        locationService.setLowAccuracy()
        liveActivityManager.endActivity()

        if let location = lastLocation ?? locationService.lastLocation {
            apiCallsMade.append((type: "end", lat: location.coordinate.latitude, lng: location.coordinate.longitude))
        }
    }

    private func sendPing() {
        guard isActivelyTracking else { return }
        guard let location = locationService.lastLocation else { return }

        pingCount += 1
        apiCallsMade.append((type: "ping", lat: location.coordinate.latitude, lng: location.coordinate.longitude))
    }

    // MARK: - Reset

    func reset() {
        isDriving = false
        isActivelyTracking = false
        lastLocation = nil
        driveStartTime = nil
        totalDistanceMeters = 0
        apiCallsMade.removeAll()
        pingCount = 0
    }
}

// MARK: - LocationTrackingServiceDelegate

extension TestableAppDelegate: LocationTrackingServiceDelegate {
    func locationService(_ service: LocationTrackingServiceProtocol, didUpdateLocation location: CLLocation) {
        if isActivelyTracking {
            if let previous = lastLocation {
                let distance = location.distance(from: previous)
                if distance < 1000 && location.horizontalAccuracy < 50 {
                    totalDistanceMeters += distance
                }
            }

            // Update Live Activity
            let distanceKm = totalDistanceMeters / 1000.0
            let durationMinutes = Int(Date().timeIntervalSince(driveStartTime ?? Date()) / 60)
            let avgSpeed = durationMinutes > 0 ? (distanceKm / (Double(durationMinutes) / 60.0)) : 0

            liveActivityManager.updateActivity(state: TripActivityState(
                distanceKm: distanceKm,
                durationMinutes: durationMinutes,
                avgSpeed: avgSpeed,
                startTime: driveStartTime ?? Date(),
                isActive: true
            ))

            sendPing()
        }
        lastLocation = location
    }

    func locationService(_ service: LocationTrackingServiceProtocol, didFailWithError error: Error) {
        // Log error in tests
    }

    func locationService(_ service: LocationTrackingServiceProtocol, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            locationService.startMonitoring()
            motionHandler.startActivityUpdates()
        }
    }
}

// MARK: - MotionActivityHandlerDelegate

extension TestableAppDelegate: MotionActivityHandlerDelegate {
    func motionHandler(_ handler: MotionActivityHandlerProtocol, didDetectAutomotive isAutomotive: Bool) {
        // Immediate detection - logging only, no trip state changes
        // Trip control moved to didConfirmAutomotive for debouncing
    }

    func motionHandler(_ handler: MotionActivityHandlerProtocol, didConfirmAutomotive isAutomotive: Bool) {
        // Debounced confirmation of automotive state - control trip start/stop here
        if isAutomotive && !isDriving {
            isDriving = true
            startDriveTracking()
        } else if !isAutomotive && isDriving {
            isDriving = false
            stopDriveTracking()
        }
    }

    func motionHandler(_ handler: MotionActivityHandlerProtocol, didChangeState state: MotionState) {
        // Could track state changes
    }
}

// MARK: - WatchConnectivityServiceDelegate

extension TestableAppDelegate: WatchConnectivityServiceDelegate {
    func watchConnectivityService(_ service: WatchConnectivityServiceProtocol, requestsAuthToken completion: @escaping (String?) -> Void) {
        completion("test-token")
    }

    func watchConnectivityServiceDidActivate(_ service: WatchConnectivityServiceProtocol) {
        // Sync config on activation
    }
}
