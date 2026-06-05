import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/app.dart';
import 'package:weather_app/core/config/flavor_config.dart';
import 'package:weather_app/core/storage/local_db.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlavorConfig.instance = const FlavorConfig(
    flavor: Flavor.dev,
    appName: 'Weather Dev',
    baseUrl: 'https://weather.visualcrossing.com',
    apiKey: '5CXGVQTKX2D6ZKAJWTA5D2EXC',
  );

  await RealmDb.init();

  runApp(const ProviderScope(child: App()));
}
