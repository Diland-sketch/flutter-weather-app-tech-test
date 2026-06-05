import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:weather_app/core/router/app_router.dart';
import 'package:weather_app/core/theme/app_colors.dart';
import 'package:weather_app/features/events/domain/entities/event_entity.dart';
import 'package:weather_app/features/events/presentation/providers/events_provider.dart';
import 'package:weather_app/features/favorites/presentation/providers/favorites_provider.dart';

class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsState = ref.watch(eventsNotifierProvider);
    final favorites = ref.watch(favoritesNotifierProvider);

    // Combinamos eventos cargados + favoritos para mostrar en el mapa
    // Los favoritos siempre están disponibles offline
    final eventsFromApi = eventsState.maybeWhen(
      data: (list) => list,
      orElse: () => <EventEntity>[],
    );

    // Unimos sin duplicados por id
    final allIds = eventsFromApi.map((e) => e.id).toSet();
    final favoritesNotInApi = favorites
        .where((e) => !allIds.contains(e.id))
        .toList();
    final allEvents = [...eventsFromApi, ...favoritesNotInApi];

    // Centro del mapa: primer evento o posición por defecto (Colombia)
    final initialCenter = allEvents.isNotEmpty
        ? LatLng(allEvents.first.latitude, allEvents.first.longitude)
        : const LatLng(4.6097, -74.0817); // Bogota

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        title: const Text(
          'Mapa de Eventos',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          // Contador de eventos visibles
          if (allEvents.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${allEvents.length} eventos',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          // Mapa principal
          FlutterMap(
            options: MapOptions(
              initialCenter: initialCenter,
              initialZoom: allEvents.length == 1 ? 8 : 3,
              maxZoom: 18,
              minZoom: 2,
            ),
            children: [
              // Capa de tiles OpenStreetMap (gratuito, sin API key)
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.devDiland.weather_app',
              ),
              // Marcadores de eventos
              MarkerLayer(
                markers: allEvents
                    .map((event) => _buildMarker(context, event))
                    .toList(),
              ),
            ],
          ),

          // Estado de carga superpuesto
          if (eventsState.isLoading)
            Positioned(
              top: 12,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.cardDark,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Cargando eventos...',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Vista vacía cuando no hay eventos
          if (allEvents.isEmpty && !eventsState.isLoading)
            Center(
              child: Container(
                margin: const EdgeInsets.all(24),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.cardDark.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.map_outlined, color: Colors.white38, size: 48),
                    SizedBox(height: 12),
                    Text(
                      'Sin eventos en el mapa',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Carga eventos desde la pestaña Eventos\no guarda favoritos para verlos aquí',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white54, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Marker _buildMarker(BuildContext context, EventEntity event) {
    final isFavorite = event.isFavorite;

    return Marker(
      point: LatLng(event.latitude, event.longitude),
      width: 44,
      height: 44,
      child: GestureDetector(
        onTap: () => _showEventBottomSheet(context, event),
        child: Container(
          decoration: BoxDecoration(
            color: isFavorite
                ? const Color(0xFFE53935)
                : AppColors.primary,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              _eventEmoji(event.type),
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }

  void _showEventBottomSheet(BuildContext context, EventEntity event) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _EventMapBottomSheet(event: event),
    );
  }

  String _eventEmoji(String type) {
    switch (type.toLowerCase()) {
      case 'hail':       return '🌨️';
      case 'tornado':    return '🌪️';
      case 'wind':       return '💨';
      case 'earthquake': return '🌍';
      case 'flood':      return '🌊';
      case 'lightning':  return '⚡';
      default:           return '⚠️';
    }
  }
}

// ─── Bottom sheet del evento en el mapa ──────────────────────────────────────

class _EventMapBottomSheet extends StatelessWidget {
  final EventEntity event;

  const _EventMapBottomSheet({required this.event});

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white30,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Título
          Row(
            children: [
              Text(
                _translateType(event.type),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              if (event.isFavorite)
                const Icon(Icons.favorite, color: Color(0xFFE53935), size: 20),
            ],
          ),
          const SizedBox(height: 8),
          // Descripción
          if (event.description != null)
            Text(
              event.description!,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          const SizedBox(height: 12),
          // Coordenadas
          Row(
            children: [
              const Icon(Icons.location_on, color: AppColors.primary, size: 16),
              const SizedBox(width: 6),
              Text(
                '${event.latitude.toStringAsFixed(4)}, ${event.longitude.toStringAsFixed(4)}',
                style: const TextStyle(color: Colors.white54, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Botón ver detalle
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                context.push(
                  '${AppRoutes.events}/${AppRoutes.eventDetail}',
                  extra: event,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                'Ver detalle',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}