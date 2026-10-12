enum MarcaTarjeta {
  visa('Visa'),
  mastercard('Mastercard');

  const MarcaTarjeta(this.etiqueta);

  final String etiqueta;
}

enum TipoTarjeta {
  debito('Débito'),
  credito('Crédito');

  const TipoTarjeta(this.etiqueta);

  final String etiqueta;
}

/// Tarjeta asociada a una cuenta. Los campos se llaman igual que en el
/// backend y en la base de datos (tarjetaId, ultimosDigitos...).
class Tarjeta {
  const Tarjeta({
    required this.tarjetaId,
    required this.cuentaId,
    required this.ultimosDigitos,
    required this.marca,
    required this.tipo,
    required this.fechaExpiracion,
  });

  final String tarjetaId;
  final String cuentaId;
  final String ultimosDigitos;
  final MarcaTarjeta marca;
  final TipoTarjeta tipo;
  final DateTime fechaExpiracion;
}
