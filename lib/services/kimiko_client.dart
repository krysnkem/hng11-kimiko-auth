import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:kimko_auth/services/api.dart';
import 'package:kimko_auth/services/kimiko_exeception.dart';
import 'package:kimko_auth/services/kimiko_response.dart';
import 'package:kimko_auth/services/storage.service.dart';

class KimikoClient {
  final Dio _dio;

  KimikoClient({required Dio connect}) : _dio = connect;

  StorageService storageService = StorageService();

  Future<KimikoResponse> login(String usernameOrEmail, String password) async {
    try {
      final response = await _dio.post(Api.login, data: {
        'usernameOrEmail': usernameOrEmail,
        'password': password,
      });
      var apiResponse = jsonDecode(response.data);
      // Store the user ID once successful
      await storageService.storeUserID(userID: apiResponse['user']['id']);
      return KimikoResponse(data: apiResponse, statusCode: response.statusCode);
    } on DioException catch (e) {
      throw KimikoException(
        error: e.response?.data ?? e.error.toString() ?? "Login failed",
      );
    }
  }

  Future<KimikoResponse> signup(
      String username, String email, String password) async {
    try {
      final response = await _dio.post(Api.signup, data: {
        'username': username,
        'email': email,
        'password': password,
      });
      var apiResponse = jsonDecode(response.data);
      return KimikoResponse(data: apiResponse, statusCode: response.statusCode);
    } on DioException catch (e) {
      throw KimikoException(
        error: e.response?.data ?? e.error.toString() ?? "Signup failed",
      );
    }
  }

  Future<KimikoResponse> logout() async {
    String? userID = await storageService.getUserID();
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
      final response = await _dio.get('${Api.user}/$userID');
      var apiResponse = jsonDecode(response.data);
      return KimikoResponse(data: apiResponse, statusCode: response.statusCode);
    } on DioException catch (e) {
      throw KimikoException(
        error: e.response?.data ?? e.error.toString() ?? "Failed to get user",
      );
    }
  }

  Future<KimikoResponse> updateProfileDetails(String fullName) async {
    String? userID = await storageService.getUserID();
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
    String? userID = await storageService.getUserID();
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
    String? userID = await storageService.getUserID();
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
