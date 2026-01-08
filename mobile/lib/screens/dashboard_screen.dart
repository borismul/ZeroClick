// Dashboard screen - main screen with trip controls

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/generated/app_localizations.dart';
import '../providers/app_provider.dart';
import '../widgets/trip_controls.dart';
import '../widgets/active_trip_banner.dart';
import '../widgets/stats_cards.dart';
import '../widgets/car_status_card.dart';
import '../widgets/car_selector.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Refresh once on start
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<AppProvider>();
      if (provider.isConfigured) {
        provider.refreshAll();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        if (!provider.isConfigured) {
          return _buildSetupPrompt(context, provider, l10n);
        }

        // Show loading spinner on initial load
        if (provider.isLoading && provider.trips.isEmpty && provider.stats == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return RefreshIndicator(
          onRefresh: provider.refreshAll,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // CarPlay status
              if (provider.isCarPlayConnected)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.withValues(alpha: 0.5)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.car_rental, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        l10n.carPlayConnected,
                        style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),

              // Connection status
              if (!provider.isOnline)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.wifi_off, color: Colors.orange),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l10n.offlineWarning,
                          style: const TextStyle(color: Colors.orange),
                        ),
                      ),
                      if (provider.queueLength > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${provider.queueLength}',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],
                  ),
                ),

              // Error message
              if (provider.error != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          provider.error!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: provider.clearError,
                      ),
                    ],
                  ),
                ),

              // Active trip banner
              if (provider.activeTrip?.active == true)
                ActiveTripBanner(activeTrip: provider.activeTrip!),

              const SizedBox(height: 16),

              // Trip controls
              const TripControls(),

              const SizedBox(height: 24),

              // Car selector (only show if we have cars)
              if (provider.cars.isNotEmpty)
                const CarSelector(),

              // Car status
              if (provider.isLoadingCarData)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                )
              else if (provider.carData != null)
                CarStatusCard(carData: provider.carData!),

              const SizedBox(height: 24),

              // Stats
              if (provider.isLoadingStats)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                )
              else if (provider.stats != null)
                const StatsCards(),

              const SizedBox(height: 24),

              // Recent trips
              if (provider.isLoadingTrips)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                )
              else
                _buildRecentTrips(provider, l10n),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSetupPrompt(BuildContext context, AppProvider provider, AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.account_circle, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              l10n.loginPrompt,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.loginSubtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                provider.navigateTo(2);
              },
              icon: const Icon(Icons.arrow_forward),
              label: Text(l10n.goToSettings),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTrips(AppProvider provider, AppLocalizations l10n) {
    final recentTrips = provider.trips.take(5).toList();

    if (recentTrips.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.recentTrips,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...recentTrips.map((trip) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text('${trip.fromAddress} → ${trip.toAddress}'),
                subtitle: Text(trip.date),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${trip.distanceKm} ${l10n.km}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: trip.tripType == 'B'
                            ? Colors.blue.withValues(alpha: 0.2)
                            : trip.tripType == 'P'
                                ? Colors.orange.withValues(alpha: 0.2)
                                : Colors.purple.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        trip.getTripTypeLabel(l10n),
                        style: TextStyle(
                          fontSize: 12,
                          color: trip.tripType == 'B'
                              ? Colors.blue
                              : trip.tripType == 'P'
                                  ? Colors.orange
                                  : Colors.purple,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }
}
