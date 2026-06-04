import 'package:realm/realm.dart';
import 'package:weather_app/core/errors/app_exception.dart';
import 'package:weather_app/core/storage/local_db.dart';
import 'package:weather_app/core/storage/realm_models/event_cache.dart';
import 'package:weather_app/features/events/domain/entities/event_entity.dart';

abstract interface class IEventsLocalDataSource {
  Future<void> saveEvents(String location, List<EventEntity> events);
  List<EventEntity> getCachedEvents(String location);
}

class EventsLocalDataSourceImpl implements IEventsLocalDataSource {
  @override
  Future<void> saveEvents(String location, List<EventEntity> events) async {
    final realm = RealmDb.instance;
    realm.write(() {
      for (final event in events) {
        realm.add(
          EventCache(
            event.id,
            event.type,
            event.datetime,
            event.latitude,
            event.longitude,
            event.distance,
            event.isFavorite,
            location,
            description: event.description,
            size: event.size,
            
          ),
          update: true, // Actualiza si ya existe un evento con el mismo ID
        );
      }
    });
  }

  @override
  List<EventEntity> getCachedEvents(String location) {
    final realm = RealmDb.instance;
    final cached = realm
        .all<EventCache>()
        .query("location == '$location'")
        .toList();

    if (cached.isEmpty) {
      throw CacheException('No hay eventos en caché para $location');
    }

      return cached.map((cache) => EventEntity(
        id: cache.id,
        type: cache.type,
        datetime: cache.datetime,
        latitude: cache.latitude,
        longitude: cache.longitude,
        distance: cache.distance,
        description: cache.description,
        size: cache.size,
        isFavorite: cache.isFavorite,
      )).toList();
  }
}