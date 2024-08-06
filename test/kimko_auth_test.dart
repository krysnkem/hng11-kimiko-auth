import 'package:flutter_test/flutter_test.dart';
import 'package:kimko_auth/kimko_auth.dart';
import 'package:kimko_auth/kimko_auth_platform_interface.dart';
import 'package:kimko_auth/kimko_auth_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockKimkoAuthPlatform
    with MockPlatformInterfaceMixin
    implements KimkoAuthPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final KimkoAuthPlatform initialPlatform = KimkoAuthPlatform.instance;

  test('$MethodChannelKimkoAuth is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelKimkoAuth>());
  });

  test('getPlatformVersion', () async {
    KimkoAuth kimkoAuthPlugin = KimkoAuth();
    MockKimkoAuthPlatform fakePlatform = MockKimkoAuthPlatform();
    KimkoAuthPlatform.instance = fakePlatform;

  });
}
