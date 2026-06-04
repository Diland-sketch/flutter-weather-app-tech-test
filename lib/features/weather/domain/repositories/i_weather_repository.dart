import 'package:fpdart/fpdart.dart';
import 'package:weather_app/core/errors/failure.dart';
import 'package:weather_app/features/weather/domain/entities/weather_entity.dart';

abstract interface class IWeatherRepository {
  Future<Either<Failure, WeatherEntity>> getWeather(String location);
}