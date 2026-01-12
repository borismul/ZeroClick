// App settings model

class AppSettings {
  const AppSettings({
    required this.apiUrl,
    required this.userEmail,
    required this.autoDetectCar,
    required this.gpsPingIntervalSeconds,
    this.localeCode,
  });

  factory AppSettings.defaults() => const AppSettings(
        apiUrl: 'https://mileage-api-ivdikzmo7a-ez.a.run.app',
        userEmail: '',
        autoDetectCar: true,
        gpsPingIntervalSeconds: 30,
      );

  factory AppSettings.fromJson(Map<String, dynamic> json) => AppSettings(
        apiUrl: json['apiUrl'] as String? ?? 'https://mileage-api-ivdikzmo7a-ez.a.run.app',
        userEmail: json['userEmail'] as String? ?? '',
        autoDetectCar: json['autoDetectCar'] as bool? ?? true,
        gpsPingIntervalSeconds: json['gpsPingIntervalSeconds'] as int? ?? 30,
        localeCode: json['localeCode'] as String?,
      );

  final String apiUrl;
  final String userEmail;
  final bool autoDetectCar;
  final int gpsPingIntervalSeconds;
  // Language setting (null = system default)
  final String? localeCode;

  AppSettings copyWith({
    String? apiUrl,
    String? userEmail,
    bool? autoDetectCar,
    int? gpsPingIntervalSeconds,
    String? localeCode,
    bool clearLocale = false,
  }) =>
      AppSettings(
        apiUrl: apiUrl ?? this.apiUrl,
        userEmail: userEmail ?? this.userEmail,
        autoDetectCar: autoDetectCar ?? this.autoDetectCar,
        gpsPingIntervalSeconds: gpsPingIntervalSeconds ?? this.gpsPingIntervalSeconds,
        localeCode: clearLocale ? null : (localeCode ?? this.localeCode),
      );

  Map<String, dynamic> toJson() => {
        'apiUrl': apiUrl,
        'userEmail': userEmail,
        'autoDetectCar': autoDetectCar,
        'gpsPingIntervalSeconds': gpsPingIntervalSeconds,
        'localeCode': localeCode,
      };

  bool get isConfigured => userEmail.isNotEmpty;
}

// Queued request for offline support
class QueuedRequest {
  QueuedRequest({
    required this.id,
    required this.endpoint,
    required this.lat,
    required this.lng,
    required this.timestamp,
    this.deviceId,
    this.retryCount = 0,
  });

  factory QueuedRequest.fromJson(Map<String, dynamic> json) => QueuedRequest(
        id: json['id'] as String,
        endpoint: json['endpoint'] as String,
        lat: (json['lat'] as num).toDouble(),
        lng: (json['lng'] as num).toDouble(),
        timestamp: DateTime.parse(json['timestamp'] as String),
        deviceId: json['deviceId'] as String?,
        retryCount: json['retryCount'] as int? ?? 0,
      );

  final String id;
  final String endpoint;
  final double lat;
  final double lng;
  final DateTime timestamp;
  final String? deviceId;
  int retryCount;

  Map<String, dynamic> toJson() => {
        'id': id,
        'endpoint': endpoint,
        'lat': lat,
        'lng': lng,
        'timestamp': timestamp.toIso8601String(),
        'deviceId': deviceId,
        'retryCount': retryCount,
      };
}
