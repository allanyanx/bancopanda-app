import '../../model/cuenta.dart';
import '../../model/movimiento.dart';
import '../../model/tarjeta.dart';

abstract interface class DashboardDataSource {
  Future<List<Cuenta>> obtenerCuentas();
  Future<List<Tarjeta>> obtenerTarjetas();
  Future<List<Movimiento>> obtenerMovimientos({required int limite});
}
