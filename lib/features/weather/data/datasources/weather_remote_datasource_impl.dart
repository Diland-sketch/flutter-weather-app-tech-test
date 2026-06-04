import 'package:dio/dio.dart';
import 'package:weather_app/core/constants/api_constants.dart';
import 'package:weather_app/core/errors/app_exception.dart';
import 'package:weather_app/core/network/api_client.dart';
import 'package:weather_app/features/weather/data/datasources/weather_remote_datasource.dart';
import 'package:weather_app/features/weather/data/dtos/weather_response_dto.dart';

class WeatherRemoteDataSourceImpl implements IWeatherRemoteDataSource {

  final ApiClient _apiClient;

  const WeatherRemoteDataSourceImpl(this._apiClient);

  @override
  Future<WeatherResponseDto> getWeather(
    String location, {
    String period = ApiConstants.last5Days,
    }) async {
    try {
      final path = period.isEmpty
          ? '${ApiConstants.baseUrl}/$location'
          : '${ApiConstants.baseUrl}/$location/$period';

      final response = await _apiClient.dio.get(
        path,
        queryParameters: {
          'include': ApiConstants.includeWeather,
        }
      );
      return WeatherResponseDto.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      _handleDioException(e);
    } catch (e) {
      throw ParsingException('Error procesando respuesta: $e');
    }
  }

  Never _handleDioException(DioException e){
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.connectionError:
        throw NetworkException('Error de conexión. Por favor, verifica tu conexión a internet.');

      case DioExceptionType.badResponse:
        throw ServerException(
          statusCode: e.response?.statusCode,
          message: 'Error del servidor: ${e.response?.statusMessage}',
        );
      
      default:
        throw NetworkException('Error de conexión desconocido: ${e.message}');
    }
  }
}