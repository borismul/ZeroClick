import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/app_provider.dart';
import 'screens/dashboard_screen.dart';
import 'screens/history_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/trip_edit_screen.dart';
import 'widgets/device_link_dialog.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Don't block app startup - init auth in background
  AuthService().init();
  runApp(const MileageTrackerApp());
}

class MileageTrackerApp extends StatelessWidget {
  const MileageTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppProvider(),
      child: MaterialApp(
        title: 'Kilometerregistratie',
        debugShowCheckedModeBanner: false,
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
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Belangrijk'),
          content: const Text(
            'Deze app detecteert automatisch wanneer je in de auto stapt via Bluetooth.\n\n'
            'Dit werkt alleen als de app op de achtergrond draait. '
            'Als je de app afsluit (omhoog swipen), werkt de automatische detectie niet meer.\n\n'
            'Tip: Laat de app gewoon open staan, dan werkt alles automatisch.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                prefs.setBool('has_seen_background_warning', true);
                Navigator.of(context).pop();
              },
              child: const Text('Begrepen'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Kilometerregistratie'),
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
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                label: 'Status',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list),
                label: 'Ritten',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Instellingen',
              ),
            ],
          ),
        );
      },
    );
  }
}
