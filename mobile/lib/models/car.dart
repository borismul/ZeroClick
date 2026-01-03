// Car model for multi-car support

class Car {
  final String id;
  final String name;
  final String brand;
  final String color;
  final String icon;
  final bool isDefault;
  final String? carplayDeviceId;
  final double startOdometer;
  final String? createdAt;
  final String? lastUsed;
  final int totalTrips;
  final double totalKm;

  Car({
    required this.id,
    required this.name,
    this.brand = 'other',
    this.color = '#3B82F6',
    this.icon = 'car',
    this.isDefault = false,
    this.carplayDeviceId,
    this.startOdometer = 0,
    this.createdAt,
    this.lastUsed,
    this.totalTrips = 0,
    this.totalKm = 0,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      brand: json['brand'] as String? ?? 'other',
      color: json['color'] as String? ?? '#3B82F6',
      icon: json['icon'] as String? ?? 'car',
      isDefault: json['is_default'] as bool? ?? false,
      carplayDeviceId: json['carplay_device_id'] as String?,
      startOdometer: (json['start_odometer'] as num?)?.toDouble() ?? 0,
      createdAt: json['created_at'] as String?,
      lastUsed: json['last_used'] as String?,
      totalTrips: json['total_trips'] as int? ?? 0,
      totalKm: (json['total_km'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'color': color,
      'icon': icon,
      'is_default': isDefault,
      'carplay_device_id': carplayDeviceId,
      'start_odometer': startOdometer,
      'created_at': createdAt,
      'last_used': lastUsed,
      'total_trips': totalTrips,
      'total_km': totalKm,
    };
  }

  Car copyWith({
    String? id,
    String? name,
    String? brand,
    String? color,
    String? icon,
    bool? isDefault,
    String? carplayDeviceId,
    double? startOdometer,
    String? createdAt,
    String? lastUsed,
    int? totalTrips,
    double? totalKm,
  }) {
    return Car(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      isDefault: isDefault ?? this.isDefault,
      carplayDeviceId: carplayDeviceId ?? this.carplayDeviceId,
      startOdometer: startOdometer ?? this.startOdometer,
      createdAt: createdAt ?? this.createdAt,
      lastUsed: lastUsed ?? this.lastUsed,
      totalTrips: totalTrips ?? this.totalTrips,
      totalKm: totalKm ?? this.totalKm,
    );
  }

  String get brandLabel {
    switch (brand) {
      case 'audi':
        return 'Audi';
      case 'vw':
      case 'volkswagen':
        return 'Volkswagen';
      case 'skoda':
        return 'Skoda';
      case 'seat':
        return 'Seat';
      case 'cupra':
        return 'Cupra';
      case 'renault':
        return 'Renault';
      case 'tesla':
        return 'Tesla';
      case 'bmw':
        return 'BMW';
      case 'mercedes':
        return 'Mercedes';
      default:
        return 'Overig';
    }
  }
}

class CarCredentials {
  final String brand;
  final String username;
  final String password;
  final String country;
  final String locale;
  final String spin;
  final double startOdometer;

  CarCredentials({
    this.brand = 'audi',
    this.username = '',
    this.password = '',
    this.country = 'NL',
    this.locale = 'nl_NL',
    this.spin = '',
    this.startOdometer = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'brand': brand,
      'username': username,
      'password': password,
      'country': country,
      'locale': locale,
      'spin': spin,
      'start_odometer': startOdometer,
    };
  }
}

class CarStats {
  final String carId;
  final int tripCount;
  final double totalKm;
  final double businessKm;
  final double privateKm;

  CarStats({
    required this.carId,
    required this.tripCount,
    required this.totalKm,
    required this.businessKm,
    required this.privateKm,
  });

  factory CarStats.fromJson(Map<String, dynamic> json) {
    return CarStats(
      carId: json['car_id'] as String? ?? '',
      tripCount: json['trip_count'] as int? ?? 0,
      totalKm: (json['total_km'] as num?)?.toDouble() ?? 0,
      businessKm: (json['business_km'] as num?)?.toDouble() ?? 0,
      privateKm: (json['private_km'] as num?)?.toDouble() ?? 0,
    );
  }
}
