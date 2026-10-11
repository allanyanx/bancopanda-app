import 'package:flutter/foundation.dart';

import '../../../core/errors/app_exception.dart';
import '../../auth/model/usuario.dart';
import '../../auth/viewmodel/auth_view_model.dart';
import '../data/repositories/profile_repository.dart';
import '../model/datos_perfil.dart';

class ProfileViewModel extends ChangeNotifier {
  ProfileViewModel({required this._repository, required this._auth});

  final ProfileRepository _repository;
  final AuthViewModel _auth;

  bool _isSaving = false;
  String? _error;
  bool _notificationsEnabled = true;

  Usuario? get usuario => _auth.usuario;
  bool get isSaving => _isSaving;
  String? get error => _error;
  bool get notificationsEnabled => _notificationsEnabled;

  Future<void> loadPreferences() async {
    _notificationsEnabled = await _repository.loadNotifications();
  }

  Future<void> setNotifications(bool enabled) async {
    _notificationsEnabled = enabled;
    notifyListeners();
    await _repository.saveNotifications(enabled);
  }

  Future<void> refresh() async {
    try {
      await _auth.updateUsuario(await _repository.fetch());
    } on AppException catch (e) {
      if (e.statusCode == 401) await _auth.logout();
    }
  }

  Future<bool> save(DatosPerfil datos) async {
    if (_isSaving) return false;

    _isSaving = true;
    _error = null;
    notifyListeners();

    try {
      await _auth.updateUsuario(await _repository.update(datos));
      return true;
    } on AppException catch (e) {
      _error = e.message;
      if (e.statusCode == 401) await _auth.logout();
      return false;
    } on Object {
      _error = 'Ocurrió un error inesperado';
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  void clearError() {
    if (_error == null) return;
    _error = null;
    notifyListeners();
  }

  Future<void> logout() => _auth.logout();
}
