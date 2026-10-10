/// Validaciones de formularios. Cada método devuelve `null` si el valor
/// es válido, o el mensaje de error que se muestra bajo el campo.
abstract final class Validators {
  static final _correoRegex = RegExp(r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$');
  static final _nombreRegex = RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ ]{2,60}$');
  static final _telefonoRegex = RegExp(r'^09\d{8}$');
  static final _cedulaRegex = RegExp(r'^\d{10}$');

  static String? nombres(String? value) => _nombre(value, 'tus nombres');

  static String? apellidos(String? value) => _nombre(value, 'tus apellidos');

  static String? _nombre(String? value, String campo) {
    final texto = value?.trim() ?? '';
    if (texto.isEmpty) return 'Ingresa $campo';
    if (!_nombreRegex.hasMatch(texto)) return 'Solo letras, mínimo 2';
    return null;
  }

  static String? correo(String? value) {
    final texto = value?.trim() ?? '';
    if (texto.isEmpty) return 'Ingresa tu correo electrónico';
    if (!_correoRegex.hasMatch(texto)) return 'Correo electrónico no válido';
    return null;
  }

  static String? cedula(String? value) {
    final texto = value?.trim() ?? '';
    if (texto.isEmpty) return 'Ingresa tu cédula';
    if (!_cedulaRegex.hasMatch(texto)) return 'La cédula debe tener 10 dígitos';
    return null;
  }

  static String? correoOCedula(String? value) {
    final texto = value?.trim() ?? '';
    if (texto.isEmpty) return 'Ingresa tu correo o cédula';
    return texto.contains('@') ? correo(texto) : cedula(texto);
  }

  static String? telefono(String? value) {
    final texto = value?.trim() ?? '';
    if (texto.isEmpty) return 'Ingresa tu número de teléfono';
    if (!_telefonoRegex.hasMatch(texto)) return 'Debe tener 10 dígitos y empezar con 09';
    return null;
  }

  static String? contrasena(String? value) {
    final texto = value ?? '';
    if (texto.isEmpty) return 'Ingresa tu contraseña';
    if (texto.length < 8) return 'Mínimo 8 caracteres';
    if (!texto.contains(RegExp(r'[A-Za-z]')) || !texto.contains(RegExp(r'\d'))) {
      return 'Debe incluir letras y números';
    }
    return null;
  }

  static String? contrasenaLogin(String? value) {
    return (value == null || value.isEmpty) ? 'Ingresa tu contraseña' : null;
  }

  static String? confirmarContrasena(String? value, String original) {
    if (value == null || value.isEmpty) return 'Confirma tu contraseña';
    if (value != original) return 'Las contraseñas no coinciden';
    return null;
  }

  /// Dirección del backend: http(s)://host[:puerto]
  static String? urlServidor(String? value) {
    final texto = value?.trim() ?? '';
    if (texto.isEmpty) return 'Ingresa la dirección del servidor';
    final uri = Uri.tryParse(texto);
    final esValida = uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
    return esValida ? null : 'Usa el formato http://host:puerto';
  }
}