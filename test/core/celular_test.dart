import 'package:bancopanda_app/core/utils/celular.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('agrega el código de Ecuador', () {
    expect(Celular.completo('987654321'), '+593987654321');
  });

  test('quita el código de Ecuador para editar', () {
    expect(Celular.local('+593987654321'), '987654321');
  });

  test('convierte el formato antiguo 09', () {
    expect(Celular.local('0987654321'), '987654321');
  });

  test('sin teléfono devuelve vacío', () {
    expect(Celular.local(null), '');
  });

  test('oculta el celular para mostrarlo en pantalla', () {
    expect(Celular.oculto('+593987654321'), '+593 9XX XXX 321');
    expect(Celular.ocultoLocal('+593987654321'), '09X-XXX-X321');
  });
}
