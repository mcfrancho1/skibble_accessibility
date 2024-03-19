
import 'package:get/get.dart';

import 'package:skibble/services/preferences/theme_preferences.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ThemeController>(() => ThemeController.getThemeController());
    // Get.lazyPut<InitialController>(() => InitialController());
  }
}