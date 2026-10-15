import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/utils/proximamente.dart';
import 'widgets/profile_menu_tile.dart';

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            ProfileMenuTile(
              label: 'Huella',
              onTap: () => mostrarProximamente(context),
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
