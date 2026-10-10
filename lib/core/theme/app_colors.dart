import 'package:flutter/material.dart';

abstract final class AppColors {
  // Marca
  static const primary = Color(0xFF239A55); // Botones principales
  static const primaryDark = Color(0xFF17603A); // "Panda", títulos de sección
  static const primaryDeep = Color(0xFF1E7D45); // Accesos rápidos del dashboard
  static const accent = Color(0xFF3DDC6A); // "Panda" sobre la tarjeta oscura

  // Modo claro
  static const background = Color(0xFFFFFFFF); // Dashboard y perfil
  static const backgroundAuth = Color(0xFFE3F6EA); // Login y registro
  static const surfaceMint = Color(0xFFE8F6EE); // Tarjetas de datos del perfil
  static const fieldFill = Color(0xFFF5FBF7); // Relleno de los campos de texto
  static const fieldBorder = Color(0xFFA9E2C3);
  static const textPrimary = Color(0xFF0E0E10);
  static const textSecondary = Color(0xFF6B7370); // Hints, fechas, etiquetas

  // Modo oscuro
  static const backgroundDark = Color(0xFF18191C);
  static const surfaceDark = Color(0xFF1B1E26); // Tarjeta de saldo y barra inferior
  static const cardSlate = Color(0xFF2F3542); // Tarjeta de saldo en modo oscuro
  static const cardGreen = Color(0xFF134B2B); // Segunda tarjeta
  static const textOnDark = Color(0xFFFFFFFF);

  // Estados
  static const error = Color(0xFFF0443A); // "Cerrar Sesión", errores
}
