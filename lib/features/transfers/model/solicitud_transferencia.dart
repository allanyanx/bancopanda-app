import 'destino.dart';

class SolicitudTransferencia {
  const SolicitudTransferencia({
    required this.solicitudId,
    required this.cuentaOrigenId,
    required this.destino,
    required this.monto,
  });

  final String solicitudId;
  final String cuentaOrigenId;
  final Destino destino;
  final double monto;

  Map<String, dynamic> toJson() => {
    'solicitudId': solicitudId,
    'cuentaOrigenId': cuentaOrigenId,
    'bancoId': destino.bancoId,
    'numeroCuenta': destino.numeroCuenta,
    'cedula': destino.cedula,
    'nombre': destino.nombre,
    'monto': monto,
  };
}
