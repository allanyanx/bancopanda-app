abstract final class Celular {
  static const prefijo = '+593';

  static String completo(String nueveDigitos) => '$prefijo${nueveDigitos.trim()}';

  static String local(String? telefono) {
    final texto = telefono?.trim() ?? '';
    if (texto.startsWith(prefijo)) return texto.substring(prefijo.length);
    if (texto.startsWith('0')) return texto.substring(1);
    return texto;
  }
}
