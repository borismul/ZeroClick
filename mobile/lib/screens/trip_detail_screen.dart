// Trip detail screen

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/trip.dart';
import '../providers/app_provider.dart';
import 'trip_edit_screen.dart';

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

  @override
  Widget build(BuildContext context) {
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
                  const Text(
                    'Route',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                            const Text('Van', style: TextStyle(color: Colors.grey, fontSize: 12)),
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
                            const Text('Naar', style: TextStyle(color: Colors.grey, fontSize: 12)),
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
                  const Text(
                    'Details',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _detailRow('Datum', _trip.date),
                  _detailRow('Tijd', '${_trip.startTime} - ${_trip.endTime}'),
                  _detailRow('Afstand', '${_trip.distanceKm.toStringAsFixed(1)} km'),
                  _detailRow('Type', _trip.tripTypeLabel),
                  if (_trip.businessKm > 0)
                    _detailRow('Zakelijk', '${_trip.businessKm.toStringAsFixed(1)} km'),
                  if (_trip.privateKm > 0)
                    _detailRow('Privé', '${_trip.privateKm.toStringAsFixed(1)} km'),
                  if (_trip.googleMapsKm != null)
                    _detailRow('Google Maps', '${_trip.googleMapsKm!.toStringAsFixed(1)} km'),
                  if (_trip.routeDeviationPercent != null && _trip.routeDeviationPercent! > 0)
                    _detailRow('Route afwijking', '${_trip.routeDeviationPercent!.toStringAsFixed(1)}%'),
                  if (_trip.carId != null)
                    _detailRow('Auto', _getCarName(provider)),
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
                _trip.tripTypeLabel,
                style: TextStyle(
                  color: _getTripTypeColor(_trip.tripType),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),

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
                      'Route is ${_trip.routeDeviationPercent!.toStringAsFixed(0)}% langer dan verwacht via Google Maps',
                      style: const TextStyle(color: Colors.orange),
                    ),
                  ),
                ],
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
