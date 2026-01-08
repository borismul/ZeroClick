// Trip model - matching web frontend (frontend/app/page.tsx)

class Trip {
  final String id;
  final String date;
  final String startTime;
  final String endTime;
  final String fromAddress;
  final String toAddress;
  final double? fromLat;
  final double? fromLon;
  final double? toLat;
  final double? toLon;
  final double distanceKm;
  final String tripType; // 'B' = Business, 'P' = Private, 'M' = Mixed
  final double businessKm;
  final double privateKm;
  final String? carId;
  final List<GpsPoint>? gpsTrail;
  final double? googleMapsKm;
  final double? routeDeviationPercent;
  final String? routeFlag;
  final String? distanceSource; // "odometer", "osrm", or "gps"

  Trip({
    required this.id,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.fromAddress,
    required this.toAddress,
    this.fromLat,
    this.fromLon,
    this.toLat,
    this.toLon,
    required this.distanceKm,
    required this.tripType,
    required this.businessKm,
    required this.privateKm,
    this.carId,
    this.gpsTrail,
    this.googleMapsKm,
    this.routeDeviationPercent,
    this.routeFlag,
    this.distanceSource,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'] as String? ?? '',
      date: json['date'] as String? ?? '',
      startTime: json['start_time'] as String? ?? '',
      endTime: json['end_time'] as String? ?? '',
      fromAddress: json['from_address'] as String? ?? '',
      toAddress: json['to_address'] as String? ?? '',
      fromLat: (json['from_lat'] as num?)?.toDouble(),
      fromLon: (json['from_lon'] as num?)?.toDouble(),
      toLat: (json['to_lat'] as num?)?.toDouble(),
      toLon: (json['to_lon'] as num?)?.toDouble(),
      distanceKm: (json['distance_km'] as num?)?.toDouble() ?? 0.0,
      tripType: json['trip_type'] as String? ?? 'P',
      businessKm: (json['business_km'] as num?)?.toDouble() ?? 0.0,
      privateKm: (json['private_km'] as num?)?.toDouble() ?? 0.0,
      carId: json['car_id'] as String?,
      gpsTrail: (json['gps_trail'] as List<dynamic>?)
          ?.map((e) => GpsPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
      googleMapsKm: (json['google_maps_km'] as num?)?.toDouble(),
      routeDeviationPercent: (json['route_deviation_percent'] as num?)?.toDouble(),
      routeFlag: json['route_flag'] as String?,
      distanceSource: json['distance_source'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'start_time': startTime,
      'end_time': endTime,
      'from_address': fromAddress,
      'to_address': toAddress,
      'from_lat': fromLat,
      'from_lon': fromLon,
      'to_lat': toLat,
      'to_lon': toLon,
      'distance_km': distanceKm,
      'trip_type': tripType,
      'business_km': businessKm,
      'private_km': privateKm,
      'car_id': carId,
      'gps_trail': gpsTrail?.map((e) => e.toJson()).toList(),
      'google_maps_km': googleMapsKm,
      'route_deviation_percent': routeDeviationPercent,
      'route_flag': routeFlag,
      'distance_source': distanceSource,
    };
  }

  /// Check if distance was estimated (not from odometer)
  bool get isDistanceEstimated => distanceSource != null && distanceSource != 'odometer';

  /// Get localized distance source label
  String getDistanceSourceLabel(dynamic l10n) {
    switch (distanceSource) {
      case 'odometer':
        return l10n.distanceSourceOdometer;
      case 'osrm':
        return l10n.distanceSourceOsrm;
      case 'gps':
        return l10n.distanceSourceGps;
      default:
        return '';
    }
  }

  /// Get localized trip type label
  String getTripTypeLabel(dynamic l10n) {
    switch (tripType) {
      case 'B':
        return l10n.tripTypeBusiness;
      case 'P':
        return l10n.tripTypePrivate;
      case 'M':
        return l10n.tripTypeMixed;
      default:
        return tripType;
    }
  }
}

class GpsPoint {
  final double lat;
  final double lng;
  final String timestamp;

  GpsPoint({
    required this.lat,
    required this.lng,
    required this.timestamp,
  });

  factory GpsPoint.fromJson(Map<String, dynamic> json) {
    return GpsPoint(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      timestamp: json['timestamp'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lng': lng,
      'timestamp': timestamp,
    };
  }
}

class Stats {
  final double totalKm;
  final double businessKm;
  final double privateKm;
  final int tripCount;

  Stats({
    required this.totalKm,
    required this.businessKm,
    required this.privateKm,
    required this.tripCount,
  });

  factory Stats.fromJson(Map<String, dynamic> json) {
    return Stats(
      totalKm: (json['total_km'] as num).toDouble(),
      businessKm: (json['business_km'] as num).toDouble(),
      privateKm: (json['private_km'] as num).toDouble(),
      tripCount: json['trip_count'] as int,
    );
  }
}

class ActiveTrip {
  final bool active;
  final String? startTime;
  final double? startOdo;
  final double? lastOdo;
  final String? lastOdoChange;
  final int? gpsCount;
  final GpsPoint? firstGps;
  final GpsPoint? lastGps;

  ActiveTrip({
    required this.active,
    this.startTime,
    this.startOdo,
    this.lastOdo,
    this.lastOdoChange,
    this.gpsCount,
    this.firstGps,
    this.lastGps,
  });

  factory ActiveTrip.fromJson(Map<String, dynamic> json) {
    return ActiveTrip(
      active: json['active'] as bool,
      startTime: json['start_time'] as String?,
      startOdo: (json['start_odo'] as num?)?.toDouble(),
      lastOdo: (json['last_odo'] as num?)?.toDouble(),
      lastOdoChange: json['last_odo_change'] as String?,
      gpsCount: json['gps_count'] as int?,
      firstGps: json['first_gps'] != null
          ? GpsPoint.fromJson(json['first_gps'] as Map<String, dynamic>)
          : null,
      lastGps: json['last_gps'] != null
          ? GpsPoint.fromJson(json['last_gps'] as Map<String, dynamic>)
          : null,
    );
  }

  double get distanceKm {
    if (startOdo != null && lastOdo != null) {
      return lastOdo! - startOdo!;
    }
    return 0;
  }
}

class CarData {
  final String brand;
  final String? vin;
  final double? odometerKm;
  final double? latitude;
  final double? longitude;
  final String? state;
  final int? batteryLevel;
  final int? rangeKm;
  final bool isCharging;
  final bool isPluggedIn;
  final double? chargingPowerKw;
  final int? chargingRemainingMinutes;
  final double? batteryTempCelsius;
  final String? climateState;
  final double? climateTargetTemp;
  final bool? seatHeating;
  final bool? windowHeating;
  final String? connectionState;
  final String? lightsState;
  final String fetchedAt;

  CarData({
    required this.brand,
    this.vin,
    this.odometerKm,
    this.latitude,
    this.longitude,
    this.state,
    this.batteryLevel,
    this.rangeKm,
    required this.isCharging,
    required this.isPluggedIn,
    this.chargingPowerKw,
    this.chargingRemainingMinutes,
    this.batteryTempCelsius,
    this.climateState,
    this.climateTargetTemp,
    this.seatHeating,
    this.windowHeating,
    this.connectionState,
    this.lightsState,
    required this.fetchedAt,
  });

  factory CarData.fromJson(Map<String, dynamic> json) {
    return CarData(
      brand: json['brand'] as String? ?? 'unknown',
      vin: json['vin'] as String?,
      odometerKm: (json['odometer_km'] as num?)?.toDouble(),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      state: json['state'] as String?,
      batteryLevel: (json['battery_level'] as num?)?.toInt(),
      rangeKm: (json['range_km'] as num?)?.toInt(),
      isCharging: json['is_charging'] as bool? ?? false,
      isPluggedIn: json['is_plugged_in'] as bool? ?? false,
      chargingPowerKw: (json['charging_power_kw'] as num?)?.toDouble(),
      chargingRemainingMinutes: (json['charging_remaining_minutes'] as num?)?.toInt(),
      batteryTempCelsius: (json['battery_temp_celsius'] as num?)?.toDouble(),
      climateState: json['climate_state'] as String?,
      climateTargetTemp: (json['climate_target_temp'] as num?)?.toDouble(),
      seatHeating: json['seat_heating'] as bool?,
      windowHeating: json['window_heating'] as bool?,
      connectionState: json['connection_state'] as String?,
      lightsState: json['lights_state'] as String?,
      fetchedAt: json['fetched_at'] as String? ?? '',
    );
  }

  /// Get localized state label
  String getStateLabel(dynamic l10n) {
    switch (state) {
      case 'parked':
        return l10n.stateParked;
      case 'driving':
        return l10n.stateDriving;
      case 'charging':
        return l10n.stateCharging;
      default:
        return l10n.stateUnknown;
    }
  }
}
