class WeatherIconMapper {
  WeatherIconMapper._();

  static String toEmoji(String icon) {
    switch (icon) {
      case 'clear-day':
        return '☀️';
      case 'clear-night':
        return '🌙';
      case 'partly-cloudy-day':
        return '⛅';
      case 'partly-cloudy-night':
        return '🌤️';
      case 'cloudy':
        return '☁️';
      case 'rain':
        return '🌧️';
      case 'showers-day':
      case 'showers-night':
        return '🌦️';
      case 'thunder-rain':
      case 'thunder-showers-day':
      case 'thunder-showers-night':
        return '⛈️';
      case 'snow':
      case 'snow-showers-day':
      case 'snow-showers-night':
        return '❄️';
      case 'fog':
        return '🌫️';
      case 'wind':
        return '💨';
      case 'hail':
        return '🌨️';
      default:
        return '🌡️';
    }
  }
}