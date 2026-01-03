// Dialog to link an unknown Bluetooth device to a car

import 'package:flutter/material.dart';
import '../models/car.dart';
import '../providers/app_provider.dart';
import 'package:provider/provider.dart';

class DeviceLinkDialog extends StatelessWidget {
  final String deviceName;

  const DeviceLinkDialog({super.key, required this.deviceName});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final cars = provider.cars;

        return AlertDialog(
          title: const Text('Onbekend apparaat'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Apparaat: $deviceName',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              const Text('Koppel aan auto:'),
              const SizedBox(height: 8),
              if (cars.isEmpty)
                const Text(
                  'Geen auto\'s gevonden. Voeg eerst een auto toe.',
                  style: TextStyle(color: Colors.grey),
                )
              else
                ...cars.map((car) => _CarOption(
                      car: car,
                      onTap: () => _linkAndStart(context, provider, car),
                    )),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                provider.clearPendingUnknownDevice();
                Navigator.of(context).pop();
              },
              child: const Text('Annuleren'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _linkAndStart(
    BuildContext context,
    AppProvider provider,
    Car car,
  ) async {
    Navigator.of(context).pop();

    final success = await provider.linkDeviceAndStartTrip(deviceName, car);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? '${car.name} gekoppeld aan $deviceName - Rit gestart!'
                : 'Fout bij koppelen: ${provider.error}',
          ),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    }
  }
}

class _CarOption extends StatelessWidget {
  final Car car;
  final VoidCallback onTap;

  const _CarOption({required this.car, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: _parseColor(car.color),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.directions_car, color: Colors.white),
      ),
      title: Text(car.name),
      subtitle: Text(car.brandLabel),
      trailing: const Icon(Icons.link),
      onTap: onTap,
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

/// Show the device link dialog
void showDeviceLinkDialog(BuildContext context, String deviceName) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => DeviceLinkDialog(deviceName: deviceName),
  );
}
