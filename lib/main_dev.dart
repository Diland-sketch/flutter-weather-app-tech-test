import 'package:flutter/material.dart';
import 'package:weather_app/app.dart';
import 'package:weather_app/core/config/flavor_config.dart';

void main() {
  FlavorConfig.instance = const FlavorConfig(
    flavor: Flavor.dev,
    appName: 'Flutter Demo (Dev)',
    baseUrl: 'https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/',
    apiKey: 'dev-api-key',
  );
  runApp(const App());
}