import '../../domain/entities/currency_entity.dart';

class CurrencyModel {
  final String code;
  final double buyRate;
  final double sellRate;
  final String? flag;

  const CurrencyModel({
    required this.code,
    required this.buyRate,
    required this.sellRate,
    this.flag,
  });

  factory CurrencyModel.fromJson(Map<String, dynamic> json) {
    return CurrencyModel(
      code: json['code'] ?? '',
      buyRate: (json['buyRate'] ?? 0.0).toDouble(),
      sellRate: (json['sellRate'] ?? 0.0).toDouble(),
      flag: json['flag'],
    );
  }

  CurrencyEntity toEntity() {
    return CurrencyEntity(
      code: code,
      buyRate: buyRate,
      sellRate: sellRate,
      flag: flag,
    );
  }
}