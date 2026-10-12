import '../../model/resumen_dashboard.dart';

/// Contrato de la fuente de datos del dashboard. El repositorio depende de
/// esta interfaz, así que se puede cambiar la implementación (datos de
/// ejemplo, API real) sin tocar el resto de la app.
abstract interface class DashboardDataSource {
  Future<ResumenDashboard> obtenerResumen();
}
