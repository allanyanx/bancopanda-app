class SolicitudEfectivoMovil {
  const SolicitudEfectivoMovil({
    required this.solicitudId,
    required this.cuentaId,
    required this.monto,
    this.telefonoDestino,
  });

  final String solicitudId;
  final String cuentaId;
  final double monto;

  /// null = "Mi número": el API usa el celular registrado del usuario.
  final String? telefonoDestino;

  Map<String, dynamic> toJson() => {
    'solicitudId': solicitudId,
    'cuentaId': cuentaId,
    'monto': monto,
    if (telefonoDestino != null) 'telefonoDestino': telefonoDestino,
  };
}
