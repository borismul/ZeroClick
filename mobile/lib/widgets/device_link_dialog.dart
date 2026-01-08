// Dialog to link an unknown Bluetooth device to a car

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/generated/app_localizations.dart';
import '../models/car.dart';
import '../providers/app_provider.dart';
import '../utils/color_utils.dart';

class DeviceLinkDialog extends StatelessWidget {
  final String deviceName;

  const DeviceLinkDialog({super.key, required this.deviceName});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final cars = provider.cars;

        return AlertDialog(
          title: Text(l10n.unknownDevice),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.deviceName(deviceName),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              Text(l10n.linkToCar),
              const SizedBox(height: 8),
              if (cars.isEmpty)
                Text(
                  l10n.noCarsFound,
                  style: const TextStyle(color: Colors.grey),
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
              child: Text(l10n.cancel),
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
    final l10n = AppLocalizations.of(context);
    Navigator.of(context).pop();

    final success = await provider.linkDeviceAndStartTrip(deviceName, car);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? l10n.carLinkedSuccess(car.name, deviceName)
                : l10n.linkError(provider.error ?? ''),
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
    final l10n = AppLocalizations.of(context);
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: parseHexColor(car.color),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.directions_car, color: Colors.white),
      ),
      title: Text(car.name),
      subtitle: Text(car.getBrandLabel(l10n)),
      trailing: const Icon(Icons.link),
      onTap: onTap,
    );
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
