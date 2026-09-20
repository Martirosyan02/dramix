import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CurrencyLocalSource {
  static const String _cachedKey = 'CACHED_CURRENCIES_JSON';
  static const String _lastUpdateKey = 'LAST_UPDATE_TIMESTAMP';

  Future<void> cacheCurrencies(Map<String, dynamic> jsonDatam) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(jsonDatam);

    await prefs.setString(_cachedKey, jsonString);
    await prefs.setInt(_lastUpdateKey, DateTime.now().millisecondsSinceEpoch);
  }

  Future<bool> shouldFetchFromRemote() async {
    final prefs = await SharedPreferences.getInstance();
    final lastUpdate = prefs.getInt(_lastUpdateKey);

    if (lastUpdate == null) return true;

    final lastUpdateTime = DateTime.fromMillisecondsSinceEpoch(lastUpdate);
    final now = DateTime.now();

    final today10Am = DateTime(now.year, now.month, now.day, 10, 0);

    if (lastUpdateTime.isBefore(today10Am) && now.isAfter(today10Am)) {
      return true;
    }

    return false;
  }

  Future<Map<String, dynamic>?> getCachedCurrencies() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_cachedKey);

    if (jsonString != null) {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    }
    return null;
  }

  Future<int?> getLastUpdateTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_lastUpdateKey);
  }
}