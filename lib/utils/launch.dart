import 'package:url_launcher/url_launcher.dart';

class LaunchUtils {
  static Future<void> launchApp(Uri uri) async {
    final hasApp = await canLaunchUrl(uri);

    if (hasApp) {
      launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      launchUrl(uri);
    }
  }
}
