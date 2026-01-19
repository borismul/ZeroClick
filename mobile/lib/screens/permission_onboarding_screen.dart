import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../l10n/generated/app_localizations.dart';
import '../services/auth_service.dart';
import 'cars_screen.dart';

class PermissionOnboardingScreen extends StatefulWidget {
  const PermissionOnboardingScreen({super.key, required this.onComplete});

  final VoidCallback onComplete;

  @override
  State<PermissionOnboardingScreen> createState() =>
      _PermissionOnboardingScreenState();
}

class _PermissionOnboardingScreenState
    extends State<PermissionOnboardingScreen> with WidgetsBindingObserver {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Auth state
  bool _isLoggedIn = false;
  bool _isLoggingIn = false;

  // Permission states
  bool _notificationsGranted = false;
  bool _locationGranted = false;
  bool _locationAlwaysGranted = false;
  bool _motionGranted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Don't check permissions here - it triggers all dialogs at once on iOS!
    // Instead, we check each permission only when its page is shown
    if (!Platform.isIOS) {
      _motionGranted = true; // Android doesn't need motion permission
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pageController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // When returning from settings, refresh the current page's permission
    if (state == AppLifecycleState.resumed) {
      _refreshCurrentPagePermission();
    }
  }

  Future<void> _refreshCurrentPagePermission() async {
    // Page 0 = Welcome (no permission)
    // Page 1 = How it works (no permission)
    // Page 2 = Login (no permission)
    // Page 3 = Notifications
    // Page 4 = Location
    // Page 5 = Location Always
    // Page 6 = Motion (iOS) or Done (Android)
    // Page 7 = Done (iOS)
    bool wasGranted = false;
    switch (_currentPage) {
      case 3:
        await _refreshPermissionStatus(Permission.notification);
        wasGranted = _notificationsGranted;
      case 4:
        await _refreshPermissionStatus(Permission.location);
        wasGranted = _locationGranted;
      case 5:
        await _refreshPermissionStatus(Permission.locationAlways);
        wasGranted = _locationAlwaysGranted;
      case 6:
        if (Platform.isIOS) {
          await _refreshPermissionStatus(Permission.sensors);
          wasGranted = _motionGranted;
        }
    }
    // Auto-advance if permission was granted while in settings
    if (wasGranted) {
      _nextPage();
    }
  }

  /// Check a single permission status without triggering the dialog
  /// Only call this after the user has already interacted with that permission
  Future<void> _refreshPermissionStatus(Permission permission) async {
    final status = await permission.status;
    setState(() {
      switch (permission) {
        case Permission.notification:
          _notificationsGranted = status.isGranted;
        case Permission.location:
          _locationGranted = status.isGranted;
        case Permission.locationAlways:
          _locationAlwaysGranted = status.isGranted;
        case Permission.sensors:
          _motionGranted = status.isGranted;
        default:
          break;
      }
    });
  }

  void _nextPage() {
    if (_currentPage < _getPageCount() - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  int _getPageCount() {
    // Welcome, How it works, Login, Notifications, Location, Location Always, Motion (iOS only), Done
    return Platform.isIOS ? 8 : 7;
  }

  Future<void> _signIn() async {
    setState(() => _isLoggingIn = true);
    try {
      final success = await AuthService().signIn();
      if (success) {
        setState(() => _isLoggedIn = true);
        _nextPage();
      }
    } finally {
      setState(() => _isLoggingIn = false);
    }
  }

  Future<void> _requestNotifications() async {
    final currentStatus = await Permission.notification.status;
    if (currentStatus.isGranted) {
      setState(() => _notificationsGranted = true);
      _nextPage();
      return;
    }

    final status = await Permission.notification.request();
    setState(() {
      _notificationsGranted = status.isGranted;
    });
    if (status.isGranted) {
      _nextPage();
    } else {
      await _openSettings();
    }
  }

  Future<void> _requestLocation() async {
    final currentStatus = await Permission.location.status;
    if (currentStatus.isGranted) {
      setState(() => _locationGranted = true);
      _nextPage();
      return;
    }

    final status = await Permission.location.request();
    setState(() {
      _locationGranted = status.isGranted;
    });
    if (status.isGranted) {
      _nextPage();
    } else if (status.isPermanentlyDenied) {
      await _openSettings();
    }
  }

  Future<void> _requestLocationAlways() async {
    final currentStatus = await Permission.locationAlways.status;
    if (currentStatus.isGranted) {
      setState(() => _locationAlwaysGranted = true);
      _nextPage();
      return;
    }

    final locationStatus = await Permission.location.status;
    if (!locationStatus.isGranted) {
      final basicStatus = await Permission.location.request();
      if (!basicStatus.isGranted) {
        if (basicStatus.isPermanentlyDenied) {
          await _openSettings();
        }
        return;
      }
      setState(() {
        _locationGranted = true;
      });
    }

    final status = await Permission.locationAlways.request();
    setState(() {
      _locationAlwaysGranted = status.isGranted;
    });
    if (status.isGranted) {
      _nextPage();
    } else if (status.isPermanentlyDenied) {
      await _openSettings();
    }
  }

  Future<void> _requestMotion() async {
    if (!Platform.isIOS) {
      _nextPage();
      return;
    }

    final currentStatus = await Permission.sensors.status;
    if (currentStatus.isGranted) {
      setState(() => _motionGranted = true);
      _nextPage();
      return;
    }

    final status = await Permission.sensors.request();
    setState(() {
      _motionGranted = status.isGranted;
    });
    if (status.isGranted) {
      _nextPage();
    } else {
      await _openSettings();
    }
  }

  Future<void> _openSettings() async {
    await openAppSettings();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: List.generate(_getPageCount(), (index) {
                  return Expanded(
                    child: Container(
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: index <= _currentPage
                            ? theme.colorScheme.primary
                            : theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
            ),

            // Pages
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
                  // Welcome page
                  _buildPage(
                    icon: Icons.directions_car_rounded,
                    iconColor: theme.colorScheme.primary,
                    title: l10n.onboardingWelcome,
                    description: l10n.onboardingWelcomeSubtitle,
                    buttonText: l10n.onboardingNext,
                    onPressed: _nextPage,
                  ),

                  // How it works page
                  _buildFeaturePage(
                    title: l10n.onboardingHowItWorksTitle,
                    description: l10n.onboardingHowItWorksDescription,
                    features: [
                      _FeatureItem(
                        icon: Icons.speed_rounded,
                        color: Colors.purple,
                        title: l10n.onboardingFeatureMotion,
                        description: l10n.onboardingFeatureMotionDesc,
                      ),
                      _FeatureItem(
                        icon: Icons.bluetooth_rounded,
                        color: Colors.indigo,
                        title: l10n.onboardingFeatureBluetooth,
                        description: l10n.onboardingFeatureBluetoothDesc,
                      ),
                      _FeatureItem(
                        icon: Icons.link_rounded,
                        color: Colors.orange,
                        title: l10n.onboardingFeatureCarApi,
                        description: l10n.onboardingFeatureCarApiDesc,
                      ),
                    ],
                    buttonText: l10n.onboardingNext,
                    onPressed: _nextPage,
                  ),

                  // Login page
                  _buildPage(
                    icon: Icons.account_circle_rounded,
                    iconColor: Colors.blue,
                    title: l10n.onboardingLoginTitle,
                    description: l10n.onboardingLoginDescription,
                    buttonText: _isLoggingIn
                        ? l10n.onboardingLoggingIn
                        : (_isLoggedIn ? l10n.onboardingNext : l10n.onboardingLoginButton),
                    onPressed: _isLoggingIn ? () {} : (_isLoggedIn ? _nextPage : _signIn),
                    isGranted: _isLoggedIn,
                    isLoading: _isLoggingIn,
                  ),

                  // Notifications
                  _buildPage(
                    icon: Icons.notifications_rounded,
                    iconColor: Colors.orange,
                    title: l10n.onboardingNotificationsTitle,
                    description: l10n.onboardingNotificationsDescription,
                    buttonText: _notificationsGranted
                        ? l10n.onboardingNext
                        : l10n.onboardingNotificationsButton,
                    onPressed:
                        _notificationsGranted ? _nextPage : _requestNotifications,
                    isGranted: _notificationsGranted,
                  ),

                  // Location
                  _buildPage(
                    icon: Icons.location_on_rounded,
                    iconColor: Colors.blue,
                    title: l10n.onboardingLocationTitle,
                    description: l10n.onboardingLocationDescription,
                    buttonText: _locationGranted
                        ? l10n.onboardingNext
                        : l10n.onboardingLocationButton,
                    onPressed: _locationGranted ? _nextPage : _requestLocation,
                    isGranted: _locationGranted,
                  ),

                  // Location Always
                  _buildPage(
                    icon: Icons.my_location_rounded,
                    iconColor: Colors.green,
                    title: l10n.onboardingLocationAlwaysTitle,
                    description: l10n.onboardingLocationAlwaysDescription,
                    secondaryDescription: _locationAlwaysGranted
                        ? null
                        : l10n.onboardingLocationAlwaysInstructions,
                    buttonText: _locationAlwaysGranted
                        ? l10n.onboardingNext
                        : l10n.onboardingLocationButton,
                    onPressed:
                        _locationAlwaysGranted ? _nextPage : _requestLocationAlways,
                    isGranted: _locationAlwaysGranted,
                    showRefreshButton: !_locationAlwaysGranted,
                    onRefresh: () =>
                        _refreshPermissionStatus(Permission.locationAlways),
                  ),

                  // Motion (iOS only)
                  if (Platform.isIOS)
                    _buildPage(
                      icon: Icons.speed_rounded,
                      iconColor: Colors.purple,
                      title: l10n.onboardingMotionTitle,
                      description: l10n.onboardingMotionDescription,
                      buttonText: _motionGranted
                          ? l10n.onboardingNext
                          : l10n.onboardingMotionButton,
                      onPressed: _motionGranted ? _nextPage : _requestMotion,
                      isGranted: _motionGranted,
                    ),

                  // Done
                  _buildPage(
                    icon: Icons.check_circle_rounded,
                    iconColor: Colors.green,
                    title: l10n.onboardingAllSet,
                    description: l10n.onboardingAllSetDescription,
                    buttonText: l10n.onboardingGetStarted,
                    onPressed: widget.onComplete,
                    isPrimary: true,
                  ),
                ],
              ),
            ),

            // Skip button (not on first or last page)
            if (_currentPage > 0 && _currentPage < _getPageCount() - 1)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: TextButton(
                  onPressed: _nextPage,
                  child: Text(l10n.onboardingSkip),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturePage({
    required String title,
    required String description,
    required List<_FeatureItem> features,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 16),

          // Title
          Text(
            title,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          // Description
          Text(
            description,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 24),

          // Feature cards
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: features.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final feature = features[index];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: feature.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: feature.color.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: feature.color.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          feature.icon,
                          color: feature.color,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              feature.title,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              feature.description,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Button
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onPressed,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                buttonText,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildCarSetupPage(AppLocalizations l10n, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 8),

          // Title
          Text(
            l10n.onboardingSetupTitle,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          Text(
            l10n.onboardingSetupDescription,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 24),

          // Steps
          Expanded(
            child: ListView(
              children: [
                // Step 1: Add car
                _SetupStepCard(
                  stepNumber: '1',
                  icon: Icons.add_circle_rounded,
                  color: Colors.green,
                  title: l10n.onboardingSetupStep1Title,
                  description: l10n.onboardingSetupStep1Desc,
                  buttonText: l10n.onboardingSetupStep1Button,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (context) => const AddEditCarScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 12),

                // Step 2: Go to car
                _SetupStepCard(
                  stepNumber: '2',
                  icon: Icons.directions_car_rounded,
                  color: Colors.blue,
                  title: l10n.onboardingSetupStep2Title,
                  description: l10n.onboardingSetupStep2Desc,
                ),

                const SizedBox(height: 12),

                // Step 3: Connect Bluetooth
                _SetupStepCard(
                  stepNumber: '3',
                  icon: Icons.bluetooth_connected_rounded,
                  color: Colors.indigo,
                  title: l10n.onboardingSetupStep3Title,
                  description: l10n.onboardingSetupStep3Desc,
                ),

                const SizedBox(height: 12),

                // Step 4: Link car account (optional)
                _SetupStepCard(
                  stepNumber: '4',
                  icon: Icons.link_rounded,
                  color: Colors.orange,
                  title: l10n.onboardingSetupStep4Title,
                  description: l10n.onboardingSetupStep4Desc,
                  isOptional: true,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Continue button
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _nextPage,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                l10n.onboardingNext,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Skip for now
          TextButton(
            onPressed: _nextPage,
            child: Text(l10n.onboardingSetupLater),
          ),
        ],
      ),
    );
  }

  Widget _buildPage({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    String? secondaryDescription,
    required String buttonText,
    required VoidCallback onPressed,
    bool isGranted = false,
    bool isPrimary = false,
    bool isLoading = false,
    bool showRefreshButton = false,
    VoidCallback? onRefresh,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),

          // Icon with checkmark overlay if granted
          Stack(
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 64,
                  color: iconColor,
                ),
              ),
              if (isGranted)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.colorScheme.surface,
                        width: 3,
                      ),
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 32),

          // Title
          Text(
            title,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // Description
          Text(
            description,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),

          if (secondaryDescription != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      secondaryDescription,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const Spacer(),

          // Refresh button for checking permission status
          if (showRefreshButton && onRefresh != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: TextButton.icon(
                onPressed: onRefresh,
                icon: const Icon(Icons.refresh),
                label: const Text('Check permission'),
              ),
            ),

          // Main button
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: isLoading ? null : onPressed,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor:
                    isPrimary ? Colors.green : theme.colorScheme.primary,
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      buttonText,
                      style: const TextStyle(fontSize: 16),
                    ),
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _FeatureItem {
  final IconData icon;
  final Color color;
  final String title;
  final String description;

  const _FeatureItem({
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
  });
}

class _SetupStepCard extends StatelessWidget {
  final String stepNumber;
  final IconData icon;
  final Color color;
  final String title;
  final String description;
  final String? buttonText;
  final VoidCallback? onPressed;
  final bool isOptional;

  const _SetupStepCard({
    required this.stepNumber,
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
    this.buttonText,
    this.onPressed,
    this.isOptional = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Step number circle
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    stepNumber,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 12),
              // Title
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (isOptional) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Optioneel',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[400],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Description
          Text(
            description,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          // Action button if provided
          if (buttonText != null && onPressed != null) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onPressed,
                icon: const Icon(Icons.arrow_forward, size: 18),
                label: Text(buttonText!),
                style: OutlinedButton.styleFrom(
                  foregroundColor: color,
                  side: BorderSide(color: color),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
