import 'package:flutter/foundation.dart';

import '../../../core/errors/app_exception.dart';
import '../../auth/viewmodel/auth_view_model.dart';
import '../data/repositories/dashboard_repository.dart';
import '../model/movimiento.dart';

class MovementsViewModel extends ChangeNotifier {
  MovementsViewModel({required this._repository, required this._auth});

  static const limite = 50;

  final DashboardRepository _repository;
  final AuthViewModel _auth;

  List<Movimiento> movimientos = [];
  bool cargando = false;
  String? error;
  bool _activo = true;

  Future<void> cargar() async {
    cargando = true;
    error = null;
    notifyListeners();
    try {
      movimientos = await _repository.obtenerMovimientos(limite: limite);
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

  @override
  void dispose() {
    _activo = false;
    super.dispose();
  }
}
