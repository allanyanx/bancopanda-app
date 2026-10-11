/// Datos editables del perfil
class DatosPerfil {
  const DatosPerfil({
    required this.nombres,
    required this.apellidos,
    required this.correo,
    required this.telefono,
    this.contrasenaNueva,
  });

  final String nombres;
  final String apellidos;
  final String correo;
  final String telefono;
  final String? contrasenaNueva;

  Map<String, dynamic> toJson() => {
    'nombres': nombres,
    'apellidos': apellidos,
    'correo': correo,
    'telefono': telefono,
    'contrasenaNueva': contrasenaNueva,
  };
}
