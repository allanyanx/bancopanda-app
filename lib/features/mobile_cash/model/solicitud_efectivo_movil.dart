class SolicitudEfectivoMovil {
  const SolicitudEfectivoMovil({
    required this.solicitudId,
    required this.cuentaId,
    required this.telefonoDestino,
    required this.monto,
  });

  final String solicitudId;
  final String cuentaId;
  final String telefonoDestino;
  final double monto;

  Map<String, dynamic> toJson() => {
    'solicitudId': solicitudId,
    'cuentaId': cuentaId,
    'telefonoDestino': telefonoDestino,
    'monto': monto,
  };
}
