class Banco {
  const Banco({required this.bancoId, required this.nombre});

  /// Id fijo que crea la migración del API para Banco Panda.
  static const bancoPandaId = 'b0000000-0000-4000-8000-000000000001';

  final String bancoId;
  final String nombre;

  bool get esBancoPanda => bancoId == bancoPandaId;

  factory Banco.fromJson(Map<String, dynamic> json) {
    return Banco(
      bancoId: json['bancoId'] as String,
      nombre: json['nombre'] as String,
    );
  }
}
