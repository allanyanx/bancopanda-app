import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../features/auth/data/datasources/remote_auth_data_source.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/auth/viewmodel/auth_view_model.dart';
import '../config/app_settings.dart';
import '../network/api_client.dart';
import '../storage/key_value_storage.dart';
import '../theme/theme_view_model.dart';

/// Inyección de dependencias, lugar concreto para todas las implementaciones
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

  return [
    ChangeNotifierProvider.value(value: settings),
    ChangeNotifierProvider.value(value: authViewModel),
    ChangeNotifierProvider(create: (_) => ThemeViewModel()),
  ];
}
