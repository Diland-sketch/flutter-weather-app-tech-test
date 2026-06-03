import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/core/config/flavor_config.dart';
import 'package:weather_app/core/network/api_interceptors.dart';

class ApiClient {
  final Dio _dio;

  ApiClient(this._dio);

  Dio get dio => _dio;

  factory ApiClient.create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: FlavorConfig.instance.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        listFormat: ListFormat.csv,
        headers: {
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.addAll([
      WeatherQueryParamsInterceptor(),
      LoggerInterceptor(),
    ]);
    return ApiClient(dio);
  }

  final apiClienteProvider = Provider<ApiClient>((ref){
    return ApiClient.create();
  });
}