import 'cuenta.dart';
import 'movimiento.dart';
import 'tarjeta.dart';

class ResumenDashboard {
  const ResumenDashboard({
    required this.cuentas,
    required this.tarjetas,
    required this.movimientos,
  });

  final List<Cuenta> cuentas;
  final List<Tarjeta> tarjetas;
  final List<Movimiento> movimientos;

  double get saldoTotal =>
      cuentas.fold(0, (total, cuenta) => total + cuenta.saldo);

  String get moneda => cuentas.isEmpty ? 'USD' : cuentas.first.moneda;
}
