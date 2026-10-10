import '../../model/datos_registro.dart';
import '../../model/sesion.dart';

/// Contrato de la fuente de datos de autenticación. El repositorio depende
/// de esta interfaz, así que se puede cambiar la implementación (API real,
/// datos de prueba) sin tocar el resto de la app.
abstract interface class AuthDataSource {
  Future<Sesion> login({
    required String identificador,
    required String contrasena,
  });

  Future<Sesion> register(DatosRegistro datos);
}
