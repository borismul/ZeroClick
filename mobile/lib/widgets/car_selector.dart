// Car selector dropdown widget

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/car.dart';
import '../screens/cars_screen.dart';

class CarSelector extends StatelessWidget {
  const CarSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final cars = provider.cars;
        final selectedCar = provider.selectedCar;

        if (cars.isEmpty) {
          // No cars - prompt to add one
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: const Icon(Icons.add_circle_outline, color: Colors.blue),
              title: const Text('Voeg je eerste auto toe'),
              subtitle: const Text('Om ritten per auto te volgen'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const CarsScreen()),
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
                    hint: const Row(
                      children: [
                        Icon(Icons.directions_car, size: 20),
                        SizedBox(width: 8),
                        Text("Selecteer auto"),
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
                              color: _parseColor(car.color),
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
                              child: const Text(
                                'Standaard',
                                style: TextStyle(color: Colors.blue, fontSize: 9),
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
                              color: _parseColor(car.color),
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
                tooltip: "Auto's beheren",
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const CarsScreen()),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Color _parseColor(String hex) {
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (e) {
      return Colors.blue;
    }
  }
}

/// Compact car selector for use in headers
class CarSelectorCompact extends StatelessWidget {
  const CarSelectorCompact({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final cars = provider.cars;
        final selectedCar = provider.selectedCar;

        if (cars.isEmpty) {
          return const SizedBox.shrink();
        }

        return PopupMenuButton<String>(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: selectedCar != null
                  ? _parseColor(selectedCar.color).withValues(alpha: 0.2)
                  : Colors.grey[800],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (selectedCar != null) ...[
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: _parseColor(selectedCar.color),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    selectedCar.name,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ] else ...[
                  const Icon(Icons.directions_car, size: 16),
                  const SizedBox(width: 8),
                  const Text(
                    "Selecteer auto",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
                const SizedBox(width: 4),
                const Icon(Icons.arrow_drop_down, size: 20),
              ],
            ),
          ),
          itemBuilder: (context) => cars.map((car) => PopupMenuItem<String>(
            value: car.id,
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: _parseColor(car.color),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(Icons.directions_car, size: 12, color: Colors.white),
                ),
                const SizedBox(width: 8),
                Expanded(child: Text(car.name)),
                if (selectedCar?.id == car.id)
                  const Icon(Icons.check, size: 16, color: Colors.blue),
              ],
            ),
          )).toList(),
          onSelected: (value) {
            final car = cars.firstWhere((c) => c.id == value);
            provider.selectCar(car);
          },
        );
      },
    );
  }

  Color _parseColor(String hex) {
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (e) {
      return Colors.blue;
    }
  }
}
