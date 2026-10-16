import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../viewmodel/profile_view_model.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_menu_tile.dart';

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
    final usuario = vm.usuario;
    if (usuario == null) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final titulo = theme.textTheme.titleMedium?.copyWith(
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
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  tooltip: 'Volver',
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  onPressed: () => context.canPop()
                      ? context.pop()
                      : context.go(AppRoutes.home),
                ),
              ),
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
              const SizedBox(height: 28),
              Text('Información', style: titulo),
              const SizedBox(height: 10),
              ProfileMenuTile(
                label: 'Datos Personales',
                onTap: () => context.push(AppRoutes.profileData),
              ),
              const SizedBox(height: 20),
              Text('Seguridad', style: titulo),
              const SizedBox(height: 10),
              ProfileMenuTile(
                label: 'Seguridad',
                onTap: () => context.push(AppRoutes.profileSecurity),
              ),
              const SizedBox(height: 20),
              Text('Preferencias', style: titulo),
              const SizedBox(height: 10),
              ProfileMenuTile(
                label: 'Configuración',
                onTap: () => context.push(AppRoutes.profileSettings),
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: vm.cerrarSesion,
                  style: TextButton.styleFrom(foregroundColor: AppColors.error),
                  child: const Text('Cerrar Sesión'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
