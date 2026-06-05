// lib/features/favorites/presentation/providers/favorites_provider.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:weather_app/features/events/domain/entities/event_entity.dart';
import 'package:weather_app/features/favorites/data/repositories/favorites_repository_impl.dart';
import 'package:weather_app/features/favorites/domain/repositories/i_favorites_repository.dart';

part 'favorites_provider.g.dart';

@riverpod
IFavoritesRepository favoritesRepository(FavoritesRepositoryRef ref) {
  return FavoritesRepositoryImpl();
}

@riverpod
class FavoritesNotifier extends _$FavoritesNotifier {
  @override
  List<EventEntity> build() {
    // Carga favoritos al iniciar desde Realm
    return ref.read(favoritesRepositoryProvider).getFavorites();
  }

  void toggleFavorite(EventEntity event) {
    final repo = ref.read(favoritesRepositoryProvider);
    final isFav = state.any((e) => e.id == event.id);

    if (isFav) {
      state = state.where((e) => e.id != event.id).toList();
      repo.removeFavorite(event.id);
    } else {
      state = [...state, event.copyWith(isFavorite: true)];
      repo.saveFavorite(event.copyWith(isFavorite: true));
    }
  }

  bool isFavorite(String id) => state.any((e) => e.id == id);
}