import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/router/app_router.dart';
import '../../../core/widgets/status_dialog.dart';
import '../viewmodel/profile_view_model.dart';
import 'widgets/preference_tile.dart';
import 'widgets/profile_menu_tile.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  Future<void> _cambiarHuella(bool activar) async {
    await context.read<ProfileViewModel>().setHuella(activar);
    if (!mounted) return;
    await mostrarEstado(
      context,
      icono: Icons.fingerprint,
      titulo: activar ? 'Huella activada' : 'Huella desactivada',
      mensaje: activar
          ? 'Se acaba de activar el acceso con huella.'
          : 'Se desactivó el acceso con huella.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProfileViewModel>();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Seguridad'),
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
              label: 'Huella',
              value: vm.huella,
              onChanged: _cambiarHuella,
            ),
            const SizedBox(height: 12),
            ProfileMenuTile(
              label: 'Cambio de contraseña',
              onTap: () => context.push(AppRoutes.profilePassword),
            ),
          ],
        ),
      ),
    );
  }
}
