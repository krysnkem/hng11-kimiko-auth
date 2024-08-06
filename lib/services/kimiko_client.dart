import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:kimko_auth/services/api.dart';
import 'package:kimko_auth/services/base-api.service.dart';
import 'package:kimko_auth/services/kimiko_response.dart';

class KimikoClient {
  final Dio _dio;

  KimikoClient({required Dio connect}) : _dio = connect;

  Future<KimikoResponse> login(String usernameOrEmail, String password) async {
    try {
      final response = await _dio.post(Api.login, data: {
        'usernameOrEmail': usernameOrEmail,
        'password': password,
      });
      var apiResponse = jsonDecode(response.data);
      return KimikoResponse(data: apiResponse, statusCode: response.statusCode);
    } on DioException catch (e) {
      return KimikoResponse(
        error: "Failed to sign in",
        statusCode: e.response?.statusCode,
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
      return KimikoResponse(
        error: "Failed to sign up",
        statusCode: e.response?.statusCode,
      );
    }
  }

  Future<KimikoResponse> logout(String userId) async {
    try {
      final response = await _dio.post(Api.signup, data: {
        'userId': userId,
      });

      var apiResponse = jsonDecode(response.data);
      return KimikoResponse(data: apiResponse, statusCode: response.statusCode);
    } on DioException catch (e) {
      return KimikoResponse(
        error: "Failed to log out",
        statusCode: e.response?.statusCode,
      );
    }
  }

  Future<KimikoResponse> getUser(String userId) async {
    try {
      final response = await _dio.get('${Api.logout}/$userId');

      var apiResponse = jsonDecode(response.data);
      return KimikoResponse(data: apiResponse, statusCode: response.statusCode);
    } on DioException catch (e) {
      return KimikoResponse(
        error: "Failed to get user",
        statusCode: e.response?.statusCode,
      );
    }
  }

  Future<KimikoResponse> updateProfileDetails(
      String userId, String fullName) async {
    try {
      final response = await _dio.put('${Api.user}/$userId', data: {
        'fullName': fullName,
      });

      var apiResponse = jsonDecode(response.data);
      return KimikoResponse(data: apiResponse, statusCode: response.statusCode);
    } on DioException catch (e) {
      return KimikoResponse(
        error: "Failed to update profile details",
        statusCode: e.response?.statusCode,
      );
    }
  }

  Future<KimikoResponse> updateProfileImage(
      String userId, String profileImageUrl) async {
    try {
      final response = await _dio.put('${Api.user}/$userId/image', data: {
        'profileImageUrl': profileImageUrl,
      });

      var apiResponse = jsonDecode(response.data);
      return KimikoResponse(data: apiResponse, statusCode: response.statusCode);
    } on DioException catch (e) {
      return KimikoResponse(
        error: "Failed to update profile image",
        statusCode: e.response?.statusCode,
      );
    }
  }

  Future<KimikoResponse> deactivateAccount(String userId) async {
    try {
      final response = await _dio.delete('${Api.user}/$userId');

      var apiResponse = jsonDecode(response.data);
      return KimikoResponse(data: apiResponse, statusCode: response.statusCode);
    } on DioException catch (e) {
      return KimikoResponse(
        error: "Failed to deactivate account",
        statusCode: e.response?.statusCode,
      );
    }
  }
}
