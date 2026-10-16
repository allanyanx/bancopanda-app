import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../features/auth/data/datasources/remote_auth_data_source.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/auth/viewmodel/auth_view_model.dart';
import '../../features/dashboard/data/datasources/remote_dashboard_data_source.dart';
import '../../features/dashboard/data/repositories/dashboard_repository.dart';
import '../../features/profile/data/datasources/remote_profile_data_source.dart';
import '../../features/profile/data/repositories/profile_repository.dart';
import '../../features/profile/viewmodel/profile_view_model.dart';
import '../config/app_settings.dart';
import '../network/api_client.dart';
import '../storage/key_value_storage.dart';
import '../theme/theme_view_model.dart';

Future<List<SingleChildWidget>> createProviders() async {
  const storage = SecureKeyValueStorage();

  final settings = AppSettings(storage);
  await settings.load();

  final apiClient = ApiClient(settings: settings);

  final authRepository = AuthRepository(
    dataSource: RemoteAuthDataSource(apiClient),
    storage: storage,
    apiClient: apiClient,
  );

  // La sesión guardada se restaura en WelcomeScreen, no aquí.
  final authViewModel = AuthViewModel(authRepository);

  final profileViewModel = ProfileViewModel(
    repository: ProfileRepository(RemoteProfileDataSource(apiClient)),
    auth: authViewModel,
    storage: storage,
  );
  await profileViewModel.cargarPreferencias();

  final themeViewModel = ThemeViewModel(storage);
  await themeViewModel.cargar();

  final dashboardRepository = DashboardRepository(
    RemoteDashboardDataSource(apiClient),
  );

  return [
    ChangeNotifierProvider.value(value: settings),
    Provider.value(value: dashboardRepository),
    ChangeNotifierProvider.value(value: authViewModel),
    ChangeNotifierProvider.value(value: profileViewModel),
    ChangeNotifierProvider.value(value: themeViewModel),
  ];
}
