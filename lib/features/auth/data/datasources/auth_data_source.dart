import '../../model/datos_registro.dart';
import '../../model/sesion.dart';

abstract interface class AuthDataSource {
  Future<Sesion> login({
    required String identificador,
    required String contrasena,
  });

  Future<Sesion> register(DatosRegistro datos);
}
