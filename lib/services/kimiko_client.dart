import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:kimko_auth/services/base-api.service.dart';
import 'package:kimko_auth/services/kimiko_response.dart';

class KimikoClient {

  Future<KimikoResponse> login(String usernameOrEmail, String password) async {
    try {
      final response = await connect().post('/login', data: {
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
      final response = await  connect().post('/signup', data: {
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
      final response = await  connect().post('/logout', data: {
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
      final response = await  connect().get('/user/$userId');

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
      final response = await  connect().put('/user/$userId', data: {
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
      final response = await  connect().put('/user/$userId/image', data: {
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
      final response = await  connect().delete('/user/$userId');

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
