import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primarios — inspirados en cielo/clima
  static const Color primary = Color(0xFF1E88E5);      // Azul cielo
  static const Color primaryDark = Color(0xFF1565C0);  // Azul noche
  static const Color accent = Color(0xFF26C6DA);       // Celeste

  // Fondos
  static const Color backgroundLight = Color(0xFFF5F7FA);
  static const Color backgroundDark = Color(0xFF0D1B2A);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF1A2B3C);

  // Gradientes principales
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
}