import 'package:flutter/services.dart';

abstract final class InputFormatters {
  static final soloLetras = <TextInputFormatter>[
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ ]')),
    LengthLimitingTextInputFormatter(60),
  ];

  static final nombreUsuario = <TextInputFormatter>[
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9._]')),
    LengthLimitingTextInputFormatter(20),
    const _Minusculas(),
  ];

  static final correo = <TextInputFormatter>[
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9._@-]')),
    LengthLimitingTextInputFormatter(150),
    const _Minusculas(),
  ];

  static final celular = <TextInputFormatter>[
    FilteringTextInputFormatter.digitsOnly,
    const _SinCeroInicial(),
    LengthLimitingTextInputFormatter(9),
  ];

  static final numeroCuenta = <TextInputFormatter>[
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(20),
  ];

  static final cedula = <TextInputFormatter>[
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(10),
  ];

  static final monto = <TextInputFormatter>[const _Monto()];
}

/// Acepta solo montos como 1500 o 25.50: cambia la coma por punto y no deja
/// escribir más de 2 decimales.
class _Monto extends TextInputFormatter {
  const _Monto();

  static final _valido = RegExp(r'^\d{0,7}(\.\d{0,2})?$');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final texto = newValue.text.replaceAll(',', '.');
    if (!_valido.hasMatch(texto)) return oldValue;
    return newValue.copyWith(text: texto);
  }
}

class _SinCeroInicial extends TextInputFormatter {
  const _SinCeroInicial();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final texto = newValue.text.replaceFirst(RegExp(r'^0+'), '');
    return TextEditingValue(
      text: texto,
      selection: TextSelection.collapsed(offset: texto.length),
    );
  }
}

class _Minusculas extends TextInputFormatter {
  const _Minusculas();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(text: newValue.text.toLowerCase());
  }
}
