class Beneficiario {
  const Beneficiario({
    required this.beneficiarioId,
    required this.bancoId,
    required this.banco,
    required this.numeroCuenta,
    required this.cedula,
    this.nombre,
  });

  final String beneficiarioId;
  final String bancoId;
  final String banco;
  final String numeroCuenta;
  final String cedula;
  final String? nombre;

  factory Beneficiario.fromJson(Map<String, dynamic> json) {
    return Beneficiario(
      beneficiarioId: json['beneficiarioId'] as String,
      bancoId: json['bancoId'] as String,
      banco: json['banco'] as String,
      numeroCuenta: json['numeroCuenta'] as String,
      cedula: json['cedula'] as String,
      nombre: json['nombre'] as String?,
    );
  }
}
