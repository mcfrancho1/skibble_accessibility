import 'package:flutter/cupertino.dart';
import 'package:package_info_plus/package_info_plus.dart';

enum AppEnvironmentType { dev, prod }

class AppEnvironment {

  static PackageInfo? globalPackageInfo;

  static AppEnvironmentType? currentEnv;
  static final AppEnvironment _instance = AppEnvironment._internal();


  factory AppEnvironment() {
    return _instance;
  }

  AppEnvironment._internal() {
    // initialization logic
  }

  static Future<void> init() async {
    await PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      globalPackageInfo = packageInfo;

      //testing to confirm that the right package name is printed
      // debugPrint(packageInfo.packageName);
      switch (packageInfo.packageName) {
        case "com.mcfranchostudios.skibble.dev":
          currentEnv = AppEnvironmentType.dev;
          break;
        default:
          currentEnv = AppEnvironmentType.prod;
      }
    });
  }

}