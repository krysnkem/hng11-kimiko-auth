part of '../kimko_auth.dart';

Dio _connect() {
  StorageService storageService = StorageService();
  BaseOptions options = BaseOptions(
      baseUrl: Api.baseUrl,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      responseType: ResponseType.plain);
  Dio dio = Dio(options);
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {

        String? token = await storageService.getUserToken();
        if(token != null){
          options.headers['Authorization'] = "Bearer $token";
        }
        options.headers['teamId'] = await storageService.getAppID();
        options.headers['appId'] = (await PackageInfo.fromPlatform()).packageName;
        // options.headers['appId'] = "io.king.kimko_auth_example";

        debugPrint(jsonEncode(options.headers));

        debugPrint(options.uri.path);
        debugPrint(options.data.toString());
        debugPrint(options.baseUrl);

        return handler.next(options);
      },
      onResponse: (response, handler) async {
        // debugPrint("SERVER RESPONSE::: ${response.data}");
        return handler.next(response);
      },
      onError: (DioException e, handler) async {
        // debugPrint(e.response?.statusCode.toString());
        // debugPrint(e.response?.data);
        // debugPrint(e.response?.statusMessage);

        return handler.next(e);
      },
    ),
  );

  return dio;
}
