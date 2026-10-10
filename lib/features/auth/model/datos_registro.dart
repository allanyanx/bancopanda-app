/// Datos del formulario de registro, tal como los espera el backend.
class DatosRegistro {
  const DatosRegistro({
    required this.cedula,
    required this.nombres,
    required this.apellidos,
    required this.correo,
    required this.telefono,
    required this.contrasena,
  });

  final String cedula;
  final String nombres;
  final String apellidos;
  final String correo;
  final String telefono;
  final String contrasena;

  Map<String, dynamic> toJson() => {
        'cedula': cedula,
        'nombres': nombres,
        'apellidos': apellidos,
        'correo': correo,
        'telefono': telefono,
        'contrasena': contrasena,
      };
}
