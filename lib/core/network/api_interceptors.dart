import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart'; // para kDebugMode
import 'package:weather_app/core/config/flavor_config.dart';
import 'package:weather_app/core/constants/api_constants.dart';

class WeatherQueryParamsInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters.addAll({
      'unitGroup': ApiConstants.unitGroup,
      'lang': ApiConstants.language,
      'contentType': ApiConstants.contentType,
      'key': FlavorConfig.instance.apiKey,
    });

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {

    handler.next(err);
  }
}

/// Logger de requests y responses — solo activo en modo debug
class LoggerInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('🌐 REQUEST: ${options.method} ${options.uri}');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('✅ RESPONSE: ${response.statusCode} ${response.requestOptions.path}');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('❌ ERROR: ${err.response?.statusCode} ${err.message}');
    }
    handler.next(err);
  }
}