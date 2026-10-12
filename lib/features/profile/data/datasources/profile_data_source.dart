import '../../../auth/model/usuario.dart';
import '../../model/datos_perfil.dart';

abstract interface class ProfileDataSource {
  Future<Usuario> fetch();
  Future<Usuario> update(DatosPerfil datos);
}
