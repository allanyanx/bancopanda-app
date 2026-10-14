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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<ProfileViewModel>().cargar();
    });
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
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    onPressed: () => context.canPop()
                        ? context.pop()
                        : context.go(AppRoutes.home),
                  ),
                  TextButton(
                    onPressed: vm.cerrarSesion,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.error,
                      textStyle: theme.textTheme.bodyLarge,
                    ),
                    child: const Text('Cerrar Sesión'),
                  ),
                ],
              ),

              if (vm.cargando) const LinearProgressIndicator(minHeight: 3),
              if (vm.errorCarga != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 20,
                        color: theme.colorScheme.error,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          vm.errorCarga!,
                          style: TextStyle(color: theme.colorScheme.error),
                        ),
                      ),
                      TextButton(
                        onPressed: vm.cargar,
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                ),

              Center(child: ProfileHeader(usuario: usuario)),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Datos Personales', style: tituloSeccion),
                  TextButton(
                    onPressed: () => mostrarEditarPerfil(context, usuario),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.error,
                    ),
                    child: const Text('Editar'),
                  ),
                ],
              ),
              ProfileInfoTile(
                label: 'Nombre de usuario',
                value: usuario.nombreUsuario,
              ),
              const SizedBox(height: 10),
              ProfileInfoTile(label: 'Nombres', value: usuario.nombres),
              const SizedBox(height: 10),
              ProfileInfoTile(label: 'Apellidos', value: usuario.apellidos),
              const SizedBox(height: 10),
              ProfileInfoTile(label: 'Correo', value: usuario.correo),
              const SizedBox(height: 10),
              ProfileInfoTile(
                label: 'Número de celular',
                value: usuario.telefono ?? '—',
              ),
              const SizedBox(height: 24),

              Text('Seguridad', style: tituloSeccion),
              const SizedBox(height: 10),
              const ProfileInfoTile(label: 'Contraseña', value: '••••••••••'),
              const SizedBox(height: 24),

              Text('Preferencias', style: tituloSeccion),
              const SizedBox(height: 10),
              PreferenceTile(
                label: 'Notificaciones',
                value: vm.notificaciones,
                onChanged: vm.setNotificaciones,
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
