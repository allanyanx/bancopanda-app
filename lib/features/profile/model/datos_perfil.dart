class DatosPerfil {
  const DatosPerfil({
    required this.nombreUsuario,
    required this.nombres,
    required this.apellidos,
    required this.correo,
    required this.telefono,
  });

  final String nombreUsuario;
  final String nombres;
  final String apellidos;
  final String correo;
  final String telefono;

  Map<String, dynamic> toJson() => {
    'nombreUsuario': nombreUsuario,
    'nombres': nombres,
    'apellidos': apellidos,
    'correo': correo,
    'telefono': telefono,
  };
}
