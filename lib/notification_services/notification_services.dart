import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices {
  final notificationPlugin = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  /// INITISLIZE
  Future<void> initNotifications() async {
    requestNotificationPermissions();
    if (_isInitialized) return;
    // for Android
    const initSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    // for iOS
    const initSettingsIos = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // for both platforms
    const initSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsIos,
    );

    // initialize the plugin with the settings
    await notificationPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {},
    );
    _isInitialized = true; // set initialized to true
  }

  /// NOTIFICATION DETAIL SETUP
  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channelId',
        'channelName',
        channelDescription: 'description',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }

  /// SHOW NOTIFICATION
  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    await notificationPlugin.show(id, title, body, notificationDetails());
  }

  /// Request notification permissions for iOS and Android.
  Future<void> requestNotificationPermissions() async {
    // for iOS
    await notificationPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    // for Android
    await notificationPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }
}
