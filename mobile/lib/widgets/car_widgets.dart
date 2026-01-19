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

/// Renault branded login form (username/password via Gigya)
class RenaultLoginForm extends StatelessWidget {
  const RenaultLoginForm({
    required this.usernameController,
    required this.passwordController,
    required this.countryController,
    required this.isLoading,
    required this.isConnected,
    required this.onLogin,
    this.onLogout,
    super.key,
  });

  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController countryController;
  final bool isLoading;
  final bool isConnected;
  final VoidCallback onLogin;
  final VoidCallback? onLogout;

  static const _renaultYellow = Color(0xFFFFCC33);

  @override
  Widget build(BuildContext context) {
    if (isConnected) {
      // Show connected status
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.green.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.green, width: 2),
        ),
        child: Column(
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 56),
            const SizedBox(height: 16),
            const Text(
              'MY Renault verbonden',
              style: TextStyle(
                color: Colors.green,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Je account is succesvol gekoppeld',
              style: TextStyle(color: Colors.grey[400], fontSize: 14),
            ),
            if (onLogout != null) ...[
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: onLogout,
                icon: const Icon(Icons.logout, size: 18),
                label: const Text('Uitloggen'),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
              ),
            ],
          ],
        ),
      );
    }

    // Show branded login form
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _renaultYellow.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _renaultYellow.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: _renaultYellow,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.diamond_outlined, color: Colors.black, size: 32),
          ),
          const SizedBox(height: 16),
          const Text(
            'MY Renault',
            style: TextStyle(
              color: Color(0xFFFFCC33),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Log in met je MY Renault account',
            style: TextStyle(color: Colors.grey[400], fontSize: 13),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          // Form fields
          TextField(
            controller: usernameController,
            decoration: InputDecoration(
              labelText: 'E-mail',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.email),
              filled: true,
              fillColor: Colors.grey[900],
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(
              labelText: 'Wachtwoord',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.lock),
              filled: true,
              fillColor: Colors.grey[900],
            ),
            obscureText: true,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: countryController.text.isEmpty ? 'nl_NL' : countryController.text,
            decoration: InputDecoration(
              labelText: 'Land',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.flag),
              filled: true,
              fillColor: Colors.grey[900],
            ),
            items: const [
              DropdownMenuItem(value: 'nl_NL', child: Text('Nederland')),
              DropdownMenuItem(value: 'be_BE', child: Text('België')),
              DropdownMenuItem(value: 'de_DE', child: Text('Deutschland')),
              DropdownMenuItem(value: 'fr_FR', child: Text('France')),
              DropdownMenuItem(value: 'en_GB', child: Text('United Kingdom')),
              DropdownMenuItem(value: 'es_ES', child: Text('España')),
              DropdownMenuItem(value: 'it_IT', child: Text('Italia')),
              DropdownMenuItem(value: 'pt_PT', child: Text('Portugal')),
            ],
            onChanged: (value) {
              countryController.text = value ?? 'nl_NL';
            },
          ),
          const SizedBox(height: 20),

          // Login button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: isLoading ? null : onLogin,
              icon: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.black,
                      ),
                    )
                  : const Icon(Icons.login),
              label: const Text('Inloggen met Renault ID'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                backgroundColor: _renaultYellow,
                foregroundColor: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// OAuth login card for Tesla/Audi/VW Group - shows connected status or login button
class OAuthLoginCard extends StatelessWidget {
  const OAuthLoginCard({
    required this.brandName,
    required this.brandColor,
    required this.icon,
    required this.description,
    required this.buttonText,
    required this.isLoading,
    required this.isConnected,
    required this.onLogin,
    this.textColor = Colors.white,
    this.onLogout,
    super.key,
  });

  final String brandName;
  final Color brandColor;
  final Color textColor;
  final IconData icon;
  final String description;
  final String buttonText;
  final bool isLoading;
  final bool isConnected;
  final VoidCallback onLogin;
  final VoidCallback? onLogout;

  @override
  Widget build(BuildContext context) {
    if (isConnected) {
      // Show connected status with logout option
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.green.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.green, width: 2),
        ),
        child: Column(
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 56),
            const SizedBox(height: 16),
            Text(
              '$brandName verbonden',
              style: const TextStyle(
                color: Colors.green,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Je account is succesvol gekoppeld',
              style: TextStyle(color: Colors.grey[400], fontSize: 14),
            ),
            if (onLogout != null) ...[
              const SizedBox(height: 20),
              TextButton.icon(
                onPressed: onLogout,
                icon: const Icon(Icons.logout, size: 18),
                label: const Text('Uitloggen'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
              ),
            ],
          ],
        ),
      );
    }

    // Show login card
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: brandColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: brandColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: brandColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: textColor, size: 32),
          ),
          const SizedBox(height: 16),
          Text(
            '$brandName koppelen',
            style: TextStyle(
              color: brandColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(color: Colors.grey[400], fontSize: 13),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: isLoading ? null : onLogin,
              icon: isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: textColor,
                      ),
                    )
                  : const Icon(Icons.login),
              label: Text(buttonText),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                backgroundColor: brandColor,
                foregroundColor: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
