abstract final class Celular {
  static const prefijo = '+593';

  static String completo(String nueveDigitos) => '$prefijo${nueveDigitos.trim()}';

  static String local(String? telefono) {
    final texto = telefono?.trim() ?? '';
    if (texto.startsWith(prefijo)) return texto.substring(prefijo.length);
    if (texto.startsWith('0')) return texto.substring(1);
    return texto;
  }

  /// +593987654321 → "+593 9XX XXX 321"
  static String oculto(String telefono) {
    final n = local(telefono);
    if (n.length != 9) return telefono;
    return '$prefijo ${n[0]}XX XXX ${n.substring(6)}';
  }

  /// +593987654321 → "09X-XXX-X321", como lo pide el cajero.
  static String ocultoLocal(String telefono) {
    final n = local(telefono);
    if (n.length != 9) return telefono;
    return '0${n[0]}X-XXX-X${n.substring(6)}';
  }
}
