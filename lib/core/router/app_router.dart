import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/view/login_screen.dart';
import '../../features/auth/view/register_screen.dart';
import '../../features/auth/viewmodel/auth_view_model.dart';
import '../../features/dashboard/view/dashboard_screen.dart';
import '../../features/settings/view/server_settings_screen.dart';
import '../../features/shell/view/cuenta_provisional_screen.dart';
import '../../features/shell/view/en_construccion_screen.dart';
import '../../features/shell/view/main_shell.dart';

abstract final class AppRoutes {
  static const login = '/login';
  static const register = '/login/registro';
  static const serverSettings = '/login/servidor';
  static const home = '/inicio';
  static const cards = '/tarjetas';
  static const movements = '/movimientos';
  static const account = '/cuenta';
}

/// Rutas de la app, protegidas por sesión
GoRouter createAppRouter(AuthViewModel auth) {
  return GoRouter(
    initialLocation: AppRoutes.login,
    refreshListenable: auth,
    redirect: (context, state) {
      final enZonaPublica = state.matchedLocation.startsWith(AppRoutes.login);

      if (!auth.isLoggedIn && !enZonaPublica) return AppRoutes.login;
      if (auth.isLoggedIn && enZonaPublica) return AppRoutes.home;
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
        routes: [
          GoRoute(
            path: 'registro',
            builder: (context, state) => const RegisterScreen(),
          ),
          GoRoute(
            path: 'servidor',
            builder: (context, state) => const ServerSettingsScreen(),
          ),
        ],
      ),
      // Zona privada: cada pestaña de la barra inferior es una rama que
      // conserva su estado al cambiar de pestaña.
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.cards,
                builder: (context, state) => const EnConstruccionScreen(
                  titulo: 'Tarjetas',
                  icono: Icons.credit_card_outlined,
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.movements,
                builder: (context, state) => const EnConstruccionScreen(
                  titulo: 'Movimientos',
                  icono: Icons.format_list_bulleted,
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.account,
                builder: (context, state) => const CuentaProvisionalScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
