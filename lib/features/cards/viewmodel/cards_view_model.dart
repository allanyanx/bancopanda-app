import 'package:flutter/foundation.dart';

import '../../../core/errors/app_exception.dart';
import '../../auth/viewmodel/auth_view_model.dart';
import '../../dashboard/data/repositories/dashboard_repository.dart';
import '../../dashboard/model/tarjeta.dart';

class CardsViewModel extends ChangeNotifier {
  CardsViewModel({required this._repository, required this._auth});

  final DashboardRepository _repository;
  final AuthViewModel _auth;

  List<Tarjeta> tarjetas = [];
  bool cargando = false;
  String? error;
  bool _activo = true;

  String get titular {
    final usuario = _auth.usuario;
    return usuario == null
        ? ''
        : '${usuario.primerNombre} ${usuario.primerApellido}';
  }

  Future<void> cargar() async {
    cargando = true;
    error = null;
    notifyListeners();
    try {
      tarjetas = await _repository.obtenerTarjetas();
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
