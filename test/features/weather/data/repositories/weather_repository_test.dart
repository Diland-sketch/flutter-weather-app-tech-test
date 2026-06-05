import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:weather_app/core/constants/api_constants.dart';
import 'package:weather_app/core/errors/app_exception.dart';
import 'package:weather_app/core/errors/failure.dart';
import 'package:weather_app/core/network/connectivity_service.dart';
import 'package:weather_app/features/weather/data/datasources/weather_local_datasource.dart';
import 'package:weather_app/features/weather/data/datasources/weather_remote_datasource.dart';
import 'package:weather_app/features/weather/data/repositories/weather_repository_impl.dart';

import '../../../../helpers/test_fixtures.dart';

// ─── Mocks ────────────────────────────────────────────────────────────────────

class MockWeatherRemoteDataSource extends Mock
    implements IWeatherRemoteDataSource {}

class MockWeatherLocalDataSource extends Mock
    implements IWeatherLocalDataSource {}

class MockConnectivityService extends Mock implements ConnectivityService {}

// ─── Tests ────────────────────────────────────────────────────────────────────

void main() {
  late WeatherRepositoryImpl repository;
  late MockWeatherRemoteDataSource mockRemote;
  late MockWeatherLocalDataSource mockLocal;
  late MockConnectivityService mockConnectivity;

  // setUp se ejecuta antes de CADA test — estado limpio garantizado
  setUp(() {
    mockRemote = MockWeatherRemoteDataSource();
    mockLocal = MockWeatherLocalDataSource();
    mockConnectivity = MockConnectivityService();

    repository = WeatherRepositoryImpl(
      remote: mockRemote,
      local: mockLocal,
      connectivity: mockConnectivity,
    );
  });

  // Necesario para mocktail — registra el tipo de los argumentos
  setUpAll(() {
    registerFallbackValue(fakeWeatherDto);
  });

  const testLocation = 'Bogota, Colombia';

  group('WeatherRepository - getWeather', () {
    group('con conexión a internet', () {
      setUp(() {
        // Arrange común para este grupo
        when(() => mockConnectivity.isConnected)
            .thenAnswer((_) async => true);
        when(() => mockLocal.saveWeather(any(), any()))
            .thenAnswer((_) async {});
      });

      test('retorna WeatherEntity cuando la API responde correctamente',
          () async {
        // Arrange
        when(() => mockRemote.getWeather(
              testLocation,
              period: ApiConstants.last5Days,
            )).thenAnswer((_) async => fakeWeatherDto);

        // Act
        final result = await repository.getWeather(testLocation);

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('No debería retornar failure'),
          (weather) {
            expect(weather.resolvedAddress, 'Bogota, Colombia');
            expect(weather.currentConditions?.temp, 18.0);
            expect(weather.days.length, 1);
          },
        );

        // Verifica que se guardó en caché
        verify(() => mockLocal.saveWeather(testLocation, any())).called(1);
      });

      test('retorna ServerFailure cuando la API retorna error de servidor',
          () async {
        // Arrange
        when(() => mockRemote.getWeather(
              testLocation,
              period: any(named: 'period'),
            )).thenThrow(const ServerException(statusCode: 500));

        // Act
        final result = await repository.getWeather(testLocation);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<ServerFailure>()),
          (_) => fail('No debería retornar datos'),
        );
      });

      test('retorna ParsingFailure cuando hay error de parseo', () async {
        // Arrange
        when(() => mockRemote.getWeather(
              testLocation,
              period: any(named: 'period'),
            )).thenThrow(const ParsingException());

        // Act
        final result = await repository.getWeather(testLocation);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<ParsingFailure>()),
          (_) => fail('No debería retornar datos'),
        );
      });
    });

    group('sin conexión a internet', () {
      setUp(() {
        when(() => mockConnectivity.isConnected)
            .thenAnswer((_) async => false);
      });

      test('retorna datos del caché cuando no hay conexión', () async {
        // Arrange
        when(() => mockLocal.getCachedWeather(testLocation))
            .thenReturn(fakeWeatherDto);

        // Act
        final result = await repository.getWeather(testLocation);

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Debería retornar caché'),
          (weather) => expect(weather.resolvedAddress, 'Bogota, Colombia'),
        );

        // Verifica que NO llamó a la API
        verifyNever(() => mockRemote.getWeather(any()));
      });

      test('retorna CacheFailure cuando no hay conexión ni caché', () async {
        // Arrange
        when(() => mockLocal.getCachedWeather(testLocation))
            .thenThrow(const CacheException());

        // Act
        final result = await repository.getWeather(testLocation);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<CacheFailure>()),
          (_) => fail('No debería retornar datos'),
        );
      });
    });
  });
}