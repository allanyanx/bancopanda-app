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
    required this.ultimosDigitos,
    required this.marca,
    required this.tipo,
    required this.fechaExpiracion,
    required this.activa,
    required this.cuentaId,
    required this.saldo,
    required this.moneda,
  });

  final String tarjetaId;
  final String ultimosDigitos;
  final MarcaTarjeta marca;
  final TipoTarjeta tipo;
  final DateTime fechaExpiracion;
  final bool activa;
  final String cuentaId;
  final double saldo;
  final String moneda;

  String get nombre => '${marca.etiqueta} ${tipo.etiqueta}';
  String get numeroOculto => '•••• $ultimosDigitos';

  factory Tarjeta.fromJson(Map<String, dynamic> json) {
    return Tarjeta(
      tarjetaId: json['tarjetaId'] as String,
      ultimosDigitos: json['ultimosDigitos'] as String,
      marca: MarcaTarjeta.fromJson(json['marca'] as String),
      tipo: TipoTarjeta.fromJson(json['tipo'] as String),
      fechaExpiracion: DateTime.parse(json['fechaExpiracion'] as String),
      activa: json['activa'] as bool,
      cuentaId: json['cuentaId'] as String,
      saldo: (json['saldo'] as num).toDouble(),
      moneda: json['moneda'] as String,
    );
  }
}
