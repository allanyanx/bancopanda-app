class Comprobante {
  const Comprobante({
    required this.transferenciaId,
    required this.referencia,
    required this.fecha,
    required this.monto,
    required this.moneda,
    required this.cuentaOrigen,
    required this.banco,
    required this.cuentaDestino,
    required this.saldoDisponible,
    this.beneficiario,
  });

  final String transferenciaId;
  final String referencia;
  final DateTime fecha;
  final double monto;
  final String moneda;
  final String cuentaOrigen;
  final String banco;
  final String cuentaDestino;
  final String? beneficiario;
  final double saldoDisponible;

  factory Comprobante.fromJson(Map<String, dynamic> json) {
    return Comprobante(
      transferenciaId: json['transferenciaId'] as String,
      referencia: json['referencia'] as String,
      fecha: DateTime.parse(json['fecha'] as String).toLocal(),
      monto: (json['monto'] as num).toDouble(),
      moneda: json['moneda'] as String,
      cuentaOrigen: json['cuentaOrigen'] as String,
      banco: json['banco'] as String,
      cuentaDestino: json['cuentaDestino'] as String,
      beneficiario: json['beneficiario'] as String?,
      saldoDisponible: (json['saldoDisponible'] as num).toDouble(),
    );
  }
}
