import 'package:weather_app/features/events/data/dtos/event_response_dto.dart';

abstract interface class IEventsRemoteDataSource {
  Future<EventResponseDto> getEvents(String location);
}