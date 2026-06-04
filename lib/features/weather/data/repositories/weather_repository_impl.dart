import 'package:fpdart/src/either.dart';
import 'package:weather_app/core/errors/app_exception.dart';
import 'package:weather_app/core/errors/failure.dart';
import 'package:weather_app/core/network/connectivity_service.dart';
import 'package:weather_app/features/weather/data/datasources/weather_local_datasource.dart';
import 'package:weather_app/features/weather/data/datasources/weather_remote_datasource.dart';
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
  }) : _remote = remote,
       _local = local,
       _connectivity = connectivity;

  @override
  Future<Either<Failure, WeatherEntity>> getWeather(String location) async {
    final isConnected = await _connectivity.isConnected;

    if (!isConnected) {
      return _getCachedWeather(location);
    }

    try {
      final dto = await _remote.getWeather(location);
      await _local.saveWeather(location, dto).catchError((_) {});
      return Right(dto.toEntity());
    } on NetworkFailure {
      return _getCachedWeather(location);
    } on ServerFailure catch(e) {
      return Left(ServerFailure(statusCode: e.statusCode));
    } on ParsingFailure {
      return Left(ParsingFailure());
    }
  }

  Either<Failure, WeatherEntity> _getCachedWeather(String location) {
    try{
      final cached = _local.getCachedWeather(location);
      return Right(cached.toEntity());
    } on CacheException {
      return Left(CacheFailure('Sin conexión y sin datos guardados'));
    }
  }

}