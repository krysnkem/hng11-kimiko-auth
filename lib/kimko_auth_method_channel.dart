import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'kimko_auth_platform_interface.dart';

/// An implementation of [KimkoAuthPlatform] that uses method channels.
class MethodChannelKimkoAuth extends KimkoAuthPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('kimko_auth');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
