import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

Dio connect({bool? useFormData}) {
  BaseOptions options = BaseOptions(
      baseUrl: "https://taskitly.com/api/",
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      responseType: ResponseType.plain);
  Dio dio = Dio(options);
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        debugPrint(options.uri.path);
        debugPrint(options.baseUrl);
        return handler.next(options);
      },
      onResponse: (response, handler) async {
        debugPrint("SERVER RESPONSE::: ${response.data}");
        return handler.next(response);
      },
      onError: (DioException e, handler) async {
        debugPrint(e.response?.statusCode.toString());
        debugPrint(e.response?.data);
        debugPrint(e.response?.statusMessage);

        return handler.next(e);
      },
    ),
  );

  return dio;
}
