import 'package:apple_shop/util/auth_manager.dart';
import 'package:dio/dio.dart';

class DioProvider {
  Dio createDio() {
    Dio dio = Dio(
      BaseOptions(baseUrl: 'https://startflutter.ir/api/', headers: {
        "Content-Type": "application/json",
        "Authentication": "Bearer ${AuthManager.readAuth()}"
      }),
    );

    return dio;
  }

  Dio createDioWithoutHeader() {
    Dio dio = Dio(
      BaseOptions(
        baseUrl: 'https://startflutter.ir/api/',
      ),
    );

    return dio;
  }
}
