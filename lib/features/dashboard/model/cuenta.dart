enum TipoCuenta {
  ahorros('Cuenta de ahorro'),
  corriente('Cuenta corriente');

  const TipoCuenta(this.etiqueta);

  final String etiqueta;
}

/// Cuenta bancaria del usuario. Los campos se llaman igual que en el backend
/// y en la base de datos (cuentaId, numeroCuenta...).
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
}
