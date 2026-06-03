import 'package:flutter/material.dart';
import 'package:weather_app/app.dart';
import 'package:weather_app/core/config/flavor_config.dart';

void main() {
  FlavorConfig.instance = const FlavorConfig(
    flavor: Flavor.prod,
    appName: 'Flutter Demo (Prod)',
    baseUrl: 'https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/',
    apiKey: 'prod-api-key',
  );
  runApp(const App());
}