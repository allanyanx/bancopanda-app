import '../../model/banco.dart';
import '../../model/beneficiario.dart';
import '../../model/comprobante.dart';
import '../../model/solicitud_transferencia.dart';
import '../datasources/transfers_data_source.dart';

class TransfersRepository {
  TransfersRepository(this._dataSource);

  final TransfersDataSource _dataSource;

  Future<List<Banco>> obtenerBancos() => _dataSource.obtenerBancos();

  Future<List<Beneficiario>> obtenerBeneficiarios() =>
      _dataSource.obtenerBeneficiarios();

  Future<Comprobante> transferir(SolicitudTransferencia solicitud) =>
      _dataSource.transferir(solicitud);
}
