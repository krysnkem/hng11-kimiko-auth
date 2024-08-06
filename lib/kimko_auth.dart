import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kimko_auth/services/api.dart';
import 'package:kimko_auth/services/api_client.dart';
import 'package:kimko_auth/services/kimiko_response.dart';
import 'services/base-api.service.dart';
import 'services/kimiko_client.dart';
import 'services/storage.service.dart';
part './services/kimiko_conect.dart';

class KimkoAuth {
  static const bool _initialized = false;
  static KimikoClient? _client;

  static Future<void> initialize({required String orgId}) async {
    if (_initialized) {
      return;
    }

    await GetStorage.init();

    _client = KimikoClient(
      connect: _connect(baseUrl: Api.baseUrl, appId: orgId),
    );

    storeUserID(orgId: orgId);
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

    // throw Exception("Is organization ID saved::::::::::::: $res");
  }

  Future<KimikoResponse> signIn(String email, String password) async {
    _checkInitialization();
    return await _client!.login(email, password);
  }
}
