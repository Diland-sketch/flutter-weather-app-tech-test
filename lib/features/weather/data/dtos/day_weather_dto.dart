import 'package:weather_app/features/weather/domain/entities/day_forecast_entity.dart';

class DayWeatherDto {
  final String datetime;
  final double tempMax;
  final double tempMin;
  final double temp;
  final double humidity;
  final double windSpeed;
  final double precipProb;
  final String conditions;
  final String description;
  final String icon;
  final List<String>? precipType;

  const DayWeatherDto({
    required this.datetime,
    required this.tempMax,
    required this.tempMin,
    required this.temp,
    required this.humidity,
    required this.windSpeed,
    required this.precipProb,
    required this.conditions,
    required this.description,
    required this.icon,
    this.precipType,
  });

  factory DayWeatherDto.fromJson(Map<String, dynamic> json) {
    return DayWeatherDto(
      datetime: json['datetime'] as String,
      tempMax: (json['tempmax'] as num).toDouble(),
      tempMin: (json['tempmin'] as num).toDouble(),
      temp: (json['temp'] as num).toDouble(),
      humidity: (json['humidity'] as num).toDouble(),
      windSpeed: (json['windspeed'] as num).toDouble(),
      precipProb: (json['precipprob'] as num).toDouble(),
      conditions: json['conditions'] as String? ?? '',
      description: json['description'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
      precipType: (json['preciptype'] != null
          ? List<String>.from(json['preciptype'] as List)
          : null),
    );
  }

  DayForecastEntity toEntity() {
    return DayForecastEntity(
      datetime: datetime,
      tempMax: tempMax,
      tempMin: tempMin,
      temp: temp,
      humidity: humidity,
      windSpeed: windSpeed,
      precipProb: precipProb,
      conditions: conditions,
      description: description,
      icon: icon,
      precipType: precipType,
    );
  }
}