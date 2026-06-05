import 'package:realm/realm.dart';

part 'weather_cache.realm.dart';

@RealmModel()
class _WeatherCache {
  @PrimaryKey()
  late String id;

  late String resolvedAddress;
  late String timezone;
  late double latitude;
  late double longitude;

  late double? currentTemp;
  late double? currentFeelsLike;
  late double? currentHumidity;
  late double? currentWindSpeed;
  late String? currentConditions;
  late String? currentIcon;
  late String? currentDatetime;

  late String daysJson;

  late DateTime cachedAt;
}