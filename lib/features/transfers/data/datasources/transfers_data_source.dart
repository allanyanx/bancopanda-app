import '../../model/banco.dart';
import '../../model/beneficiario.dart';
import '../../model/comprobante.dart';
import '../../model/solicitud_transferencia.dart';

abstract interface class TransfersDataSource {
  Future<List<Banco>> obtenerBancos();
  Future<List<Beneficiario>> obtenerBeneficiarios();
  Future<Comprobante> transferir(SolicitudTransferencia solicitud);
}
