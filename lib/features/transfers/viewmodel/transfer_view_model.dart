import 'package:flutter/foundation.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/utils/solicitud_id.dart';
import '../../auth/viewmodel/auth_view_model.dart';
import '../../dashboard/data/repositories/dashboard_repository.dart';
import '../../dashboard/model/cuenta.dart';
import '../data/repositories/transfers_repository.dart';
import '../model/banco.dart';
import '../model/beneficiario.dart';
import '../model/comprobante.dart';
import '../model/destino.dart';
import '../model/solicitud_transferencia.dart';

enum PasoTransferencia { origen, destinatario, monto, confirmar, comprobante }

class TransferViewModel extends ChangeNotifier {
  TransferViewModel({
    required this._repository,
    required this._cuentas,
    required this._auth,
  });

  static const montoMaximo = 5000.0;

  final TransfersRepository _repository;
  final DashboardRepository _cuentas;
  final AuthViewModel _auth;

  List<Cuenta> cuentas = [];
  List<Banco> bancos = [];
  List<Beneficiario> beneficiarios = [];
  bool cargando = false;
  bool enviando = false;
  String? error;
  bool _activo = true;

  PasoTransferencia paso = PasoTransferencia.origen;
  Cuenta? origen;
  bool aMisCuentas = false;
  Destino? destino;
  double? monto;
  Comprobante? comprobante;
  String? _solicitudId;

  bool get puedeTransferirEntreMisCuentas => cuentas.length > 1;

  List<Cuenta> get misOtrasCuentas => [
    for (final c in cuentas)
      if (c.cuentaId != origen?.cuentaId) c,
  ];

  /// Los frecuentes, sin la propia cuenta de origen.
  List<Beneficiario> get frecuentes => [
    for (final b in beneficiarios)
      if (!(b.bancoId == Banco.bancoPandaId &&
          b.numeroCuenta == origen?.numeroCuenta))
        b,
  ];

  Future<void> cargar() async {
    cargando = true;
    error = null;
    notifyListeners();
    try {
      final cuentas = _cuentas.obtenerCuentas();
      final bancos = _repository.obtenerBancos();
      final beneficiarios = _repository.obtenerBeneficiarios();
      await Future.wait([cuentas, bancos, beneficiarios]);

      this.cuentas = await cuentas;
      this.bancos = await bancos;
      this.beneficiarios = await beneficiarios;
    } on AppException catch (e) {
      error = e.message;
      if (e.statusCode == 401) await _auth.logout();
    } on Object {
      error = 'Ocurrió un error inesperado';
    } finally {
      cargando = false;
      if (_activo) notifyListeners();
    }
  }

  void elegirOrigen(Cuenta cuenta) {
    origen = cuenta;
    destino = null;
    if (!puedeTransferirEntreMisCuentas) aMisCuentas = false;
    _irA(PasoTransferencia.destinatario);
  }

  void cambiarTipoDestino({required bool aMisCuentas}) {
    this.aMisCuentas = aMisCuentas;
    destino = null;
    error = null;
    notifyListeners();
  }

  bool elegirDestino(Destino nuevo) {
    if (nuevo.esBancoPanda && nuevo.numeroCuenta == origen?.numeroCuenta) {
      error = 'No puedes transferir a la misma cuenta';
      notifyListeners();
      return false;
    }

    destino = nuevo;
    _irA(PasoTransferencia.monto);
    return true;
  }

  void elegirBeneficiario(Beneficiario beneficiario) =>
      elegirDestino(Destino.desdeBeneficiario(beneficiario));

  void elegirCuentaPropia(Cuenta cuenta) {
    final usuario = _auth.usuario;
    elegirDestino(
      Destino(
        bancoId: Banco.bancoPandaId,
        banco: 'Banco Panda',
        numeroCuenta: cuenta.numeroCuenta,
        cedula: usuario?.cedula ?? '',
        nombre: usuario == null
            ? null
            : '${usuario.primerNombre} ${usuario.primerApellido}',
      ),
    );
  }

  void confirmarMonto(double monto) {
    this.monto = monto;
    // Un identificador nuevo por cada intento; si se reintenta, el API no cobra dos veces.
    _solicitudId = nuevoSolicitudId();
    _irA(PasoTransferencia.confirmar);
  }

  Future<bool> transferir() async {
    final origen = this.origen;
    final destino = this.destino;
    final monto = this.monto;
    final solicitudId = _solicitudId;
    if (origen == null ||
        destino == null ||
        monto == null ||
        solicitudId == null) {
      return false;
    }

    final resultado = await _enviar(
      () => _repository.transferir(
        SolicitudTransferencia(
          solicitudId: solicitudId,
          cuentaOrigenId: origen.cuentaId,
          destino: destino,
          monto: monto,
        ),
      ),
    );
    if (resultado == null) return false;

    comprobante = resultado;
    _irA(PasoTransferencia.comprobante);
    return true;
  }

  /// Vuelve al paso anterior. Devuelve false si no hay a dónde volver o si
  /// la transferencia se está enviando.
  bool retroceder() {
    if (enviando) return false;

    final anterior = switch (paso) {
      PasoTransferencia.origen || PasoTransferencia.comprobante => null,
      PasoTransferencia.destinatario => PasoTransferencia.origen,
      PasoTransferencia.monto => PasoTransferencia.destinatario,
      PasoTransferencia.confirmar => PasoTransferencia.monto,
    };
    if (anterior == null) return false;

    _irA(anterior);
    return true;
  }

  void _irA(PasoTransferencia nuevo) {
    paso = nuevo;
    error = null;
    if (_activo) notifyListeners();
  }

  Future<T?> _enviar<T>(Future<T> Function() accion) async {
    if (enviando) return null;

    enviando = true;
    error = null;
    notifyListeners();
    try {
      return await accion();
    } on AppException catch (e) {
      error = e.message;
      if (e.statusCode == 401) await _auth.logout();
      return null;
    } on Object {
      error = 'Ocurrió un error inesperado';
      return null;
    } finally {
      enviando = false;
      if (_activo) notifyListeners();
    }
  }

  @override
  void dispose() {
    _activo = false;
    super.dispose();
  }
}
