class CurrentConditionsEntity {
  final double temp;
  final double feelsLike;
  final double humidity;
  final double windSpeed;
  final String conditions;
  final String icon;
  final String datetime;

  const CurrentConditionsEntity({
    required this.temp,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.conditions,
    required this.icon,
    required this.datetime,
  });
}