import 'package:flutter/foundation.dart';

import '../../../core/errors/app_exception.dart';
import '../../auth/viewmodel/auth_view_model.dart';
import '../data/repositories/dashboard_repository.dart';
import '../model/resumen_dashboard.dart';

class DashboardViewModel extends ChangeNotifier {
  DashboardViewModel({required this._repository, required this._auth});

  static const movimientosRecientes = 5;

  final DashboardRepository _repository;
  final AuthViewModel _auth;

  ResumenDashboard? resumen;
  bool cargando = false;
  String? error;
  bool saldoVisible = true;
  bool _activo = true;

  Future<void> cargar() async {
    cargando = true;
    error = null;
    notifyListeners();
    try {
      resumen = await _repository.obtenerResumen(
        limiteMovimientos: movimientosRecientes,
      );
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

  void alternarSaldo() {
    saldoVisible = !saldoVisible;
    notifyListeners();
  }

  @override
  void dispose() {
    _activo = false;
    super.dispose();
  }
}
