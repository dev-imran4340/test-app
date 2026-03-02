import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_storage/get_storage.dart';

class AppNotification {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  static final storage = GetStorage();

  static Future<void> initialize() async {
    if (kDebugMode) print('  Initializing notifications...');

    await _requestPermission();
    await _setupLocalNotifications();
    await _getDeviceToken();
    _setupForegroundHandler();
    _setupBackgroundHandler();
    _setupNotificationTapHandler();

    if (kDebugMode) print('  Initialization complete');
  }

  static Future<void> _requestPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (kDebugMode) {
      print('  Permission status: ${settings.authorizationStatus}');
    }
  }

  static Future<void> _setupLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        if (kDebugMode) {
          print('  Notification tapped: ${details.payload}');
        }
      },
    );
  }

  static Future<void> _getDeviceToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        await storage.write('fcmToken', token);
        if (kDebugMode) print('  Device token: $token');
      }
    } catch (e) {
      if (kDebugMode) print('Failed to get token: $e');
    }
  }

  static void _setupForegroundHandler() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('  Foreground message received');
        print('  Title: ${message.notification?.title}');
        print('  Body: ${message.notification?.body}');
      }

      if (message.notification != null) {
        _showLocalNotification(message);
      }
    });
  }

  static void _setupBackgroundHandler() {
    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);
  }

  static void _setupNotificationTapHandler() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('  Notification opened app');
        print('  Data: ${message.data}');
      }
    });
  }

  static Future<void> _showLocalNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Default Channel',
      channelDescription: 'Default notification channel',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      message.hashCode,
      message.notification?.title ?? 'Notification',
      message.notification?.body ?? '',
      notificationDetails,
      payload: message.data.toString(),
    );
  }

  static Future<void> sendOrderNotification({
    required String title,
    required String body,
  }) async {
    if (kDebugMode) {
      print('  Sending order notification');
      print('  Title: $title');
      print('  Body: $body');
    }

    const androidDetails = AndroidNotificationDetails(
      'orders_channel',
      'Orders',
      channelDescription: 'Order notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      notificationDetails,
    );
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print('  Background message received');
    print('  Title: ${message.notification?.title}');
    print('  Body: ${message.notification?.body}');
  }
}
