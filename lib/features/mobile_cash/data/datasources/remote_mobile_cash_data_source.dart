import '../../../../core/network/api_client.dart';
import '../../model/efectivo_movil.dart';
import '../../model/solicitud_efectivo_movil.dart';
import 'mobile_cash_data_source.dart';

class RemoteMobileCashDataSource implements MobileCashDataSource {
  const RemoteMobileCashDataSource(this._api);

  final ApiClient _api;

  @override
  Future<EfectivoMovil> crear(SolicitudEfectivoMovil solicitud) async {
    final json = await _api.post('/api/efectivo-movil', solicitud.toJson());
    return EfectivoMovil.fromJson(json);
  }
}
