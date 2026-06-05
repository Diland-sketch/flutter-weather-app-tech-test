import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/core/errors/app_exception.dart';
import 'package:weather_app/core/errors/failure.dart';
import 'package:weather_app/core/network/connectivity_service.dart';
import 'package:weather_app/features/events/data/datasources/events_local_datasource.dart';
import 'package:weather_app/features/events/data/datasources/events_remote_datasource.dart';
import 'package:weather_app/features/events/data/dtos/event_dto.dart';
import 'package:weather_app/features/events/data/dtos/event_response_dto.dart';
import 'package:weather_app/features/events/data/repositories/events_repository_impl.dart';
import 'package:weather_app/features/events/domain/entities/event_entity.dart';

import '../../../../helpers/test_fixtures.dart';

// ─── Mocks ────────────────────────────────────────────────────────────────────

class MockEventsRemoteDataSource extends Mock
    implements IEventsRemoteDataSource {}

class MockEventsLocalDataSource extends Mock
    implements IEventsLocalDataSource {}

class MockConnectivityService extends Mock implements ConnectivityService {}

// ─── Fake DTO para tests ──────────────────────────────────────────────────────

// Construimos un EventResponseDto real con EventDtos sin id
// (el id en EventResponseDto.toEntities() usa e.datetime como id)
final fakeEventDto1 = EventDto(
  type: 'hail',
  datetime: '2024-01-15T10:00:00',
  latitude: 4.6097,
  longitude: -74.0817,
  distance: 5.2,
  description: 'Granizo moderado',
  size: 1.5,
);

final fakeEventDto2 = EventDto(
  type: 'tornado',
  datetime: '2024-01-14T08:00:00',
  latitude: 6.2518,
  longitude: -75.5636,
  distance: 12.0,
  description: 'Tornado F1',
);

final fakeEventResponseDto = EventResponseDto(
  resolvedAddress: 'Bogota, Colombia',
  latitude: 4.6097,
  longitude: -74.0817,
  events: [fakeEventDto1, fakeEventDto2],
);

final fakeEmptyResponseDto = EventResponseDto(
  resolvedAddress: 'Bogota, Colombia',
  latitude: 4.6097,
  longitude: -74.0817,
  events: [],
);

// ─── Tests ────────────────────────────────────────────────────────────────────

void main() {
  late EventsRepositoryImpl repository;
  late MockEventsRemoteDataSource mockRemote;
  late MockEventsLocalDataSource mockLocal;
  late MockConnectivityService mockConnectivity;

  setUpAll(() {
    registerFallbackValue(fakeEventEntity);
    registerFallbackValue(<EventEntity>[]);
  });

  setUp(() {
    mockRemote = MockEventsRemoteDataSource();
    mockLocal = MockEventsLocalDataSource();
    mockConnectivity = MockConnectivityService();

    repository = EventsRepositoryImpl(
      remote: mockRemote,
      local: mockLocal,
      connectivity: mockConnectivity,
    );
  });

  const testLocation = 'Bogota, Colombia';

  group('EventsRepository - getEvents', () {
    group('con conexión a internet', () {
      setUp(() {
        when(() => mockConnectivity.isConnected)
            .thenAnswer((_) async => true);
        when(() => mockLocal.saveEvents(any(), any()))
            .thenAnswer((_) async {});
      });

      test('retorna lista de eventos cuando la API responde correctamente',
          () async {
        // Arrange
        when(() => mockRemote.getEvents(testLocation))
            .thenAnswer((_) async => fakeEventResponseDto);

        // Act
        final result = await repository.getEvents(testLocation);

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('No debería retornar failure'),
          (events) {
            expect(events.length, 2);
            expect(events.first.type, 'hail');
            expect(events.last.type, 'tornado');
          },
        );

        verify(() => mockLocal.saveEvents(testLocation, any())).called(1);
      });

      test('retorna lista vacía cuando la API no tiene eventos', () async {
        // Arrange
        when(() => mockRemote.getEvents(testLocation))
            .thenAnswer((_) async => fakeEmptyResponseDto);

        // Act
        final result = await repository.getEvents(testLocation);

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('No debería retornar failure'),
          (events) => expect(events, isEmpty),
        );
      });

      test('retorna ServerFailure cuando la API retorna error 500', () async {
        // Arrange
        when(() => mockRemote.getEvents(testLocation))
            .thenThrow(const ServerException(statusCode: 500));

        // Act
        final result = await repository.getEvents(testLocation);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure, isA<ServerFailure>());
            expect((failure as ServerFailure).statusCode, 500);
          },
          (_) => fail('No debería retornar datos'),
        );
      });

      test('retorna ParsingFailure cuando hay error de parseo', () async {
        // Arrange
        when(() => mockRemote.getEvents(testLocation))
            .thenThrow(const ParsingException());

        // Act
        final result = await repository.getEvents(testLocation);

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

      test('retorna eventos del caché cuando no hay conexión', () async {
        // Arrange — caché tiene eventos previos
        final cachedEvents = fakeEventResponseDto.toEntities();
        when(() => mockLocal.getCachedEvents(testLocation))
            .thenReturn(cachedEvents);

        // Act
        final result = await repository.getEvents(testLocation);

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Debería retornar caché'),
          (events) => expect(events.length, 2),
        );

        // Verifica que NO llamó a la API
        verifyNever(() => mockRemote.getEvents(any()));
      });

      test('retorna CacheFailure cuando no hay conexión ni caché', () async {
        // Arrange
        when(() => mockLocal.getCachedEvents(testLocation))
            .thenThrow(const CacheException());

        // Act
        final result = await repository.getEvents(testLocation);

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