import 'package:realm/realm.dart';
import 'package:weather_app/core/storage/local_db.dart';
import 'package:weather_app/core/storage/realm_models/event_cache.dart';
import 'package:weather_app/features/events/domain/entities/event_entity.dart';
import 'package:weather_app/features/favorites/domain/repositories/i_favorites_repository.dart';

class FavoritesRepositoryImpl implements IFavoritesRepository {
  @override
  List<EventEntity> getFavorites() {
    final realm = RealmDb.instance;
    return realm
        .all<EventCache>()
        .query('isFavorite == true')
        .map((c) => EventEntity(
              id: c.id,
              type: c.type,
              datetime: c.datetime,
              latitude: c.latitude,
              longitude: c.longitude,
              distance: c.distance,
              description: c.description,
              size: c.size,
              isFavorite: true,
            ))
        .toList();
  }

  @override
  Future<void> saveFavorite(EventEntity event) async {
    final realm = RealmDb.instance;
    final existing = realm.find<EventCache>(event.id);
    realm.write(() {
      if (existing != null) {
        existing.isFavorite = true;
      } else {
        realm.add(
          EventCache(
            event.id,
            event.type,
            event.datetime,
            event.latitude,
            event.longitude,
            event.distance,
            true,
            '',
            description: event.description,
            size: event.size,
          ),
        );
      }
    });
  }

  @override
  Future<void> removeFavorite(String id) async {
    final realm = RealmDb.instance;
    final existing = realm.find<EventCache>(id);
    if (existing != null) {
      realm.write(() => existing.isFavorite = false);
    }
  }

  @override
  bool isFavorite(String id) {
    final realm = RealmDb.instance;
    return realm.find<EventCache>(id)?.isFavorite ?? false;
  }
}