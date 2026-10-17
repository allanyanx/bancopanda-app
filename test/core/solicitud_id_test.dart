import 'package:bancopanda_app/core/utils/solicitud_id.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('genera un UUID v4 válido', () {
    expect(
      nuevoSolicitudId(),
      matches(
        RegExp(
          r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
        ),
      ),
    );
  });

  test('cada llamada da un identificador distinto', () {
    final ids = {for (var i = 0; i < 1000; i++) nuevoSolicitudId()};
    expect(ids, hasLength(1000));
  });
}
