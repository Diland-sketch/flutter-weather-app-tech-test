import 'package:weather_app/features/weather/domain/entities/current_conditions_entity.dart';

class CurrentConditionsDto {
  final double temp;
  final double feelsLike;
  final double humidity;
  final double windSpeed;
  final String conditions;
  final String icon;
  final String datetime;

  const CurrentConditionsDto({
    required this.temp,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.conditions,
    required this.icon,
    required this.datetime,
  });

  factory CurrentConditionsDto.fromJson(Map<String, dynamic> json) {
    return CurrentConditionsDto(
      temp: (json['temp'] as num?)?.toDouble() ?? 0.0,
      feelsLike: (json['feelslike'] as num?)?.toDouble() ?? 0.0,
      humidity: (json['humidity'] as num?)?.toDouble() ?? 0.0,
      windSpeed: (json['windspeed'] as num?)?.toDouble() ?? 0.0,
      conditions: json['conditions'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
      datetime: json['datetime'] as String? ?? '',
    );
  }

  CurrentConditionsEntity toEntity() {
    return CurrentConditionsEntity(
      temp: temp,
      feelsLike: feelsLike,
      humidity: humidity,
      windSpeed: windSpeed,
      conditions: conditions,
      icon: icon,
      datetime: datetime,
    );
  }
}
