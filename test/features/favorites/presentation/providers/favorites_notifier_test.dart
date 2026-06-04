import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/features/favorites/domain/repositories/i_favorites_repository.dart';
import 'package:weather_app/features/favorites/presentation/providers/favorites_provider.dart';

import '../../../../helpers/test_fixtures.dart';

// ─── Mock ─────────────────────────────────────────────────────────────────────

class MockFavoritesRepository extends Mock implements IFavoritesRepository {}

// ─── Tests ────────────────────────────────────────────────────────────────────

void main() {

  setUpAll(() {
    registerFallbackValue(fakeEventEntity);
  });

  late ProviderContainer container;
  late MockFavoritesRepository mockRepo;

  setUp(() {
    mockRepo = MockFavoritesRepository();

    // Retorna lista vacía al iniciar
    when(() => mockRepo.getFavorites()).thenReturn([]);
    when(() => mockRepo.saveFavorite(any())).thenAnswer((_) async {});
    when(() => mockRepo.removeFavorite(any())).thenAnswer((_) async {});

    // ProviderContainer permite testear providers sin Flutter
    container = ProviderContainer(
      overrides: [
        // Reemplazamos el repositorio real por el mock
        favoritesRepositoryProvider.overrideWithValue(mockRepo),
      ],
    );
  });

  tearDown(() => container.dispose());

  group('FavoritesNotifier', () {
    test('inicia con lista vacía', () {
      final state = container.read(favoritesNotifierProvider);
      expect(state, isEmpty);
    });

    test('toggleFavorite agrega evento cuando no está en favoritos', () {
      // Act
      container
          .read(favoritesNotifierProvider.notifier)
          .toggleFavorite(fakeEventEntity);

      // Assert
      final state = container.read(favoritesNotifierProvider);
      expect(state.length, 1);
      expect(state.first.id, fakeEventEntity.id);
      expect(state.first.isFavorite, true);

      // Verifica que se persistió
      verify(() => mockRepo.saveFavorite(any())).called(1);
    });

    test('toggleFavorite elimina evento cuando ya está en favoritos', () {
      // Arrange — primero lo agregamos
      container
          .read(favoritesNotifierProvider.notifier)
          .toggleFavorite(fakeEventEntity);

      // Act — lo quitamos
      container
          .read(favoritesNotifierProvider.notifier)
          .toggleFavorite(fakeEventEntity);

      // Assert
      final state = container.read(favoritesNotifierProvider);
      expect(state, isEmpty);

      verify(() => mockRepo.removeFavorite(fakeEventEntity.id)).called(1);
    });

    test('isFavorite retorna true para evento guardado', () {
      // Arrange
      container
          .read(favoritesNotifierProvider.notifier)
          .toggleFavorite(fakeEventEntity);

      // Act & Assert
      final result = container
          .read(favoritesNotifierProvider.notifier)
          .isFavorite(fakeEventEntity.id);

      expect(result, true);
    });

    test('isFavorite retorna false para evento no guardado', () {
      final result = container
          .read(favoritesNotifierProvider.notifier)
          .isFavorite('id-inexistente');

      expect(result, false);
    });

    test('puede manejar múltiples favoritos independientemente', () {
      // Arrange & Act
      container
          .read(favoritesNotifierProvider.notifier)
          .toggleFavorite(fakeEventEntity);
      container
          .read(favoritesNotifierProvider.notifier)
          .toggleFavorite(fakeEventEntity2);

      // Assert
      final state = container.read(favoritesNotifierProvider);
      expect(state.length, 2);
    });
  });
}