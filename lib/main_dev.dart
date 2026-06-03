import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/app.dart';
import 'package:weather_app/core/config/flavor_config.dart';
import 'package:weather_app/core/storage/local_db.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await RealmDb.init();
    print('✅ Realm inicializado correctamente');
  } catch (e, stack) {
    print('❌ Error inicializando Realm: $e');
    print(stack);
  }

  FlavorConfig.instance = const FlavorConfig(
    flavor: Flavor.dev,
    appName: 'Weather Dev',
    baseUrl: 'https://weather.visualcrossing.com',
    apiKey: 'dev-api-key',
  );

  runApp(const ProviderScope(child: App()));
}