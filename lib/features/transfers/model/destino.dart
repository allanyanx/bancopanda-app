import 'banco.dart';
import 'beneficiario.dart';

/// A dónde va el dinero: un banco, una cuenta y la cédula de su dueño.
class Destino {
  const Destino({
    required this.bancoId,
    required this.banco,
    required this.numeroCuenta,
    required this.cedula,
    this.nombre,
  });

  factory Destino.desdeBeneficiario(Beneficiario b) => Destino(
    bancoId: b.bancoId,
    banco: b.banco,
    numeroCuenta: b.numeroCuenta,
    cedula: b.cedula,
    nombre: b.nombre,
  );

  final String bancoId;
  final String banco;
  final String numeroCuenta;
  final String cedula;
  final String? nombre;

  bool get esBancoPanda => bancoId == Banco.bancoPandaId;
  String get titulo => nombre ?? 'Cuenta $numeroCuenta';
}
