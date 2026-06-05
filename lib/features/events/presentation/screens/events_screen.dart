import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app/core/router/app_router.dart';
import 'package:weather_app/core/theme/app_colors.dart';
import 'package:weather_app/features/events/domain/entities/event_entity.dart';
import 'package:weather_app/features/events/presentation/providers/events_provider.dart';
import 'package:weather_app/features/favorites/presentation/providers/favorites_provider.dart';

class EventsScreen extends ConsumerStatefulWidget {
  const EventsScreen({super.key});

  @override
  ConsumerState<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends ConsumerState<EventsScreen> {
  String _currentLocation = 'Bogota, Colombia';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(eventsNotifierProvider.notifier).loadEvents(_currentLocation);
    });
  }

  void _onLocationSelected(String location) {
    setState(() => _currentLocation = location);
    ref.read(eventsNotifierProvider.notifier).loadEvents(location);
  }

  @override
  Widget build(BuildContext context) {
    final eventsState = ref.watch(eventsNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        title: GestureDetector(
          onTap: () => _showLocationSearch(context),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.location_on, color: Colors.white, size: 18),
              const SizedBox(width: 6),
              Text(
                _currentLocation,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white,
                size: 18,
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: eventsState.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (error, _) => _ErrorView(
          message: error.toString(),
          onRetry: () => ref
              .read(eventsNotifierProvider.notifier)
              .loadEvents(_currentLocation),
        ),
        data: (events) {
          if (events.isEmpty) {
            return const _EmptyView();
          }
          return _EventsList(
            events: events,
            location: _currentLocation,
          );
        },
      ),
    );
  }

  void _showLocationSearch(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _LocationSearchSheet(
        onLocationSelected: _onLocationSelected,
      ),
    );
  }
}

// ─── Lista de eventos ─────────────────────────────────────────────────────────

class _EventsList extends ConsumerWidget {
  final List<EventEntity> events;
  final String location;

  const _EventsList({required this.events, required this.location});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Escuchamos favoritos para actualizar el ícono en tiempo real
    final favorites = ref.watch(favoritesNotifierProvider);
    final favoriteIds = favorites.map((e) => e.id).toSet();

    return ListView.builder(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: 80 + MediaQuery.of(context).padding.bottom,
      ),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        final isFav = favoriteIds.contains(event.id);

        return _EventCard(
          event: event.copyWith(isFavorite: isFav),
          onTap: () => context.push(
            AppRoutes.eventDetail,
            extra: event.copyWith(isFavorite: isFav),
          ),
          onFavoriteTap: () => ref
              .read(favoritesNotifierProvider.notifier)
              .toggleFavorite(event),
        );
      },
    );
  }
}

// ─── Card de evento ───────────────────────────────────────────────────────────

class _EventCard extends StatelessWidget {
  final EventEntity event;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;

  const _EventCard({
    required this.event,
    required this.onTap,
    required this.onFavoriteTap,
  });

  // Ícono según tipo de evento
  String _eventEmoji(String type) {
    switch (type.toLowerCase()) {
      case 'hail':
        return '🌨️';
      case 'tornado':
        return '🌪️';
      case 'wind':
        return '💨';
      case 'earthquake':
        return '🌍';
      case 'flood':
        return '🌊';
      case 'lightning':
      case 'thunder':
        return '⚡';
      default:
        return '⚠️';
    }
  }

  Color _eventColor(String type) {
    switch (type.toLowerCase()) {
      case 'tornado':
        return const Color(0xFFE53935);
      case 'hail':
        return const Color(0xFF42A5F5);
      case 'earthquake':
        return const Color(0xFFFF9800);
      case 'flood':
        return const Color(0xFF26C6DA);
      default:
        return AppColors.primary;
    }
  }

  ({String label, Color color}) _severityBadge(String type) {
    switch (type.toLowerCase()) {
      case 'tornado':
        return (label: 'CRÍTICO', color: const Color(0xFFE53935));
      case 'earthquake':
      case 'flood':
        return (label: 'ALTO', color: const Color(0xFFFF9800));
      case 'thunder-rain':
      case 'thunder-showers-day':
      case 'thunder-showers-night':
        return (label: 'MEDIO', color: const Color(0xFFFFD600));
      case 'hail':
      case 'wind':
        return (label: 'BAJO', color: const Color(0xFF66BB6A));
      default:
        return (label: 'INFO', color: const Color(0xFF42A5F5));
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _eventColor(event.type);
    final badge = _severityBadge(event.type);

    return Card(
      color: AppColors.cardDark,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border(
            left: BorderSide(color: color, width: 3),
          ),
        ),
        child: Stack(
          children: [
            InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.15),
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _translateType(event.type),
                            style: TextStyle(
                              color: color,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            event.description ?? 'Sin descripción',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.access_time,
                                  color: Colors.white38, size: 12),
                              const SizedBox(width: 4),
                              Text(
                                _formatDate(event.datetime),
                                style: const TextStyle(
                                    color: Colors.white38, fontSize: 11),
                              ),
                              const SizedBox(width: 12),
                              const Icon(Icons.social_distance,
                                  color: Colors.white38, size: 12),
                              const SizedBox(width: 4),
                              Text(
                                '${event.distance.toStringAsFixed(1)} km',
                                style: const TextStyle(
                                    color: Colors.white38, fontSize: 11),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: onFavoriteTap,
                      icon: Icon(
                        event.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: event.isFavorite
                            ? const Color(0xFFE53935)
                            : Colors.white38,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Badge de severidad — esquina superior derecha
            Positioned(
              top: 8,
              right: 52, // deja espacio al botón de favorito
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: badge.color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: badge.color.withOpacity(0.6)),
                ),
                child: Text(
                  badge.label,
                  style: TextStyle(
                    color: badge.color,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _translateType(String type) {
    const map = {
      'hail': 'GRANIZO',
      'tornado': 'TORNADO',
      'wind': 'VIENTO FUERTE',
      'earthquake': 'SISMO',
      'flood': 'INUNDACIÓN',
      'lightning': 'RAYO',
    };
    return map[type.toLowerCase()] ?? type.toUpperCase();
  }

  String _formatDate(String datetime) {
    try {
      final dt = DateTime.parse(datetime);
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return datetime;
    }
  }
}

// ─── Estados vacío / error ────────────────────────────────────────────────────

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('✅', style: TextStyle(fontSize: 64)),
          SizedBox(height: 16),
          Text(
            'Sin eventos climáticos registrados',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          SizedBox(height: 8),
          Text(
            'Esta área no tiene eventos recientes',
            style: TextStyle(color: Colors.white38, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.warning_amber, color: Colors.orange, size: 64),
            const SizedBox(height: 16),
            const Text(
              'Error al cargar eventos',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white54, fontSize: 13),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Modal búsqueda (mismo patrón que WeatherScreen) ─────────────────────────

class _LocationSearchSheet extends StatefulWidget {
  final void Function(String) onLocationSelected;
  const _LocationSearchSheet({required this.onLocationSelected});

  @override
  State<_LocationSearchSheet> createState() => _LocationSearchSheetState();
}

class _LocationSearchSheetState extends State<_LocationSearchSheet> {
  final _controller = TextEditingController();

  static const _suggestions = [
    'Bogota, Colombia',
    'Medellin, Colombia',
    'Cali, Colombia',
    'Barranquilla, Colombia',
    'London, UK',
    'New York, US',
    'Madrid, Spain',
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _select(String location) {
    Navigator.pop(context);
    widget.onLocationSelected(location);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Color(0xFF1A2B3C),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white30,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _controller,
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Buscar ciudad...',
                hintStyle: const TextStyle(color: Colors.white38),
                prefixIcon: const Icon(Icons.search, color: Colors.white38),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) _select(value.trim());
              },
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  child: Text(
                    'Ciudades populares',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                ..._suggestions.map(
                  (city) => ListTile(
                    leading: const Icon(
                      Icons.location_city,
                      color: Colors.white54,
                    ),
                    title: Text(
                      city,
                      style: const TextStyle(color: Colors.white),
                    ),
                    onTap: () => _select(city),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
