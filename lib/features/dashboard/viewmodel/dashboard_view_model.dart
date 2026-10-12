import 'package:flutter/foundation.dart';

import '../../../core/errors/app_exception.dart';
import '../data/repositories/dashboard_repository.dart';
import '../model/resumen_dashboard.dart';

/// Estado de la pantalla de inicio: cargando, error o datos listos.
/// No contiene reglas de negocio: solo pide los datos al repositorio.
class DashboardViewModel extends ChangeNotifier {
  DashboardViewModel(this._repository);

  final DashboardRepository _repository;

  ResumenDashboard? _resumen;
  bool _isLoading = false;
  String? _error;
  bool _disposed = false;

  ResumenDashboard? get resumen => _resumen;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> load() async {
    if (_isLoading) return;

    _isLoading = true;
    _error = null;
    _notify();

    try {
      _resumen = await _repository.obtenerResumen();
    } on AppException catch (e) {
      _error = e.message;
    } on Object {
      _error = 'No se pudo cargar tu información';
    } finally {
      _isLoading = false;
      _notify();
    }
  }

  // La pantalla puede cerrarse (cierre de sesión) antes de que llegue la
  // respuesta; en ese caso ya no hay a quién avisar.
  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
