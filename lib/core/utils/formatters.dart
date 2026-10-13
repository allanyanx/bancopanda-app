import 'package:intl/intl.dart';

abstract final class Formatters {
  static final _moneda = NumberFormat.currency(locale: 'en_US', symbol: r'$');

  static const _meses = [
    'ene',
    'feb',
    'mar',
    'abr',
    'may',
    'jun',
    'jul',
    'ago',
    'sep',
    'oct',
    'nov',
    'dic',
  ];

  static String moneda(double monto) => _moneda.format(monto);

  static String fechaMovimiento(DateTime fecha, {DateTime? ahora}) {
    final local = fecha.toLocal();
    final hoy = ahora ?? DateTime.now();
    final hora = '${_dosDigitos(local.hour)}:${_dosDigitos(local.minute)}';

    final dias = _soloFecha(hoy).difference(_soloFecha(local)).inDays;
    if (dias == 0) return 'Hoy, $hora';
    if (dias == 1) return 'Ayer, $hora';

    final dia = '${local.day} ${_meses[local.month - 1]}';
    return local.year == hoy.year ? '$dia, $hora' : '$dia ${local.year}';
  }

  static String expiracion(DateTime fecha) =>
      '${_dosDigitos(fecha.month)}/${_dosDigitos(fecha.year % 100)}';

  static DateTime _soloFecha(DateTime fecha) =>
      DateTime.utc(fecha.year, fecha.month, fecha.day);

  static String _dosDigitos(int valor) => valor.toString().padLeft(2, '0');
}
