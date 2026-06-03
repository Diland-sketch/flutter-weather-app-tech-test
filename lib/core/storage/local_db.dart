import 'package:realm/realm.dart';

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
        /* modelos aquí */
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