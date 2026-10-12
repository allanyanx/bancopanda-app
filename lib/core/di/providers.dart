import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../features/auth/data/datasources/remote_auth_data_source.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/auth/viewmodel/auth_view_model.dart';
import '../../features/dashboard/data/datasources/mock_dashboard_data_source.dart';
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

  final authViewModel = AuthViewModel(authRepository);
  await authViewModel.restoreSession();

  // Datos de ejemplo mientras el backend no exponga el dashboard.
  const dashboardRepository = DashboardRepository(MockDashboardDataSource());

  final profileViewModel = ProfileViewModel(
    repository: ProfileRepository(
      dataSource: RemoteProfileDataSource(apiClient),
      storage: storage,
    ),
    auth: authViewModel,
  );
  await profileViewModel.loadPreferences();

  return [
    ChangeNotifierProvider.value(value: settings),
    ChangeNotifierProvider.value(value: authViewModel),
    Provider.value(value: dashboardRepository),
    ChangeNotifierProvider.value(value: profileViewModel),
    ChangeNotifierProvider(create: (_) => ThemeViewModel()),
  ];
}
