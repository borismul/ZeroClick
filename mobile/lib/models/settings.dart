// App settings model

class AppSettings {
  final String apiUrl;
  final String userEmail;
  final bool autoDetectCar;
  final int gpsPingIntervalSeconds;
  // Language setting (null = system default)
  final String? localeCode;

  AppSettings({
    required this.apiUrl,
    required this.userEmail,
    required this.autoDetectCar,
    required this.gpsPingIntervalSeconds,
    this.localeCode,
  });

  factory AppSettings.defaults() {
    return AppSettings(
      apiUrl: 'https://mileage-api-ivdikzmo7a-ez.a.run.app',
      userEmail: '',
      autoDetectCar: true,
      gpsPingIntervalSeconds: 30,
      localeCode: null,
    );
  }

  AppSettings copyWith({
    String? apiUrl,
    String? userEmail,
    bool? autoDetectCar,
    int? gpsPingIntervalSeconds,
    String? localeCode,
    bool clearLocale = false,
  }) {
    return AppSettings(
      apiUrl: apiUrl ?? this.apiUrl,
      userEmail: userEmail ?? this.userEmail,
      autoDetectCar: autoDetectCar ?? this.autoDetectCar,
      gpsPingIntervalSeconds: gpsPingIntervalSeconds ?? this.gpsPingIntervalSeconds,
      localeCode: clearLocale ? null : (localeCode ?? this.localeCode),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'apiUrl': apiUrl,
      'userEmail': userEmail,
      'autoDetectCar': autoDetectCar,
      'gpsPingIntervalSeconds': gpsPingIntervalSeconds,
      'localeCode': localeCode,
    };
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      apiUrl: json['apiUrl'] as String? ?? 'https://mileage-api-ivdikzmo7a-ez.a.run.app',
      userEmail: json['userEmail'] as String? ?? '',
      autoDetectCar: json['autoDetectCar'] as bool? ?? true,
      gpsPingIntervalSeconds: json['gpsPingIntervalSeconds'] as int? ?? 30,
      localeCode: json['localeCode'] as String?,
    );
  }

  bool get isConfigured => userEmail.isNotEmpty;
}

// Queued request for offline support
class QueuedRequest {
  final String id;
  final String endpoint;
  final double lat;
  final double lng;
  final DateTime timestamp;
  final String? deviceId;
  int retryCount;

  QueuedRequest({
    required this.id,
    required this.endpoint,
    required this.lat,
    required this.lng,
    required this.timestamp,
    this.deviceId,
    this.retryCount = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'endpoint': endpoint,
      'lat': lat,
      'lng': lng,
      'timestamp': timestamp.toIso8601String(),
      'deviceId': deviceId,
      'retryCount': retryCount,
    };
  }

  factory QueuedRequest.fromJson(Map<String, dynamic> json) {
    return QueuedRequest(
      id: json['id'] as String,
      endpoint: json['endpoint'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      deviceId: json['deviceId'] as String?,
      retryCount: json['retryCount'] as int? ?? 0,
    );
  }
}
