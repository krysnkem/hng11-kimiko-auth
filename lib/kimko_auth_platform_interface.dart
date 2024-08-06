import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'kimko_auth_method_channel.dart';

abstract class KimkoAuthPlatform extends PlatformInterface {
  /// Constructs a KimkoAuthPlatform.
  KimkoAuthPlatform() : super(token: _token);

  static final Object _token = Object();

  static KimkoAuthPlatform _instance = MethodChannelKimkoAuth();

  /// The default instance of [KimkoAuthPlatform] to use.
  ///
  /// Defaults to [MethodChannelKimkoAuth].
  static KimkoAuthPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [KimkoAuthPlatform] when
  /// they register themselves.
  static set instance(KimkoAuthPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
