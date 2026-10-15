import '../../../auth/model/usuario.dart';
import '../../model/cambio_contrasena.dart';
import '../../model/datos_perfil.dart';

abstract interface class ProfileDataSource {
  Future<Usuario> obtener();
  Future<Usuario> actualizar(DatosPerfil datos);
  Future<void> cambiarContrasena(CambioContrasena datos);
}
