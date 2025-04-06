import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notification_demo/comman/app_storage.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

/// A class to handle notifications using flutter_local_notifications
class NotificationServices {
  final FlutterLocalNotificationsPlugin notificationPlugin =
      FlutterLocalNotificationsPlugin();

  /// Init notifications
  Future<void> initNotifications() async {
    if (AppStorage.getString(AppStorage.isNotificationInit) ?? false) {
      return;
    }
    tz.initializeTimeZones();
    requestNotificationPermissions();
    // for Android
    const initSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    // for iOS
    const initSettingsIos = DarwinInitializationSettings();
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
    // Added notification channel creation (required for Android 8.0+)
    await _createNotificationChannel();
    // set notification init to true
    AppStorage.setString(AppStorage.isNotificationInit, true);
  }

  // NEW METHOD: Added to create notification channel for Android
  Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'channelId',
      'channelName',
      description: 'description',
      importance: Importance.max,
      playSound: true, // Added sound option
    );

    await notificationPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  /// Notification details for Android and iOS
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

  /// Show notification with title and body
  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    await notificationPlugin.show(id, title, body, notificationDetails());
  }

  /// Schedule notification at specific time
  Future<void> scheduleNotification({
    int id = 0,
    String? title,
    String? body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    final scheduledTime = tz.TZDateTime.from(scheduledDate, tz.local);
    if (scheduledTime.isBefore(tz.TZDateTime.now(tz.local))) {
      throw Exception('Cannot schedule notification in the past');
    }
    await notificationPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledTime,
      notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}
