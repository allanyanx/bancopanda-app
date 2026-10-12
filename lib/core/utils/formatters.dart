import 'package:intl/intl.dart';

/// Formatos de presentación para montos y fechas. Solo dan forma al texto
/// que se muestra: no calculan ni validan nada.
abstract final class Formatters {
  static final _moneda = NumberFormat.currency(locale: 'en_US', symbol: r'$');
  static final _hora = DateFormat('HH:mm');
  static final _fecha = DateFormat('dd/MM/yyyy');
  static final _expiracion = DateFormat('MM/yy');

  /// 12456.8 → "$12,456.80"
  static String moneda(double monto) => _moneda.format(monto);

  /// Vencimiento de una tarjeta: "05/27"
  static String expiracion(DateTime fecha) => _expiracion.format(fecha);

  /// "Hoy, 12:32", "Ayer, 14:12" o "09/10/2026, 14:12".
  static String fechaMovimiento(DateTime fecha, {DateTime? ahora}) {
    final local = fecha.toLocal();
    final dias = _soloFecha(ahora ?? DateTime.now())
        .difference(_soloFecha(local))
        .inDays;

    final dia = switch (dias) {
      0 => 'Hoy',
      1 => 'Ayer',
      _ => _fecha.format(local),
    };
    return '$dia, ${_hora.format(local)}';
  }

  static DateTime _soloFecha(DateTime fecha) =>
      DateTime.utc(fecha.year, fecha.month, fecha.day);
}
