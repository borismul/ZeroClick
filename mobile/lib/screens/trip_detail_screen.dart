// Trip detail screen

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/generated/app_localizations.dart';
import '../models/trip.dart';
import '../providers/app_provider.dart';
import 'trip_edit_screen.dart';
import 'trip_map_screen.dart';

class TripDetailScreen extends StatefulWidget {
  final Trip trip;

  const TripDetailScreen({super.key, required this.trip});

  @override
  State<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> {
  late Trip _trip;

  @override
  void initState() {
    super.initState();
    _trip = widget.trip;
  }

  String _getCarName(AppProvider provider) {
    if (_trip.carId == null) return '-';
    final car = provider.cars.where((c) => c.id == _trip.carId).firstOrNull;
    return car?.name ?? _trip.carId!;
  }

  Future<void> _openEditScreen() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => TripEditScreen(trip: _trip),
      ),
    );
    if (result == true && mounted) {
      // Trip was updated or deleted, refresh and check if we should pop
      final provider = context.read<AppProvider>();
      final updatedTrip = provider.trips.where((t) => t.id == _trip.id).firstOrNull;
      if (updatedTrip != null) {
        setState(() => _trip = updatedTrip);
      }
    }
  }

  void _openMapWithPins() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TripMapScreen(trip: _trip),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final provider = Provider.of<AppProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(_trip.date),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _openEditScreen,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Route card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.route,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.trip_origin, color: Colors.green, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l10n.from, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                            Text(_trip.fromAddress, style: const TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 9),
                    child: Container(width: 2, height: 30, color: Colors.grey.withValues(alpha: 0.3)),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.red, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l10n.to, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                            Text(_trip.toAddress, style: const TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Details card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.details,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _detailRow(l10n.date, _trip.date),
                  _detailRow(l10n.time, '${_trip.startTime} - ${_trip.endTime}'),
                  _detailRow(l10n.distance, '${_trip.distanceKm.toStringAsFixed(1)} ${l10n.km}'),
                  _detailRow(l10n.type, _trip.getTripTypeLabel(l10n)),
                  if (_trip.businessKm > 0)
                    _detailRow(l10n.business, '${_trip.businessKm.toStringAsFixed(1)} ${l10n.km}'),
                  if (_trip.privateKm > 0)
                    _detailRow(l10n.private, '${_trip.privateKm.toStringAsFixed(1)} ${l10n.km}'),
                  if (_trip.googleMapsKm != null)
                    _detailRow(l10n.googleMaps, '${_trip.googleMapsKm!.toStringAsFixed(1)} ${l10n.km}'),
                  if (_trip.routeDeviationPercent != null && _trip.routeDeviationPercent! > 0)
                    _detailRow(l10n.routeDeviation, '${_trip.routeDeviationPercent!.toStringAsFixed(1)}%'),
                  if (_trip.carId != null)
                    _detailRow(l10n.car, _getCarName(provider)),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Trip type badge
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: _getTripTypeColor(_trip.tripType).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: _getTripTypeColor(_trip.tripType)),
              ),
              child: Text(
                _trip.getTripTypeLabel(l10n),
                style: TextStyle(
                  color: _getTripTypeColor(_trip.tripType),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),

          // Distance estimated warning (car API was unavailable)
          if (_trip.isDistanceEstimated) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.blue),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '${l10n.distanceEstimated} (${_trip.getDistanceSourceLabel(l10n)})',
                      style: const TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Route deviation warning
          if (_trip.routeDeviationPercent != null && _trip.routeDeviationPercent! > 5) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber, color: Colors.orange),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.routeDeviationWarning(_trip.routeDeviationPercent!.toInt()),
                      style: const TextStyle(color: Colors.orange),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // View on map button
          if (_trip.gpsTrail != null && _trip.gpsTrail!.isNotEmpty ||
              (_trip.fromLat != null && _trip.toLat != null)) ...[
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _openMapWithPins,
                icon: const Icon(Icons.map),
                label: Text(l10n.viewOnMap),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[400])),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Color _getTripTypeColor(String type) {
    switch (type) {
      case 'B':
        return Colors.blue;
      case 'P':
        return Colors.orange;
      case 'M':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
