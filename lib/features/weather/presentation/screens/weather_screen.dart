import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/core/theme/app_colors.dart';
import 'package:weather_app/core/utils/weather_icon_mapper.dart';
import 'package:weather_app/features/weather/domain/entities/day_forecast_entity.dart';
import 'package:weather_app/features/weather/domain/entities/weather_entity.dart';
import 'package:weather_app/features/weather/presentation/providers/weather_provider.dart';

class WeatherScreen extends ConsumerStatefulWidget {
  const WeatherScreen({super.key});

  @override
  ConsumerState<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends ConsumerState<WeatherScreen> {
  // Ubicación por defecto al abrir la app
  String _currentLocation = 'Bogota, Colombia';

  @override
  void initState() {
    super.initState();
    // Cargamos el clima al iniciar la pantalla
    // addPostFrameCallback evita llamar setState durante el build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(weatherNotifierProvider.notifier).loadWeather(_currentLocation);
    });
  }

  void _onLocationSelected(String location) {
    setState(() => _currentLocation = location);
    ref.read(weatherNotifierProvider.notifier).loadWeather(location);
  }

  @override
  Widget build(BuildContext context) {
    final weatherState = ref.watch(weatherNotifierProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.skyGradient),
        child: SafeArea(
          child: Column(
            children: [
              _LocationBar(
                location: _currentLocation,
                onTap: () => _showLocationSearch(context),
              ),
              Expanded(
                child: weatherState.when(
                  loading: () => const _LoadingView(),
                  error: (error, _) => _ErrorView(
                    message: error.toString(),
                    onRetry: () => ref
                        .read(weatherNotifierProvider.notifier)
                        .loadWeather(_currentLocation),
                  ),
                  data: (weather) {
                    if (weather == null) return const _EmptyView();
                    return _WeatherContent(weather: weather);
                  },
                ),
              ),
            ],
          ),
        ),
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

// ─── Barra de ubicación ───────────────────────────────────────────────────────

class _LocationBar extends StatelessWidget {
  final String location;
  final VoidCallback onTap;

  const _LocationBar({required this.location, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_on, color: Colors.white, size: 18),
            const SizedBox(width: 6),
            Text(
              location,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }
}

// ─── Estados de carga / error / vacío ────────────────────────────────────────

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: Colors.white),
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
            const Icon(Icons.cloud_off, color: Colors.white70, size: 64),
            const SizedBox(height: 16),
            Text(
              'No se pudo cargar el clima',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Busca una ciudad para ver el clima',
        style: TextStyle(color: Colors.white70, fontSize: 16),
      ),
    );
  }
}

// ─── Contenido principal ──────────────────────────────────────────────────────

class _WeatherContent extends StatelessWidget {
  final WeatherEntity weather;

  const _WeatherContent({required this.weather});

  @override
  Widget build(BuildContext context) {
    // Tomamos solo los últimos 5 días
    final last5Days = weather.days.length > 5
        ? weather.days.sublist(weather.days.length - 5)
        : weather.days;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Temperatura actual grande
          _CurrentWeatherHero(
            conditions: weather.currentConditions,
            resolvedAddress: weather.resolvedAddress,
          ),

          const SizedBox(height: 24),

          // Cards de métricas
          if (weather.currentConditions != null)
            _StatsRow(current: weather.currentConditions!),

          const SizedBox(height: 24),

          // Forecast 5 días
          _DailyForecastCard(days: last5Days),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ─── Hero temperatura ─────────────────────────────────────────────────────────

class _CurrentWeatherHero extends StatelessWidget {
  final dynamic conditions; // CurrentConditionsEntity
  final String resolvedAddress;

  const _CurrentWeatherHero({
    required this.conditions,
    required this.resolvedAddress,
  });

  @override
  Widget build(BuildContext context) {
    if (conditions == null) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: Text(
            'Sin datos actuales',
            style: TextStyle(color: Colors.white70),
          ),
        ),
      );
    }

    return Column(
      children: [
        const SizedBox(height: 16),
        // Ícono grande
        Text(
          WeatherIconMapper.toEmoji(conditions.icon),
          style: const TextStyle(fontSize: 80),
        ),
        const SizedBox(height: 8),
        // Temperatura principal
        Text(
          '${conditions.temp.round()}°C',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 72,
            fontWeight: FontWeight.w200,
            letterSpacing: -2,
          ),
        ),
        // Descripción
        Text(
          conditions.conditions,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 8),
        // Sensación térmica
        Text(
          'Sensación: ${conditions.feelsLike.round()}°C',
          style: const TextStyle(color: Colors.white60, fontSize: 14),
        ),
      ],
    );
  }
}

// ─── Fila de estadísticas ─────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  final dynamic current;

  const _StatsRow({required this.current});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.water_drop_outlined,
            label: 'Humedad',
            value: '${current.humidity.round()}%',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.air,
            label: 'Viento',
            value: '${current.windSpeed.round()} km/h',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.thermostat,
            label: 'Sensación',
            value: '${current.feelsLike.round()}°C',
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white70, size: 22),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.white60, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

// ─── Forecast diario ──────────────────────────────────────────────────────────

class _DailyForecastCard extends StatelessWidget {
  final List<DayForecastEntity> days;

  const _DailyForecastCard({required this.days});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Row(
              children: const [
                Icon(Icons.calendar_today, color: Colors.white70, size: 14),
                SizedBox(width: 6),
                Text(
                  'ÚLTIMOS 5 DÍAS',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white24, height: 1),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: days.length,
            separatorBuilder: (_, __) =>
                const Divider(color: Colors.white24, height: 1),
            itemBuilder: (context, index) =>
                _DayForecastRow(day: days[index]),
          ),
        ],
      ),
    );
  }
}

class _DayForecastRow extends StatelessWidget {
  final DayForecastEntity day;

  const _DayForecastRow({required this.day});

  String _formatDay(String datetime) {
    try {
      final date = DateTime.parse(datetime);
      const days = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
      // Hoy
      final now = DateTime.now();
      if (date.day == now.day && date.month == now.month) return 'Hoy';
      return days[date.weekday - 1];
    } catch (_) {
      return datetime;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Día
          SizedBox(
            width: 48,
            child: Text(
              _formatDay(day.datetime),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // Ícono
          Text(WeatherIconMapper.toEmoji(day.icon), style: const TextStyle(fontSize: 22)),
          const Spacer(),
          // Prob. precipitación
          if (day.precipProb > 0) ...[
            const Icon(Icons.water_drop, color: Color.fromARGB(255, 50, 58, 64), size: 14),
            const SizedBox(width: 2),
            Text(
              '${day.precipProb.round()}%',
              style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 12),
            ),
            const SizedBox(width: 12),
          ],
          // Mín / Máx
          Text(
            '${day.tempMin.round()}°',
            style: const TextStyle(color: Colors.white60, fontSize: 15),
          ),
          const SizedBox(width: 8),
          Text(
            '${day.tempMax.round()}°',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Modal de búsqueda de ubicación ──────────────────────────────────────────

class _LocationSearchSheet extends StatefulWidget {
  final void Function(String) onLocationSelected;

  const _LocationSearchSheet({required this.onLocationSelected});

  @override
  State<_LocationSearchSheet> createState() => _LocationSearchSheetState();
}

class _LocationSearchSheetState extends State<_LocationSearchSheet> {
  final _controller = TextEditingController();

  // Ciudades sugeridas rápidas
  static const _suggestions = [
    'Bogota, Colombia',
    'Medellin, Colombia',
    'Cali, Colombia',
    'Barranquilla, Colombia',
    'Cartagena, Colombia',
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
          // Handle
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white30,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Campo de búsqueda
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
          // Sugerencias
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