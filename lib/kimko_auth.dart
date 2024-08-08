import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kimko_auth/services/api.dart';
import 'package:kimko_auth/services/kimiko_response.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'services/kimiko_client.dart';
import 'services/storage.service.dart';
part './services/kimiko_conect.dart';

class KimkoAuth {
  static bool _initialized = false;
  static KimikoClient? _client;

  static Future<void> initialize({required String orgId}) async {
    if (_initialized) {
      return;
    }

    await GetStorage.init();

    // Store organization ID
    var res = await _storeOrganizationID(orgId: orgId);

    _client = KimikoClient(
      connect: _connect(),
    );
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

  static Future<bool> _storeOrganizationID({required String orgId}) async {
    StorageService store = StorageService();

    var res = await store.storeAppID(id: orgId);

    return res;
  }

  // LOGIN FUNCTION
  Future<KimikoResponse> signIn(String email, String password) async {
    _checkInitialization();
    return await _client!.login(email, password);
  }

  // GET USER FUNCTION
  Future<KimikoResponse> getUser() async {
    _checkInitialization();
    return await _client!.getUser();
  }

  // GET UPDATED USER FROM STORAGE (NO API CALL) FUNCTION
  Future<KimikoResponse> getStoredUser() async {
    _checkInitialization();
    return await _client!.getCacheUser();
  }

  // LOGOUT FUNCTION
  Future<KimikoResponse> logOut() async {
    _checkInitialization();
    return await _client!.logout();
  }
}
