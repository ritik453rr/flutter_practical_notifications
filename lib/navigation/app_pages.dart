import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:notification_demo/navigation/app_routes.dart';
import 'package:notification_demo/screens/home/home_binding.dart';
import 'package:notification_demo/screens/home/home_view.dart';

/// A class that defines the application pages and their routes.
class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: Homebinding(),
    ),
  ];
}
