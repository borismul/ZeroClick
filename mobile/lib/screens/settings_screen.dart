// Settings screen

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import '../providers/app_provider.dart';
import '../models/settings.dart';
import '../services/auth_service.dart';
import 'cars_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _carBrandController;
  late TextEditingController _carUsernameController;
  late TextEditingController _carPasswordController;
  late TextEditingController _carCountryController;

  final AuthService _authService = AuthService();
  bool _isValidating = false;
  String? _validationResult;

  @override
  void initState() {
    super.initState();
    final settings = context.read<AppProvider>().settings;
    _carBrandController = TextEditingController(text: settings.carBrand);
    _carUsernameController = TextEditingController(text: settings.carUsername);
    _carPasswordController = TextEditingController();
    _carCountryController = TextEditingController(text: settings.carCountry);

    _initAuth();
  }

  Future<void> _initAuth() async {
    await _authService.init();
    if (_authService.isSignedIn) {
      final provider = context.read<AppProvider>();
      if (provider.settings.userEmail != _authService.userEmail) {
        provider.saveSettings(provider.settings.copyWith(
          userEmail: _authService.userEmail,
        ));
      }
    }
    setState(() {});
  }

  @override
  void dispose() {
    _carBrandController.dispose();
    _carUsernameController.dispose();
    _carPasswordController.dispose();
    _carCountryController.dispose();
    super.dispose();
  }

  Future<void> _signInWithGoogle() async {
    final success = await _authService.signIn();
    if (success && mounted) {
      final email = _authService.userEmail;
      final provider = context.read<AppProvider>();
      await provider.saveSettings(provider.settings.copyWith(
        userEmail: email ?? '',
      ));
      setState(() {});

      // Refresh all data with new user email
      provider.refreshAll();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ingelogd als ${email ?? "onbekend"}'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _signOut() async {
    await _authService.signOut();
    if (mounted) {
      final provider = context.read<AppProvider>();
      provider.saveSettings(provider.settings.copyWith(
        userEmail: '',
      ));
      setState(() {});
    }
  }

  void _saveCarSettings() {
    final provider = context.read<AppProvider>();

    provider.saveSettings(AppSettings(
      apiUrl: provider.settings.apiUrl,
      userEmail: provider.settings.userEmail,
      autoDetectCar: provider.settings.autoDetectCar,
      gpsPingIntervalSeconds: provider.settings.gpsPingIntervalSeconds,
      carBrand: _carBrandController.text.trim(),
      carUsername: _carUsernameController.text.trim(),
      carPassword: _carPasswordController.text.isNotEmpty
          ? _carPasswordController.text
          : provider.settings.carPassword,
      carCountry: _carCountryController.text.trim(),
    ));

    // Save car settings to API
    _saveCarSettingsToApi();
  }

  Future<void> _saveCarSettingsToApi() async {
    // Clear any existing snackbars
    ScaffoldMessenger.of(context).clearSnackBars();

    final provider = context.read<AppProvider>();

    try {
      await provider.saveCarSettings(
        brand: _carBrandController.text.trim(),
        username: _carUsernameController.text.trim(),
        password: _carPasswordController.text.isNotEmpty
            ? _carPasswordController.text
            : null,
        country: _carCountryController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Auto instellingen opgeslagen'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fout bij opslaan: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _validateCarApi() async {
    final provider = context.read<AppProvider>();

    // Get password - use entered value or fall back to saved
    final password = _carPasswordController.text.isNotEmpty
        ? _carPasswordController.text
        : provider.settings.carPassword;

    if (_carUsernameController.text.trim().isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vul gebruikersnaam en wachtwoord in'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isValidating = true;
      _validationResult = null;
    });

    // Clear any existing snackbars
    ScaffoldMessenger.of(context).clearSnackBars();

    try {
      // Test with current field values (not saved)
      final result = await provider.testCarApi(
        brand: _carBrandController.text.trim(),
        username: _carUsernameController.text.trim(),
        password: password,
        country: _carCountryController.text.trim(),
      );

      setState(() {
        _validationResult = 'success';
      });

      if (mounted) {
        final odometer = result['odometer_km'];
        final battery = result['battery_level'];
        String message = 'API OK!';
        if (odometer != null) {
          message += ' ${(odometer as num).toStringAsFixed(0)} km';
        }
        if (battery != null) {
          message += ' ${battery}%';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _validationResult = 'error';
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$e'.replaceAll('Exception: ', '')),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      setState(() {
        _isValidating = false;
      });
    }
  }

  Future<bool> _requestLocationPermission() async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Zet eerst Locatieservices aan in iOS Instellingen'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return false;
    }

    // Request permission
    var status = await Permission.locationWhenInUse.request();
    return status.isGranted;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Google Sign-In section
            const Text(
              'Account',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            if (_authService.isSignedIn) ...[
              Card(
                child: ListTile(
                  leading: const Icon(Icons.account_circle, color: Colors.green),
                  title: Text(_authService.userEmail ?? 'Ingelogd'),
                  subtitle: const Text('Google account'),
                  trailing: TextButton(
                    onPressed: _signOut,
                    child: const Text('Uitloggen'),
                  ),
                ),
              ),
            ] else ...[
              ElevatedButton.icon(
                onPressed: _signInWithGoogle,
                icon: const Icon(Icons.login),
                label: const Text('Inloggen met Google'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                ),
              ),
            ],

            const SizedBox(height: 24),

            // My Cars section
            const Text(
              "Mijn Auto's",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.directions_car),
                title: Text("${provider.cars.length} auto${provider.cars.length == 1 ? '' : "'s"}"),
                subtitle: const Text("Beheer je voertuigen"),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const CarsScreen()),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // Location Permission
            const Text(
              'Locatie',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: () async {
                final granted = await _requestLocationPermission();
                if (mounted) {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(granted
                        ? 'Locatiepermissie toegestaan!'
                        : 'Locatiepermissie geweigerd - ga naar Instellingen'),
                      backgroundColor: granted ? Colors.green : Colors.red,
                    ),
                  );
                }
              },
              icon: const Icon(Icons.location_on),
              label: const Text('Vraag Locatie Permissie'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),

            const SizedBox(height: 8),

            TextButton(
              onPressed: () async {
                await openAppSettings();
              },
              child: const Text('Open iOS Instellingen'),
            ),

            const SizedBox(height: 24),

            // CarPlay Configuration
            const Text(
              'CarPlay',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            SwitchListTile(
              title: const Text('Automatische detectie'),
              subtitle: const Text('Start/stop ritten automatisch bij CarPlay verbinding'),
              value: provider.settings.autoDetectCar,
              onChanged: (value) {
                provider.saveSettings(provider.settings.copyWith(
                  autoDetectCar: value,
                ));
              },
            ),

            // CarPlay status
            if (provider.isCarPlayConnected)
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.car_rental, color: Colors.blue),
                    SizedBox(width: 8),
                    Text(
                      'CarPlay is verbonden',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 24),

            // Queue status
            if (provider.queueLength > 0) ...[
              const Divider(),
              const SizedBox(height: 16),
              const Text(
                'Wachtrij',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: const Icon(Icons.pending_actions, color: Colors.orange),
                title: Text('${provider.queueLength} items in wachtrij'),
                subtitle: const Text('Worden verzonden zodra online'),
                trailing: TextButton(
                  onPressed: provider.processQueue,
                  child: const Text('Nu verzenden'),
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Info section
            const Divider(),
            const SizedBox(height: 16),

            Card(
              color: Colors.blue.withValues(alpha: 0.1),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue),
                        SizedBox(width: 8),
                        Text(
                          'Over deze app',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Deze app vervangt de iPhone Opdrachten automatisering. '
                      'Ritten starten/stoppen automatisch bij CarPlay verbinding, '
                      'of gebruik de knoppen op het dashboard.',
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
