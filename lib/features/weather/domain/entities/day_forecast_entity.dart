class DayForecastEntity {
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

  const DayForecastEntity({
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
}