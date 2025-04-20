import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notification_demo/notification_services/notification_services.dart';
import 'package:notification_demo/screens/home/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: Get.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  controller.sendLocalNotification();
                },
                child: Text(
                  "Press for local notification",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  NotificationServices.sendPushNotification(
                    token:
                        "cyGEsc8KQK-f7ghSSKayrP:APA91bEoRnznknrirRBGwMbqLXjxhm_uC4HCwGjmjITjVhIR8CCfi4fjM_f6KRzJvqB7X3v_gYhlHAfJHDwrEOD9qbVI0E292RZzs1pRBWfkjSGBY3pcJzw",
                    title: "Ritik",
                    body: "Push notification test",
                  );
                },
                child: Text(
                  "Press for push Ritik",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
