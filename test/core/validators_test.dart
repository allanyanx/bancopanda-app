import 'package:bancopanda_app/core/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

    group('Cédula', () {
    test('acepta 10 dígitos', () {
      expect(Validators.cedula('1234567890'), isNull);
    });

    test('rechaza si no tiene 10 dígitos', () {
      expect(Validators.cedula('12345678'), isNotNull);
    });

    test('rechaza letras', () {
      expect(Validators.cedula('12345abcde'), isNotNull);
    });

    test('rechaza si está vacía', () {
      expect(Validators.cedula(''), isNotNull);
    });
  });

  group('Login', () {
    test('acepta un correo', () {
      expect(Validators.correoOCedula('andrea@gmail.com'), isNull);
    });

    test('acepta una cédula', () {
      expect(Validators.correoOCedula('1710034065'), isNull);
    });

    test('rechaza un correo mal escrito', () {
      expect(Validators.correoOCedula('andrea@gmail'), isNotNull);
    });
  });

  group('Contraseña', () {
    test('exige letras y números', () {
      expect(Validators.contrasena('soloLetras'), isNotNull);
      expect(Validators.contrasena('12345678'), isNotNull);
      expect(Validators.contrasena('Panda2026'), isNull);
    });

    test('la confirmación debe coincidir', () {
      expect(Validators.confirmarContrasena('Panda2026', 'Panda2026'), isNull);
      expect(Validators.confirmarContrasena('Panda2027', 'Panda2026'), isNotNull);
    });
  });
}