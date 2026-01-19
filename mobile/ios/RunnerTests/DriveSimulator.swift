import CoreLocation
@testable import Runner

/// Pre-built drive scenarios (Rotterdam area coordinates)
struct DriveScenarios {
    static let homeLat = 51.9270
    static let homeLng = 4.3620
    static let officeLat = 51.9420
    static let officeLng = 4.4850
    static let skipLat = 51.9350
    static let skipLng = 4.4200

    /// Home to office drive with realistic GPS intervals (~500m between points)
    /// This ensures distance < 1000m threshold is respected for accumulation
    static func homeToOffice() -> [CLLocation] {
        let now = Date()
        return [
            // Start at home
            CLLocation(coordinate: CLLocationCoordinate2D(latitude: homeLat, longitude: homeLng),
                      altitude: 0, horizontalAccuracy: 10, verticalAccuracy: 10, timestamp: now),
            // ~500m increments heading towards office
            CLLocation(coordinate: CLLocationCoordinate2D(latitude: 51.9285, longitude: 4.3690),
                      altitude: 0, horizontalAccuracy: 10, verticalAccuracy: 10,
                      timestamp: now.addingTimeInterval(30)),
            CLLocation(coordinate: CLLocationCoordinate2D(latitude: 51.9300, longitude: 4.3760),
                      altitude: 0, horizontalAccuracy: 10, verticalAccuracy: 10,
                      timestamp: now.addingTimeInterval(60)),
            CLLocation(coordinate: CLLocationCoordinate2D(latitude: 51.9315, longitude: 4.3830),
                      altitude: 0, horizontalAccuracy: 10, verticalAccuracy: 10,
                      timestamp: now.addingTimeInterval(90)),
            CLLocation(coordinate: CLLocationCoordinate2D(latitude: 51.9330, longitude: 4.3900),
                      altitude: 0, horizontalAccuracy: 10, verticalAccuracy: 10,
                      timestamp: now.addingTimeInterval(120)),
            // End approaching office area
            CLLocation(coordinate: CLLocationCoordinate2D(latitude: 51.9345, longitude: 4.3970),
                      altitude: 0, horizontalAccuracy: 10, verticalAccuracy: 10,
                      timestamp: now.addingTimeInterval(150)),
        ]
    }

    /// Stationary trip (false start)
    static func stationaryTrip() -> [CLLocation] {
        let now = Date()
        return [
            CLLocation(coordinate: CLLocationCoordinate2D(latitude: homeLat, longitude: homeLng),
                      altitude: 0, horizontalAccuracy: 10, verticalAccuracy: 10, timestamp: now),
            CLLocation(coordinate: CLLocationCoordinate2D(latitude: homeLat, longitude: homeLng),
                      altitude: 0, horizontalAccuracy: 10, verticalAccuracy: 10,
                      timestamp: now.addingTimeInterval(60)),
            CLLocation(coordinate: CLLocationCoordinate2D(latitude: homeLat, longitude: homeLng),
                      altitude: 0, horizontalAccuracy: 10, verticalAccuracy: 10,
                      timestamp: now.addingTimeInterval(120)),
        ]
    }

    /// Trip with skip location stop
    static func tripWithSkipLocation() -> [CLLocation] {
        let now = Date()
        return [
            CLLocation(coordinate: CLLocationCoordinate2D(latitude: homeLat, longitude: homeLng),
                      altitude: 0, horizontalAccuracy: 10, verticalAccuracy: 10, timestamp: now),
            CLLocation(coordinate: CLLocationCoordinate2D(latitude: 51.9300, longitude: 4.3900),
                      altitude: 0, horizontalAccuracy: 10, verticalAccuracy: 10,
                      timestamp: now.addingTimeInterval(60)),
            // At skip location
            CLLocation(coordinate: CLLocationCoordinate2D(latitude: skipLat, longitude: skipLng),
                      altitude: 0, horizontalAccuracy: 10, verticalAccuracy: 10,
                      timestamp: now.addingTimeInterval(120)),
            CLLocation(coordinate: CLLocationCoordinate2D(latitude: skipLat, longitude: skipLng),
                      altitude: 0, horizontalAccuracy: 10, verticalAccuracy: 10,
                      timestamp: now.addingTimeInterval(180)),
            // Continue to office
            CLLocation(coordinate: CLLocationCoordinate2D(latitude: officeLat, longitude: officeLng),
                      altitude: 0, horizontalAccuracy: 10, verticalAccuracy: 10,
                      timestamp: now.addingTimeInterval(240)),
        ]
    }
}

/// Orchestrates mock services for iOS drive simulation testing
class DriveSimulator {
    let locationService: MockLocationTrackingService
    let motionHandler: MockMotionActivityHandler
    let liveActivityManager: MockLiveActivityManager
    let watchService: MockWatchConnectivityService

    // Current scenario
    private var currentLocations: [CLLocation] = []
    private var currentLocationIndex = 0

    init() {
        locationService = MockLocationTrackingService()
        motionHandler = MockMotionActivityHandler()
        liveActivityManager = MockLiveActivityManager()
        watchService = MockWatchConnectivityService()
    }

    // MARK: - Scenario Setup

    /// Setup home to office drive scenario
    func setupHomeToOfficeTrip() {
        currentLocations = DriveScenarios.homeToOffice()
        currentLocationIndex = 0
    }

    /// Setup stationary trip (should be cancelled)
    func setupStationaryTrip() {
        currentLocations = DriveScenarios.stationaryTrip()
        currentLocationIndex = 0
    }

    /// Setup trip with skip location
    func setupTripWithSkipLocation() {
        currentLocations = DriveScenarios.tripWithSkipLocation()
        currentLocationIndex = 0
    }

    /// Setup custom location sequence
    func setupCustomTrip(_ locations: [CLLocation]) {
        currentLocations = locations
        currentLocationIndex = 0
    }

    // MARK: - Trip Lifecycle

    /// Start the trip (simulates motion detection trigger)
    func startTrip() {
        // Inject first location to set lastLocation (needed for start coordinate)
        if let firstLocation = currentLocations.first {
            locationService.injectLocation(firstLocation)
        }

        // Trigger automotive detection - this starts tracking
        motionHandler.simulateStartDriving()

        // Inject location again now that tracking is active
        // This ensures the delegate processes it while actively tracking
        if let firstLocation = currentLocations.first {
            locationService.injectLocation(firstLocation)
        }
    }

    /// Trigger next GPS ping
    func triggerPing() {
        currentLocationIndex += 1
        if currentLocationIndex < currentLocations.count {
            locationService.injectLocation(currentLocations[currentLocationIndex])
        }
    }

    /// End the trip (simulates motion stopping)
    func endTrip() {
        motionHandler.simulateStopDriving()
    }

    /// Run complete trip automatically
    func runCompleteTrip() {
        startTrip()

        // Trigger all pings
        while currentLocationIndex < currentLocations.count - 1 {
            triggerPing()
        }

        endTrip()
    }

    // MARK: - Verification Helpers

    /// Check if tracking started
    var didStartTracking: Bool {
        return liveActivityManager.startActivityCalled && locationService.highAccuracyEnabled
    }

    /// Check if tracking stopped
    var didStopTracking: Bool {
        return liveActivityManager.endActivityCalled && locationService.lowAccuracyEnabled
    }

    /// Get number of location updates
    var locationUpdateCount: Int {
        return locationService.locationHistory.count
    }

    /// Get Live Activity update count
    var liveActivityUpdateCount: Int {
        return liveActivityManager.updateCount
    }

    /// Check if Watch was notified
    var didNotifyWatch: Bool {
        return watchService.notifyTripStartedCalled
    }

    /// Reset all mocks for next test
    func reset() {
        locationService.reset()
        motionHandler.reset()
        liveActivityManager.reset()
        watchService.reset()
        currentLocations.removeAll()
        currentLocationIndex = 0
    }
}
