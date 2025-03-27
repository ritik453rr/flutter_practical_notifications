import 'package:flutter/material.dart';
import 'package:notification_demo/notification_services/notification_services.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            NotificationServices().showNotification(
              title: "Hello",
              body: "This is a test notification",
            );
          },
          child: Text("Press"),
        ),
      ),
    );
  }
}
