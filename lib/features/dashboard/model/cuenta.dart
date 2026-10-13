enum TipoCuenta {
  ahorros('Cuenta de ahorro'),
  corriente('Cuenta corriente');

  const TipoCuenta(this.etiqueta);

  final String etiqueta;

  static TipoCuenta fromJson(String valor) =>
      values.byName(valor.toLowerCase());
}

class Cuenta {
  const Cuenta({
    required this.cuentaId,
    required this.numeroCuenta,
    required this.tipo,
    required this.saldo,
    required this.moneda,
  });

  final String cuentaId;
  final String numeroCuenta;
  final TipoCuenta tipo;
  final double saldo;
  final String moneda;

  factory Cuenta.fromJson(Map<String, dynamic> json) {
    return Cuenta(
      cuentaId: json['cuentaId'] as String,
      numeroCuenta: json['numeroCuenta'] as String,
      tipo: TipoCuenta.fromJson(json['tipo'] as String),
      saldo: (json['saldo'] as num).toDouble(),
      moneda: json['moneda'] as String,
    );
  }
}
