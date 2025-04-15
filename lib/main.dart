import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart' show GetStorage;
import 'package:notification_demo/navigation/app_pages.dart';
import 'package:notification_demo/navigation/app_routes.dart';
import 'package:notification_demo/notification_services/notification_services.dart';


void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  NotificationServices().initNotifications();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
  final fcmToken = await FirebaseMessaging.instance.getToken(vapidKey: "BKagOny0KF_2pCJQ3m....moL0ewzQ8rZu");
  print("FCM Token: $fcmToken");
  runApp(const MyApp());
} 

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.home,
      getPages: AppPages.pages,
    );
  }
}


Future<void> _backgroundHandler(RemoteMessage message) async {
  // Handle background message
}
