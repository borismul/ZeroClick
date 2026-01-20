import 'dart:async';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'l10n/generated/app_localizations.dart';
import 'models/settings.dart';
import 'providers/app_provider.dart';
import 'providers/car_provider.dart';
import 'providers/connectivity_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/trip_provider.dart';
import 'services/api_service.dart';
import 'screens/cars_screen.dart';
import 'screens/charging_map_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/history_screen.dart';
import 'screens/permission_onboarding_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/trip_edit_screen.dart';
import 'services/auth_service.dart';
import 'services/background_service.dart';
import 'services/debug_log_service.dart';
import 'widgets/device_link_dialog.dart';
import 'core/analytics/analytics_service.dart';

void main() async {
  // Catch Flutter framework errors in a zone
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize Firebase
    await Firebase.initializeApp();

    // Pass all uncaught Flutter errors to Crashlytics
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };

    // Pass uncaught async errors to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    // Disable Crashlytics collection in debug mode
    if (kDebugMode) {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    }

    // Initialize debug log service to receive native logs
    DebugLogService.instance.init();

    // Initialize analytics service
    await AnalyticsService.init();

    runApp(const ZeroClickApp());
  }, (error, stack) {
    // Catch any errors not caught by Flutter error handlers
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  });
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

class ZeroClickApp extends StatelessWidget {
  const ZeroClickApp({super.key});

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SettingsProvider()),
          // ApiService depends on SettingsProvider for URL and email
          ProxyProvider<SettingsProvider, ApiService>(
            update: (context, settings, previous) {
              if (previous != null) {
                previous.updateConfig(settings.apiUrl, settings.userEmail);
                return previous;
              }
              return ApiService(
                baseUrl: settings.apiUrl,
                userEmail: settings.userEmail,
              );
            },
          ),
          // CarProvider depends on ApiService
          ChangeNotifierProxyProvider<ApiService, CarProvider>(
            create: (context) => CarProvider(context.read<ApiService>()),
            update: (context, api, previous) => previous ?? CarProvider(api),
          ),
          // ConnectivityProvider depends on ApiService and CarProvider
          ChangeNotifierProxyProvider2<ApiService, CarProvider, ConnectivityProvider>(
            create: (context) => ConnectivityProvider(
              context.read<ApiService>(),
              context.read<CarProvider>(),
            )..init(),
            update: (context, api, carProvider, previous) =>
                previous ?? (ConnectivityProvider(api, carProvider)..init()),
          ),
          // TripProvider depends on ApiService, CarProvider, ConnectivityProvider
          ChangeNotifierProxyProvider3<ApiService, CarProvider, ConnectivityProvider, TripProvider>(
            create: (context) => TripProvider(
              context.read<ApiService>(),
              context.read<CarProvider>(),
              context.read<ConnectivityProvider>(),
            ),
            update: (context, api, carProvider, connectivityProvider, previous) =>
                previous ?? TripProvider(api, carProvider, connectivityProvider),
          ),
          // AppProvider depends on SettingsProvider, CarProvider, ConnectivityProvider, TripProvider, and ApiService
          ChangeNotifierProxyProvider5<SettingsProvider, CarProvider, ConnectivityProvider, TripProvider, ApiService,
              AppProvider>(
            create: (context) => AppProvider(
              context.read<SettingsProvider>(),
              context.read<CarProvider>(),
              context.read<ConnectivityProvider>(),
              context.read<TripProvider>(),
              context.read<ApiService>(),
            ),
            update: (context, settings, carProvider, connectivityProvider, tripProvider, api, previous) =>
                previous ?? AppProvider(settings, carProvider, connectivityProvider, tripProvider, api),
          ),
        ],
        child: Consumer<AppProvider>(
          builder: (context, provider, child) {
            final locale = parseLocale(provider.settings.localeCode);
            return MaterialApp(
              title: 'Zero Click',
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

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  final _screens = const [
    DashboardScreen(),
    HistoryScreen(),
    ChargingMapScreen(),
    SettingsScreen(),
  ];

  bool? _onboardingComplete;
  bool _shouldStartTutorial = false;

  // Screen names for analytics
  static const _screenNames = ['dashboard', 'history', 'charging', 'settings'];

  void _trackScreen(int index) {
    if (index >= 0 && index < _screenNames.length) {
      AnalyticsService.logScreenView(_screenNames[index]);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkOnboarding();
  }

  Future<void> _checkOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    final complete = prefs.getBool('onboarding_complete') ?? false;
    if (mounted) {
      setState(() {
        _onboardingComplete = complete;
      });
      // Set up callback for unknown device detection after onboarding
      if (complete) {
        _setupAfterOnboarding();
        // Track initial screen view (dashboard)
        _trackScreen(0);
      } else {
        // Track onboarding screen
        AnalyticsService.logScreenView('onboarding');
      }
    }
  }

  void _setupAfterOnboarding() {
    Provider.of<AppProvider>(context, listen: false).onUnknownDevice = (deviceName) {
      if (mounted) {
        showDeviceLinkDialog(context, deviceName);
      }
    };
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
    // Also mark old warning as seen for migration
    await prefs.setBool('has_seen_background_warning', true);

    // Start native background monitoring now that permissions are granted
    await BackgroundService().startMonitoring();

    if (mounted) {
      // Sync auth email to settings and refresh data
      final provider = Provider.of<AppProvider>(context, listen: false);
      final auth = AuthService();
      if (auth.isSignedIn && auth.userEmail != null) {
        await provider.saveSettings(
          provider.settings.copyWith(userEmail: auth.userEmail),
        );
      }

      // Check if tutorial should start
      final tutorialComplete = prefs.getBool('tutorial_complete') ?? false;

      setState(() {
        _onboardingComplete = true;
        _shouldStartTutorial = !tutorialComplete;
      });
      _setupAfterOnboarding();

      // Refresh all data now that user is logged in
      if (provider.isConfigured) {
        provider.refreshAll();
      }

      // Show setup dialog after frame is built
      if (_shouldStartTutorial) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _showSetupDialog();
          }
        });
      }
    }
  }

  void _showSetupDialog() {
    final l10n = AppLocalizations.of(context);
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.directions_car, size: 48, color: Colors.blue),
        title: Text(l10n.tutorialDialogTitle),
        content: Text(l10n.tutorialDialogContent),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _skipTutorial();
            },
            child: Text(l10n.tutorialDialogLater),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              _startCarSetup();
            },
            child: Text(l10n.tutorialDialogSetup),
          ),
        ],
      ),
    );
  }

  Future<void> _skipTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('tutorial_complete', true);
    setState(() => _shouldStartTutorial = false);
  }

  void _startCarSetup() {
    final provider = Provider.of<AppProvider>(context, listen: false);
    provider.navigateTo(3); // Go to Settings tab
    _trackScreen(3);
    // Navigate to Cars screen
    AnalyticsService.logScreenView('cars');
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => const CarsScreen(showTutorial: true),
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Refresh data when app comes to foreground
      final provider = Provider.of<AppProvider>(context, listen: false);
      if (provider.isConfigured) {
        provider.refreshAll();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    // Show loading while checking onboarding status
    if (_onboardingComplete == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Show onboarding if not complete
    if (_onboardingComplete == false) {
      return PermissionOnboardingScreen(onComplete: _completeOnboarding);
    }

    return Consumer<AppProvider>(
      builder: (context, provider, child) => Scaffold(
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
                  Navigator.push<void>(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => const TripEditScreen(),
                    ),
                  );
                },
                child: const Icon(Icons.add),
              )
            : null,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: provider.navigationIndex,
          onTap: (index) {
            provider.navigateTo(index);
            _trackScreen(index);
          },
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
      ),
    );
  }
}
