import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final _storage = const FlutterSecureStorage();

  static const String _keyLastRates = 'last_rates';

  Future<void> saveRatesData(String data) async {
    await _storage.write(key: _keyLastRates, value: data);
  }

  Future<String?> getRatesData() async {
    return await _storage.read(key: _keyLastRates);
  }

  Future<void> clearStorage() async {
    await _storage.delete(key: _keyLastRates);
  }
}