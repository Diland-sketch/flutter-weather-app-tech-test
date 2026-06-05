import 'package:weather_app/features/events/domain/entities/event_entity.dart';

abstract interface class IFavoritesRepository {
  List<EventEntity> getFavorites();
  Future<void> saveFavorite(EventEntity event);
  Future<void> removeFavorite(String id);
  bool isFavorite(String id);
}