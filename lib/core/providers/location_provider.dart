import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:weather_app/core/services/location_service.dart';

part 'location_provider.g.dart';

@riverpod
LocationService locationService(LocationServiceRef ref) {
  return LocationService();
}