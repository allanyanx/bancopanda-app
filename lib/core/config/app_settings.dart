import 'package:flutter/foundation.dart';

import '../storage/key_value_storage.dart';

/// Ajustes de la app. Flutter no tiene variables de entorno en tiempo de
/// ejecución, así que la dirección del backend se configura aquí y se puede
/// cambiar desde la pantalla "Configurar servidor" sin recompilar.
class AppSettings extends ChangeNotifier {
  AppSettings(this._storage);

  /// Desde el emulador de Android, 10.0.2.2 es el localhost de la PC.
  static const defaultServerUrl = 'http://10.0.2.2:5258';
  static const _serverUrlKey = 'url_servidor';

  final KeyValueStorage _storage;
  String _serverUrl = defaultServerUrl;

  String get serverUrl => _serverUrl;

  Future<void> load() async {
    final guardada = await _storage.read(_serverUrlKey);
    if (guardada != null && guardada.isNotEmpty) _serverUrl = guardada;
  }

  Future<void> setServerUrl(String url) async {
    _serverUrl = _normalizar(url);
    await _storage.write(_serverUrlKey, _serverUrl);
    notifyListeners();
  }

  Future<void> resetServerUrl() async {
    _serverUrl = defaultServerUrl;
    await _storage.delete(_serverUrlKey);
    notifyListeners();
  }

  /// Quita espacios y la barra final: "http://host:5258/" → "http://host:5258"
  static String _normalizar(String url) {
    final limpia = url.trim();
    return limpia.endsWith('/') ? limpia.substring(0, limpia.length - 1) : limpia;
  }
}
