import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notification_demo/notification_services/notification_services.dart';
import 'package:permission_handler/permission_handler.dart';

/// This is the controller for the home screen
class HomeController extends GetxController {
  final permissionHandler = Permission.notification;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void onInit() {
    super.onInit();
    _firebaseMessaging.requestPermission();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Message data: ${message.data}');
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message clicked! ${message.messageId}');
    });
  }

  Future<void> showNotification() async {
    final status = await permissionHandler.status;
    if (status.isGranted) {
      NotificationServices().showNotification(
        id: 0,
        title: "Hello",
        body: "This is a notification",
      );
    } else {
      showAdaptiveDialog(
        context: Get.context!,
        builder: (context) {
          return AlertDialog(
            title: const Text("Permission Required"),
            content: const Text("Please allow notification permission"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  openAppSettings();
                  Navigator.of(context).pop();
                },
                child: const Text("Settings"),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> scheduleNotification() async {
    final status = await permissionHandler.status;
    if (status.isGranted) {
      NotificationServices().scheduleNotification(
        id: 0,
        title: "Hello",
        body: "This is a notification",
        scheduledDate: DateTime.now().add(const Duration(seconds: 5)),
      );
    } else {
      print("Not granted");
      showAdaptiveDialog(
        context: Get.context!,
        builder: (context) {
          return AlertDialog(
            title: const Text("Permission Required"),
            content: const Text("Please allow notification permission"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  openAppSettings();
                  Navigator.of(context).pop();
                },
                child: const Text("Settings"),
              ),
            ],
          );
        },
      );
    }
  }
}
