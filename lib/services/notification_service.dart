import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  // Singleton pattern to ensure only one instance of this service.
  static final NotificationService _notificationService = NotificationService._internal();
  factory NotificationService() => _notificationService;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  /// Initializes the notification service with proper error handling.
  Future<void> init() async {
    if (_isInitialized) return;
    
    try {
      // Use @mipmap/ic_launcher which is the standard launcher icon in Flutter projects
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        // iOS: DarwinInitializationSettings(),
        // macOS: DarwinInitializationSettings(),
      );

      await _flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          // Handle notification tap if needed
        },
      );
      
      _isInitialized = true;
      debugPrint('Notification service initialized successfully');
    } catch (e, stackTrace) {
      debugPrint('Failed to initialize notification service: $e');
      debugPrint('Stack trace: $stackTrace');
      // Continue app execution even if notifications fail
      _isInitialized = false;
    }
  }

  /// Shows a local notification.
  Future<void> showNotification(String title, String body) async {
    if (!_isInitialized) {
      debugPrint('Cannot show notification - notification service not initialized');
      return;
    }

    try {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'smart_desk_channel',
        'Smart Desk Notifications',
        channelDescription: 'Alerts for light level and timer events',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: false,
        enableVibration: true,
        playSound: true,
      );

      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      await _flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch.remainder(100000),
        title,
        body,
        platformChannelSpecifics,
      );
    } catch (e) {
      debugPrint('Error showing notification: $e');
    }
  }
}
