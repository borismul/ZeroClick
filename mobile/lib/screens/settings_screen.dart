// Settings screen

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import '../l10n/generated/app_localizations.dart';
import '../providers/app_provider.dart';
import '../services/auth_service.dart';
import 'cars_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
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

  Future<void> _signInWithGoogle() async {
    final l10n = AppLocalizations.of(context);
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
          content: Text(l10n.loggedInAs(email ?? '')),
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

  Future<bool> _requestLocationPermission() async {
    final l10n = AppLocalizations.of(context);
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.enableLocationServices),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return false;
    }

    var status = await Permission.locationWhenInUse.request();
    return status.isGranted;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Google Sign-In section
            Text(
              l10n.account,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            if (_authService.isSignedIn) ...[
              Card(
                child: ListTile(
                  leading: const Icon(Icons.account_circle, color: Colors.green),
                  title: Text(_authService.userEmail ?? l10n.loggedIn),
                  subtitle: Text(l10n.googleAccount),
                  trailing: TextButton(
                    onPressed: _signOut,
                    child: Text(l10n.logout),
                  ),
                ),
              ),
            ] else ...[
              ElevatedButton.icon(
                onPressed: _signInWithGoogle,
                icon: const Icon(Icons.login),
                label: Text(l10n.loginWithGoogle),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Language section
            Text(
              l10n.language,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.language),
                title: Text(_getLanguageName(provider.settings.localeCode, l10n)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showLanguageSelector(context, provider),
              ),
            ),

            const SizedBox(height: 24),

            // My Cars section
            Text(
              l10n.myCars,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.directions_car),
                title: Text(l10n.carsCount(provider.cars.length)),
                subtitle: Text(l10n.manageVehicles),
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
            Text(
              l10n.location,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                        ? l10n.locationPermissionGranted
                        : l10n.locationPermissionDenied),
                      backgroundColor: granted ? Colors.green : Colors.red,
                    ),
                  );
                }
              },
              icon: const Icon(Icons.location_on),
              label: Text(l10n.requestLocationPermission),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),

            const SizedBox(height: 8),

            TextButton(
              onPressed: () async {
                await openAppSettings();
              },
              child: Text(l10n.openIOSSettings),
            ),

            const SizedBox(height: 24),

            // CarPlay Configuration
            Text(
              l10n.carPlay,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            SwitchListTile(
              title: Text(l10n.automaticDetection),
              subtitle: Text(l10n.autoDetectionSubtitle),
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
                child: Row(
                  children: [
                    const Icon(Icons.car_rental, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(
                      l10n.carPlayIsConnected,
                      style: const TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 24),

            // Queue status
            if (provider.queueLength > 0) ...[
              const Divider(),
              const SizedBox(height: 16),
              Text(
                l10n.queue,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: const Icon(Icons.pending_actions, color: Colors.orange),
                title: Text(l10n.queueItems(provider.queueLength)),
                subtitle: Text(l10n.queueSubtitle),
                trailing: TextButton(
                  onPressed: provider.processQueue,
                  child: Text(l10n.sendNow),
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Info section
            const Divider(),
            const SizedBox(height: 16),

            Card(
              color: Colors.blue.withValues(alpha: 0.1),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.info_outline, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(
                          l10n.aboutApp,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.aboutDescription,
                      style: const TextStyle(fontSize: 13),
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

  String _getLanguageName(String? localeCode, AppLocalizations l10n) {
    if (localeCode == null) return l10n.systemDefault;
    switch (localeCode) {
      case 'en': return l10n.languageEnglish;
      case 'nl': return l10n.languageDutch;
      case 'de': return l10n.languageGerman;
      case 'fr': return l10n.languageFrench;
      case 'es': return l10n.languageSpanish;
      case 'pt': return l10n.languagePortuguese;
      case 'it': return l10n.languageItalian;
      case 'pl': return l10n.languagePolish;
      case 'ru': return l10n.languageRussian;
      case 'zh': return l10n.languageChinese;
      case 'ja': return l10n.languageJapanese;
      case 'ko': return l10n.languageKorean;
      case 'ar': return l10n.languageArabic;
      case 'tr': return l10n.languageTurkish;
      case 'hi': return l10n.languageHindi;
      case 'id': return l10n.languageIndonesian;
      case 'th': return l10n.languageThai;
      case 'vi': return l10n.languageVietnamese;
      case 'sv': return l10n.languageSwedish;
      case 'nb': return l10n.languageNorwegian;
      case 'da': return l10n.languageDanish;
      case 'fi': return l10n.languageFinnish;
      case 'cs': return l10n.languageCzech;
      case 'hu': return l10n.languageHungarian;
      case 'uk': return l10n.languageUkrainian;
      case 'el': return l10n.languageGreek;
      case 'ro': return l10n.languageRomanian;
      case 'he': return l10n.languageHebrew;
      default: return localeCode;
    }
  }

  void _showLanguageSelector(BuildContext context, AppProvider provider) {
    final l10n = AppLocalizations.of(context);
    final languages = <MapEntry<String?, String>>[
      MapEntry(null, l10n.systemDefault),
      MapEntry('en', l10n.languageEnglish),
      MapEntry('nl', l10n.languageDutch),
      MapEntry('de', l10n.languageGerman),
      MapEntry('fr', l10n.languageFrench),
      MapEntry('es', l10n.languageSpanish),
      MapEntry('pt', l10n.languagePortuguese),
      MapEntry('it', l10n.languageItalian),
      MapEntry('pl', l10n.languagePolish),
      MapEntry('ru', l10n.languageRussian),
      MapEntry('zh', l10n.languageChinese),
      MapEntry('ja', l10n.languageJapanese),
      MapEntry('ko', l10n.languageKorean),
      MapEntry('ar', l10n.languageArabic),
      MapEntry('tr', l10n.languageTurkish),
      MapEntry('hi', l10n.languageHindi),
      MapEntry('id', l10n.languageIndonesian),
      MapEntry('th', l10n.languageThai),
      MapEntry('vi', l10n.languageVietnamese),
      MapEntry('sv', l10n.languageSwedish),
      MapEntry('nb', l10n.languageNorwegian),
      MapEntry('da', l10n.languageDanish),
      MapEntry('fi', l10n.languageFinnish),
      MapEntry('cs', l10n.languageCzech),
      MapEntry('hu', l10n.languageHungarian),
      MapEntry('uk', l10n.languageUkrainian),
      MapEntry('el', l10n.languageGreek),
      MapEntry('ro', l10n.languageRomanian),
      MapEntry('he', l10n.languageHebrew),
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                l10n.language,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: languages.length,
                itemBuilder: (context, index) {
                  final entry = languages[index];
                  final isSelected = provider.settings.localeCode == entry.key;
                  return ListTile(
                    title: Text(entry.value),
                    trailing: isSelected
                        ? const Icon(Icons.check, color: Colors.blue)
                        : null,
                    onTap: () {
                      if (entry.key == null) {
                        provider.saveSettings(
                          provider.settings.copyWith(clearLocale: true),
                        );
                      } else {
                        provider.saveSettings(
                          provider.settings.copyWith(localeCode: entry.key),
                        );
                      }
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
