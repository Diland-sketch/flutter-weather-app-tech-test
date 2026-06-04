import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app/core/router/app_router.dart';
import 'package:weather_app/core/theme/app_colors.dart';
import 'package:weather_app/features/events/domain/entities/event_entity.dart';
import 'package:weather_app/features/favorites/presentation/providers/favorites_provider.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // FavoritesNotifier es síncrono (List<EventEntity>, no AsyncValue)
    // porque Realm es lectura local inmediata
    final favorites = ref.watch(favoritesNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        title: const Text(
          'Favoritos',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          if (favorites.isNotEmpty)
            TextButton.icon(
              onPressed: () => _confirmClearAll(context, ref),
              icon: const Icon(Icons.delete_outline, color: Colors.white70, size: 18),
              label: const Text(
                'Limpiar',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ),
        ],
      ),
      body: favorites.isEmpty
          ? const _EmptyFavoritesView()
          : _FavoritesList(favorites: favorites),
    );
  }

  void _confirmClearAll(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        title: const Text(
          'Limpiar favoritos',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          '¿Eliminar todos los eventos guardados?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              // Eliminamos uno por uno usando el notifier
              final events = ref.read(favoritesNotifierProvider);
              for (final e in events) {
                ref.read(favoritesNotifierProvider.notifier).toggleFavorite(e);
              }
            },
            child: const Text(
              'Eliminar',
              style: TextStyle(color: Color(0xFFE53935)),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Vista vacía ──────────────────────────────────────────────────────────────

class _EmptyFavoritesView extends StatelessWidget {
  const _EmptyFavoritesView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: Colors.white.withOpacity(0.15),
          ),
          const SizedBox(height: 20),
          const Text(
            'Sin favoritos aún',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Guarda eventos desde la pestaña Eventos',
            style: TextStyle(color: Colors.white38, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

// ─── Lista de favoritos ───────────────────────────────────────────────────────

class _FavoritesList extends ConsumerWidget {
  final List<EventEntity> favorites;

  const _FavoritesList({required this.favorites});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final event = favorites[index];
        return _FavoriteCard(
          event: event,
          onTap: () => context.push(
            '${AppRoutes.events}/${AppRoutes.eventDetail}',
            extra: event,
          ),
          onRemove: () => ref
              .read(favoritesNotifierProvider.notifier)
              .toggleFavorite(event),
        );
      },
    );
  }
}

// ─── Card de favorito ─────────────────────────────────────────────────────────

class _FavoriteCard extends StatelessWidget {
  final EventEntity event;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const _FavoriteCard({
    required this.event,
    required this.onTap,
    required this.onRemove,
  });

  String _eventEmoji(String type) {
    switch (type.toLowerCase()) {
      case 'hail':      return '🌨️';
      case 'tornado':   return '🌪️';
      case 'wind':      return '💨';
      case 'earthquake':return '🌍';
      case 'flood':     return '🌊';
      case 'lightning': return '⚡';
      default:          return '⚠️';
    }
  }

  String _translateType(String type) {
    const map = {
      'hail': 'Granizo',
      'tornado': 'Tornado',
      'wind': 'Viento Fuerte',
      'earthquake': 'Sismo',
      'flood': 'Inundación',
      'lightning': 'Rayo',
    };
    return map[type.toLowerCase()] ?? type;
  }

  String _formatDate(String datetime) {
    try {
      final dt = DateTime.parse(datetime);
      const months = [
        'ene', 'feb', 'mar', 'abr', 'may', 'jun',
        'jul', 'ago', 'sep', 'oct', 'nov', 'dic',
      ];
      return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
    } catch (_) {
      return datetime;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      // Swipe para eliminar — UX estándar en apps móviles
      key: Key(event.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onRemove(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFE53935),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.delete, color: Colors.white),
            SizedBox(height: 4),
            Text(
              'Eliminar',
              style: TextStyle(color: Colors.white, fontSize: 11),
            ),
          ],
        ),
      ),
      child: Card(
        color: AppColors.cardDark,
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: const Color(0xFFE53935).withOpacity(0.3),
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Ícono
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE53935).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      _eventEmoji(event.type),
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _translateType(event.type),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        event.description ?? 'Sin descripción',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            color: Colors.white38,
                            size: 11,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatDate(event.datetime),
                            style: const TextStyle(
                              color: Colors.white38,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Botón eliminar explícito (además del swipe)
                IconButton(
                  onPressed: onRemove,
                  icon: const Icon(
                    Icons.favorite,
                    color: Color(0xFFE53935),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}