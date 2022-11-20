// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Project imports:
import 'package:infixedu/screens/fees/paymentGateway/khalti/core/src/config/khalti_config.dart';
import 'package:infixedu/screens/fees/paymentGateway/khalti/core/src/data/khalti_service.dart';
import 'package:infixedu/screens/fees/paymentGateway/khalti/sdk/src/khalti_http_client.dart';
import 'package:infixedu/screens/fees/paymentGateway/khalti/sdk/src/util/device_util.dart';
import 'package:infixedu/screens/fees/paymentGateway/khalti/sdk/src/util/package_util.dart';

class Khalti {
  static Future<void> init({
    @required String publicKey,
    KhaltiConfig config,
    bool enabledDebugging = false,
  }) async {
    KhaltiService.enableDebugging = enabledDebugging;
    KhaltiService.publicKey = publicKey;

    if (config == null) {
      final deviceUtil = DeviceUtil();
      final packageUtil = PackageUtil();
      await deviceUtil.init();
      await packageUtil.init();

      KhaltiService.config = KhaltiConfig(
        source: kIsWeb ? 'web' : Platform.operatingSystem,
        osVersion: deviceUtil.osVersion,
        deviceModel: deviceUtil.deviceModel,
        deviceManufacturer: deviceUtil.deviceManufacturer,
        packageName: packageUtil.applicationId,
        packageVersion: packageUtil.versionName,
      );
    } else {
      KhaltiService.config = config;
    }
  }

  static KhaltiService get service => _service;
}

final KhaltiService _service = KhaltiService(client: KhaltiHttpClient());
