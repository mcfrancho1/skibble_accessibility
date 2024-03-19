import 'dart:io';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class VersioningService {

  Future<String> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  Future<bool> checkVersionWithBackend(String baseVersion) async {
    // Replace this with actual API call to check version
    // Return true if version is allowed, false otherwise
    // Example: return myBackendApi.checkVersion(version);

    var appVersion = await getAppVersion();

    return double.parse(appVersion.split('.')[0]) >= double.parse(baseVersion.split('.')[0]); // For demonstration purposes
  }


  void openAppStoreForUpdate() async {
    String appStoreLink = '';
    Uri appStoreLaunchUri = Uri();

    if (Platform.isAndroid) {
      // Replace with your app's Google Play Store link

      appStoreLaunchUri = Uri(
        scheme: 'https',
        path: 'play.google.com/store/apps/details?id=your.package.name',
        query: encodeQueryParameters(<String, String>{
          'subject': '',
        }));
    }

    else if (Platform.isIOS) {
      // Replace with your app's App Store link
      appStoreLaunchUri = Uri(
          scheme: 'https',
          path: 'apps.apple.com/app/your-app/id1234567890',
          query: encodeQueryParameters(<String, String>{
            'subject': '',
          }));
    }

    if (await canLaunchUrl(appStoreLaunchUri)) {
      await launchUrl(appStoreLaunchUri);
    } else {
      throw 'Could not launch Store link';
    }
  }


  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
    '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }
// ···

}