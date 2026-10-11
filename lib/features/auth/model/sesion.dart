import 'usuario.dart';

class Sesion {
  const Sesion({
    required this.token,
    required this.expiraEn,
    required this.usuario,
  });

  final String token;
  final DateTime expiraEn;
  final Usuario usuario;

  bool get expirada => DateTime.now().toUtc().isAfter(expiraEn);

  factory Sesion.fromJson(Map<String, dynamic> json) {
    return Sesion(
      token: json['token'] as String,
      expiraEn: DateTime.parse(json['expiraEn'] as String).toUtc(),
      usuario: Usuario.fromJson(json['usuario'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'token': token,
        'expiraEn': expiraEn.toIso8601String(),
        'usuario': usuario.toJson(),
      };
}
