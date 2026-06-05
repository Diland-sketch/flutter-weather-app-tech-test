import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app/core/widgets/offline_banner.dart';

class AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    // Altura real de la barra de navegación + safe area inferior
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    const barHeight = 64.0;
    final totalBarHeight = barHeight + bottomPadding;

    return Scaffold(
      // Permite que el body se extienda detrás de la barra
      extendBody: true,
      body: Column(
        children: [
          const OfflineBanner(),
          Expanded(child: navigationShell),
        ],
      ),
      bottomNavigationBar: _GlassNavBar(
        currentIndex: navigationShell.currentIndex,
        totalHeight: totalBarHeight,
        barHeight: barHeight,
        bottomPadding: bottomPadding,
        onTap: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
      ),
    );
  }
}

class _GlassNavBar extends StatelessWidget {
  final int currentIndex;
  final double totalHeight;
  final double barHeight;
  final double bottomPadding;
  final ValueChanged<int> onTap;

  const _GlassNavBar({
    required this.currentIndex,
    required this.totalHeight,
    required this.barHeight,
    required this.bottomPadding,
    required this.onTap,
  });

  static const _items = [
    (icon: Icons.wb_sunny_outlined, activeIcon: Icons.wb_sunny, label: 'Clima'),
    (icon: Icons.warning_amber_outlined, activeIcon: Icons.warning_amber, label: 'Eventos'),
    (icon: Icons.favorite_outline, activeIcon: Icons.favorite, label: 'Favoritos'),
    (icon: Icons.map_outlined, activeIcon: Icons.map, label: 'Mapa'),
  ];

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: totalHeight,
          decoration: BoxDecoration(
            // Fondo semitransparente — se adapta al tema
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black.withOpacity(0.4)
                : Colors.white.withOpacity(0.6),
            border: Border(
              top: BorderSide(
                color: Colors.white.withOpacity(0.15),
                width: 0.5,
              ),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(bottom: bottomPadding),
            child: SizedBox(
              height: barHeight,
              child: Row(
                children: List.generate(_items.length, (index) {
                  final item = _items[index];
                  final isActive = index == currentIndex;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () => onTap(index),
                      behavior: HitTestBehavior.opaque,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: Icon(
                                isActive ? item.activeIcon : item.icon,
                                key: ValueKey(isActive),
                                color: isActive
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.5),
                                size: 24,
                              ),
                            ),
                            const SizedBox(height: 4),
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 200),
                              style: TextStyle(
                                color: isActive
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.5),
                                fontSize: 11,
                                fontWeight: isActive
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                              child: Text(item.label),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}