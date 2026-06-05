import 'package:realm/realm.dart';
import 'package:weather_app/core/storage/realm_models/event_cache.dart';
import 'package:weather_app/core/storage/realm_models/weather_cache.dart';

class RealmDb {
  static Realm? _realm;

  static Realm get instance {
    if (_realm == null) {
      throw StateError('RealmDb no ha sido inicializado. Llama a RealmDb.init() primero.');
    }
    return _realm!;
  }

  static Future<void> init() async {
    final config = Configuration.local(
      [
        WeatherCache.schema,
        EventCache.schema,
      ],
      schemaVersion: 1,
      migrationCallback: (migration, oldVersion){
        // Manejo de migraciones
      },
    );
    _realm = Realm(config);
  }

  static void close() {
    _realm?.close();
    _realm = null;
  }
}