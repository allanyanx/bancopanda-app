import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/app_settings.dart';
import '../errors/app_exception.dart';

class ApiClient {
  ApiClient({required this._settings, http.Client? httpClient})
    : _http = httpClient ?? http.Client();

  static const _timeout = Duration(seconds: 10);

  final AppSettings _settings;
  final http.Client _http;

  String? token;

  Future<Map<String, dynamic>> get(String path) async {
    return _asMap(await _send(() => _http.get(_uri(path), headers: _headers)));
  }

  Future<List<dynamic>> getList(String path) async {
    final json = await _send(() => _http.get(_uri(path), headers: _headers));
    if (json is List<dynamic>) return json;

    throw const AppException('El servidor envió una respuesta inesperada');
  }

  Future<Map<String, dynamic>> post(
    String path,
    Map<String, dynamic> body,
  ) async {
    return _asMap(
      await _send(
        () => _http.post(_uri(path), headers: _headers, body: jsonEncode(body)),
      ),
    );
  }

  Uri _uri(String path) => Uri.parse('${_settings.serverUrl}$path');

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    if (token != null) 'Authorization': 'Bearer $token',
  };

  Future<Object?> _send(Future<http.Response> Function() request) async {
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
      _errorMessage(_asMap(body), response.statusCode),
      statusCode: response.statusCode,
    );
  }

  Future<Map<String, dynamic>> put(
    String path,
    Map<String, dynamic> body,
  ) async {
    return _asMap(
      await _send(
        () => _http.put(_uri(path), headers: _headers, body: jsonEncode(body)),
      ),
    );
  }

  Object? _decode(http.Response response) {
    if (response.bodyBytes.isEmpty) return null;
    try {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } on FormatException {
      return null;
    }
  }

  Map<String, dynamic> _asMap(Object? json) =>
      json is Map<String, dynamic> ? json : {};

  String _errorMessage(Map<String, dynamic> body, int statusCode) {
    final errors = body['errors'];
    if (errors is Map && errors.isNotEmpty) {
      final first = errors.values.first;
      if (first is List && first.isNotEmpty) return first.first.toString();
    }

    final detail = body['detail'];
    if (detail is String && detail.isNotEmpty) return detail;

    if (statusCode == 401)
      return 'Tu sesión no es válida. Inicia sesión de nuevo.';
    if (statusCode >= 500)
      return 'El servidor tuvo un problema. Intenta más tarde.';
    return 'Ocurrió un error inesperado';
  }
}
