enum TipoMovimiento { ingreso, egreso }

enum CategoriaMovimiento {
  sueldo,
  transferencia,
  comida,
  transporte,
  compras,
  servicios,
  otros,
}

/// Movimiento de una cuenta. Los campos se llaman igual que en el backend
/// y en la base de datos (movimientoId, descripcion...).
class Movimiento {
  const Movimiento({
    required this.movimientoId,
    required this.cuentaId,
    required this.descripcion,
    required this.monto,
    required this.tipo,
    required this.categoria,
    required this.fecha,
  });

  final String movimientoId;
  final String cuentaId;
  final String descripcion;

  /// Siempre positivo: el signo lo da [tipo].
  final double monto;
  final TipoMovimiento tipo;
  final CategoriaMovimiento categoria;
  final DateTime fecha;
}
