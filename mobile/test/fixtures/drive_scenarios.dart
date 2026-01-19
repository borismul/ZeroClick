import 'package:zero_click/services/location_service.dart';

/// Pre-built drive scenarios for integration testing.
///
/// Contains GPS coordinate sequences for common driving patterns and edge cases.
/// Coordinates are based on Rotterdam/Netherlands area (matching CLAUDE.md config).
class DriveScenarios {
  /// Home coordinates (Rotterdam area)
  static const double homeLat = 51.9270;
  static const double homeLng = 4.3620;

  /// Office coordinates (Rotterdam area)
  static const double officeLat = 51.9420;
  static const double officeLng = 4.4850;

  /// Skip location (e.g., gas station between home and office)
  static const double skipLat = 51.9350;
  static const double skipLng = 4.4200;

  /// Generate a simple home-to-office drive (5 pings, ~15km)
  static List<LocationResult> homeToOffice() {
    final now = DateTime.now();
    return [
      LocationResult(lat: homeLat, lng: homeLng, timestamp: now),
      LocationResult(
        lat: 51.9300,
        lng: 4.3900,
        timestamp: now.add(const Duration(minutes: 1)),
      ),
      LocationResult(
        lat: 51.9350,
        lng: 4.4200,
        timestamp: now.add(const Duration(minutes: 2)),
      ),
      LocationResult(
        lat: 51.9380,
        lng: 4.4500,
        timestamp: now.add(const Duration(minutes: 3)),
      ),
      LocationResult(
        lat: officeLat,
        lng: officeLng,
        timestamp: now.add(const Duration(minutes: 4)),
      ),
    ];
  }

  /// Office-to-home drive (reverse of homeToOffice)
  static List<LocationResult> officeToHome() {
    final now = DateTime.now();
    return [
      LocationResult(lat: officeLat, lng: officeLng, timestamp: now),
      LocationResult(
        lat: 51.9380,
        lng: 4.4500,
        timestamp: now.add(const Duration(minutes: 1)),
      ),
      LocationResult(
        lat: 51.9350,
        lng: 4.4200,
        timestamp: now.add(const Duration(minutes: 2)),
      ),
      LocationResult(
        lat: 51.9300,
        lng: 4.3900,
        timestamp: now.add(const Duration(minutes: 3)),
      ),
      LocationResult(
        lat: homeLat,
        lng: homeLng,
        timestamp: now.add(const Duration(minutes: 4)),
      ),
    ];
  }

  /// Short trip that should be skipped (<0.1km, near-stationary)
  static List<LocationResult> tooShortTrip() {
    final now = DateTime.now();
    return [
      LocationResult(lat: homeLat, lng: homeLng, timestamp: now),
      LocationResult(
        lat: homeLat + 0.0001,
        lng: homeLng + 0.0001,
        timestamp: now.add(const Duration(minutes: 1)),
      ),
    ];
  }

  /// Trip that visits skip location mid-way (tests skip location pausing)
  static List<LocationResult> tripWithSkipLocation() {
    final now = DateTime.now();
    return [
      LocationResult(lat: homeLat, lng: homeLng, timestamp: now),
      LocationResult(
        lat: 51.9300,
        lng: 4.3900,
        timestamp: now.add(const Duration(minutes: 1)),
      ),
      // At skip location for multiple pings (should trigger pause)
      LocationResult(
        lat: skipLat,
        lng: skipLng,
        timestamp: now.add(const Duration(minutes: 2)),
      ),
      LocationResult(
        lat: skipLat,
        lng: skipLng,
        timestamp: now.add(const Duration(minutes: 3)),
      ),
      LocationResult(
        lat: skipLat,
        lng: skipLng,
        timestamp: now.add(const Duration(minutes: 4)),
      ),
      // Continue to office
      LocationResult(
        lat: 51.9380,
        lng: 4.4500,
        timestamp: now.add(const Duration(minutes: 5)),
      ),
      LocationResult(
        lat: officeLat,
        lng: officeLng,
        timestamp: now.add(const Duration(minutes: 6)),
      ),
    ];
  }

  /// Stationary trip (false start - no movement)
  static List<LocationResult> stationaryTrip() {
    final now = DateTime.now();
    return [
      LocationResult(lat: homeLat, lng: homeLng, timestamp: now),
      LocationResult(
        lat: homeLat,
        lng: homeLng,
        timestamp: now.add(const Duration(minutes: 1)),
      ),
      LocationResult(
        lat: homeLat,
        lng: homeLng,
        timestamp: now.add(const Duration(minutes: 2)),
      ),
    ];
  }

  /// Long trip with traffic (15 pings, same location repeated = traffic jam)
  static List<LocationResult> tripWithTraffic() {
    final now = DateTime.now();
    return [
      LocationResult(lat: homeLat, lng: homeLng, timestamp: now),
      LocationResult(
        lat: 51.9300,
        lng: 4.3900,
        timestamp: now.add(const Duration(minutes: 1)),
      ),
      // Traffic jam - 5 pings at same location
      LocationResult(
        lat: 51.9320,
        lng: 4.4000,
        timestamp: now.add(const Duration(minutes: 2)),
      ),
      LocationResult(
        lat: 51.9320,
        lng: 4.4000,
        timestamp: now.add(const Duration(minutes: 3)),
      ),
      LocationResult(
        lat: 51.9320,
        lng: 4.4000,
        timestamp: now.add(const Duration(minutes: 4)),
      ),
      LocationResult(
        lat: 51.9320,
        lng: 4.4000,
        timestamp: now.add(const Duration(minutes: 5)),
      ),
      LocationResult(
        lat: 51.9320,
        lng: 4.4000,
        timestamp: now.add(const Duration(minutes: 6)),
      ),
      // Traffic clears
      LocationResult(
        lat: 51.9380,
        lng: 4.4500,
        timestamp: now.add(const Duration(minutes: 7)),
      ),
      LocationResult(
        lat: officeLat,
        lng: officeLng,
        timestamp: now.add(const Duration(minutes: 8)),
      ),
    ];
  }

  /// Highway trip (longer distance, fewer pings per km)
  static List<LocationResult> highwayTrip() {
    final now = DateTime.now();
    // A13 highway route approximation
    return [
      LocationResult(
        lat: 51.9270,
        lng: 4.3620,
        timestamp: now,
      ), // Rotterdam
      LocationResult(
        lat: 51.9800,
        lng: 4.3500,
        timestamp: now.add(const Duration(minutes: 2)),
      ), // Delft area
      LocationResult(
        lat: 52.0500,
        lng: 4.3200,
        timestamp: now.add(const Duration(minutes: 4)),
      ), // Near Den Haag
      LocationResult(
        lat: 52.0800,
        lng: 4.3000,
        timestamp: now.add(const Duration(minutes: 6)),
      ), // Den Haag
    ];
  }

  /// Round trip (home -> destination -> home)
  static List<LocationResult> roundTrip() {
    final now = DateTime.now();
    return [
      LocationResult(lat: homeLat, lng: homeLng, timestamp: now),
      LocationResult(
        lat: 51.9350,
        lng: 4.4200,
        timestamp: now.add(const Duration(minutes: 2)),
      ),
      LocationResult(
        lat: officeLat,
        lng: officeLng,
        timestamp: now.add(const Duration(minutes: 4)),
      ),
      // Return journey
      LocationResult(
        lat: 51.9350,
        lng: 4.4200,
        timestamp: now.add(const Duration(minutes: 6)),
      ),
      LocationResult(
        lat: homeLat,
        lng: homeLng,
        timestamp: now.add(const Duration(minutes: 8)),
      ),
    ];
  }

  /// Generate custom drive with N pings between two points
  static List<LocationResult> customDrive({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
    required int pingCount,
    Duration pingInterval = const Duration(minutes: 1),
  }) {
    final now = DateTime.now();
    final latStep = (endLat - startLat) / (pingCount - 1);
    final lngStep = (endLng - startLng) / (pingCount - 1);

    return List.generate(
      pingCount,
      (i) => LocationResult(
        lat: startLat + (latStep * i),
        lng: startLng + (lngStep * i),
        timestamp: now.add(pingInterval * i),
      ),
    );
  }

  /// Generate drive with variable speed (for testing speed calculations)
  static List<LocationResult> variableSpeedDrive() {
    final now = DateTime.now();
    return [
      // Slow start (30 km/h equivalent spacing)
      LocationResult(lat: homeLat, lng: homeLng, timestamp: now),
      LocationResult(
        lat: 51.9285,
        lng: 4.3700,
        timestamp: now.add(const Duration(minutes: 1)),
      ),
      // Speed up (60 km/h)
      LocationResult(
        lat: 51.9320,
        lng: 4.3900,
        timestamp: now.add(const Duration(minutes: 2)),
      ),
      // Highway speed (100 km/h)
      LocationResult(
        lat: 51.9400,
        lng: 4.4300,
        timestamp: now.add(const Duration(minutes: 3)),
      ),
      // Slow down for exit
      LocationResult(
        lat: 51.9410,
        lng: 4.4700,
        timestamp: now.add(const Duration(minutes: 4)),
      ),
      // Arrival
      LocationResult(
        lat: officeLat,
        lng: officeLng,
        timestamp: now.add(const Duration(minutes: 5)),
      ),
    ];
  }
}
