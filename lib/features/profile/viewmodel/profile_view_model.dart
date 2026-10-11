import 'package:flutter/foundation.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/storage/key_value_storage.dart';
import '../../auth/model/usuario.dart';
import '../../auth/viewmodel/auth_view_model.dart';
import '../data/repositories/profile_repository.dart';
import '../model/datos_perfil.dart';

class ProfileViewModel extends ChangeNotifier {
  ProfileViewModel({
    required ProfileRepository repository,
    required AuthViewModel auth,
    required KeyValueStorage storage,
  }) : _repository = repository,
       _auth = auth,
       _storage = storage;

  static const _notificacionesKey = 'notificaciones';

  final ProfileRepository _repository;
  final AuthViewModel _auth;
  final KeyValueStorage _storage;

  bool guardando = false;
  String? error;
  bool notificaciones = true;

  /// El usuario vive en la sesión; el perfil solo lo lee.
  Usuario? get usuario => _auth.usuario;

  Future<void> cargarPreferencias() async {
    final guardada = await _storage.read(_notificacionesKey);
    if (guardada != null) notificaciones = guardada == 'true';
  }

  Future<void> setNotificaciones(bool valor) async {
    notificaciones = valor;
    notifyListeners();
    await _storage.write(_notificacionesKey, valor.toString());
  }

  Future<bool> guardar(DatosPerfil datos) async {
    guardando = true;
    error = null;
    notifyListeners();
    try {
      final actualizado = await _repository.actualizar(datos);
      await _auth.actualizarUsuario(actualizado);
      return true;
    } on AppException catch (e) {
      error = e.message;
      if (e.statusCode == 401) await _auth.logout(); // token vencido
      return false;
    } finally {
      guardando = false;
      notifyListeners();
    }
  }

  void limpiarError() {
    if (error == null) return;
    error = null;
    notifyListeners();
  }

  Future<void> cerrarSesion() => _auth.logout();
}
