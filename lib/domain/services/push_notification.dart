import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:app_mobile/application/providers/_app_provider.dart';
import 'package:app_mobile/domain/models/other/notification_model.dart';
import 'package:app_mobile/infrastructure/locals/shared_manager.dart';
import 'package:app_mobile/presentation/routes/app_routes.dart';
import 'package:go_router/go_router.dart';

import 'firebase_options.dart';

// Background handler for Firebase messages
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(name: 'TerraProc', options: DefaultFirebaseOptions.currentPlatform);
  debugPrint('Handling background message: ${message.messageId}');
  await NotificationService.instance.showNotificationFromFirebase(message);
  SharedPreferencesProvider.instance.setAppRoute(
    message.data['route'] ?? '/',
  );
}

// Background handler for notification taps but not working
@pragma('vm:entry-point')
void notificationTapBackground(
    NotificationResponse notificationResponse) async {
  debugPrint(
      'Background notification tapped with payload: ${notificationResponse.payload}');
}

class NotificationService {
  static final NotificationService instance = NotificationService._internal();
  factory NotificationService() => instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  String? fcmToken;

  Future<void> init() async {
    // Initialize Firebase Messaging
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Get FCM token (for testing)
    if (Platform.isIOS) {
      String? apnsToken = await _firebaseMessaging.getAPNSToken();
      debugPrint('APNS Token: $apnsToken');
      await Future.delayed(const Duration(seconds: 2));
    }

    fcmToken = await _firebaseMessaging.getToken();
    debugPrint('FCM Token: $fcmToken');

    // Android initialization settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization settings
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Combine settings
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    // Initialize local notifications
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          debugPrint(
              'Foreground notification tapped with payload: ${response.payload}');
          _handleNotificationTap(response.payload);
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    // Request permissions for iOS
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    // Request Android 13+ notification permissions
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    // Set up Firebase message handlers
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Received foreground message: ${message.messageId}');
      showNotificationFromFirebase(message);
      AcnooAppRoutes.rootNavigatorKey.currentContext!
          .read<AppProvider>()
          .catchNotification(MNotification.fromJson(message.data));
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('Message opened app: ${message.messageId}');
      _handleFirebaseMessageTap(message);
    });

    // Handle initial message (app opened from terminated state)
    RemoteMessage? initialMessage =
        await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      debugPrint(
          'App opened from terminated state: ${initialMessage.messageId}');
      _handleFirebaseMessageTap(initialMessage);
    }

    // Handle notification taps when the app is in the background
    _handleNotificationTapOnBackground(SharedPreferencesProvider.instance.appRoute);

    // Set up background message handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'default_channel_id',
      'Default Channel',
      channelDescription: 'General notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails();

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  Future<void> showNotificationFromFirebase(RemoteMessage message) async {
    final notification = message.notification;
    final data = message.data;

    if (notification != null) {
      await showNotification(
        id: DateTime.now().millisecondsSinceEpoch % 1000,
        title: notification.title ?? 'No Title',
        body: notification.body ?? 'No Body',
        payload: data['route'] ?? '/',
      );
    }
  }

  void _handleNotificationTap(String? payload) {
    if (payload == null) return;
    AcnooAppRoutes.rootNavigatorKey.currentContext!.go(payload);
  }

  void _handleNotificationTapOnBackground(String payload) {
    if (payload == '/') return;
    AcnooAppRoutes.rootNavigatorKey.currentContext!.go(payload);
    SharedPreferencesProvider.instance.setAppRoute('/');
  }

  void _handleFirebaseMessageTap(RemoteMessage message) {
    final route = message.data['route'] ?? '/';
    AcnooAppRoutes.rootNavigatorKey.currentContext!.go(route);
  }
}
