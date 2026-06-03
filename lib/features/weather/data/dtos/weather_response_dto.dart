import 'package:weather_app/features/weather/data/dtos/current_conditions_dto.dart';
import 'package:weather_app/features/weather/data/dtos/day_weather_dto.dart';
import 'package:weather_app/features/weather/domain/entities/weather_entity.dart';

class WeatherResponseDto {
  final String resolvedAddress;
  final String timezone;
  final double latitude;
  final double longitude;
  final CurrentConditionsDto? currentConditions;
  final List<DayWeatherDto> days;

  const WeatherResponseDto({
    required this.resolvedAddress,
    required this.timezone,
    required this.latitude,
    required this.longitude,
    required this.currentConditions,
    required this.days,
  }); 

  factory WeatherResponseDto.fromJson(Map<String, dynamic> json) {
    return WeatherResponseDto(
      resolvedAddress: json['resolvedAddress'] as String? ?? '',
      timezone: json['timezone'] as String? ?? '',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      currentConditions: json['currentConditions'] != null
          ? CurrentConditionsDto.fromJson(
            json['currentConditions'] as Map<String, dynamic>,
          )
          : null,
      days: (json['days'] as List<dynamic>)
          .map((day) => DayWeatherDto.fromJson(day as Map<String, dynamic>))
          .toList(),
    );
  }

  WeatherEntity toEntity() {
    return WeatherEntity(
      resolvedAddress: resolvedAddress,
      timezone: timezone,
      latitude: latitude,
      longitude: longitude,
      currentConditions: currentConditions?.toEntity(),
      days: days.map((day) => day.toEntity()).toList(),
    );
  }
}