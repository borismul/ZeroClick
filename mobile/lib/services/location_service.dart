// Location service - GPS tracking with background support

import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../core/logging/app_logger.dart';

class LocationResult {
  LocationResult({
    required this.lat,
    required this.lng,
    required this.timestamp,
    this.accuracy,
  });

  final double lat;
  final double lng;
  final double? accuracy;
  final DateTime timestamp;
}

class LocationService {
  static const _log = AppLogger('LocationService');

  bool _hasPermission = false;
  StreamSubscription<Position>? _positionStream;
  Timer? _pingTimer;
  void Function(LocationResult)? _onLocationUpdate;
  bool _isTracking = false;

  String? lastError;
  bool get isTracking => _isTracking;

  Future<bool> requestPermissions() async {
    // Check if location services are enabled
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
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

    final status = await Permission.location.status;
    _hasPermission = status.isGranted;
    return _hasPermission;
  }

  Future<LocationResult?> getCurrentLocation() async {
    lastError = null;

    // Check if location services are enabled
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      lastError = 'Locatieservices uitgeschakeld';
      _log.warning('Location services disabled');
      return null;
    }

    if (!await hasPermission) {
      final granted = await requestPermissions();
      if (!granted) {
        lastError = 'Geen locatiepermissie';
        _log.warning('Location permission not granted');
        return null;
      }
    }

    try {
      // Try to get current position with timeout
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      ).timeout(const Duration(seconds: 15));

      // Check if position is fresh (within last 2 minutes)
      final positionAge = DateTime.now().difference(position.timestamp);
      if (positionAge.inMinutes > 2) {
        _log.warning('GPS position too old: ${positionAge.inSeconds}s ago, rejecting');
        lastError = 'GPS positie te oud (${positionAge.inSeconds}s)';
        return null;
      }

      _log.debug('Got location: ${position.latitude}, ${position.longitude} (age: ${positionAge.inSeconds}s)');
      return LocationResult(
        lat: position.latitude,
        lng: position.longitude,
        accuracy: position.accuracy,
        timestamp: DateTime.fromMillisecondsSinceEpoch(
          position.timestamp.millisecondsSinceEpoch,
        ),
      );
    } on Exception catch (e) {
      _log.error('Error getting current location', e);
      lastError = 'GPS timeout: $e';

      // Try last known location as fallback
      try {
        final lastPosition = await Geolocator.getLastKnownPosition();
        if (lastPosition != null) {
          _log.debug('Using last known location as fallback');
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
      } on Exception catch (e2) {
        _log.error('Error getting last known location', e2);
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
    } on Exception catch (e) {
      _log.error('Error getting last known location', e);
      return null;
    }
  }

  Future<bool> isLocationEnabled() => Geolocator.isLocationServiceEnabled();

  /// Start background location tracking with periodic pings
  Future<bool> startBackgroundTracking({
    required void Function(LocationResult) onLocationUpdate,
    Duration pingInterval = const Duration(minutes: 1),
  }) async {
    if (_isTracking) {
      _log.debug('Already tracking');
      return true;
    }

    // Request always permission for background tracking
    var status = await Permission.locationAlways.request();
    if (!status.isGranted) {
      // Fall back to when in use
      status = await Permission.locationWhenInUse.request();
      if (!status.isGranted) {
        _log.warning('Location permission not granted for background tracking');
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
    ).listen((position) {
      _log.debug('Background location update: ${position.latitude}, ${position.longitude}');
    });

    // Set up periodic ping timer
    _pingTimer = Timer.periodic(pingInterval, (timer) async {
      _log.debug('Ping timer fired');
      final location = await getCurrentLocation();
      if (location != null && _onLocationUpdate != null) {
        _log.debug('Sending ping: ${location.lat}, ${location.lng}');
        _onLocationUpdate!(location);
      }
    });

    // Send initial ping immediately
    final location = await getCurrentLocation();
    if (location != null && _onLocationUpdate != null) {
      _log.debug('Sending initial ping: ${location.lat}, ${location.lng}');
      _onLocationUpdate!(location);
    }

    _log.info('Background tracking started');
    return true;
  }

  /// Stop background location tracking
  void stopBackgroundTracking() {
    _log.info('Stopping background tracking');
    _pingTimer?.cancel();
    _pingTimer = null;
    _positionStream?.cancel();
    _positionStream = null;
    _onLocationUpdate = null;
    _isTracking = false;
  }
}
