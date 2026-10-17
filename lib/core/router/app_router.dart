import 'package:go_router/go_router.dart';

import '../../features/auth/view/login_screen.dart';
import '../../features/auth/view/register_screen.dart';
import '../../features/auth/viewmodel/auth_view_model.dart';
import '../../features/dashboard/view/dashboard_screen.dart';
import '../../features/dashboard/view/movements_screen.dart';
import '../../features/settings/view/server_settings_screen.dart';
import '../../features/profile/view/profile_screen.dart';
import '../../features/profile/view/personal_data_screen.dart';
import '../../features/profile/view/security_screen.dart';
import '../../features/auth/view/welcome_screen.dart';
import '../../features/profile/view/change_password_screen.dart';
import '../../features/profile/view/preferences_screen.dart';
import '../../features/transfers/view/transfer_screen.dart';
import '../../features/mobile_cash/view/mobile_cash_screen.dart';
import '../../features/services/view/pay_services_screen.dart';
import '../../features/cards/view/cards_screen.dart';

abstract final class AppRoutes {
  static const login = '/login';
  static const register = '/login/registro';
  static const serverSettings = '/login/servidor';
  static const home = '/inicio';
  static const profile = '/perfil';
  static const movements = '/movimientos';
  static const profileData = '/perfil/datos';
  static const profileSecurity = '/perfil/seguridad';
  static const welcome = '/bienvenida';
  static const profilePassword = '/perfil/seguridad/contrasena';
  static const profileSettings = '/perfil/configuracion';
  static const transfer = '/transferir';
  static const mobileCash = '/efectivo-movil';
  static const payServices = '/pagar-servicios';
  static const cards = '/tarjetas';
}

GoRouter createAppRouter(AuthViewModel auth) {
  return GoRouter(
    initialLocation: AppRoutes.welcome,
    refreshListenable: auth,
    redirect: (context, state) {
      final ubicacion = state.matchedLocation;

      if (ubicacion == AppRoutes.welcome) return null;

      final enZonaPublica = ubicacion.startsWith(AppRoutes.login);

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
      GoRoute(
        path: AppRoutes.welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const ProfileScreen(),
        routes: [
          GoRoute(
            path: 'datos',
            builder: (context, state) => const PersonalDataScreen(),
          ),
          GoRoute(
            path: 'seguridad',
            builder: (context, state) => const SecurityScreen(),
            routes: [
              GoRoute(
                path: 'contrasena',
                builder: (context, state) => const ChangePasswordScreen(),
              ),
            ],
          ),
          GoRoute(
            path: 'configuracion',
            builder: (context, state) => const PreferencesScreen(),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.transfer,
        builder: (context, state) => const TransferScreen(),
      ),
      GoRoute(
        path: AppRoutes.mobileCash,
        builder: (context, state) => const MobileCashScreen(),
      ),
      GoRoute(
        path: AppRoutes.payServices,
        builder: (context, state) => const PayServicesScreen(),
      ),
      GoRoute(
        path: AppRoutes.cards,
        builder: (context, state) => const CardsScreen(),
      ),
      GoRoute(
        path: AppRoutes.movements,
        builder: (context, state) => const MovementsScreen(),
      ),
    ],
  );
}
