import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/core/network/connectivity_service.dart';

class OfflineBanner extends ConsumerWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityState = ref.watch(isConnectedProvider);

    return connectivityState.when(
      // Mientras determina el estado no mostramos nada
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (isConnected) {
        if (isConnected) return const SizedBox.shrink();

        // Animación de entrada suave
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: double.infinity,
          color: const Color(0xFF323232),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: const SafeArea(
            bottom: false,
            child: Row(
              children: [
                Icon(Icons.wifi_off, color: Colors.white70, size: 16),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Sin conexión — mostrando datos guardados',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}