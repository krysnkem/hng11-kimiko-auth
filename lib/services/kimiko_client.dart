import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:kimko_auth/constant/image.dart';
import 'package:kimko_auth/services/api.dart';
import 'package:kimko_auth/services/kimiko_exeception.dart';
import 'package:kimko_auth/services/kimiko_response.dart';
import 'package:kimko_auth/services/storage.service.dart';

class KimikoClient {
  final Dio _dio;

  KimikoClient({required Dio connect}) : _dio = connect;

  StorageService storageService = StorageService();

  Future<KimikoResponse> login(String email, String password) async {
    try {
      final response = await _dio.post(Api.login, data: {
        'email': email,
        'password': password,
      });
      var apiResponse = jsonDecode(response.data);

      await storageService.storeUserToken(userID: apiResponse['access_token']);
      await storageService.storeUserID(userID: apiResponse['data']['user']['id']);
      await storageService.storeUser(user: {
        "id": apiResponse['data']['user']['id'],
        "email": apiResponse['data']['user']['email'],
        "first_name": (apiResponse['data']['user']['fullName']??"  ").toString().split(" ").first,
        "last_name": (apiResponse['data']['user']['fullName']??"  ").toString().split(" ").last,
        "avatar_url": apiResponse['data']['user']['profileImageUrl'],
        "is_active": true,
        "team_id": await storageService.getAppID()
      });
      return KimikoResponse(data: apiResponse, statusCode: response.statusCode);
    } on DioException catch (e) {
      throw {
        "error": e.response?.data ?? e.error.toString() ?? "Login failed",
      };
    }
  }

  Future<KimikoResponse> signup(
      {required String username,
      required String email,
      required String password,
      String? firstName,
      String? lastName}) async {
    try {
      final response = await _dio.post(Api.signup, data: {
        "username": username,
        "email": email,
        "password": password,
        "first_name": firstName,
        "last_name": lastName,
        "avatar_url": getRandomImage()
      });
      var apiResponse = jsonDecode(response.data);
      return KimikoResponse(data: apiResponse, statusCode: response.statusCode);
    } on DioException catch (e) {
      throw {
        "error": e.response?.data ?? e.error.toString() ?? "Signup failed",
      };
    }
  }

  Future<KimikoResponse> updateUser({
      String? firstName,
      String? lastName,
      String? avatarUrl,
    }) async {
    try {

      var res = await storageService.getUser();
      final response = await _dio.patch(Api.updateUser, data: {
        "first_name": firstName?? res?["first_name"],
        "last_name": lastName ?? res?["last_name"],
        "avatar_url": avatarUrl ?? res?["avatar_url"]
      });
      var apiResponse = jsonDecode(response.data);
      await storageService.storeUser(user: {
        "id": res?["id"],
        "email": res?["email"],
        "first_name": firstName?? res?["first_name"],
        "last_name": lastName?? res?["last_name"],
        "avatar_url": avatarUrl ?? res?["avatar_url"],
        "is_active": res?["is_active"],
        "team_id": res?["team_id"]
      });
      return KimikoResponse(data: apiResponse, statusCode: response.statusCode);
    } on DioException catch (e) {
      throw {
        "error": e.response?.data ?? e.error.toString() ?? "Signup failed",
      };
    }
  }

  Future<KimikoResponse> logout() async {
    try {
      // final response = await _dio.get(Api.logout);
      // var apiResponse = jsonDecode(response.data);
      await Future.delayed(Duration(seconds: 1));
      await storageService.deleteItem(key: StorageKeys.accessToken);
      await storageService.deleteItem(key: StorageKeys.userProfile);
      await storageService.deleteItem(key: StorageKeys.userID);
      await storageService.deleteItem(key: StorageKeys.user);
      // return KimikoResponse(data: apiResponse, statusCode: response.statusCode);
      return KimikoResponse(data: {"message": "done"});
    } on DioException catch (e) {
      throw {
        "error":e.response?.data ?? e.error.toString() ?? "Logout failed",
      };
    }
  }

  Future<KimikoResponse> getUser() async {
    try {
      final response = await _dio.get(Api.user);
      var apiResponse = jsonDecode(response.data);

      return KimikoResponse(data: apiResponse, statusCode: response.statusCode);
    } on DioException catch (e) {
      throw {
        "error": e.response?.data ?? e.error.toString() ?? "Failed to get user",
      };
    }
  }

  Future<KimikoResponse> getCacheUser() async {
    try {
      Map<String, dynamic>? user = await storageService.getUser();
      if (user != null) {
        return KimikoResponse(data: user);
      } else {
        throw {
          "error":  "User not saved run \"kimkoAuth.getUser()\" first to fetch the user"
        };
      }
    } on DioException catch (e) {
      throw {
        "error": e.response?.data ?? e.error.toString() ?? "Failed to get user"
      };
    }
  }

  Future<KimikoResponse> updateProfileDetails(String fullName) async {
    String? userID = await storageService.getUserToken();
    try {
      final response = await _dio.put('${Api.user}/$userID', data: {
        'fullName': fullName,
      });
      var apiResponse = jsonDecode(response.data);
      return KimikoResponse(data: apiResponse, statusCode: response.statusCode);
    } on DioException catch (e) {
      throw KimikoException(
        error: e.response?.data ??
            e.error.toString() ??
            "Failed to update profile details",
      );
    }
  }

  Future<KimikoResponse> updateProfileImage(String profileImageUrl) async {
    String? userID = await storageService.getUserToken();
    try {
      final response = await _dio.put('${Api.user}/$userID/image', data: {
        'profileImageUrl': profileImageUrl,
      });
      var apiResponse = jsonDecode(response.data);
      return KimikoResponse(data: apiResponse, statusCode: response.statusCode);
    } on DioException catch (e) {
      throw {
        "error": e.response?.data ??
            e.error.toString() ??
            "Failed to update profile image",
      };
    }
  }

  Future<KimikoResponse> deactivateAccount() async {
    String? userID = await storageService.getUserToken();
    try {
      final response = await _dio.delete('${Api.user}/$userID');
      var apiResponse = jsonDecode(response.data);
      await storageService.deleteAllItems();
      return KimikoResponse(data: apiResponse, statusCode: response.statusCode);
    } on DioException catch (e) {
      throw {
        "error": e.response?.data ??
            e.error.toString() ??
            "Failed to deactivate account",
      };
    }
  }
}
