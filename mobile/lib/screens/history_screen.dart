// History screen - trip list

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/generated/app_localizations.dart';
import '../providers/app_provider.dart';
import '../models/trip.dart';
import 'trip_detail_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<AppProvider>();
      if (provider.isConfigured) {
        provider.refreshTrips();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        if (!provider.isConfigured) {
          return Center(
            child: Text(l10n.configureFirst),
          );
        }

        if (provider.isLoading && provider.trips.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.trips.isEmpty) {
          return RefreshIndicator(
            onRefresh: provider.refreshTrips,
            child: ListView(
              children: [
                const SizedBox(height: 100),
                Center(
                  child: Column(
                    children: [
                      const Icon(Icons.directions_car_outlined, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(
                        l10n.noTripsYet,
                        style: const TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: provider.refreshTrips,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.trips.length,
            itemBuilder: (context, index) {
              final trip = provider.trips[index];
              return _TripCard(trip: trip);
            },
          ),
        );
      },
    );
  }
}

class _TripCard extends StatelessWidget {
  final Trip trip;

  const _TripCard({required this.trip});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) => TripDetailScreen(trip: trip),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  trip.date,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getTripTypeColor(trip.tripType).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    trip.getTripTypeLabel(l10n),
                    style: TextStyle(
                      color: _getTripTypeColor(trip.tripType),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Route
            Row(
              children: [
                const Icon(Icons.trip_origin, size: 16, color: Colors.green),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    trip.fromAddress,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 7),
              child: Container(
                width: 2,
                height: 20,
                color: Colors.grey.withValues(alpha: 0.3),
              ),
            ),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.red),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    trip.toAddress,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Details row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${trip.startTime} - ${trip.endTime}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
                Row(
                  children: [
                    const Icon(Icons.straighten, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      '${trip.distanceKm.toStringAsFixed(1)} ${l10n.km}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Route deviation warning
            if (trip.routeDeviationPercent != null && trip.routeDeviationPercent! > 5)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber, size: 16, color: Colors.orange),
                    const SizedBox(width: 4),
                    Text(
                      l10n.routeLongerPercent(trip.routeDeviationPercent!.toInt()),
                      style: const TextStyle(color: Colors.orange, fontSize: 12),
                    ),
                  ],
                ),
              ),
          ],
        ),
        ),
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
