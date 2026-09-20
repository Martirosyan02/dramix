import 'package:dio/dio.dart';
import 'package:dramix/data/models/currency_model.dart';
import 'package:dramix/data/sources/local_sources/currency_local_source.dart';
import '../../exception.dart';

class CurrencyRemoteSource {
  final Dio _dio;
  final CurrencyLocalSource _localSource;

  CurrencyRemoteSource()
      : _dio = Dio(BaseOptions(
    baseUrl: 'https://open.er-api.com/v6',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  )),
        _localSource = CurrencyLocalSource();

  Future<List<CurrencyModel>> fetchCurrencies() async {
    try {
      Map<String, dynamic>? ratesMap;

      bool needsFetch = await _localSource.shouldFetchFromRemote();

      if (!needsFetch) {
        final cachedData = await _localSource.getCachedCurrencies();
        if (cachedData != null) {
          ratesMap = cachedData['rates'];
        }
      }

      if (ratesMap == null) {
        final response = await _dio.get('/latest/USD');

        if (response.statusCode == 200 && response.data != null) {
          ratesMap = response.data['rates'];
          await _localSource.cacheCurrencies(response.data);
        } else {
          throw ServerException('Failed to load currencies from server');
        }
      }

      final double usdToAmd = (ratesMap!['AMD'] as num).toDouble();
      const allowedCodes = ['USD', 'EUR', 'RUB', 'AMD', 'GEL', 'GBP', 'CHF', 'CAD'];

      return allowedCodes.map((code) {
        double rateInAmd;

        if (code == 'USD') {
          rateInAmd = usdToAmd;
        } else if (code == 'AMD') {
          rateInAmd = 1.0;
        } else {
          final double codeRateToUsd = (ratesMap![code] as num).toDouble();
          rateInAmd = usdToAmd / codeRateToUsd;
        }

        final double buyRate = code == 'AMD' ? 1.0 : rateInAmd * 0.995;
        final double sellRate = code == 'AMD' ? 1.0 : rateInAmd * 1.005;

        return CurrencyModel(
          code: code,
          buyRate: buyRate,
          sellRate: sellRate,
          flag: _getFlagForCode(code),
        );
      }).toList();

    } on DioException catch (e) {
      try {
        final cachedData = await _localSource.getCachedCurrencies();
        if (cachedData != null) {
          final ratesMap = cachedData['rates'];
          final double usdToAmd = (ratesMap['AMD'] as num).toDouble();
          const allowedCodes = ['USD', 'EUR', 'RUB', 'AMD', 'GEL', 'GBP', 'CHF', 'CAD'];

          return allowedCodes.map((code) {
            double rateInAmd = code == 'AMD' ? 1.0 : (code == 'USD' ? usdToAmd : usdToAmd / (ratesMap[code] as num).toDouble());
            return CurrencyModel(
              code: code,
              buyRate: code == 'AMD' ? 1.0 : rateInAmd * 0.995,
              sellRate: code == 'AMD' ? 1.0 : rateInAmd * 1.005,
              flag: _getFlagForCode(code),
            );
          }).toList();
        }
      } catch (_) {}

      throw ServerException('Network error occurred: ${e.message}');
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  String _getFlagForCode(String code) {
    switch (code) {
      case 'AMD': return '🇦🇲';
      case 'USD': return '🇺🇸';
      case 'EUR': return '🇪🇺';
      case 'RUB': return '🇷🇺';
      case 'GBP': return '🇬🇧';
      case 'GEL': return '🇬🇪';
      case 'CHF': return '🇨🇭';
      case 'CAD': return '🇨🇦';
      default: return '💱';
    }
  }
}