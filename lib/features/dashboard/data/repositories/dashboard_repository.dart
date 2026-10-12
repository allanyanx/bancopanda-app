import '../../model/resumen_dashboard.dart';
import '../datasources/dashboard_data_source.dart';

/// Entrega al view model los datos de la pantalla de inicio.
class DashboardRepository {
  const DashboardRepository(this._dataSource);

  final DashboardDataSource _dataSource;

  Future<ResumenDashboard> obtenerResumen() => _dataSource.obtenerResumen();
}
