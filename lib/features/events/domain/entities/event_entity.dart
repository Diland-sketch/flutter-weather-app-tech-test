class EventEntity {
  final String id;
  final String type;
  final String datetime;
  final double latitude;
  final double longitude;
  final double distance;
  final String? description;
  final double? size;
  final bool isFavorite;

  const EventEntity({
    required this.id,
    required this.type,
    required this.datetime,
    required this.latitude,
    required this.longitude,
    required this.distance,
    this.description,
    this.size,
    this.isFavorite = false,
  });

  EventEntity copyWith({bool? isFavorite}) {
    return EventEntity(
      id: id,
      type: type,
      datetime: datetime,
      latitude: latitude,
      longitude: longitude,
      distance: distance,
      description: description,
      size: size,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}