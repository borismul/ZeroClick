import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/app_provider.dart';
import 'screens/dashboard_screen.dart';
import 'screens/history_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/trip_edit_screen.dart';
import 'screens/charging_map_screen.dart';
import 'widgets/device_link_dialog.dart';
import 'services/auth_service.dart';
import 'models/settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MileageTrackerApp());
}

/// Convert locale code to Locale object
Locale? parseLocale(String? code) {
  if (code == null || code.isEmpty) return null;
  final parts = code.split('_');
  if (parts.length == 1) {
    return Locale(parts[0]);
  }
  return Locale(parts[0], parts[1]);
}

class MileageTrackerApp extends StatelessWidget {
  const MileageTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppProvider(),
      child: Consumer<AppProvider>(
        builder: (context, provider, child) {
          final locale = parseLocale(provider.settings.localeCode);
          return MaterialApp(
            title: 'Mileage Tracker',
            debugShowCheckedModeBanner: false,
            locale: locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: const Color(0xFF0A0A0A),
          cardTheme: CardThemeData(
            color: const Color(0xFF1A1A1A),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1A1A1A),
            elevation: 0,
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Color(0xFF1A1A1A),
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: const Color(0xFF1A1A1A),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade700),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.blue),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
            home: const MainScreen(),
          );
        },
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _screens = const [
    DashboardScreen(),
    HistoryScreen(),
    ChargingMapScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Set up callback for unknown device detection
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<AppProvider>(context, listen: false);
      provider.onUnknownDevice = (deviceName) {
        if (mounted) {
          showDeviceLinkDialog(context, deviceName);
        }
      };
      // Show first-launch warning
      _showBackgroundWarningIfNeeded();
    });
  }

  Future<void> _showBackgroundWarningIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenWarning = prefs.getBool('has_seen_background_warning') ?? false;

    if (!hasSeenWarning && mounted) {
      final l10n = AppLocalizations.of(context);
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text(l10n.importantTitle),
          content: Text(l10n.backgroundWarningMessage),
          actions: [
            TextButton(
              onPressed: () {
                prefs.setBool('has_seen_background_warning', true);
                Navigator.of(context).pop();
              },
              child: Text(l10n.understood),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.appTitle),
            actions: [
              if (provider.queueLength > 0)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: IconButton(
                    onPressed: provider.processQueue,
                    icon: Badge(
                      label: Text('${provider.queueLength}'),
                      child: Icon(
                        provider.isOnline ? Icons.sync : Icons.sync_disabled,
                        color: provider.isOnline ? Colors.orange : Colors.grey,
                      ),
                    ),
                  ),
                ),
              // Always show logout option
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) async {
                  if (value == 'logout') {
                    await AuthService().signOut();
                    await provider.saveSettings(AppSettings.defaults());
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'logout',
                    child: Row(
                      children: [
                        const Icon(Icons.logout, color: Colors.red),
                        const SizedBox(width: 8),
                        Text(l10n.logout),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: IndexedStack(
            index: provider.navigationIndex,
            children: _screens,
          ),
          floatingActionButton: provider.navigationIndex == 1 && provider.isConfigured
              ? FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TripEditScreen(),
                      ),
                    );
                  },
                  child: const Icon(Icons.add),
                )
              : null,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: provider.navigationIndex,
            onTap: provider.navigateTo,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.dashboard),
                label: l10n.tabStatus,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.list),
                label: l10n.tabTrips,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.ev_station),
                label: l10n.tabCharging,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.settings),
                label: l10n.tabSettings,
              ),
            ],
          ),
        );
      },
    );
  }
}
