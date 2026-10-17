import '../../../../core/network/api_client.dart';
import '../../model/banco.dart';
import '../../model/beneficiario.dart';
import '../../model/comprobante.dart';
import '../../model/solicitud_transferencia.dart';
import 'transfers_data_source.dart';

class RemoteTransfersDataSource implements TransfersDataSource {
  const RemoteTransfersDataSource(this._api);

  final ApiClient _api;

  @override
  Future<List<Banco>> obtenerBancos() async {
    final json = await _api.getList('/api/bancos');
    return [
      for (final item in json) Banco.fromJson(item as Map<String, dynamic>),
    ];
  }

  @override
  Future<List<Beneficiario>> obtenerBeneficiarios() async {
    final json = await _api.getList('/api/beneficiarios');
    return [
      for (final item in json)
        Beneficiario.fromJson(item as Map<String, dynamic>),
    ];
  }

  @override
  Future<Comprobante> transferir(SolicitudTransferencia solicitud) async {
    final json = await _api.post('/api/transferencias', solicitud.toJson());
    return Comprobante.fromJson(json);
  }
}
