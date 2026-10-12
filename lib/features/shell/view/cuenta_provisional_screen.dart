import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_view_model.dart';
import '../../auth/viewmodel/auth_view_model.dart';

/// Pestaña "Tu cuenta" provisional: datos de la sesión, modo oscuro y
/// cierre de sesión. Se reemplazará por la pantalla de perfil.
class CuentaProvisionalScreen extends StatelessWidget {
  const CuentaProvisionalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();
    final theme = context.watch<ThemeViewModel>();
    final textTheme = Theme.of(context).textTheme;
    final usuario = auth.usuario;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              usuario?.nombreCompleto ?? '',
              textAlign: TextAlign.center,
              style:
                  textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              usuario?.correo ?? '',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            SwitchListTile(
              title: const Text('Modo oscuro'),
              value: theme.isDark,
              onChanged: theme.setDarkMode,
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: FilledButton.icon(
                onPressed: () => context.push(AppRoutes.profile),
                icon: const Icon(Icons.person_outline),
                label: const Text('Mi perfil'),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: auth.logout,
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
              child: const Text('Cerrar Sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
