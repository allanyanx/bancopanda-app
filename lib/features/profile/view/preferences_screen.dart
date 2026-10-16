import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_view_model.dart';
import '../../../core/widgets/status_dialog.dart';
import '../viewmodel/profile_view_model.dart';
import 'widgets/preference_tile.dart';
import 'widgets/profile_menu_tile.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  Future<void> _cambiarNotificaciones(bool activar) async {
    await context.read<ProfileViewModel>().setNotificaciones(activar);
    if (!mounted) return;
    await mostrarEstado(
      context,
      icono: activar
          ? Icons.notifications_active_outlined
          : Icons.notifications_off_outlined,
      titulo: activar
          ? 'Notificaciones activadas'
          : 'Notificaciones desactivadas',
      mensaje: activar
          ? 'Recibirás avisos de tus movimientos.'
          : 'Ya no recibirás avisos de tus movimientos.',
    );
  }

  Future<void> _elegirModo() async {
    final tema = context.read<ThemeViewModel>();
    final oscuro = await showDialog<bool>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Elige el modo'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        children: [
          _OpcionModo(
            icono: Icons.light_mode_outlined,
            texto: 'Modo claro',
            seleccionado: !tema.isDark,
            onTap: () => Navigator.of(ctx).pop(false),
          ),
          _OpcionModo(
            icono: Icons.dark_mode_outlined,
            texto: 'Modo oscuro',
            seleccionado: tema.isDark,
            onTap: () => Navigator.of(ctx).pop(true),
          ),
        ],
      ),
    );
    if (oscuro == null || !mounted) return;

    await tema.setDarkMode(oscuro);
    if (!mounted) return;
    await mostrarEstado(
      context,
      icono: oscuro ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
      titulo: oscuro ? 'Modo oscuro activado' : 'Modo claro activado',
      mensaje: oscuro
          ? 'La app ahora usa colores oscuros.'
          : 'La app ahora usa colores claros.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProfileViewModel>();
    final tema = context.watch<ThemeViewModel>();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Configuración'),
        actions: [
          IconButton(
            tooltip: 'Cerrar',
            icon: const Icon(Icons.close),
            onPressed: () => context.pop(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            PreferenceTile(
              label: 'Notificaciones',
              value: vm.notificaciones,
              onChanged: _cambiarNotificaciones,
            ),
            const SizedBox(height: 12),
            ProfileMenuTile(
              label: 'Apariencia',
              value: tema.isDark ? 'Oscuro' : 'Claro',
              onTap: _elegirModo,
            ),
          ],
        ),
      ),
    );
  }
}

class _OpcionModo extends StatelessWidget {
  const _OpcionModo({
    required this.icono,
    required this.texto,
    required this.seleccionado,
    required this.onTap,
  });

  final IconData icono;
  final String texto;
  final bool seleccionado;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icono),
      title: Text(texto),
      selected: seleccionado,
      selectedColor: AppColors.primary,
      trailing: seleccionado
          ? const Icon(Icons.check_circle, color: AppColors.primary)
          : null,
      onTap: onTap,
    );
  }
}
