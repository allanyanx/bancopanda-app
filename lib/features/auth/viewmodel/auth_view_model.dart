import 'package:flutter/foundation.dart';

import '../../../core/errors/app_exception.dart';
import '../data/repositories/auth_repository.dart';
import '../model/datos_registro.dart';
import '../model/sesion.dart';
import '../model/usuario.dart';

class AuthViewModel extends ChangeNotifier {
  AuthViewModel(this._repository);

  final AuthRepository _repository;

  Sesion? _sesion;
  bool _isLoading = false;
  String? _error;

  Usuario? get usuario => _sesion?.usuario;
  bool get isLoggedIn => _sesion != null;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> restoreSession() async {
    _sesion = await _repository.restoreSession();
    notifyListeners();
  }

  Future<bool> login({
    required String identificador,
    required String contrasena,
  }) {
    return _run(
      () => _repository.login(
        identificador: identificador,
        contrasena: contrasena,
      ),
    );
  }

  Future<bool> register(DatosRegistro datos) {
    return _run(() => _repository.register(datos));
  }

  Future<void> logout() async {
    await _repository.logout();
    _sesion = null;
    _error = null;
    notifyListeners();
  }

  void clearError() {
    if (_error == null) return;
    _error = null;
    notifyListeners();
  }

  Future<bool> _run(Future<Sesion> Function() action) async {
    if (_isLoading) return false;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _sesion = await action();
      return true;
    } on AppException catch (e) {
      _error = e.message;
      return false;
    } on Object {
      _error = 'Ocurrió un error inesperado';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> actualizarUsuario(Usuario usuario) async {
    final actual = _sesion;
    if (actual == null) return;
    _sesion = await _repository.actualizarUsuario(actual, usuario);
    notifyListeners();
  }
}
