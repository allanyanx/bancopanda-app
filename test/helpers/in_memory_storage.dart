import 'package:bancopanda_app/core/storage/key_value_storage.dart';

/// Almacenamiento en memoria para los tests (no necesita un dispositivo).
class InMemoryStorage implements KeyValueStorage {
  final Map<String, String> data = {};

  @override
  Future<String?> read(String key) async => data[key];

  @override
  Future<void> write(String key, String value) async => data[key] = value;

  @override
  Future<void> delete(String key) async => data.remove(key);
}
