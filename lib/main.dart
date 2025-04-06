import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart' show GetStorage;
import 'package:notification_demo/navigation/app_pages.dart';
import 'package:notification_demo/navigation/app_routes.dart';
import 'package:notification_demo/notification_services/notification_services.dart';

void main() async{
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  NotificationServices().initNotifications();
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
