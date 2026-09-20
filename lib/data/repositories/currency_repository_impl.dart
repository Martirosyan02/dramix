import '../../domain/entities/currency_entity.dart';
import '../../domain/repositories/currency_repository.dart';
import '../sources/remote_sources/currency_remote_source.dart';

class CurrencyRepositoryImpl implements CurrencyRepository {
  final CurrencyRemoteSource remoteSource;

  CurrencyRepositoryImpl({required this.remoteSource});

  List<CurrencyEntity>? _cachedCurrencies;
  DateTime? _lastFetchTime;

  bool get isUpdatedToday {
    if (_lastFetchTime == null) return false;
    final now = DateTime.now();
    return _lastFetchTime!.year == now.year &&
        _lastFetchTime!.month == now.month &&
        _lastFetchTime!.day == now.day;
  }

  DateTime? get lastFetchTime => _lastFetchTime;

  @override
  Future<List<CurrencyEntity>> getCurrencies() async {
    if (isUpdatedToday && _cachedCurrencies != null) {
      return _cachedCurrencies!;
    }

    try {
      final models = await remoteSource.fetchCurrencies();
      final entities = models.map((model) => model.toEntity()).toList();

      _cachedCurrencies = entities;
      _lastFetchTime = DateTime.now();

      return entities;
    } catch (e) {
      if (_cachedCurrencies != null && _cachedCurrencies!.isNotEmpty) {
        return _cachedCurrencies!;
      }

      return const [
    CurrencyEntity(code: 'AMD', flag: '🇦🇲', buyRate: 1.0, sellRate: 1.0),
    CurrencyEntity(code: 'USD', flag: '🇺🇸', buyRate: 361.0, sellRate: 364.0),
    CurrencyEntity(code: 'EUR', flag: '🇪🇺', buyRate: 418.0, sellRate: 421.5),
    CurrencyEntity(code: 'RUR', flag: '🇷🇺', buyRate: 4.14, sellRate: 4.20),
    CurrencyEntity(code: 'GBP', flag: '🇬🇧', buyRate: 490.0, sellRate: 500.0),
    CurrencyEntity(code: 'GEL', flag: '🇬🇪', buyRate: 140.0, sellRate: 145.0),
    CurrencyEntity(code: 'CHF', flag: '🇨🇭', buyRate: 430.0, sellRate: 440.0),
    CurrencyEntity(code: 'CAD', flag: '🇨🇦', buyRate: 280.0, sellRate: 290.0),
    ];
    }
  }
}