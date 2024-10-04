import 'dart:io';

class DeviceInfo {
  static String get label {
    // ignore: prefer_interpolation_to_compose_strings
    return Platform.localHostname + '(' + Platform.operatingSystem + ")";
  }

  static String get userAgent {
    return 'flutter-webrtc/${Platform.operatingSystem}-plugin 0.0.1';
  }
}
