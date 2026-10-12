import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_view_model.dart';
import '../viewmodel/profile_view_model.dart';
import 'widgets/edit_profile_dialog.dart';
import 'widgets/preference_tile.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_info_tile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    final vm = context.read<ProfileViewModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) => vm.refresh());
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProfileViewModel>();
    final tema = context.watch<ThemeViewModel>();
    final usuario = vm.usuario;
    if (usuario == null) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final tituloSeccion = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w600,
      color: theme.brightness == Brightness.dark
          ? AppColors.primary
          : AppColors.primaryDark,
    );

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    tooltip: 'Volver',
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () => context.canPop()
                        ? context.pop()
                        : context.go(AppRoutes.home),
                  ),
                  TextButton(
                    onPressed: vm.logout,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.error,
                    ),
                    child: const Text('Cerrar Sesión'),
                  ),
                ],
              ),
              Center(child: ProfileHeader(usuario: usuario)),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Datos Personales', style: tituloSeccion),
                  TextButton(
                    onPressed: () => mostrarEditarPerfil(context, usuario),
                    child: const Text('Editar'),
                  ),
                ],
              ),
              ProfileInfoTile(label: 'Nombres', value: usuario.nombres),
              const SizedBox(height: 10),
              ProfileInfoTile(label: 'Apellidos', value: usuario.apellidos),
              const SizedBox(height: 10),
              ProfileInfoTile(label: 'Correo', value: usuario.correo),
              const SizedBox(height: 10),
              ProfileInfoTile(
                label: 'Número de teléfono',
                value: usuario.telefono ?? '—',
              ),
              const SizedBox(height: 10),
              const ProfileInfoTile(label: 'Contraseña', value: '••••••••••'),
              const SizedBox(height: 24),
              Text('Preferencias', style: tituloSeccion),
              const SizedBox(height: 10),
              PreferenceTile(
                label: 'Notificaciones',
                value: vm.notificationsEnabled,
                onChanged: vm.setNotifications,
              ),
              const SizedBox(height: 10),
              PreferenceTile(
                label: 'Modo oscuro',
                value: tema.isDark,
                onChanged: tema.setDarkMode,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
