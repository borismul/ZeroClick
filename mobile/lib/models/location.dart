/// User-defined location for geofencing
class UserLocation {
  final String name;
  final double lat;
  final double lng;
  final bool isBusiness;

  UserLocation({
    required this.name,
    required this.lat,
    required this.lng,
    this.isBusiness = false,
  });

  factory UserLocation.fromJson(Map<String, dynamic> json) {
    return UserLocation(
      name: json['name'] as String? ?? '',
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (json['lng'] as num?)?.toDouble() ?? 0.0,
      isBusiness: json['is_business'] as bool? ?? false,
    );
  }

  bool get isHome => name.toLowerCase() == 'thuis' || name.toLowerCase() == 'home';
  bool get isOffice => name.toLowerCase() == 'kantoor' || name.toLowerCase() == 'office';
}
