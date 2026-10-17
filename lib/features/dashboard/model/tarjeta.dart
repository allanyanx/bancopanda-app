enum MarcaTarjeta {
  visa('Visa'),
  mastercard('Mastercard');

  const MarcaTarjeta(this.etiqueta);

  final String etiqueta;

  static MarcaTarjeta fromJson(String valor) =>
      values.byName(valor.toLowerCase());
}

enum TipoTarjeta {
  debito('Débito'),
  credito('Crédito');

  const TipoTarjeta(this.etiqueta);

  final String etiqueta;

  static TipoTarjeta fromJson(String valor) =>
      values.byName(valor.toLowerCase());
}

class Tarjeta {
  const Tarjeta({
    required this.tarjetaId,
    required this.numeroTarjeta,
    required this.marca,
    required this.tipo,
    required this.fechaExpiracion,
    required this.activa,
    required this.cuentaId,
    required this.numeroCuenta,
    required this.saldo,
    required this.moneda,
  });

  final String tarjetaId;
  final String numeroTarjeta;
  final MarcaTarjeta marca;
  final TipoTarjeta tipo;
  final DateTime fechaExpiracion;
  final bool activa;
  final String cuentaId;
  final String numeroCuenta;
  final double saldo;
  final String moneda;

  String get nombre => '${marca.etiqueta} ${tipo.etiqueta}';
  String get ultimosDigitos =>
      numeroTarjeta.substring(numeroTarjeta.length - 4);
  String get numeroOculto => '•••• $ultimosDigitos';

  /// El número completo en grupos de 4: 4754 0091 7145 4821.
  String get numeroFormateado => [
    for (var i = 0; i < numeroTarjeta.length; i += 4)
      numeroTarjeta.substring(i, (i + 4).clamp(0, numeroTarjeta.length)),
  ].join(' ');

  factory Tarjeta.fromJson(Map<String, dynamic> json) {
    return Tarjeta(
      tarjetaId: json['tarjetaId'] as String,
      numeroTarjeta: json['numeroTarjeta'] as String,
      marca: MarcaTarjeta.fromJson(json['marca'] as String),
      tipo: TipoTarjeta.fromJson(json['tipo'] as String),
      fechaExpiracion: DateTime.parse(json['fechaExpiracion'] as String),
      activa: json['activa'] as bool,
      cuentaId: json['cuentaId'] as String,
      numeroCuenta: json['numeroCuenta'] as String,
      saldo: (json['saldo'] as num).toDouble(),
      moneda: json['moneda'] as String,
    );
  }
}
