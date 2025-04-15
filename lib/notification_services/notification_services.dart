import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notification_demo/comman/app_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:convert';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;


import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

/// A class to handle notifications using flutter_local_notifications
class NotificationServices {
  final FlutterLocalNotificationsPlugin notificationPlugin =
      FlutterLocalNotificationsPlugin();

  static const String firebaseScope =
      'https://www.googleapis.com/auth/cloud-platform';

  /// This method is used to request permission for push notifications.
  Future<String?> getFCMToken() async {
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    debugPrint('FCM Token: $fcmToken');
    return fcmToken;
  }

  /// Method to get the access token using the service account JSON.
  static Future<String> getAccessToken() async {
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "notifications-practical",
      "private_key_id": "d27e19143abd822add469c07c231d314b51598e8",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDNhpIJWPdXpblN\nlBK6NhpCYr7hrrvmb5+r+mASrCmACZAQPv9uW96cWcMPo47rcEsEDT5BMi1HCISK\nJ4C1LkthFQ4DxVQD0xibds4l8KECCGeSXSf4kLb4O6553FghOb/i18wx3ZqivGUF\nFEi+DfqBFzhcZDq8DMzyFYKJDooqOesI6w4nZntOMFVPY2CZ/6ieu0hDPU/AN14N\ndKC32XdqjCPFv/wSJw/unES0PISP5vPKWtTS35C66MK/KGggkK/xqXWEWnFaMMRH\n4tzore6+EQqcWBYcZFi1qzLHzTP2sadCM3Gtw8Rw9LxbgcQQlmavK8OAZRDZ0vBD\nQGEjQM1jAgMBAAECggEAHTXjmp2A5f2hVRPXB4059TZ4n7XIcetqe7RlpDHA4jg5\nt/1kK2i2Pm2Jijb6UJ8Qol5Je1Wo1sAwqjwMEHQodX9bExEgLDz78diUWxMUpyfP\npJ9F14+l2akN1rcI9YvyKEj4dhvjZv60suCbqBtvf5pvwb3jFSgSltOUzmr5GyAH\n8uAXr+Ng1gS4Zi7TroLVDOywbTx1Stcjt4nPmSS+VtAadr3uDViQYBjjMDzKVuvy\nVB6nWxzE+W0iMYBxvyG01J1B1eTnZlyfIOqPXGqTclf5aJXwcJMev+DSshq2BgHa\n+QSbYulFOjV+/rKl1HALiSrMBhau16yiP91Qx/BcMQKBgQDveu6kINBzANS202XF\n6J65YKnA9p28JSSmRtQB3ExxfisIIxBdxllGMEVBkhpgSdI9TwEAzQisSzceJ//D\naBIhq7m8Rz3jIrlGMVzZg2nQdYD/7r7Owj0C8HfyqxWiopBhRC1m/l1xfRh5zF94\n4GPFJWmN+tWJX7VGE0Ne73pNkwKBgQDbtAXTYuOusX6ROdgXoEF2sMCzurM2kGlD\ndWXJhx/Q2aMFUp08uGBXL4aQxNNezxS4PS64Xdb/+EziGJPIea5Pb5YH5NOFuwS7\ntMV3XXZc5O9rCRVh1SgjDG/SvdE4c/k6z0xuU/hCqzpKfyXoN0dCLStmIWAtFgGF\n8yaPehbi8QKBgFNH9guf2b3UsSSvWXo8zk37Xq1bVjli1V75zKqk+PSTAtX+k6d4\n3fz5tmv6KjAIHBP0EI49v2FjetSC5oAHBh8tgBcI023U2oedjQObnsW+x1C5ryNq\nCxulkqESfCCl1f3tXrithsN71HIu75iyuB+MRiv46h+u5/RpqIkwUOD/AoGAeRci\nstxpMwqfALoJ8ROhoSJQQ38ecW9spQKahFWWYozhffiHs0THzKXkG/xvp2ypNdZ6\n3qDR9CjNbzwuj6sJOLz+ywEC2E04kaBTybNYnmCL2Mmb4F0UjyS2qUd3fg7lidVh\ngdmEFnK7YP3tTazR+JZeuh6hHJhpZIOceC3JWXECgYEAgYXSUh7MafIcDZAP0E5O\nVnWbDFpXqMCOvq0Z+PyIDKCjPnPdSNDuoKDQu5suKvq8zs7wYF512lBGhyNIG0e5\nE6DXwrbtroUr/eHK0NZ4ImOgNdl6eR0VDq/HpAFe+LidX784cu8A7PkcBSzdGM08\nfd5ETOIyn4OobaiWOZpxrMg=\n-----END PRIVATE KEY-----\n",
      "client_email":
          "firebase-adminsdk-fbsvc@notifications-practical.iam.gserviceaccount.com",
      "client_id": "101835464023920156640",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40notifications-practical.iam.gserviceaccount.com",
    };
    try {
      final client = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson(serviceAccountJson),
        [firebaseScope],
      );
      final accessToken = client.credentials.accessToken.data;
      debugPrint("Access Token is = $accessToken");
      return accessToken;
    } catch (e) {
      debugPrint("Error fetching access token: $e");
      rethrow;
    }
  }

  /// This method is used to send a push notification using the FCM API.
  static Future<void> sendPushNotification() async {
    final accessToken = await getAccessToken();
    const url =
        'https://fcm.googleapis.com/v1/projects/notifications-practical/messages:send';
    final Map<String, dynamic> notification = {
      "message": {
        "token":
            "fumXq7pkT6awtmQbq_DPoM:APA91bGhNOmp9iGfYIlQIwhteuQXQ3QJOjCcQ9YY9TE3qonnbi1_Au_ruR9JzMAFfyU59eRhNItoedZwzn1iZHpQr9913xM1y9p2PYExQA6g3Y-M_PVARAQ",
        "notification": {
          "title": "Vibe mate",
          "body": "This is a test message",
        },
      },
    };
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: json.encode(notification),
    );
    if (response.statusCode == 200) {
      debugPrint('Notification sent successfully');
    } else {
      debugPrint('Error sending notification: ${response.statusCode}');
      debugPrint('Error response body: ${response.body}');
    }
  }

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
