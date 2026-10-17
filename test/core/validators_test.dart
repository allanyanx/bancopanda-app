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

  group('Número de cuenta', () {
    test('acepta de 6 a 20 dígitos (cuentas de cualquier banco)', () {
      expect(Validators.numeroCuenta('5000900003'), isNull);
      expect(Validators.numeroCuenta('220045'), isNull);
      expect(Validators.numeroCuenta('12345678901234567890'), isNull);
    });

    test('rechaza vacío, muy cortos, muy largos o con letras', () {
      expect(Validators.numeroCuenta(''), isNotNull);
      expect(Validators.numeroCuenta('50009'), isNotNull);
      expect(Validators.numeroCuenta('123456789012345678901'), isNotNull);
      expect(Validators.numeroCuenta('50009000ab'), isNotNull);
    });
  });

  group('Datos del beneficiario', () {
    test('la cédula es obligatoria y de 10 dígitos', () {
      expect(
        Validators.cedulaBeneficiario(''),
        'Ingresa la cédula del beneficiario',
      );
      expect(Validators.cedulaBeneficiario('0912'), isNotNull);
      expect(Validators.cedulaBeneficiario('0923456781'), isNull);
    });

    test('el nombre es opcional pero, si se escribe, solo letras', () {
      expect(Validators.nombreOpcional(''), isNull);
      expect(Validators.nombreOpcional('Juan Pérez'), isNull);
      expect(Validators.nombreOpcional('J'), isNotNull);
    });
  });

  group('Monto', () {
    String? validar(String valor) =>
        Validators.monto(valor, disponible: 1000, maximo: 5000);

    test('acepta montos con hasta 2 decimales dentro del saldo', () {
      expect(validar('25'), isNull);
      expect(validar('25.5'), isNull);
      expect(validar('1000.00'), isNull);
    });

    test('rechaza vacío, cero y más de 2 decimales', () {
      expect(validar(''), 'Ingresa el monto');
      expect(validar('0'), 'El monto debe ser mayor a cero');
      expect(validar('10.123'), isNotNull);
      expect(validar('.'), isNotNull);
    });

    test('rechaza si pasa el saldo o el máximo', () {
      expect(validar('1000.01'), 'No tienes saldo suficiente');
      expect(
        Validators.monto('5000.01', disponible: 9000, maximo: 5000),
        r'El máximo por operación es $5,000.00',
      );
    });
  });
}