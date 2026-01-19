import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../l10n/generated/app_localizations.dart';
import '../providers/app_provider.dart';

class ChargingMapScreen extends StatefulWidget {
  const ChargingMapScreen({super.key});

  @override
  State<ChargingMapScreen> createState() => _ChargingMapScreenState();
}

class _ChargingMapScreenState extends State<ChargingMapScreen> {
  final MapController _mapController = MapController();
  List<ChargingStation> _stations = [];
  bool _loading = true;
  String? _error;
  LatLng _center = const LatLng(52.0907, 5.1214); // Default: Utrecht, NL
  double _zoom = 12.0;
  ChargingStation? _selectedStation;

  // Calculate radius based on zoom level (rough approximation)
  int _getRadiusForZoom(double zoom) {
    // zoom 6 = ~500km, zoom 10 = ~50km, zoom 14 = ~5km, zoom 18 = ~0.5km
    if (zoom <= 6) return 200;
    if (zoom <= 8) return 100;
    if (zoom <= 10) return 50;
    if (zoom <= 12) return 25;
    if (zoom <= 14) return 10;
    if (zoom <= 16) return 5;
    return 2;
  }

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    try {
      // Try to get current location
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        final position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.low,
            timeLimit: Duration(seconds: 5),
          ),
        );
        _center = LatLng(position.latitude, position.longitude);
      }
    } catch (e) {
      debugPrint('Location error: $e');
    }

    await _loadStations();
  }

  Future<void> _loadStations() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final radius = _getRadiusForZoom(_zoom);
      var stations = await _fetchChargingStations(
        _center.latitude,
        _center.longitude,
        radius: radius,
        maxResults: 200,
      );

      // When zoomed out, show random sample for better coverage spread
      if (_zoom <= 10 && stations.length > 25) {
        stations.shuffle();
        stations = stations.take(25).toList();
      } else if (_zoom <= 12 && stations.length > 50) {
        stations.shuffle();
        stations = stations.take(50).toList();
      }

      if (mounted) {
        setState(() {
          _stations = stations;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _loading = false;
        });
      }
    }
  }

  Future<List<ChargingStation>> _fetchChargingStations(
    double lat,
    double lng, {
    int radius = 15,
    int maxResults = 150,
  }) async {
    // Use backend API to proxy Open Charge Map (keeps API key secure)
    final provider = Provider.of<AppProvider>(context, listen: false);
    final baseUrl = provider.settings.apiUrl;

    if (baseUrl.isEmpty) {
      throw Exception('API not configured');
    }

    final url = Uri.parse(
      '$baseUrl/charging/stations'
      '?lat=$lat'
      '&lng=$lng'
      '&radius=$radius'
      '&max_results=$maxResults',
    );

    final response = await http.get(url, headers: {
      'User-Agent': 'ZeroClick/1.0',
    });

    if (response.statusCode != 200) {
      throw Exception('API error: ${response.statusCode}');
    }

    final data = json.decode(response.body) as List<dynamic>;
    return data.map((item) => ChargingStation.fromJson(item as Map<String, dynamic>)).toList();
  }

  void _onMapMove(MapCamera camera, bool hasGesture) {
    if (!hasGesture) return;

    final distance = const Distance().as(
      LengthUnit.Kilometer,
      _center,
      camera.center,
    );

    // Reload if moved significantly or zoom changed enough to affect radius
    final oldRadius = _getRadiusForZoom(_zoom);
    final newRadius = _getRadiusForZoom(camera.zoom);
    final radiusChanged = oldRadius != newRadius;
    final movedFar = distance > (oldRadius * 0.5); // Moved more than half the radius

    if (radiusChanged || movedFar) {
      _center = camera.center;
      _zoom = camera.zoom;
      _loadStations();
    }
  }

  List<Marker> _buildMarkers() {
    return _stations.map((station) {
      final isSelected = _selectedStation?.id == station.id;
      return Marker(
        point: LatLng(station.latitude, station.longitude),
        width: isSelected ? 50 : 40,
        height: isSelected ? 50 : 40,
        child: GestureDetector(
          onTap: () => setState(() => _selectedStation = station),
          child: Icon(
            Icons.ev_station,
            color: _getStationColor(station),
            size: isSelected ? 50 : 40,
          ),
        ),
      );
    }).toList();
  }

  Color _getStationColor(ChargingStation station) {
    // Color based on max power
    if (station.maxPowerKW != null) {
      if (station.maxPowerKW! >= 150) return Colors.purple; // Ultra-fast
      if (station.maxPowerKW! >= 50) return Colors.orange; // Fast
      if (station.maxPowerKW! >= 22) return Colors.blue; // AC fast
    }
    return Colors.green; // Standard
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _center,
              initialZoom: 12,
              onPositionChanged: _onMapMove,
              onTap: (_, __) => setState(() => _selectedStation = null),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.zeroclick.app',
              ),
              MarkerLayer(markers: _buildMarkers()),
            ],
          ),

          // Loading indicator
          if (_loading)
            const Center(child: CircularProgressIndicator()),

          // Error message
          if (_error != null)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Card(
                color: Colors.red.shade900,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(_error!, style: const TextStyle(color: Colors.white)),
                ),
              ),
            ),

          // Station count
          Positioned(
            top: 16,
            left: 16,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text(
                  '${_stations.length} ${l10n.chargingStations}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),

          // Legend
          Positioned(
            top: 16,
            right: 16,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _legendItem(Colors.purple, '150+ kW'),
                    _legendItem(Colors.orange, '50-150 kW'),
                    _legendItem(Colors.blue, '22-50 kW'),
                    _legendItem(Colors.green, '< 22 kW'),
                  ],
                ),
              ),
            ),
          ),

          // Selected station details
          if (_selectedStation != null)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: _StationCard(
                station: _selectedStation!,
                onClose: () => setState(() => _selectedStation = null),
              ),
            ),

          // Reload button
          Positioned(
            bottom: _selectedStation != null ? 180 : 16,
            right: 16,
            child: FloatingActionButton(
              mini: true,
              onPressed: _loadStations,
              child: const Icon(Icons.refresh),
            ),
          ),

          // Center on location button
          Positioned(
            bottom: _selectedStation != null ? 230 : 66,
            right: 16,
            child: FloatingActionButton(
              mini: true,
              onPressed: _centerOnLocation,
              child: const Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }

  Widget _legendItem(Color color, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.ev_station, color: color, size: 16),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Future<void> _centerOnLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 10),
        ),
      );
      final newCenter = LatLng(position.latitude, position.longitude);
      _mapController.move(newCenter, 14);
      _center = newCenter;
      await _loadStations();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location error: $e')),
        );
      }
    }
  }
}

class _StationCard extends StatelessWidget {
  final ChargingStation station;
  final VoidCallback onClose;

  const _StationCard({required this.station, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  Icons.ev_station,
                  color: Theme.of(context).primaryColor,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        station.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (station.operator != null)
                        Text(
                          station.operator!,
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 14,
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onClose,
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (station.address != null)
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      station.address!,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 8),
            Row(
              children: [
                if (station.numPoints != null) ...[
                  const Icon(Icons.power, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text('${station.numPoints} connectors'),
                  const SizedBox(width: 16),
                ],
                if (station.maxPowerKW != null) ...[
                  const Icon(Icons.bolt, size: 16, color: Colors.orange),
                  const SizedBox(width: 4),
                  Text('${station.maxPowerKW!.toStringAsFixed(0)} kW'),
                ],
              ],
            ),
            if (station.connectionTypes.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: station.connectionTypes.map((type) {
                  return Chip(
                    label: Text(type, style: const TextStyle(fontSize: 11)),
                    padding: EdgeInsets.zero,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class ChargingStation {
  final int id;
  final String title;
  final double latitude;
  final double longitude;
  final String? operator;
  final String? address;
  final int? numPoints;
  final double? maxPowerKW;
  final List<String> connectionTypes;

  ChargingStation({
    required this.id,
    required this.title,
    required this.latitude,
    required this.longitude,
    this.operator,
    this.address,
    this.numPoints,
    this.maxPowerKW,
    this.connectionTypes = const [],
  });

  factory ChargingStation.fromJson(Map<String, dynamic> json) {
    final addressInfo = json['AddressInfo'] as Map<String, dynamic>?;
    final operatorInfo = json['OperatorInfo'] as Map<String, dynamic>?;
    final connections = json['Connections'] as List<dynamic>? ?? [];

    // Extract connection types and max power
    final types = <String>{};
    double? maxPower;
    for (final conn in connections) {
      final connType = conn['ConnectionType'] as Map<String, dynamic>?;
      if (connType != null) {
        final title = connType['Title'] as String?;
        if (title != null) types.add(title);
      }
      final power = conn['PowerKW'];
      if (power != null) {
        final powerVal = (power is int) ? power.toDouble() : power as double;
        if (maxPower == null || powerVal > maxPower) {
          maxPower = powerVal;
        }
      }
    }

    // Build address string
    String? address;
    if (addressInfo != null) {
      final parts = <String>[];
      final addressLine1 = addressInfo['AddressLine1'] as String?;
      final town = addressInfo['Town'] as String?;
      if (addressLine1 != null) {
        parts.add(addressLine1);
      }
      if (town != null) {
        parts.add(town);
      }
      if (parts.isNotEmpty) {
        address = parts.join(', ');
      }
    }

    return ChargingStation(
      id: json['ID'] as int,
      title: addressInfo?['Title'] as String? ?? 'Charging Station',
      latitude: (addressInfo?['Latitude'] as num).toDouble(),
      longitude: (addressInfo?['Longitude'] as num).toDouble(),
      operator: operatorInfo?['Title'] as String?,
      address: address,
      numPoints: json['NumberOfPoints'] as int?,
      maxPowerKW: maxPower,
      connectionTypes: types.toList(),
    );
  }
}
