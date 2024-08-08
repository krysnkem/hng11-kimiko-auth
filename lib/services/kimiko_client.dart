import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:kimko_auth/constant/image.dart';
import 'package:kimko_auth/services/api.dart';
import 'package:kimko_auth/services/kimiko_exeception.dart';
import 'package:kimko_auth/services/kimiko_response.dart';
import 'package:kimko_auth/services/kimiko_user.dart';
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
      await storageService.storeUserID(
          userID: apiResponse['data']['user']['id']);
      await storageService.storeUser(user: apiResponse['data']['user']);

      final data = KimikoUser.fromJson(apiResponse);
      return KimikoResponse(data: data, statusCode: response.statusCode);
    } on DioException catch (e) {
      print(e);
      throw KimikoException(
        error: e.response?.data ?? e.error.toString() ?? "Login failed",
      );
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

      final data = KimikoUser.fromJson(apiResponse);

      return KimikoResponse(data: data, statusCode: response.statusCode);
    } on DioException catch (e) {
      throw KimikoException(
        error: e.response?.data ?? e.error.toString() ?? "Signup failed",
      );
    }
  }

  Future<KimikoResponse> logout() async {
    String? userID = await storageService.getUserToken();
    try {
      final response = await _dio.post(Api.logout, data: {
        'userId': userID,
      });
      var apiResponse = jsonDecode(response.data);
      await storageService.deleteAllItems();
      return KimikoResponse(data: apiResponse, statusCode: response.statusCode);
    } on DioException catch (e) {
      throw KimikoException(
        error: e.response?.data ?? e.error.toString() ?? "Logout failed",
      );
    }
  }

  Future<KimikoResponse> getUser() async {
    String? userID = await storageService.getUserID();
    try {
      final response = await _dio.get(Api.user);
      var apiResponse = jsonDecode(response.data);
      // var res = await storageService.storeUser(user: apiResponse);
      // print("Is user saved::::: $res");
      print(apiResponse);
      return KimikoResponse(data: apiResponse, statusCode: response.statusCode);
    } on DioException catch (e) {
      throw KimikoException(
        error: e.response?.data ?? e.error.toString() ?? "Failed to get user",
      );
    }
  }

  Future<KimikoResponse> getCacheUser() async {
    try {
      Map<String, dynamic>? user = await storageService.getUser();
      if (user != null) {
        final data = KimikoUser.fromJson(user);
        return KimikoResponse(data: data);
      } else {
        return KimikoResponse(
          error: "User not saved",
          data: null,
        );
      }
    } on DioException catch (e) {
      throw KimikoException(
        error: e.response?.data ?? e.error.toString() ?? "Failed to get user",
      );
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
      throw KimikoException(
        error: e.response?.data ??
            e.error.toString() ??
            "Failed to update profile image",
      );
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
      throw KimikoException(
        error: e.response?.data ??
            e.error.toString() ??
            "Failed to deactivate account",
      );
    }
  }
}
