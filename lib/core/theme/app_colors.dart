import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primarios
  static const Color primary = Color(0xFF1E88E5);
  static const Color primaryDark = Color(0xFF1565C0);
  static const Color accent = Color(0xFF26C6DA);

  // Fondos
  static const Color backgroundLight = Color(0xFFF5F7FA);
  static const Color backgroundDark = Color(0xFF0D1B2A);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF1A2B3C);

  // Gradientes estáticos
  static const LinearGradient skyGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF1E88E5), Color(0xFF26C6DA)],
  );

  static const LinearGradient nightGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0D1B2A), Color(0xFF1A2B3C)],
  );

  static const LinearGradient stormGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF37474F), Color(0xFF546E7A)],
  );

  // Semánticos
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFE53935);
  static const Color offline = Color(0xFF757575);

  // Texto
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textOnDark = Color(0xFFFFFFFF);
  static const Color textOnDarkSecondary = Color(0xFFB0BEC5);

  // Gradiente dinámico según condición climática
  static LinearGradient dynamicGradient(String icon) {
    switch (icon) {
      case 'clear-night':
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0A0E27), Color(0xFF1A1A3E)],
        );
      case 'partly-cloudy-night':
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1C2340), Color(0xFF2C3E50)],
        );
      case 'clear-day':
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1E88E5), Color(0xFF42A5F5)],
        );
      case 'partly-cloudy-day':
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF4A90D9), Color(0xFF8BB8E8)],
        );
      case 'cloudy':
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF546E7A), Color(0xFF78909C)],
        );
      case 'rain':
      case 'showers-day':
      case 'showers-night':
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF37474F), Color(0xFF546E7A)],
        );
      case 'thunder-rain':
      case 'thunder-showers-day':
      case 'thunder-showers-night':
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1A1A2E), Color(0xFF37474F)],
        );
      case 'snow':
      case 'snow-showers-day':
      case 'snow-showers-night':
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFB0BEC5), Color(0xFFCFD8DC)],
        );
      case 'fog':
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF78909C), Color(0xFF90A4AE)],
        );
      case 'wind':
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF4A90D9), Color(0xFF78909C)],
        );
      default:
        return skyGradient;
    }
  }
}