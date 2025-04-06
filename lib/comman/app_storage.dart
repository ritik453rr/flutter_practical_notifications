import 'package:get_storage/get_storage.dart';

/// A class to handle app storage using GetStorage
class AppStorage {

  ///Keys
  static const String isNotificationInit = 'isNotificationInit';

  /// set value in storage
  static setString(String key, dynamic value) async {
    GetStorage().write(key, value);
  }
  
  /// get value from storage
  static dynamic getString(String key) {
    return GetStorage().read(key);
  }
}
