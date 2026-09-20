class CurrencyEntity {
  final String code;
  final double buyRate;
  final double sellRate;
  final String? flag;

  const CurrencyEntity({
    required this.code,
    required this.buyRate,
    required this.sellRate,
    this.flag,
  });
}