import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';

class StorageService {
  var storage = GetStorage();
  bool isLoggedIn = false;

  storeItem({required String key, String? value}) async {
    await storage.write(key, value);
  }

  Future<dynamic> readItem({required String key}) async {
    final value = await storage.read(key);
    return value;
  }

  deleteItem({required String key}) async {
    await storage.remove(key);
  }

  deleteAllItems() async {
    await storage.erase();
  }

  Future<bool> hasKey({required String key}) async {
    return storage.hasData(key);
  }

  Future<bool> storeAppID({required String id}) async {
    try {
      await storeItem(key: StorageKeys.organizationID, value: id);
      var res = await hasKey(key: StorageKeys.organizationID);
      return res;
    } catch (err) {
      debugPrint(err.toString());
      return false;
    }
  }

  Future<bool> storeUserToken({required String userID}) async {
    try {
      await storeItem(key: StorageKeys.accessToken, value: userID);
      var res = await hasKey(key: StorageKeys.accessToken);
      return res;
    } catch (err) {
      debugPrint(err.toString());
      return false;
    }
  }

  Future<bool> storeUserID({required String userID}) async {
    try {
      await storeItem(key: StorageKeys.userID, value: userID);
      var res = await hasKey(key: StorageKeys.userID);
      return res;
    } catch (err) {
      debugPrint(err.toString());
      return false;
    }
  }

  Future<bool> storeUser({required Map<String, dynamic> user}) async {
    try {
      await storeItem(key: StorageKeys.user, value: jsonEncode(user));
      var res = await hasKey(key: StorageKeys.user);
      return res;
    } catch (err) {
      debugPrint(err.toString());
      return false;
    }
  }

  Future<String?> getAppID() async {
    try {
      var res = await readItem(key: StorageKeys.organizationID);
      return res;
    } catch (err) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getUser() async {
    try {
      var res = await readItem(key: StorageKeys.user);
      if(res == null){
        return null;
      }
      return jsonDecode(res);
    } catch (err) {
      return null;
    }
  }

  Future<String?> getUserToken() async {
    try {
      var res = await readItem(key: StorageKeys.accessToken);
      return res;
    } catch (err) {
      return null;
    }
  }

  Future<String?> getUserID() async {
    try {
      var res = await readItem(key: StorageKeys.userID);
      return res;
    } catch (err) {
      return null;
    }
  }
}

class StorageKeys {
  static String organizationID = "ORGANIZATION_ID";
  static String user = "USER_OBJECT";
  static String userID = "USER_ID";
  static String accessToken = "USER_TOKEN";
  static String userProfile = "USER_PROFILE";
}
