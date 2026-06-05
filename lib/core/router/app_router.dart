import 'package:go_router/go_router.dart';
import 'package:weather_app/core/widgets/app_shell.dart';
import 'package:weather_app/features/events/domain/entities/event_entity.dart';
import 'package:weather_app/features/events/presentation/screens/events_details_screen.dart';
import 'package:weather_app/features/events/presentation/screens/events_screen.dart';
import 'package:weather_app/features/favorites/presentation/screens/favorites_screen.dart';
import 'package:weather_app/features/map/presentation/map_screen.dart';
import 'package:weather_app/features/weather/presentation/screens/weather_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String weather = '/weather';
  static const String events = '/events';
  static const String eventDetail = '/events/detail';
  static const String favorites = '/favorites';
  static const String map = '/map';
}

final appRouter = GoRouter(
  initialLocation: AppRoutes.weather,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AppShell(navigationShell: navigationShell);
      },
      branches: [
        // Tab 1 — Clima
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.weather,
              builder: (context, state) => const WeatherScreen(),
            ),
          ],
        ),

        // Tab 2 — Eventos
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.events,
              builder: (context, state) => const EventsScreen(),
            ),
          ],
        ),

        // Tab 3 — Favoritos
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.favorites,
              builder: (context, state) => const FavoritesScreen(),
            ),
          ],
        ),

        // Tab 4 — Mapa
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.map,
              builder: (context, state) => const MapScreen(),
            ),
          ],
        ),
      ],
    ),

    GoRoute(
      path: AppRoutes.eventDetail,
      builder: (context, state) {
        final event = state.extra as EventEntity?;
        return EventDetailScreen(event: event);
      },
    )
  ],
);