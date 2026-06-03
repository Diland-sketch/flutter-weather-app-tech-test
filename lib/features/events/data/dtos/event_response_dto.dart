import 'package:weather_app/features/events/data/dtos/event_dto.dart';
import 'package:weather_app/features/events/domain/entities/event_entity.dart';

class EventResponseDto {
  final String resolvedAddress;
  final double latitude;
  final double longitude;
  final List<EventDto> events;

  const EventResponseDto({
    required this.resolvedAddress,
    required this.latitude,
    required this.longitude,
    required this.events,
  });

  factory EventResponseDto.fromJson(Map<String, dynamic> json){
    final days = json['days'] as List<dynamic>? ?? [];

    final allEvents = days
        .expand((day) {
          final dayEvents = day['events'] as List<dynamic>? ?? [];
          return dayEvents.map(
            (e) => EventDto.fromJson(e as Map<String, dynamic>),
          );  
        })
        .toList();

    return EventResponseDto(
      resolvedAddress: json['resolvedAddress'] as String? ?? '',
      latitude: json['latitude'] as double? ?? 0.0,
      longitude: json['longitude'] as double? ?? 0.0,
      events: allEvents,
    );
  }

  List<EventEntity> toEntities() {
    return events.map((e) => e.toEntity(e.datetime)).toList();
  }
}