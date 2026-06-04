// lib/features/weather/presentation/providers/weather_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:weather_app/core/network/api_client.dart';
import 'package:weather_app/core/network/connectivity_service.dart';
import 'package:weather_app/features/weather/data/datasources/weather_local_datasource.dart';
import 'package:weather_app/features/weather/data/datasources/weather_remote_datasource_impl.dart';
import 'package:weather_app/features/weather/data/repositories/weather_repository_impl.dart';
import 'package:weather_app/features/weather/domain/entities/weather_entity.dart';
import 'package:weather_app/features/weather/domain/repositories/i_weather_repository.dart';

part 'weather_provider.g.dart';

// Provider del repositorio — inyección de dependencias
@riverpod
IWeatherRepository weatherRepository(WeatherRepositoryRef ref) {
  return WeatherRepositoryImpl(
    remote: WeatherRemoteDataSourceImpl(ref.read(apiClientProvider)),
    local: WeatherLocalDataSourceImpl(),
    connectivity: ref.read(connectivityServiceProvider),
  );
}

// Notifier del estado del weather
@riverpod
class WeatherNotifier extends _$WeatherNotifier {
  @override
  FutureOr<WeatherEntity?> build() => null;

  Future<void> loadWeather(String location) async {
    state = const AsyncLoading();

    final result = await ref
        .read(weatherRepositoryProvider)
        .getWeather(location);

    state = result.fold(
      (failure) => AsyncError(failure, StackTrace.current),
      (weather) => AsyncData(weather),
    );
  }
}