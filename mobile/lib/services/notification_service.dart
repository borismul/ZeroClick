// Local notification service for car detection and trip events

import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../core/logging/app_logger.dart';

/// Callback when user taps a notification
typedef NotificationTapCallback = void Function(String? payload);

/// Localized strings for notifications
class NotificationStrings {
  final String channelName;
  final String channelDescription;
  final String newCarDetected;
  final String isCarToTrack; // Contains {deviceName} placeholder
  final String tripStarted;
  final String tripTracking;
  final String tripTrackingWithCar; // Contains {carName} placeholder
  final String carLinked;
  final String carLinkedBody; // Contains {deviceName} and {carName} placeholders

  const NotificationStrings({
    this.channelName = 'Car Detection',
    this.channelDescription = 'Notifications for car detection and trip registration',
    this.newCarDetected = 'New car detected',
    this.isCarToTrack = 'Is "{deviceName}" a car you want to track?',
    this.tripStarted = 'Trip Started',
    this.tripTracking = 'Your trip is now being tracked',
    this.tripTrackingWithCar = 'Your trip with {carName} is now being tracked',
    this.carLinked = 'Car Linked',
    this.carLinkedBody = '"{deviceName}" is now linked to {carName}',
  });
}

class NotificationService {
  NotificationService();

  static const _log = AppLogger('NotificationService');

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;
  NotificationTapCallback? _onTap;
  NotificationStrings _strings = const NotificationStrings();

  /// Notification channel IDs
  static const _channelId = 'car_detection';

  String get _channelName => _strings.channelName;
  String get _channelDescription => _strings.channelDescription;

  /// Notification IDs
  static const _unknownDeviceNotificationId = 1;
  static const _tripStartedNotificationId = 2;
  static const _carLinkedNotificationId = 3;

  /// Set localized strings for notifications
  /// Call this when the app starts with localization context available
  void setLocalizedStrings(NotificationStrings strings) {
    _strings = strings;
    _log.info('Notification strings updated');
  }

  /// Initialize the notification service
  Future<void> init() async {
    if (_initialized) return;

    // Android settings
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS settings - don't request permissions here, onboarding handles it
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    final granted = await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _handleNotificationTap,
    );

    _initialized = granted ?? false;
    _log.info('Notification service initialized: $_initialized');

    // Create notification channel on Android
    if (Platform.isAndroid) {
      await _createAndroidChannel();
    }
  }

  Future<void> _createAndroidChannel() async {
    const channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.high,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  void _handleNotificationTap(NotificationResponse response) {
    _log.info('Notification tapped: ${response.payload}');
    _onTap?.call(response.payload);
  }

  /// Set callback for notification taps
  void setTapCallback(NotificationTapCallback callback) {
    _onTap = callback;
  }

  /// Request notification permissions (call on app startup)
  Future<bool> requestPermissions() async {
    if (Platform.isIOS) {
      final iosPlugin = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      final granted = await iosPlugin?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      _log.info('iOS notification permission: $granted');
      return granted ?? false;
    } else if (Platform.isAndroid) {
      final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      final granted = await androidPlugin?.requestNotificationsPermission();
      _log.info('Android notification permission: $granted');
      return granted ?? false;
    }
    return false;
  }

  /// Show notification for unknown Bluetooth device detected
  /// "Is this a car you want to track?"
  Future<void> showUnknownDeviceNotification(String deviceName) async {
    if (!_initialized) {
      _log.warning('Notification service not initialized');
      return;
    }

    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.show(
      _unknownDeviceNotificationId,
      _strings.newCarDetected,
      _strings.isCarToTrack.replaceAll('{deviceName}', deviceName),
      details,
      payload: 'unknown_device:$deviceName',
    );

    _log.info('Showed unknown device notification for: $deviceName');
  }

  /// Show notification when trip starts
  Future<void> showTripStartedNotification(String? carName) async {
    if (!_initialized) {
      _log.warning('Notification service not initialized');
      return;
    }

    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: false,
      presentSound: false,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final body = carName != null
        ? _strings.tripTrackingWithCar.replaceAll('{carName}', carName)
        : _strings.tripTracking;

    await _plugin.show(
      _tripStartedNotificationId,
      _strings.tripStarted,
      body,
      details,
      payload: 'trip_started',
    );

    _log.info('Showed trip started notification');
  }

  /// Show notification when car is successfully linked
  Future<void> showCarLinkedNotification(String carName, String deviceName) async {
    if (!_initialized) {
      _log.warning('Notification service not initialized');
      return;
    }

    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: false,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.show(
      _carLinkedNotificationId,
      _strings.carLinked,
      _strings.carLinkedBody
          .replaceAll('{deviceName}', deviceName)
          .replaceAll('{carName}', carName),
      details,
      payload: 'car_linked:$carName',
    );

    _log.info('Showed car linked notification: $carName');
  }

  /// Cancel all notifications
  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  void dispose() {
    _onTap = null;
  }
}
