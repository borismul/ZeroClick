// Trip map screen with GPS pins (free OpenStreetMap)

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import '../models/trip.dart';

class TripMapScreen extends StatefulWidget {
  final Trip trip;

  const TripMapScreen({super.key, required this.trip});

  @override
  State<TripMapScreen> createState() => _TripMapScreenState();
}

class _TripMapScreenState extends State<TripMapScreen> {
  List<LatLng>? _actualRoute;    // Actual driven route (snapped to roads)
  List<LatLng>? _expectedRoute;  // Expected shortest route (start to end only)
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadRoutes();
  }

  Future<void> _loadRoutes() async {
    await Future.wait([
      _loadActualRoute(),
      _loadExpectedRoute(),
    ]);
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _loadExpectedRoute() async {
    // Expected route: shortest path from start to end only
    final fromLat = widget.trip.fromLat ?? widget.trip.gpsTrail?.first.lat;
    final fromLng = widget.trip.fromLon ?? widget.trip.gpsTrail?.first.lng;
    final toLat = widget.trip.toLat ?? widget.trip.gpsTrail?.last.lat;
    final toLng = widget.trip.toLon ?? widget.trip.gpsTrail?.last.lng;

    if (fromLat == null || fromLng == null || toLat == null || toLng == null) return;

    try {
      final url = 'https://router.project-osrm.org/route/v1/driving/$fromLng,$fromLat;$toLng,$toLat'
          '?overview=full&geometries=geojson';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['code'] == 'Ok' && data['routes'] != null && data['routes'].isNotEmpty) {
          final geometry = data['routes'][0]['geometry'];
          final coordinates = geometry['coordinates'] as List;
          _expectedRoute = coordinates
              .map((c) => LatLng(c[1].toDouble(), c[0].toDouble()))
              .toList();
          debugPrint('Expected route: ${_expectedRoute!.length} points');
        }
      }
    } catch (e) {
      debugPrint('Expected route error: $e');
    }
  }

  Future<void> _loadActualRoute() async {
    final gpsTrail = widget.trip.gpsTrail;
    if (gpsTrail == null || gpsTrail.length < 2) return;

    try {
      // Sample waypoints (OSRM has URL length limits)
      List<GpsPoint> waypoints = gpsTrail;
      if (gpsTrail.length > 25) {
        waypoints = [gpsTrail.first];
        final step = (gpsTrail.length - 2) / 22;
        for (int i = 1; i < 23; i++) {
          waypoints.add(gpsTrail[(i * step).floor()]);
        }
        waypoints.add(gpsTrail.last);
      }

      // Build coordinates string for OSRM route API (lng,lat format)
      final coords = waypoints.map((p) => '${p.lng},${p.lat}').join(';');
      final url = 'https://router.project-osrm.org/route/v1/driving/$coords'
          '?overview=full&geometries=geojson';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['code'] == 'Ok' && data['routes'] != null && data['routes'].isNotEmpty) {
          final geometry = data['routes'][0]['geometry'];
          final coordinates = geometry['coordinates'] as List;
          final routePoints = coordinates
              .map((c) => LatLng(c[1].toDouble(), c[0].toDouble()))
              .toList();

          final firstGps = LatLng(gpsTrail.first.lat, gpsTrail.first.lng);
          final lastGps = LatLng(gpsTrail.last.lat, gpsTrail.last.lng);
          _actualRoute = [firstGps, ...routePoints, lastGps];
          debugPrint('Actual route: ${_actualRoute!.length} points');
        }
      }
    } catch (e) {
      debugPrint('Actual route error: $e');
    }
  }

  Trip get trip => widget.trip;

  List<Marker> _buildMarkers() {
    final markers = <Marker>[];
    final gpsTrail = trip.gpsTrail;

    if (gpsTrail != null && gpsTrail.isNotEmpty) {
      for (int i = 0; i < gpsTrail.length; i++) {
        final point = gpsTrail[i];
        final isFirst = i == 0;
        final isLast = i == gpsTrail.length - 1;

        markers.add(
          Marker(
            point: LatLng(point.lat, point.lng),
            width: isFirst || isLast ? 40 : 12,
            height: isFirst || isLast ? 40 : 12,
            child: isFirst || isLast
                ? Icon(
                    Icons.location_pin,
                    color: isFirst ? Colors.green : Colors.red,
                    size: 40,
                  )
                : Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
          ),
        );
      }
    } else {
      // Fallback to start/end coordinates
      if (trip.fromLat != null && trip.fromLon != null) {
        markers.add(
          Marker(
            point: LatLng(trip.fromLat!, trip.fromLon!),
            width: 40,
            height: 40,
            child: const Icon(Icons.location_pin, color: Colors.green, size: 40),
          ),
        );
      }
      if (trip.toLat != null && trip.toLon != null) {
        markers.add(
          Marker(
            point: LatLng(trip.toLat!, trip.toLon!),
            width: 40,
            height: 40,
            child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
          ),
        );
      }
    }

    return markers;
  }

  LatLng _getCenter() {
    final gpsTrail = trip.gpsTrail;
    if (gpsTrail != null && gpsTrail.isNotEmpty) {
      double sumLat = 0, sumLng = 0;
      for (final point in gpsTrail) {
        sumLat += point.lat;
        sumLng += point.lng;
      }
      return LatLng(sumLat / gpsTrail.length, sumLng / gpsTrail.length);
    }
    if (trip.fromLat != null && trip.toLat != null) {
      return LatLng(
        (trip.fromLat! + trip.toLat!) / 2,
        (trip.fromLon! + trip.toLon!) / 2,
      );
    }
    return const LatLng(52.0, 4.4);
  }

  LatLngBounds _getBounds() {
    final gpsTrail = trip.gpsTrail;
    double minLat = 90, maxLat = -90, minLng = 180, maxLng = -180;

    if (gpsTrail != null && gpsTrail.isNotEmpty) {
      for (final point in gpsTrail) {
        if (point.lat < minLat) minLat = point.lat;
        if (point.lat > maxLat) maxLat = point.lat;
        if (point.lng < minLng) minLng = point.lng;
        if (point.lng > maxLng) maxLng = point.lng;
      }
    } else {
      if (trip.fromLat != null) {
        minLat = trip.fromLat!;
        maxLat = trip.fromLat!;
        minLng = trip.fromLon!;
        maxLng = trip.fromLon!;
      }
      if (trip.toLat != null) {
        if (trip.toLat! < minLat) minLat = trip.toLat!;
        if (trip.toLat! > maxLat) maxLat = trip.toLat!;
        if (trip.toLon! < minLng) minLng = trip.toLon!;
        if (trip.toLon! > maxLng) maxLng = trip.toLon!;
      }
    }

    // Fallback if no GPS data at all
    if (minLat == 90 || maxLat == -90) {
      return LatLngBounds(
        const LatLng(51.9, 4.3),
        const LatLng(52.1, 4.5),
      );
    }

    // Ensure minimum bounds size to prevent hang with single point or very close points
    final latDiff = maxLat - minLat;
    final lngDiff = maxLng - minLng;
    final latPadding = latDiff < 0.001 ? 0.005 : latDiff * 0.15;
    final lngPadding = lngDiff < 0.001 ? 0.005 : lngDiff * 0.15;

    return LatLngBounds(
      LatLng(minLat - latPadding, minLng - lngPadding),
      LatLng(maxLat + latPadding, maxLng + lngPadding),
    );
  }

  List<LatLng> _buildRawPolyline() {
    final gpsTrail = trip.gpsTrail;
    if (gpsTrail == null || gpsTrail.isEmpty) return [];
    return gpsTrail.map((p) => LatLng(p.lat, p.lng)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final actualRoute = _actualRoute ?? _buildRawPolyline();

    return Scaffold(
      appBar: AppBar(
        title: Text('${trip.fromAddress} → ${trip.toAddress}'),
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: _getCenter(),
              initialZoom: 12,
              initialCameraFit: CameraFit.bounds(
                bounds: _getBounds(),
                padding: const EdgeInsets.all(50),
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'nl.borism.mileageTracker',
              ),
              // Expected route (orange, underneath)
              if (_expectedRoute != null && _expectedRoute!.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _expectedRoute!,
                      color: Colors.orange,
                      strokeWidth: 6,
                    ),
                  ],
                ),
              // Actual route (blue, on top)
              if (actualRoute.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: actualRoute,
                      color: Colors.blue,
                      strokeWidth: 4,
                    ),
                  ],
                ),
              // GPS dots
              MarkerLayer(markers: _buildMarkers()),
            ],
          ),
          // Legend
          Positioned(
            bottom: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(width: 20, height: 4, color: Colors.orange),
                      const SizedBox(width: 8),
                      Text('Verwacht (${trip.googleMapsKm?.toStringAsFixed(1) ?? "?"} km)',
                          style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(width: 20, height: 4, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text('Gereden (${trip.distanceKm.toStringAsFixed(1)} km)',
                          style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Loading indicator
          if (_loading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
