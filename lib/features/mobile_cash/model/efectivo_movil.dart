class EfectivoMovil {
  const EfectivoMovil({
    required this.efectivoMovilId,
    required this.primerCodigo,
    required this.segundoCodigo,
    required this.monto,
    required this.moneda,
    required this.telefonoDestino,
    required this.fechaCreacion,
    required this.fechaExpiracion,
    required this.estado,
    required this.numeroCuenta,
    required this.saldoDisponible,
  });

  final String efectivoMovilId;
  final String primerCodigo;
  final String segundoCodigo;
  final double monto;
  final String moneda;
  final String telefonoDestino;
  final DateTime fechaCreacion;
  final DateTime fechaExpiracion;
  final String estado;
  final String numeroCuenta;
  final double saldoDisponible;

  factory EfectivoMovil.fromJson(Map<String, dynamic> json) {
    return EfectivoMovil(
      efectivoMovilId: json['efectivoMovilId'] as String,
      primerCodigo: json['primerCodigo'] as String,
      segundoCodigo: json['segundoCodigo'] as String,
      monto: (json['monto'] as num).toDouble(),
      moneda: json['moneda'] as String,
      telefonoDestino: json['telefonoDestino'] as String,
      fechaCreacion: DateTime.parse(json['fechaCreacion'] as String).toLocal(),
      fechaExpiracion: DateTime.parse(json['fechaExpiracion'] as String)
          .toLocal(),
      estado: json['estado'] as String,
      numeroCuenta: json['numeroCuenta'] as String,
      saldoDisponible: (json['saldoDisponible'] as num).toDouble(),
    );
  }
}
