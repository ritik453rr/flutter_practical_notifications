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
      "private_key_id": "4f2f6e10f77883a015d8666a8c22aac16880883e",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQC0JQkO4NDpItOL\nIGWdfuB24zkwdg6d3k+9eUbMjATuxkWVejTypRIiQaDLVZc2eNXeNn3HzclferUk\nm2710BkWIAFeIAl6HxTuTDqev4RYif9S41yZooSGNv/jC4ksD8+R40PSukYEfjK1\nikRT5kELR72Ai93X+5YL/fncEDtsG6V4SQptYWSm2XoewxKVZM+tY2A5ewzQiAAs\nu+wfGgkTfMydId2a0c6g5t8b459+7XLejz8u7Jdboa51UDV+tBepBtVxPTdAOk96\nBGS0ilcya/r+68CvD8vst6TQlav0wXcMxGM8H3RAQGTttqraxwwueoXNlNmapBP7\nwaGKHGExAgMBAAECggEACjftlxv2jbrtf/9S9EedqPDDrjWMJ7VUFZ3a/8BTiU3S\n5aM8fKUTbcEGQ3Jz9OGO1B+IK/zG1vUpcE2m0ie/PIuNOE8d6oD32XqWeqnHcpRF\nWOjPuGFJHinhgvoFCmxNLGvVTY9GaHvWGYkhzhaKCv9DRxbn+xfoz35VHYAINt4U\nMyGkdZBwWtSjOGTcJikAypuSD14RpveVPkh9An6WqODicPVe8cX16zZWst/NCEtw\nxLxFEhj8CfdYH55LHy3a9Z5rPGyYoxBswu0VZ8x+ltPfi387UYt81boIIur4DboU\n4jWZXoiMDILj8BJj+oEgtPa5K9bEMVuL6Gqn0njhxwKBgQDivp5b+gAI9ptEMShK\nGzt4MiTf6wEHQqgBJLoZrzTXX5F+ukDLi9FPYZGmf8p098xLN7z5+S1WEoC+G0OR\nFpEM9ZkNnt3vQEn6mGmX/DpzNiHKmjqKFYWE9AoIZx2sgLyvJ8HgGyLz8UHDblDU\nNuPeCk6twctg5BasA7QcuKNxhwKBgQDLYzgwjdS1xxswqGz8Zhya9cMEdbhOr0rB\nKqn3av/MnQ2t9iyEZYBCkRcuZz7gFHByZA46t6d82yCWoA4JkbKUBDbNlSoC2YsL\nnuvLdD9WLGS+o8lc1Zo6N4Z4tbGANuSdLd5afYKbb8/x5ftWbHHrcNI1dH+LXdb3\n7jxCvCUlhwKBgDQlYoYEmL12+X5VT867NJIP9isJANOKoNiieaougRiHAg8DBqPJ\nI/n9lmGUQhtkYbdquitDAwoodzNBUeisJ++zC9/2CVRclKbtJlutxkN4z4yoq43W\nJT7OYQBNtqVVdg9SNWQ02XUApv8q/6vOc9k8xZtwVjWSPySQNXvlerFBAoGADQcw\nBDwxketNHJLNWGWaE3sGoPSBd9jWqwT2mjiqZgrxY2FPfLObwafVmk1Ww7fLdChg\nmPZGrkLDFaLvA0Hn9H9Im2agqEoTFA18AS5TGEwDsAqBzYaJOI1x+a15z0K05jSX\n96fug9JnuZEHxoNv0KsLbA0oVl8OdBc4mPXAU2UCgYBQEv4nmUJEgfULLJ6vSwel\n2GY+PR9tsq7I+XM4IatvAIUijYnGL2SNKlLkg2wEqVr33K2ba7cpyplCtGoC7a3C\n3m9zSxZHkynCwWX5XgrNyZKRUY40RrkTsbkE/wPObn691sxsdCW/EP8OL+ys29ie\n8bZp8W+PNh5qFaxXfgnMAA==\n-----END PRIVATE KEY-----\n",
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
  static Future<void> sendPushNotification({
    String? token,
    String? title,
    String? body,
  }) async {
    final accessToken = await getAccessToken();
    const url =
        'https://fcm.googleapis.com/v1/projects/notifications-practical/messages:send';
    final Map<String, dynamic> notification = {
      "message": {
        "token": token,
        "notification": {"title": title, "body": body},
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
