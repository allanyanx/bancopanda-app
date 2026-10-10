import 'package:go_router/go_router.dart';

import '../../features/auth/view/login_screen.dart';
import '../../features/auth/view/register_screen.dart';
import '../../features/auth/viewmodel/auth_view_model.dart';
import '../../features/dashboard/view/dashboard_screen.dart';
import '../../features/settings/view/server_settings_screen.dart';

abstract final class AppRoutes {
  static const login = '/login';
  static const register = '/login/registro';
  static const serverSettings = '/login/servidor';
  static const home = '/inicio';
}

/// Rutas de la app, protegidas por sesión.
/// `refreshListenable` hace que el router vuelva a evaluar `redirect` cada vez
/// que el AuthViewModel notifica un cambio (login, registro o cierre de sesión).
GoRouter createAppRouter(AuthViewModel auth) {
  return GoRouter(
    initialLocation: AppRoutes.login,
    refreshListenable: auth,
    redirect: (context, state) {
      final enZonaPublica = state.matchedLocation.startsWith(AppRoutes.login);

      if (!auth.isLoggedIn && !enZonaPublica) return AppRoutes.login;
      if (auth.isLoggedIn && enZonaPublica) return AppRoutes.home;
      return null; // Sin cambios
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
        // Rutas hijas: se apilan sobre el login, así el botón "atrás" vuelve a él.
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
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const DashboardScreen(),
      ),
    ],
  );
}
