import 'cuenta.dart';
import 'movimiento.dart';
import 'tarjeta.dart';

/// Todo lo que muestra la pantalla de inicio.
class ResumenDashboard {
  const ResumenDashboard({
    required this.cuenta,
    required this.tarjetas,
    required this.movimientos,
  });

  final Cuenta cuenta;
  final List<Tarjeta> tarjetas;
  final List<Movimiento> movimientos;
}
