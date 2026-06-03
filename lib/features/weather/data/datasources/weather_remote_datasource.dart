import 'package:weather_app/features/weather/data/dtos/weather_response_dto.dart';

abstract interface class IWeatherRemoteDataSource {
  Future<WeatherResponseDto> getWeather(String location);
}