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

  group('Nombre de usuario', () {
    test('acepta letras, números, punto y guion bajo', () {
      expect(Validators.nombreUsuario('andrea.barroso_92'), isNull);
    });

    test('debe empezar con una letra', () {
      expect(Validators.nombreUsuario('9andrea'), 'Debe empezar con una letra');
    });

    test('debe tener entre 4 y 20 caracteres', () {
      expect(Validators.nombreUsuario('and'), isNotNull);
      expect(Validators.nombreUsuario('a' * 21), isNotNull);
    });

    test('rechaza otros símbolos y mayúsculas', () {
      expect(Validators.nombreUsuario('andrea-b'), isNotNull);
      expect(Validators.nombreUsuario('Andrea'), isNotNull);
    });

    test('en el login solo exige que no esté vacío', () {
      expect(Validators.nombreUsuarioLogin(''), isNotNull);
      expect(Validators.nombreUsuarioLogin('andrea'), isNull);
    });
  });

  group('Nombres y apellidos', () {
    test('aceptan letras con tildes y espacios', () {
      expect(Validators.nombres('María José'), isNull);
      expect(Validators.apellidos('Núñez Peña'), isNull);
    });

    test('rechazan números', () {
      expect(Validators.nombres('Andrea2'), isNotNull);
      expect(Validators.apellidos('Barroso 3'), isNotNull);
    });
  });

  group('Correo', () {
    test('acepta un correo común', () {
      expect(Validators.correo('andrea.barroso-92_x@gmail.com'), isNull);
      expect(Validators.correo('a@mail.empresa.ec'), isNull);
    });

    test('rechaza mayúsculas', () {
      expect(Validators.correo('Andrea@gmail.com'), 'Escribe el correo en minúsculas');
    });

    test('rechaza caracteres especiales raros', () {
      expect(Validators.correo('andrea#1@gmail.com'), isNotNull);
      expect(Validators.correo('andrea+promo@gmail.com'), isNotNull);
      expect(Validators.correo('andré@gmail.com'), isNotNull);
    });

    test('rechaza formatos incompletos', () {
      expect(Validators.correo('andrea'), isNotNull);
      expect(Validators.correo('andrea@gmail'), isNotNull);
      expect(Validators.correo('andrea@@gmail.com'), isNotNull);
      expect(Validators.correo('.andrea@gmail.com'), isNotNull);
      expect(Validators.correo('andrea..b@gmail.com'), isNotNull);
    });
  });

  group('Celular', () {
    test('acepta 9 dígitos que empiezan con 9', () {
      expect(Validators.celular('987654321'), isNull);
    });

    test('rechaza otros formatos', () {
      expect(Validators.celular('0987654321'), isNotNull);
      expect(Validators.celular('887654321'), isNotNull);
      expect(Validators.celular('98765'), isNotNull);
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