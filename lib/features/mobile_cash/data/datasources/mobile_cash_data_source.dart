import '../../model/efectivo_movil.dart';
import '../../model/solicitud_efectivo_movil.dart';

abstract interface class MobileCashDataSource {
  Future<EfectivoMovil> crear(SolicitudEfectivoMovil solicitud);
}
