// Location service - GPS tracking with background support

import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationResult {
  final double lat;
  final double lng;
  final double? accuracy;
  final DateTime timestamp;

  LocationResult({
    required this.lat,
    required this.lng,
    this.accuracy,
    required this.timestamp,
  });
}

class LocationService {
  bool _hasPermission = false;
  StreamSubscription<Position>? _positionStream;
  Timer? _pingTimer;
  Function(LocationResult)? _onLocationUpdate;
  bool _isTracking = false;

  Future<bool> requestPermissions() async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    // Request location permission
    var status = await Permission.location.request();
    if (status.isDenied) {
      return false;
    }

    // Request background location for tracking during trips
    if (await Permission.locationAlways.isDenied) {
      await Permission.locationAlways.request();
    }

    _hasPermission = true;
    return true;
  }

  Future<bool> get hasPermission async {
    if (_hasPermission) return true;

    var status = await Permission.location.status;
    _hasPermission = status.isGranted;
    return _hasPermission;
  }

  String? lastError;

  Future<LocationResult?> getCurrentLocation() async {
    lastError = null;

    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      lastError = 'Locatieservices uitgeschakeld';
      print('Location services disabled');
      return null;
    }

    if (!await hasPermission) {
      final granted = await requestPermissions();
      if (!granted) {
        lastError = 'Geen locatiepermissie';
        print('Location permission not granted');
        return null;
      }
    }

    try {
      // Try to get current position with timeout
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
        ),
      ).timeout(const Duration(seconds: 10));

      print('Got location: ${position.latitude}, ${position.longitude}');
      return LocationResult(
        lat: position.latitude,
        lng: position.longitude,
        accuracy: position.accuracy,
        timestamp: DateTime.fromMillisecondsSinceEpoch(
          position.timestamp.millisecondsSinceEpoch,
        ),
      );
    } catch (e) {
      print('Error getting current location: $e');
      lastError = 'GPS timeout: $e';

      // Try last known location as fallback
      try {
        final lastPosition = await Geolocator.getLastKnownPosition();
        if (lastPosition != null) {
          print('Using last known location as fallback');
          lastError = null;
          return LocationResult(
            lat: lastPosition.latitude,
            lng: lastPosition.longitude,
            accuracy: lastPosition.accuracy,
            timestamp: DateTime.fromMillisecondsSinceEpoch(
              lastPosition.timestamp.millisecondsSinceEpoch,
            ),
          );
        } else {
          lastError = 'Geen GPS en geen laatst bekende locatie';
        }
      } catch (e2) {
        print('Error getting last known location: $e2');
        lastError = 'GPS fout: $e, fallback fout: $e2';
      }
      return null;
    }
  }

  Future<LocationResult?> getLastKnownLocation() async {
    try {
      final position = await Geolocator.getLastKnownPosition();
      if (position == null) return null;

      return LocationResult(
        lat: position.latitude,
        lng: position.longitude,
        accuracy: position.accuracy,
        timestamp: DateTime.fromMillisecondsSinceEpoch(
          position.timestamp.millisecondsSinceEpoch,
        ),
      );
    } catch (e) {
      print('Error getting last known location: $e');
      return null;
    }
  }

  Future<bool> isLocationEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  bool get isTracking => _isTracking;

  /// Start background location tracking with periodic pings
  Future<bool> startBackgroundTracking({
    required Function(LocationResult) onLocationUpdate,
    Duration pingInterval = const Duration(minutes: 1),
  }) async {
    if (_isTracking) {
      print('Already tracking');
      return true;
    }

    // Request always permission for background tracking
    var status = await Permission.locationAlways.request();
    if (!status.isGranted) {
      // Fall back to when in use
      status = await Permission.locationWhenInUse.request();
      if (!status.isGranted) {
        print('Location permission not granted for background tracking');
        return false;
      }
    }

    _onLocationUpdate = onLocationUpdate;
    _isTracking = true;

    // Start listening to location updates
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 50, // Update every 50 meters
    );

    _positionStream = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((Position position) {
      print('Background location update: ${position.latitude}, ${position.longitude}');
    });

    // Set up periodic ping timer
    _pingTimer = Timer.periodic(pingInterval, (timer) async {
      print('Ping timer fired');
      final location = await getCurrentLocation();
      if (location != null && _onLocationUpdate != null) {
        print('Sending ping: ${location.lat}, ${location.lng}');
        _onLocationUpdate!(location);
      }
    });

    // Send initial ping immediately
    final location = await getCurrentLocation();
    if (location != null && _onLocationUpdate != null) {
      print('Sending initial ping: ${location.lat}, ${location.lng}');
      _onLocationUpdate!(location);
    }

    print('Background tracking started');
    return true;
  }

  /// Stop background location tracking
  void stopBackgroundTracking() {
    print('Stopping background tracking');
    _pingTimer?.cancel();
    _pingTimer = null;
    _positionStream?.cancel();
    _positionStream = null;
    _onLocationUpdate = null;
    _isTracking = false;
  }
}
