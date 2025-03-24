import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:uuid/uuid.dart';

class PlatformService {
  static String? generatedDeviceId;

  static Future<String> get deviceId async {
    generatedDeviceId ??= Uuid().v1();

    if (Platform.isIOS) {
      var deviceInfo = DeviceInfoPlugin();
      var iosInfo = await deviceInfo.iosInfo;
      final deviceIdentifier = iosInfo.identifierForVendor;
      if (deviceIdentifier != null) {
        return deviceIdentifier;
      } else {
        generatedDeviceId ??= Uuid().v1();
      }
    } else if (Platform.isAndroid) {
      const _androidIdPlugin = AndroidId();
      final androidId = await _androidIdPlugin.getId();
      if (androidId != null) {
        return androidId;
      }
    }

    return generatedDeviceId!;
  }
}
