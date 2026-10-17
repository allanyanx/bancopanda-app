import '../../model/efectivo_movil.dart';
import '../../model/solicitud_efectivo_movil.dart';
import '../datasources/mobile_cash_data_source.dart';

class MobileCashRepository {
  MobileCashRepository(this._dataSource);

  final MobileCashDataSource _dataSource;

  Future<EfectivoMovil> crear(SolicitudEfectivoMovil solicitud) =>
      _dataSource.crear(solicitud);
}
