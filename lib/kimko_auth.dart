import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kimko_auth/services/api_client.dart';
import 'package:kimko_auth/services/kimiko_response.dart';
import 'services/base-api.service.dart';
import 'services/kimiko_client.dart';
import 'services/storage.service.dart';

class KimkoAuth {
  static bool _initialized = false;
  KimikoClient client = KimikoClient();

  static Future<void> initialize({required String orgId}) async {
    if (_initialized) {
      return;
    }

    // Initialize storage
    await GetStorage.init();

    await storeUserID(orgId: orgId);

    // Additional initialization logic
    _initialized = true;
  }

  static void _checkInitialization() {
    if (!_initialized) {
      throw Exception(
          "KimkoAuth is not initialized. Call initialize() first. in your main.dart file");
    }
  }

  static Future<void> storeUserID({required String orgId}) async {
    StorageService store = StorageService();

    await store.storeOrganizationID(id: orgId);
  }

  Future<KimikoResponse> signIn(
      String email, String password) async {
    _checkInitialization();
    return await client.login(email, password);
  }

  Future<KimikoResponse> logOut(
      String email, String password) async {
    _checkInitialization();
    return await client.logout();
  }


}
