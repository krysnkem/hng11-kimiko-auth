import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:kimko_auth/data/network-config.dart';

connect({bool? useFormData}) {
  BaseOptions options = BaseOptions(
      baseUrl: NetworkConfig.baseUrl,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      responseType: ResponseType.plain);
  Dio dio = Dio(options);
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        debugPrint(options.uri.path);
        // final box = GetStorage();
        // String? value = box.read(DbTable.TOKEN_TABLE_NAME);
        // debugPrint("ACCESS TOKEN::: $value");
        // if (value != null && value.isNotEmpty) {
        //   options.headers['Authorization'] = "Bearer $value";
        //   if(useFormData == true){
        //     options.headers['Accept'] = "multipart/form-data";
        //     options.headers['Content-Type'] = "multipart/form-data";
        //   }
        // }
        return handler.next(options);
      },
      onResponse: (response, handler) async {
        debugPrint("SERVER RESPONSE::: ${response.data}");
        return handler.next(response);
      },
      onError: (DioError e, handler) async {
        debugPrint(e.response?.statusCode.toString());
        debugPrint(e.response?.data);
        debugPrint(e.response?.statusMessage);


        return handler.next(e);
      },
    ),
  );

  return dio;
}