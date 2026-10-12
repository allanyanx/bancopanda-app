import 'package:bancopanda_app/core/utils/formatters.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('moneda: separador de miles y dos decimales', () {
    expect(Formatters.moneda(100), r'$100.00');
    expect(Formatters.moneda(12456.8), r'$12,456.80');
  });

  test('expiración de tarjeta en formato MM/AA', () {
    expect(Formatters.expiracion(DateTime(2027, 5)), '05/27');
  });

  group('fecha de un movimiento', () {
    final ahora = DateTime(2026, 10, 11, 18);

    test('del mismo día: "Hoy"', () {
      expect(
        Formatters.fechaMovimiento(DateTime(2026, 10, 11, 12, 32), ahora: ahora),
        'Hoy, 12:32',
      );
    });

    test('del día anterior, aunque falten menos de 24 horas: "Ayer"', () {
      expect(
        Formatters.fechaMovimiento(DateTime(2026, 10, 10, 23, 50), ahora: ahora),
        'Ayer, 23:50',
      );
    });

    test('más antigua: fecha completa', () {
      expect(
        Formatters.fechaMovimiento(DateTime(2026, 10, 1, 9, 5), ahora: ahora),
        '01/10/2026, 09:05',
      );
    });
  });
}
