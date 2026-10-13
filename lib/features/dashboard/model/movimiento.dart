enum TipoMovimiento {
  ingreso,
  egreso;

  static TipoMovimiento fromJson(String valor) =>
      values.byName(valor.toLowerCase());
}

enum CategoriaMovimiento {
  sueldo('Sueldo'),
  transferencia('Transferencia'),
  comida('Comida'),
  transporte('Transporte'),
  compras('Compras'),
  servicios('Servicios'),
  otros('Otros');

  const CategoriaMovimiento(this.etiqueta);

  final String etiqueta;

  static CategoriaMovimiento fromJson(String valor) =>
      values.asNameMap()[valor.toLowerCase()] ?? otros;
}

class Movimiento {
  const Movimiento({
    required this.movimientoId,
    required this.descripcion,
    required this.monto,
    required this.tipo,
    required this.categoria,
    required this.fecha,
    required this.cuentaId,
  });

  final String movimientoId;
  final String descripcion;
  final double monto;
  final TipoMovimiento tipo;
  final CategoriaMovimiento categoria;
  final DateTime fecha;
  final String cuentaId;

  bool get esIngreso => tipo == TipoMovimiento.ingreso;

  factory Movimiento.fromJson(Map<String, dynamic> json) {
    return Movimiento(
      movimientoId: json['movimientoId'] as String,
      descripcion: json['descripcion'] as String,
      monto: (json['monto'] as num).toDouble(),
      tipo: TipoMovimiento.fromJson(json['tipo'] as String),
      categoria: CategoriaMovimiento.fromJson(json['categoria'] as String),
      fecha: DateTime.parse(json['fecha'] as String).toLocal(),
      cuentaId: json['cuentaId'] as String,
    );
  }
}
