import '../../../../core/network/api_client.dart';
import '../../model/cuenta.dart';
import '../../model/movimiento.dart';
import '../../model/tarjeta.dart';
import 'dashboard_data_source.dart';

class RemoteDashboardDataSource implements DashboardDataSource {
  const RemoteDashboardDataSource(this._api);

  final ApiClient _api;

  @override
  Future<List<Cuenta>> obtenerCuentas() =>
      _lista('/api/cuentas', Cuenta.fromJson);

  @override
  Future<List<Tarjeta>> obtenerTarjetas() =>
      _lista('/api/tarjetas', Tarjeta.fromJson);

  @override
  Future<List<Movimiento>> obtenerMovimientos({required int limite}) =>
      _lista('/api/movimientos?limite=$limite', Movimiento.fromJson);

  Future<List<T>> _lista<T>(
    String path,
    T Function(Map<String, dynamic> json) fromJson,
  ) async {
    final json = await _api.getList(path);
    return [for (final item in json) fromJson(item as Map<String, dynamic>)];
  }
}
