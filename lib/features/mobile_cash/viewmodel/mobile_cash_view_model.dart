import 'package:flutter/foundation.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/utils/celular.dart';
import '../../../core/utils/solicitud_id.dart';
import '../../auth/viewmodel/auth_view_model.dart';
import '../../dashboard/data/repositories/dashboard_repository.dart';
import '../../dashboard/model/cuenta.dart';
import '../data/repositories/mobile_cash_repository.dart';
import '../model/efectivo_movil.dart';
import '../model/solicitud_efectivo_movil.dart';

class MobileCashViewModel extends ChangeNotifier {
  MobileCashViewModel({
    required this._repository,
    required this._cuentas,
    required this._auth,
  });

  static const montoMaximo = 5000.0;

  final MobileCashRepository _repository;
  final DashboardRepository _cuentas;
  final AuthViewModel _auth;

  // Un identificador por pantalla: si se reintenta, el API no descuenta dos veces.
  final _solicitudId = nuevoSolicitudId();

  List<Cuenta> cuentas = [];
  Cuenta? cuenta;
  late bool usarMiNumero = telefonoRegistrado != null;
  bool cargando = false;
  bool enviando = false;
  String? error;
  EfectivoMovil? resultado;
  bool _activo = true;

  Future<void> cargar() async {
    cargando = true;
    error = null;
    notifyListeners();
    try {
      cuentas = await _cuentas.obtenerCuentas();
      cuenta ??= cuentas.isEmpty ? null : cuentas.first;
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

  /// El celular del perfil del usuario, o null si no tiene uno registrado.
  String? get telefonoRegistrado {
    final telefono = _auth.usuario?.telefono?.trim();
    return telefono == null || telefono.isEmpty ? null : telefono;
  }

  void elegirCuenta(Cuenta nueva) {
    cuenta = nueva;
    error = null;
    notifyListeners();
  }

  void elegirDestino({required bool miNumero}) {
    usarMiNumero = miNumero && telefonoRegistrado != null;
    error = null;
    notifyListeners();
  }

  /// [celular] son los 9 dígitos después de +593; solo se usa con "Otro número".
  Future<bool> generar({required double monto, String? celular}) async {
    final cuenta = this.cuenta;
    if (cuenta == null || enviando) return false;
    if (!usarMiNumero && (celular == null || celular.trim().isEmpty)) {
      return false;
    }

    enviando = true;
    error = null;
    notifyListeners();
    try {
      resultado = await _repository.crear(
        SolicitudEfectivoMovil(
          solicitudId: _solicitudId,
          cuentaId: cuenta.cuentaId,
          monto: monto,
          telefonoDestino: usarMiNumero ? null : Celular.completo(celular!),
        ),
      );
      return true;
    } on AppException catch (e) {
      error = e.message;
      if (e.statusCode == 401) await _auth.logout();
      return false;
    } on Object {
      error = 'Ocurrió un error inesperado';
      return false;
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
