import '../../../auth/model/usuario.dart';
import '../../model/datos_perfil.dart';

abstract interface class ProfileDataSource {
  Future<Usuario> obtener();
  Future<Usuario> actualizar(DatosPerfil datos);
}
