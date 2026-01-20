// Banner shown when critical permissions are missing

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../l10n/generated/app_localizations.dart';

/// Banner that shows when critical permissions are not granted.
/// Automatically refreshes on app resume.
class PermissionsBanner extends StatefulWidget {
  const PermissionsBanner({super.key});

  @override
  State<PermissionsBanner> createState() => _PermissionsBannerState();
}

class _PermissionsBannerState extends State<PermissionsBanner>
    with WidgetsBindingObserver {
  List<String> _missingPermissions = [];
  bool _hasChecked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkPermissions();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Re-check permissions when returning from settings
    if (state == AppLifecycleState.resumed) {
      _checkPermissions();
    }
  }

  Future<void> _checkPermissions() async {
    final missing = <String>[];

    // Check location always permission
    final locationAlways = await Permission.locationAlways.status;
    if (!locationAlways.isGranted) {
      missing.add('location');
    }

    // Check motion/sensors permission (iOS only)
    if (Platform.isIOS) {
      final motion = await Permission.sensors.status;
      if (!motion.isGranted) {
        missing.add('motion');
      }
    }

    // Check notifications permission
    final notifications = await Permission.notification.status;
    if (!notifications.isGranted) {
      missing.add('notifications');
    }

    if (mounted) {
      setState(() {
        _missingPermissions = missing;
        _hasChecked = true;
      });
    }
  }

  Future<void> _openSettings() async {
    await openAppSettings();
  }

  @override
  Widget build(BuildContext context) {
    // Don't show until we've checked, and don't show if all permissions granted
    if (!_hasChecked || _missingPermissions.isEmpty) {
      return const SizedBox.shrink();
    }

    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.red),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.permissionsMissingTitle,
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            l10n.permissionsMissingMessage,
            style: TextStyle(
              color: Colors.red.shade700,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          // Show which permissions are missing
          Text(
            _getMissingPermissionsText(l10n),
            style: TextStyle(
              color: Colors.red.shade600,
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _openSettings,
              icon: const Icon(Icons.settings, size: 18),
              label: Text(l10n.permissionsOpenSettings),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getMissingPermissionsText(AppLocalizations l10n) {
    final names = _missingPermissions.map((p) {
      switch (p) {
        case 'location':
          return l10n.permissionLocation;
        case 'motion':
          return l10n.permissionMotion;
        case 'notifications':
          return l10n.permissionNotifications;
        default:
          return p;
      }
    }).toList();

    return '${l10n.permissionsMissing}: ${names.join(', ')}';
  }
}
