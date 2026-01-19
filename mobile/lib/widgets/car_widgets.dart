// Reusable car widgets for use across the app

import 'package:flutter/material.dart';
import '../l10n/generated/app_localizations.dart';
import '../models/car.dart';
import '../screens/cars_screen.dart';
import '../utils/color_utils.dart';

/// Card displaying a car with its details, stats, and edit action
class CarCard extends StatelessWidget {
  const CarCard({required this.car, super.key});

  final Car car;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _editCar(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Color indicator
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: parseHexColor(car.color).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getCarIcon(car.icon),
                  color: parseHexColor(car.color),
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              // Car info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          car.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (car.isDefault) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.blue.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              l10n.defaultBadge,
                              style: const TextStyle(color: Colors.blue, fontSize: 11),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      car.getBrandLabel(l10n),
                      style: TextStyle(color: Colors.grey[400], fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        StatChip(
                          icon: Icons.route,
                          value: '${car.totalTrips} ${l10n.trips}',
                        ),
                        const SizedBox(width: 12),
                        StatChip(
                          icon: Icons.straighten,
                          value: '${car.totalKm.toStringAsFixed(0)} ${l10n.km}',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Arrow
              Icon(Icons.chevron_right, color: Colors.grey[600]),
            ],
          ),
        ),
      ),
    );
  }

  void _editCar(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => AddEditCarScreen(car: car),
      ),
    );
  }

  IconData _getCarIcon(String icon) {
    switch (icon) {
      case 'car-suv':
        return Icons.directions_car;
      case 'car-sports':
        return Icons.sports_score;
      case 'car-van':
        return Icons.airport_shuttle;
      case 'car-hatchback':
        return Icons.directions_car_filled;
      default:
        return Icons.directions_car;
    }
  }
}

/// Small chip displaying an icon and value (used for car statistics)
class StatChip extends StatelessWidget {
  const StatChip({required this.icon, required this.value, super.key});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey[500]),
          const SizedBox(width: 4),
          Text(value, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
        ],
      );
}
