// App settings model

class AppSettings {
  final String apiUrl;
  final String userEmail;
  final bool autoDetectCar;
  final int gpsPingIntervalSeconds;
  // Car API settings
  final String carBrand;
  final String carUsername;
  final String carPassword;
  final String carCountry;

  AppSettings({
    required this.apiUrl,
    required this.userEmail,
    required this.autoDetectCar,
    required this.gpsPingIntervalSeconds,
    required this.carBrand,
    required this.carUsername,
    required this.carPassword,
    required this.carCountry,
  });

  factory AppSettings.defaults() {
    return AppSettings(
      apiUrl: 'https://mileage-api-ivdikzmo7a-ez.a.run.app',
      userEmail: '',
      autoDetectCar: true,
      gpsPingIntervalSeconds: 30,
      carBrand: 'audi',
      carUsername: '',
      carPassword: '',
      carCountry: 'NL',
    );
  }

  AppSettings copyWith({
    String? apiUrl,
    String? userEmail,
    bool? autoDetectCar,
    int? gpsPingIntervalSeconds,
    String? carBrand,
    String? carUsername,
    String? carPassword,
    String? carCountry,
  }) {
    return AppSettings(
      apiUrl: apiUrl ?? this.apiUrl,
      userEmail: userEmail ?? this.userEmail,
      autoDetectCar: autoDetectCar ?? this.autoDetectCar,
      gpsPingIntervalSeconds: gpsPingIntervalSeconds ?? this.gpsPingIntervalSeconds,
      carBrand: carBrand ?? this.carBrand,
      carUsername: carUsername ?? this.carUsername,
      carPassword: carPassword ?? this.carPassword,
      carCountry: carCountry ?? this.carCountry,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'apiUrl': apiUrl,
      'userEmail': userEmail,
      'autoDetectCar': autoDetectCar,
      'gpsPingIntervalSeconds': gpsPingIntervalSeconds,
      'carBrand': carBrand,
      'carUsername': carUsername,
      'carPassword': carPassword,
      'carCountry': carCountry,
    };
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      apiUrl: json['apiUrl'] as String? ?? 'https://mileage.borism.nl',
      userEmail: json['userEmail'] as String? ?? '',
      autoDetectCar: json['autoDetectCar'] as bool? ?? true,
      gpsPingIntervalSeconds: json['gpsPingIntervalSeconds'] as int? ?? 30,
      carBrand: json['carBrand'] as String? ?? 'audi',
      carUsername: json['carUsername'] as String? ?? '',
      carPassword: json['carPassword'] as String? ?? '',
      carCountry: json['carCountry'] as String? ?? 'NL',
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
  int retryCount;

  QueuedRequest({
    required this.id,
    required this.endpoint,
    required this.lat,
    required this.lng,
    required this.timestamp,
    this.retryCount = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'endpoint': endpoint,
      'lat': lat,
      'lng': lng,
      'timestamp': timestamp.toIso8601String(),
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
      retryCount: json['retryCount'] as int? ?? 0,
    );
  }
}
