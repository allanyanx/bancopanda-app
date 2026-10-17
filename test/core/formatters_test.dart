import 'package:bancopanda_app/core/utils/formatters.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('moneda', () {
    test('usa separador de miles y dos decimales', () {
      expect(Formatters.moneda(12456.8), r'$12,456.80');
      expect(Formatters.moneda(100), r'$100.00');
      expect(Formatters.moneda(0), r'$0.00');
    });
  });

  group('fechaMovimiento', () {
    final ahora = DateTime(2026, 10, 13, 18, 0);

    test('hoy y ayer se escriben con palabras', () {
      expect(
        Formatters.fechaMovimiento(DateTime(2026, 10, 13, 9, 5), ahora: ahora),
        'Hoy, 09:05',
      );
      expect(
        Formatters.fechaMovimiento(
          DateTime(2026, 10, 12, 23, 59),
          ahora: ahora,
        ),
        'Ayer, 23:59',
      );
    });

    test('los días anteriores muestran día y mes', () {
      expect(
        Formatters.fechaMovimiento(DateTime(2026, 10, 1, 14, 12), ahora: ahora),
        '1 oct, 14:12',
      );
    });

    test('otro año muestra el año en lugar de la hora', () {
      expect(
        Formatters.fechaMovimiento(DateTime(2025, 12, 24, 20, 0), ahora: ahora),
        '24 dic 2025',
      );
    });
  });

  test('expiracion usa el formato MM/AA de las tarjetas', () {
    expect(Formatters.expiracion(DateTime(2027, 5, 1)), '05/27');
    expect(Formatters.expiracion(DateTime(2030, 12, 31)), '12/30');
  });

  test('fechaComprobante muestra día, mes, año y hora', () {
    expect(
      Formatters.fechaComprobante(DateTime(2026, 10, 16, 8, 5)),
      '16 oct 2026, 08:05',
    );
  });
}
