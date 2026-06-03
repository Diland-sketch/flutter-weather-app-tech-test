import 'package:weather_app/features/weather/domain/entities/current_conditions_entity.dart';
import 'package:weather_app/features/weather/domain/entities/day_forecast_entity.dart';

class WeatherEntity {
  final String resolvedAddress;
  final String timezone;
  final double latitude;
  final double longitude;
  final CurrentConditionsEntity? currentConditions;
  final List<DayForecastEntity> days;

  const WeatherEntity({
    required this.resolvedAddress,
    required this.timezone,
    required this.latitude,
    required this.longitude,
    required this.currentConditions,
    required this.days,
  });
}