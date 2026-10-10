import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/app_settings.dart';
import '../errors/app_exception.dart';

/// Único punto de salida hacia el backend. Arma la URL con la dirección
/// configurada, envía JSON, agrega el token y convierte cualquier fallo
/// en una [AppException] con un mensaje listo para mostrar.
class ApiClient {
  ApiClient({required this._settings, http.Client? httpClient})
      : _http = httpClient ?? http.Client();

  static const _timeout = Duration(seconds: 10);

  final AppSettings _settings;
  final http.Client _http;

  /// Token JWT de la sesión actual. Lo asigna el AuthRepository.
  String? token;

  Future<Map<String, dynamic>> get(String path) {
    return _send(() => _http.get(_uri(path), headers: _headers));
  }

  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body) {
    return _send(
      () => _http.post(_uri(path), headers: _headers, body: jsonEncode(body)),
    );
  }

  Uri _uri(String path) => Uri.parse('${_settings.serverUrl}$path');

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

  Future<Map<String, dynamic>> _send(
    Future<http.Response> Function() request,
  ) async {
    final http.Response response;
    try {
      response = await request().timeout(_timeout);
    } on TimeoutException {
      throw const AppException('El servidor tardó demasiado en responder');
    } on http.ClientException {
      throw const AppException(
        'No se pudo conectar con el servidor. Revisa la dirección en Configuración.',
      );
    } on FormatException {
      throw const AppException('La dirección del servidor no es válida');
    }

    final body = _decode(response);
    if (response.statusCode >= 200 && response.statusCode < 300) return body;

    throw AppException(
      _errorMessage(body, response.statusCode),
      statusCode: response.statusCode,
    );
  }

  Map<String, dynamic> _decode(http.Response response) {
    if (response.bodyBytes.isEmpty) return {};
    try {
      // utf8 explícito: los mensajes del backend tienen tildes.
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      return json is Map<String, dynamic> ? json : {};
    } on FormatException {
      return {};
    }
  }

  /// El backend responde los errores en formato ProblemDetails:
  /// `detail` para reglas de negocio y `errors` para validaciones de campos.
  String _errorMessage(Map<String, dynamic> body, int statusCode) {
    final errors = body['errors'];
    if (errors is Map && errors.isNotEmpty) {
      final first = errors.values.first;
      if (first is List && first.isNotEmpty) return first.first.toString();
    }

    final detail = body['detail'];
    if (detail is String && detail.isNotEmpty) return detail;

    if (statusCode == 401) return 'Tu sesión no es válida. Inicia sesión de nuevo.';
    if (statusCode >= 500) return 'El servidor tuvo un problema. Intenta más tarde.';
    return 'Ocurrió un error inesperado';
  }
}
