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

    // Store organization ID
    var res = await storeOrganizationID(orgId: orgId);

    // Additional initialization logic
    _initialized = res;
  }

  // Checking if app is initialized
  static void _checkInitialization() {
    if (!_initialized) {
      throw Exception(
          "KimkoAuth is not initialized. Call initialize() first. in your main.dart file");
    }
  }

  static Future<bool> storeOrganizationID({required String orgId}) async {
    StorageService store = StorageService();

    var res = await store.storeOrganizationID(id: orgId);

    return res;
  }

  // LOGIN FUNCTION
  Future<KimikoResponse> signIn(
      String email, String password) async {
    _checkInitialization();
    return await client.login(email, password);
  }

  // LOGOUT FUNCTION
  Future<KimikoResponse> logOut() async {
    _checkInitialization();
    return await client.logout();
  }


}
