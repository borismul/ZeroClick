// Trip control buttons - Start/Stop

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class TripControls extends StatefulWidget {
  const TripControls({super.key});

  @override
  State<TripControls> createState() => _TripControlsState();
}

class _TripControlsState extends State<TripControls> {
  bool _isLoading = false;

  Future<void> _handleAction(Future<bool> Function() action) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);
    try {
      await action();
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final isActive = provider.activeTrip?.active == true;
        final isTracking = provider.isTrackingLocation;

        return Column(
          children: [
            // Loading indicator on top
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: CircularProgressIndicator(),
              ),

            // Main action button - simple toggle
            if (!isActive && !_isLoading)
              SizedBox(
                width: double.infinity,
                child: _ActionButton(
                  onPressed: () => _handleAction(provider.startTrip),
                  icon: Icons.play_arrow,
                  label: 'Start Rit',
                  color: Colors.green,
                ),
              )
            else if (isActive && !_isLoading)
              Column(
                children: [
                  // Show tracking status
                  if (isTracking)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.gps_fixed, color: Colors.green, size: 16),
                          SizedBox(width: 8),
                          Text(
                            'GPS actief - automatische tracking',
                            style: TextStyle(color: Colors.green, fontSize: 13),
                          ),
                        ],
                      ),
                    ),

                  // Stop button + Cancel
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: _ActionButton(
                          onPressed: () => _handleAction(provider.endTrip),
                          icon: Icons.stop,
                          label: 'Stop Rit',
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ActionButton(
                          onPressed: () => _handleAction(provider.cancelTrip),
                          icon: Icons.close,
                          label: 'Annuleer',
                          color: Colors.grey,
                          small: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        );
      },
    );
  }
}

class _ActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String label;
  final Color color;
  final bool small;

  const _ActionButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.color,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: small ? 16 : 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: small ? 24 : 36,
                color: color,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: small ? 12 : 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
