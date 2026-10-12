import 'package:bancopanda_app/core/errors/app_exception.dart';
import 'package:bancopanda_app/features/dashboard/data/datasources/dashboard_data_source.dart';
import 'package:bancopanda_app/features/dashboard/data/datasources/mock_dashboard_data_source.dart';
import 'package:bancopanda_app/features/dashboard/data/repositories/dashboard_repository.dart';
import 'package:bancopanda_app/features/dashboard/model/resumen_dashboard.dart';
import 'package:bancopanda_app/features/dashboard/viewmodel/dashboard_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

/// Datasource falso: responde lo que el test le indique.
class FakeDashboardDataSource implements DashboardDataSource {
  AppException? error;

  @override
  Future<ResumenDashboard> obtenerResumen() async {
    if (error != null) throw error!;
    return const MockDashboardDataSource().obtenerResumen();
  }
}

void main() {
  late FakeDashboardDataSource dataSource;
  late DashboardViewModel viewModel;

  setUp(() {
    dataSource = FakeDashboardDataSource();
    viewModel = DashboardViewModel(DashboardRepository(dataSource));
  });

  test('carga correcta: expone el resumen y deja de cargar', () async {
    final carga = viewModel.load();
    expect(viewModel.isLoading, isTrue);

    await carga;

    expect(viewModel.isLoading, isFalse);
    expect(viewModel.error, isNull);
    expect(viewModel.resumen, isNotNull);
    expect(viewModel.resumen!.tarjetas, isNotEmpty);
  });

  test('carga fallida: muestra el mensaje del backend', () async {
    dataSource.error = const AppException('El servidor tuvo un problema');

    await viewModel.load();

    expect(viewModel.isLoading, isFalse);
    expect(viewModel.resumen, isNull);
    expect(viewModel.error, 'El servidor tuvo un problema');
  });

  test('reintentar después de un error limpia el mensaje', () async {
    dataSource.error = const AppException('Sin conexión');
    await viewModel.load();

    dataSource.error = null;
    await viewModel.load();

    expect(viewModel.error, isNull);
    expect(viewModel.resumen, isNotNull);
  });

  test('no avisa a nadie si la pantalla se cerró antes de la respuesta',
      () async {
    final carga = viewModel.load();
    viewModel.dispose();

    await expectLater(carga, completes);
  });
}
