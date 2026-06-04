import 'dart:convert';

import 'package:weather_app/core/errors/app_exception.dart';
import 'package:weather_app/core/storage/local_db.dart';
import 'package:weather_app/core/storage/realm_models/weather_cache.dart';
import 'package:weather_app/features/weather/data/dtos/current_conditions_dto.dart';
import 'package:weather_app/features/weather/data/dtos/day_weather_dto.dart';
import 'package:weather_app/features/weather/data/dtos/weather_response_dto.dart';

abstract interface class IWeatherRepository {
  Future<void> saveWeather(String location, WeatherResponseDto dto);
  WeatherResponseDto getCachedWeather(String location);
}

class WeatherLocalDataSourceImpl implements IWeatherRepository {
  @override
  WeatherResponseDto getCachedWeather(String location) {
    final realm = RealmDb.instance;
    final cache = realm.find<WeatherCache>(location);

    if (cache == null) {
      throw CacheException('No hay datos en caché para $location');
    }

    final daysRaw = jsonDecode(cache.daysJson) as List<dynamic>;
    final days = daysRaw
        .map((d) => DayWeatherDto.fromJson(d as Map<String, dynamic>))
        .toList();

    return WeatherResponseDto(
      resolvedAddress: cache.resolvedAddress,
      timezone: cache.timezone,
      latitude: cache.latitude,
      longitude: cache.longitude,
      currentConditions: cache.currentTemp != null
          ? CurrentConditionsDto(
              temp: cache.currentTemp!,
              feelsLike: cache.currentFeelsLike!,
              humidity: cache.currentHumidity!,
              windSpeed: cache.currentWindSpeed!,
              conditions: cache.currentConditions!,
              icon: cache.currentIcon!,
              datetime: cache.currentDatetime!,
            )
          : null,
      days: days,
    );
  }

  @override
  Future<void> saveWeather(String location, WeatherResponseDto dto) async {
    final realm = RealmDb.instance;

    final daysJson = jsonEncode(
      dto.days.map((d) => {
        'datetime': d.datetime,
        'tempmax': d.tempMax,
        'tempmin': d.tempMin,
        'temp': d.temp,
        'humidity': d.humidity,
        'precipprob': d.precipProb,
        'conditions': d.conditions,
        'description': d.description,
        'icon': d.icon,
        'preciptype': d.precipType,
      }).toList(),
    );

    final cache = WeatherCache(
      location,
      dto.resolvedAddress,
      dto.timezone,
      dto.latitude,
      dto.longitude,
      daysJson,
      DateTime.now(),
      currentTemp: dto.currentConditions?.temp,
      currentFeelsLike: dto.currentConditions?.feelsLike,
      currentHumidity: dto.currentConditions?.humidity,
      currentWindSpeed: dto.currentConditions?.windSpeed,
      currentConditions: dto.currentConditions?.conditions,
      currentIcon: dto.currentConditions?.icon,
      currentDatetime: dto.currentConditions?.datetime,
    );

    realm.write(() {
      realm.add<WeatherCache>(cache, update: true);
    });
  }

}