import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:weather_app/core/theme/app_colors.dart';
import 'package:weather_app/features/events/domain/entities/event_entity.dart';
import 'package:weather_app/features/favorites/presentation/providers/favorites_provider.dart';

class EventDetailScreen extends ConsumerWidget {
  final EventEntity? event;

  const EventDetailScreen({super.key, this.event});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (event == null) {
      return const Scaffold(
        body: Center(child: Text('Evento no encontrado')),
      );
    }

    final favorites = ref.watch(favoritesNotifierProvider);
    final isFavorite = favorites.any(
      (e) => e.id == event!.id,
    );

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        title: Text(
          _translateType(event!.type),
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => ref
            .read(favoritesNotifierProvider.notifier)
            .toggleFavorite(event!),
        backgroundColor: isFavorite
            ? const Color(0xFFE53935)
            : AppColors.primary,
        icon: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: Colors.white,
        ),
        label: Text(
          isFavorite ? 'Guardado' : 'Guardar',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Mapa con la ubicación del evento
            _EventMap(
              latitude: event!.latitude,
              longitude: event!.longitude,
            ),
            // Detalles del evento
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DetailCard(event: event!),
                  const SizedBox(height: 80), // espacio para el FAB
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
}

// ─── Mapa del evento ──────────────────────────────────────────────────────────

class _EventMap extends StatelessWidget {
  final double latitude;
  final double longitude;

  const _EventMap({required this.latitude, required this.longitude});

  @override
  Widget build(BuildContext context) {
    final position = LatLng(latitude, longitude);

    return SizedBox(
      height: 250,
      child: FlutterMap(
        options: MapOptions(
          initialCenter: position,
          initialZoom: 8,
          interactionOptions: const InteractionOptions(
            flags: InteractiveFlag.none, // mapa estático en detalle
          ),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.weather_app',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: position,
                width: 48,
                height: 48,
                child: const Icon(
                  Icons.location_pin,
                  color: Color(0xFFE53935),
                  size: 48,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Tarjeta de detalles ──────────────────────────────────────────────────────

class _DetailCard extends StatelessWidget {
  final EventEntity event;

  const _DetailCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Detalles del evento',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          _DetailRow(label: 'Tipo', value: _translateType(event.type)),
          _DetailRow(
            label: 'Fecha',
            value: _formatDate(event.datetime),
          ),
          _DetailRow(
            label: 'Coordenadas',
            value:
                '${event.latitude.toStringAsFixed(4)}, ${event.longitude.toStringAsFixed(4)}',
          ),
          _DetailRow(
            label: 'Distancia',
            value: '${event.distance.toStringAsFixed(1)} km',
          ),
          if (event.size != null)
            _DetailRow(
              label: 'Magnitud',
              value: event.size!.toStringAsFixed(1),
            ),
          if (event.description != null) ...[
            const SizedBox(height: 16),
            const Text(
              'Descripción',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              event.description!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _translateType(String type) {
    const map = {
      'hail': 'Granizo',
      'tornado': 'Tornado',
      'wind': 'Viento Fuerte',
      'earthquake': 'Sismo',
      'flood': 'Inundación',
    };
    return map[type.toLowerCase()] ?? type;
  }

  String _formatDate(String datetime) {
    try {
      final dt = DateTime.parse(datetime);
      const months = [
        'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
        'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre',
      ];
      return '${dt.day} de ${months[dt.month - 1]} de ${dt.year}';
    } catch (_) {
      return datetime;
    }
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(color: Colors.white54, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}