// Car status card widget

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/trip.dart';

class CarStatusCard extends StatelessWidget {
  final CarData carData;

  const CarStatusCard({super.key, required this.carData});

  @override
  Widget build(BuildContext context) {
    String fetchedAtStr = '';
    try {
      final dt = DateTime.parse(carData.fetchedAt);
      fetchedAtStr = DateFormat('HH:mm').format(dt.toLocal());
    } catch (_) {}

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  carData.brand.isNotEmpty
                      ? carData.brand[0].toUpperCase() + carData.brand.substring(1)
                      : 'Auto',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (fetchedAtStr.isNotEmpty)
                  Text(
                    'Bijgewerkt: $fetchedAtStr',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 16),

            // Status grid
            Row(
              children: [
                // Battery
                Expanded(
                  child: _StatusItem(
                    icon: carData.isCharging
                        ? Icons.bolt
                        : Icons.battery_full,
                    iconColor: carData.isCharging ? Colors.yellow : Colors.green,
                    label: 'Batterij',
                    value: carData.batteryLevel != null
                        ? '${carData.batteryLevel}%'
                        : '-',
                    subtitle: carData.rangeKm != null
                        ? '${carData.rangeKm} km'
                        : null,
                  ),
                ),

                // Status
                Expanded(
                  child: _StatusItem(
                    icon: _getStateIcon(carData.state),
                    iconColor: _getStateColor(carData.state),
                    label: 'Status',
                    value: carData.stateLabel,
                  ),
                ),

                // Odometer
                if (carData.odometerKm != null)
                  Expanded(
                    child: _StatusItem(
                      icon: Icons.speed,
                      iconColor: Colors.blue,
                      label: 'Km-stand',
                      value: NumberFormat('#,###').format(carData.odometerKm!.toInt()),
                    ),
                  ),
              ],
            ),

            // Charging info
            if (carData.isCharging) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.yellow.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.yellow.withValues(alpha: 0.5)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.bolt, color: Colors.yellow),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Laden: ${carData.chargingPowerKw ?? 0} kW',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          if (carData.chargingRemainingMinutes != null)
                            Text(
                              'Klaar over: ${_formatMinutes(carData.chargingRemainingMinutes!)}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getStateIcon(String? state) {
    switch (state) {
      case 'parked':
        return Icons.local_parking;
      case 'driving':
        return Icons.directions_car;
      case 'charging':
        return Icons.ev_station;
      default:
        return Icons.help_outline;
    }
  }

  Color _getStateColor(String? state) {
    switch (state) {
      case 'parked':
        return Colors.blue;
      case 'driving':
        return Colors.green;
      case 'charging':
        return Colors.yellow;
      default:
        return Colors.grey;
    }
  }

  String _formatMinutes(int minutes) {
    if (minutes < 60) {
      return '$minutes min';
    }
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    return '${hours}u ${mins}m';
  }
}

class _StatusItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String? subtitle;

  const _StatusItem({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: iconColor, size: 28),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        if (subtitle != null)
          Text(
            subtitle!,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
      ],
    );
  }
}
