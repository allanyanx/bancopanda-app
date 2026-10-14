class DatosRegistro {
  const DatosRegistro({
    required this.nombreUsuario,
    required this.cedula,
    required this.nombres,
    required this.apellidos,
    required this.correo,
    required this.telefono,
    required this.contrasena,
    required this.aceptaTerminos,
  });

  final String nombreUsuario;
  final String cedula;
  final String nombres;
  final String apellidos;
  final String correo;
  final String telefono;
  final String contrasena;
  final bool aceptaTerminos;

  Map<String, dynamic> toJson() => {
        'nombreUsuario': nombreUsuario,
        'cedula': cedula,
        'nombres': nombres,
        'apellidos': apellidos,
        'correo': correo,
        'telefono': telefono,
        'contrasena': contrasena,
        'aceptaTerminos': aceptaTerminos,
      };
}
