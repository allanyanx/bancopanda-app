abstract final class Validators {
  static final _nombreRegex = RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ ]{2,60}$');
  static final _cedulaRegex = RegExp(r'^\d{10}$');
  static final _celularRegex = RegExp(r'^9\d{8}$');
  static final _usuarioCaracteres = RegExp(r'^[a-z0-9._]+$');
  static final _correoCaracteres = RegExp(r'^[a-z0-9._@-]+$');
  static final _correoUsuario = RegExp(r'^[a-z0-9]([a-z0-9._-]*[a-z0-9])?$');
  static final _correoDominio = RegExp(
    r'^[a-z0-9]([a-z0-9-]*[a-z0-9])?(\.[a-z0-9]([a-z0-9-]*[a-z0-9])?)*\.[a-z]{2,}$',
  );

  static String? nombreUsuario(String? value) {
    final texto = value?.trim() ?? '';
    if (texto.isEmpty) return 'Elige un nombre de usuario';
    if (texto.length < 4 || texto.length > 20) {
      return 'Debe tener entre 4 y 20 caracteres';
    }
    if (!RegExp(r'^[a-z]').hasMatch(texto)) return 'Debe empezar con una letra';
    if (!_usuarioCaracteres.hasMatch(texto)) {
      return 'Solo letras minúsculas, números, punto (.) o guion bajo (_)';
    }
    return null;
  }

  static String? nombreUsuarioLogin(String? value) {
    final texto = value?.trim() ?? '';
    return texto.isEmpty ? 'Ingresa tu nombre de usuario' : null;
  }

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
    if (texto != texto.toLowerCase()) return 'Escribe el correo en minúsculas';
    if (!_correoCaracteres.hasMatch(texto)) {
      return 'Solo se permiten letras, números, punto (.), guion (-) y guion bajo (_)';
    }

    final partes = texto.split('@');
    if (partes.length != 2 || partes[0].isEmpty || partes[1].isEmpty) {
      return 'Escribe un correo como nombre@dominio.com';
    }
    if (texto.contains('..')) return 'El correo no puede tener dos puntos seguidos';
    if (!_correoUsuario.hasMatch(partes[0])) {
      return 'Antes de la @ debe empezar y terminar con una letra o un número';
    }
    if (!_correoDominio.hasMatch(partes[1])) {
      return 'Revisa el dominio, por ejemplo: @gmail.com';
    }
    return null;
  }

  static String? cedula(String? value) {
    final texto = value?.trim() ?? '';
    if (texto.isEmpty) return 'Ingresa tu cédula';
    if (!_cedulaRegex.hasMatch(texto)) return 'La cédula debe tener 10 dígitos';
    return null;
  }

  static String? celular(String? value) {
    final texto = value?.trim() ?? '';
    if (texto.isEmpty) return 'Ingresa tu número de celular';
    if (!_celularRegex.hasMatch(texto)) {
      return 'Escribe los 9 dígitos después de +593, empezando con 9';
    }
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
