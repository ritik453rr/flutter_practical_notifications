import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:notification_demo/screens/home/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 200,
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            onPressed: ()  {
               controller.scheduleNotification();
            },
            child: Text(
              "Press",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
