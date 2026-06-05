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
      final encondeLocation = Uri.encodeComponent(location);

      final response = await _apiClient.dio.get(
        '${ApiConstants.baseUrl}/$encondeLocation/${ApiConstants.last30Days}',
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
        throw NetworkException(
          'Sin conexión. Verifica tu internet',
        );
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final body = e.response?.data;

        final apiMessage = body is String && body.isNotEmpty
            ? body
            : 'Error del servidor ($statusCode)';

        throw ServerException(statusCode: e.response?.statusCode, message: apiMessage);
      default:
        throw NetworkException('Error inesperado: ${e.message}');
    }
  }
}