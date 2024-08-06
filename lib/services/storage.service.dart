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

  Future<bool> storeOrganizationID ({required String id}) async {
    try{
      await storeItem(key: StorageKeys.organizationID, value: id);
      var res = await hasKey(key: StorageKeys.organizationID);
      return res;
    }catch(err){
      debugPrint(err.toString());
      return false;
    }
  }

  Future<String?> getOrganizationID () async {
    try{
      var res = await readItem(key: StorageKeys.organizationID);
      return res;
    }catch(err){
      return null;
    }
  }


}


class StorageKeys {
  static String organizationID = "ORGANIZATION_ID";
  static String userProfile = "USER_PROFILE";
}