import '../../model/cuenta.dart';
import '../../model/movimiento.dart';
import '../../model/resumen_dashboard.dart';
import '../../model/tarjeta.dart';
import 'dashboard_data_source.dart';

/// Datos de ejemplo para construir la parte visual del dashboard.
/// Se reemplaza por la implementación remota cuando el backend exponga
/// las cuentas, tarjetas y movimientos.
class MockDashboardDataSource implements DashboardDataSource {
  const MockDashboardDataSource();

  static const _cuentaId = 'cuenta-ejemplo';

  @override
  Future<ResumenDashboard> obtenerResumen() async {
    final hoy = DateTime.now();

    return ResumenDashboard(
      cuenta: const Cuenta(
        cuentaId: _cuentaId,
        numeroCuenta: '5000123456',
        tipo: TipoCuenta.ahorros,
        saldo: 100.00,
        moneda: 'USD',
      ),
      tarjetas: [
        Tarjeta(
          tarjetaId: 'tarjeta-ejemplo-1',
          cuentaId: _cuentaId,
          ultimosDigitos: '4821',
          marca: MarcaTarjeta.visa,
          tipo: TipoTarjeta.debito,
          fechaExpiracion: DateTime(2027, 5),
        ),
        Tarjeta(
          tarjetaId: 'tarjeta-ejemplo-2',
          cuentaId: _cuentaId,
          ultimosDigitos: '7730',
          marca: MarcaTarjeta.visa,
          tipo: TipoTarjeta.credito,
          fechaExpiracion: DateTime(2028, 11),
        ),
      ],
      movimientos: [
        Movimiento(
          movimientoId: 'movimiento-ejemplo-1',
          cuentaId: _cuentaId,
          descripcion: 'McDonalds',
          monto: 84.20,
          tipo: TipoMovimiento.egreso,
          categoria: CategoriaMovimiento.comida,
          fecha: DateTime(hoy.year, hoy.month, hoy.day, 12, 32),
        ),
        Movimiento(
          movimientoId: 'movimiento-ejemplo-2',
          cuentaId: _cuentaId,
          descripcion: 'Deprati',
          monto: 84.20,
          tipo: TipoMovimiento.egreso,
          categoria: CategoriaMovimiento.compras,
          fecha: DateTime(hoy.year, hoy.month, hoy.day, 14, 12),
        ),
      ],
    );
  }
}
