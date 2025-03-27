import 'package:get/get.dart';
import 'package:notification_demo/screens/home/home_controller.dart' show HomeController;

class Homebinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}