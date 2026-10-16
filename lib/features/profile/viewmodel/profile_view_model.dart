import 'package:flutter/foundation.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/storage/key_value_storage.dart';
import '../../auth/model/usuario.dart';
import '../../auth/viewmodel/auth_view_model.dart';
import '../data/repositories/profile_repository.dart';
import '../model/datos_perfil.dart';
import '../model/cambio_contrasena.dart';
import '../../../core/utils/celular.dart';

class ProfileViewModel extends ChangeNotifier {
  ProfileViewModel({
    required ProfileRepository repository,
    required AuthViewModel auth,
    required KeyValueStorage storage,
  }) : _repository = repository,
       _auth = auth,
       _storage = storage;

  static const _notificacionesKey = 'notificaciones';
  static const _huellaKey = 'huella';

  final ProfileRepository _repository;
  final AuthViewModel _auth;
  final KeyValueStorage _storage;

  bool notificaciones = true;
  bool huella = false;

  bool guardando = false;
  String? error;
  bool cargando = false;
  String? errorCarga;

  Usuario? get usuario => _auth.usuario;

  Future<void> cargarPreferencias() async {
    final guardada = await _storage.read(_notificacionesKey);
    if (guardada != null) notificaciones = guardada == 'true';
    final guardadaHuella = await _storage.read(_huellaKey);
    if (guardadaHuella != null) huella = guardadaHuella == 'true';
    notifyListeners();
  }

  Future<void> setHuella(bool valor) async {
    huella = valor;
    notifyListeners();
    await _storage.write(_huellaKey, valor.toString());
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
      if (e.statusCode == 401) await _auth.logout();
      return false;
    } finally {
      guardando = false;
      notifyListeners();
    }
  }

  Future<bool> cambiarContrasena(CambioContrasena datos) async {
    guardando = true;
    error = null;
    notifyListeners();
    try {
      await _repository.cambiarContrasena(datos);
      return true;
    } on AppException catch (e) {
      error = e.message;
      if (e.statusCode == 401) await _auth.logout();
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

  bool hayCambios(DatosPerfil datos) {
    final u = usuario;
    if (u == null) return false;

    return datos.nombreUsuario != u.nombreUsuario ||
        datos.nombres != u.nombres ||
        datos.apellidos != u.apellidos ||
        datos.correo != u.correo ||
        Celular.local(datos.telefono) != Celular.local(u.telefono);
  }

  Future<void> cargar() async {
    cargando = true;
    errorCarga = null;
    notifyListeners();
    try {
      final actualizado = await _repository.obtener();
      await _auth.actualizarUsuario(actualizado);
    } on AppException catch (e) {
      errorCarga = e.message;
      if (e.statusCode == 401) await _auth.logout();
    } finally {
      cargando = false;
      notifyListeners();
    }
  }

  Future<void> cerrarSesion() => _auth.logout();
}
