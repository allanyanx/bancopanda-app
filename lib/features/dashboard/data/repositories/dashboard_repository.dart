import '../../model/movimiento.dart';
import '../../model/resumen_dashboard.dart';
import '../datasources/dashboard_data_source.dart';

class DashboardRepository {
  DashboardRepository(this._dataSource);

  final DashboardDataSource _dataSource;

  Future<ResumenDashboard> obtenerResumen({
    required int limiteMovimientos,
  }) async {
    final cuentas = _dataSource.obtenerCuentas();
    final tarjetas = _dataSource.obtenerTarjetas();
    final movimientos = _dataSource.obtenerMovimientos(
      limite: limiteMovimientos,
    );
    await Future.wait([cuentas, tarjetas, movimientos]);

    return ResumenDashboard(
      cuentas: await cuentas,
      tarjetas: await tarjetas,
      movimientos: await movimientos,
    );
  }

  Future<List<Movimiento>> obtenerMovimientos({required int limite}) =>
      _dataSource.obtenerMovimientos(limite: limite);

  Future<List<Movimiento>> obtenerMovimientosDeTarjeta(
    String tarjetaId, {
    required int limite,
  }) => _dataSource.obtenerMovimientosDeTarjeta(tarjetaId, limite: limite);
}
