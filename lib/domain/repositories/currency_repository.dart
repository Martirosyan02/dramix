import '../entities/currency_entity.dart';

abstract class CurrencyRepository {
  Future<List<CurrencyEntity>> getCurrencies();
}