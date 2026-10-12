class Usuario {
  const Usuario({
    required this.usuarioId,
    required this.nombres,
    required this.apellidos,
    required this.cedula,
    required this.correo,
    this.telefono,
  });

  final String usuarioId;
  final String nombres;
  final String apellidos;
  final String cedula;
  final String correo;
  final String? telefono;

  String get primerNombre => nombres.split(' ').first;
  String get primerApellido => apellidos.split(' ').first;
  String get nombreCompleto => '$nombres $apellidos';

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      usuarioId: json['usuarioId'] as String,
      nombres: json['nombres'] as String,
      apellidos: json['apellidos'] as String,
      cedula: json['cedula'] as String,
      correo: json['correo'] as String,
      telefono: json['telefono'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'usuarioId': usuarioId,
        'nombres': nombres,
        'apellidos': apellidos,
        'cedula': cedula,
        'correo': correo,
        'telefono': telefono,
      };
}
