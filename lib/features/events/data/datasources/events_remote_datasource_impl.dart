import 'package:dio/dio.dart';
import 'package:weather_app/core/constants/api_constants.dart';
import 'package:weather_app/core/errors/app_exception.dart';
import 'package:weather_app/core/network/api_client.dart';
import 'package:weather_app/features/events/data/datasources/events_remote_datasource.dart';
import 'package:weather_app/features/events/data/dtos/event_response_dto.dart';

class EventsRemoteDatasourceImpl implements IEventsRemoteDataSource {

  final ApiClient _apiClient;

  const EventsRemoteDatasourceImpl(this._apiClient);

  @override
  Future<EventResponseDto> getEvents(String location) async {
    try {
      final response = await _apiClient.dio.get(
        '${ApiConstants.baseUrl}/$location/${ApiConstants.last30Days}',
        queryParameters: {
          'include': ApiConstants.includeEvents,
        },
      );

      return EventResponseDto.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      _handleDioException(e);
    } catch (e) {
      throw ParsingException('Error procesando eventos: $e');
    }
  }

  Never _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.connectionError:
        throw NetworkException();
      case DioExceptionType.badResponse:
        throw ServerException(statusCode: e.response?.statusCode);
      default:
        throw NetworkException('Error inesperado: ${e.message}');
    }
  }
}