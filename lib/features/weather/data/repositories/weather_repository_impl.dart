import 'package:fpdart/src/either.dart';
import 'package:weather_app/core/constants/api_constants.dart';
import 'package:weather_app/core/errors/app_exception.dart';
import 'package:weather_app/core/errors/failure.dart';
import 'package:weather_app/core/network/connectivity_service.dart';
import 'package:weather_app/features/weather/data/datasources/weather_local_datasource.dart';
import 'package:weather_app/features/weather/data/datasources/weather_remote_datasource.dart';
import 'package:weather_app/features/weather/data/dtos/current_conditions_dto.dart';
import 'package:weather_app/features/weather/data/dtos/weather_response_dto.dart';
import 'package:weather_app/features/weather/domain/entities/weather_entity.dart';
import 'package:weather_app/features/weather/domain/repositories/i_weather_repository.dart';

class WeatherRepositoryImpl implements IWeatherRepository {
  final IWeatherRemoteDataSource _remote;
  final IWeatherLocalDataSource _local;
  final ConnectivityService _connectivity;

  const WeatherRepositoryImpl({
    required IWeatherRemoteDataSource remote,
    required IWeatherLocalDataSource local,
    required ConnectivityService connectivity,
  })  : _remote = remote,
        _local = local,
        _connectivity = connectivity;

  @override
  Future<Either<Failure, WeatherEntity>> getWeather(String location) async {
    final isConnected = await _connectivity.isConnected;

    if (!isConnected) {
      return _getCachedWeather(location);
    }

    try {
      final dto = await _remote.getWeather(
        location,
        period: ApiConstants.last5Days,
      );

      final resolved = _resolveCurrentConditions(dto);

      await _local.saveWeather(location, resolved).catchError((_) {});
      return Right(resolved.toEntity());
    } on NetworkException {
      return _getCachedWeather(location);
    } on ServerException catch (e) {
      return Left(ServerFailure(statusCode: e.statusCode));
    } on ParsingException {
      return Left(ParsingFailure());
    }
  }

  WeatherResponseDto _resolveCurrentConditions(WeatherResponseDto dto) {

    if (dto.currentConditions != null) return dto;
    if (dto.days.isEmpty) return dto;

    final latest = dto.days.last;

    final syntheticCurrent = CurrentConditionsDto(
      temp: latest.temp,
      feelsLike: latest.temp,
      humidity: latest.humidity,
      windSpeed: latest.windSpeed,
      conditions: latest.conditions,
      icon: latest.icon,
      datetime: latest.datetime,
    );

    return WeatherResponseDto(
        resolvedAddress: dto.resolvedAddress,
        timezone: dto.timezone,
        latitude: dto.latitude,
        longitude: dto.longitude,
        currentConditions: syntheticCurrent,
        days: dto.days);
  }

  Either<Failure, WeatherEntity> _getCachedWeather(String location) {
    try {
      final cached = _local.getCachedWeather(location);
      return Right(cached.toEntity());
    } on CacheException {
      return Left(CacheFailure('Sin conexión y sin datos guardados'));
    }
  }
}
