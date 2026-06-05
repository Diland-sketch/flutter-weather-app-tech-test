import 'package:weather_app/features/events/data/dtos/event_dto.dart';
import 'package:weather_app/features/events/domain/entities/event_entity.dart';
import 'package:weather_app/features/weather/data/dtos/current_conditions_dto.dart';
import 'package:weather_app/features/weather/data/dtos/day_weather_dto.dart';
import 'package:weather_app/features/weather/data/dtos/weather_response_dto.dart';

/// Fixtures — datos de prueba reutilizables en todos los tests.
/// Centralizarlos aquí evita duplicar datos en cada archivo de test.

// ─── Weather fixtures ─────────────────────────────────────────────────────────

final fakeCurrentConditionsDto = CurrentConditionsDto(
  temp: 18.0,
  feelsLike: 16.0,
  humidity: 75.0,
  windSpeed: 12.0,
  conditions: 'Parcialmente nublado',
  icon: 'partly-cloudy-day',
  datetime: '2024-01-15T12:00:00',
);

final fakeDayDto = DayWeatherDto(
  datetime: '2024-01-15',
  tempMax: 22.0,
  tempMin: 14.0,
  temp: 18.0,
  humidity: 75.0,
  windSpeed: 12.0,
  precipProb: 20.0,
  conditions: 'Parcialmente nublado',
  description: 'Dia parcialmente nublado',
  icon: 'partly-cloudy-day',
);

final fakeWeatherDto = WeatherResponseDto(
  resolvedAddress: 'Bogota, Colombia',
  timezone: 'America/Bogota',
  latitude: 4.6097,
  longitude: -74.0817,
  currentConditions: fakeCurrentConditionsDto,
  days: [fakeDayDto],
);

final fakeWeatherEntity = fakeWeatherDto.toEntity();

// ─── Events fixtures ──────────────────────────────────────────────────────────

final fakeEventEntity = EventEntity(
  id: 'event-001',
  type: 'hail',
  datetime: '2024-01-15T10:00:00',
  latitude: 4.6097,
  longitude: -74.0817,
  distance: 5.2,
  description: 'Granizo moderado reportado',
  size: 1.5,
);

final fakeEventEntity2 = EventEntity(
  id: 'event-002',
  type: 'tornado',
  datetime: '2024-01-14T08:00:00',
  latitude: 6.2518,
  longitude: -75.5636,
  distance: 12.0,
  description: 'Tornado de categoria F1',
);