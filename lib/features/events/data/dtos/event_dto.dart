import 'package:weather_app/features/events/domain/entities/event_entity.dart';

class EventDto {
  final String type;
  final String datetime;
  final double latitude;
  final double longitude;
  final double distance;
  final String? description;
  final double? size;

  const EventDto({
    required this.type,
    required this.datetime,
    required this.latitude,
    required this.longitude,
    required this.distance,
    this.description,
    this.size,
  });

  factory EventDto.fromJson(Map<String, dynamic> json) {
    return EventDto(
      type: json['type'] as String? ?? 'unknown',
      datetime: json['datetime'] as String? ?? '',
      latitude: (json['latitude'] as num)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num)?.toDouble() ?? 0.0,
      distance: (json['distance'] as num)?.toDouble() ?? 0.0,
      description: json['description'] as String?,
      size: json['size'] != null ? (json['size'] as num)?.toDouble() : null,
    );
  }

  EventEntity toEntity(String id, {bool isFavorite = false}) {
    return EventEntity(
      id: id,
      type: type,
      datetime: datetime,
      latitude: latitude,
      longitude: longitude,
      distance: distance,
      description: description,
      size: size,
      isFavorite: isFavorite,
    );
  }
}