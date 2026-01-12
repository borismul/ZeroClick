// Car selector dropdown widget

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/generated/app_localizations.dart';
import '../providers/app_provider.dart';
import '../screens/cars_screen.dart';
import '../utils/color_utils.dart';

class CarSelector extends StatelessWidget {
  const CarSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final cars = provider.cars;
        final selectedCar = provider.selectedCar;

        if (cars.isEmpty) {
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: const Icon(Icons.add_circle_outline, color: Colors.blue),
              title: Text(l10n.addFirstCar),
              subtitle: Text(l10n.toTrackPerCar),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (context) => const CarsScreen()),
                );
              },
            ),
          );
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[700]!),
                  ),
                  child: DropdownButton<String>(
                    value: selectedCar?.id,
                    isExpanded: true,
                    underline: const SizedBox(),
                    hint: Row(
                      children: [
                        const Icon(Icons.directions_car, size: 20),
                        const SizedBox(width: 8),
                        Text(l10n.selectCar),
                      ],
                    ),
                    items: cars.map((car) => DropdownMenuItem<String>(
                      value: car.id,
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: parseHexColor(car.color),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Icon(Icons.directions_car, size: 12, color: Colors.white),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              car.name,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (car.isDefault)
                            Container(
                              margin: const EdgeInsets.only(left: 4),
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                              decoration: BoxDecoration(
                                color: Colors.blue.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                l10n.defaultBadge,
                                style: const TextStyle(color: Colors.blue, fontSize: 9),
                              ),
                            ),
                        ],
                      ),
                    )).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        final car = cars.firstWhere((c) => c.id == value);
                        provider.selectCar(car);
                      }
                    },
                    selectedItemBuilder: (context) {
                      return cars.map((car) => Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: parseHexColor(car.color),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Icon(Icons.directions_car, size: 12, color: Colors.white),
                          ),
                          const SizedBox(width: 8),
                          Text(car.name),
                        ],
                      )).toList();
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.settings),
                tooltip: l10n.manageCars,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (context) => const CarsScreen()),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
