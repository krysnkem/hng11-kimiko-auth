
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kimko_auth/services/storage.service.dart';

import 'services/base-api.service.dart';


class KimkoAuth {
  static bool _initialized = false;

  static Future<void> initialize({required String orgId}) async {
    if (_initialized) {
      return;
    }

    // Load dotenv file
    await dotenv.load(fileName: ".env");

    // initialize storage
    await GetStorage.init();

    await storeUserID(orgainizationID: orgId);

    // Additional initialization logic
    _initialized = true;
  }

  static void _checkInitialization() {
    if (!_initialized) {
      throw Exception("KimkoAuth is not initialized. Call initialize() first.");
    }
  }

  static storeUserID({required String orgainizationID}) async {
    StorageService store = StorageService();

    var res = await store.storeOrganizationID(id: orgainizationID);

    print("Is organization ID saved::::::::::::: $res");
  }

  static Future<Map<String, dynamic>> signIn(String email, String password) async {
    _checkInitialization();

    var data = {
      "username": email,
      "password": password
    };

    try {
      Response response = await connect().post("/account/login/", data:data);
      var apiResponse = jsonDecode(response.data);
      var apiData = {
        "status": true,
        "status_code": response.statusCode,
      };
      return {...apiData, ...apiResponse};
    } on DioException catch (e) {
      var apiData = {
        "status": false,
        "status_code":e.response?.statusCode,
      };
      return {
        ...apiData,
        "message": "Faild to sign in",
        "data": e.response?.data
      };
    }
  }



}
