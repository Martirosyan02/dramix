import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/utils/strings.dart';
import '../../domain/entities/currency_entity.dart';

class CBRatesTab extends StatelessWidget {
  final List<CurrencyEntity> currencies;
  final String currentLang;
  final String statusKey;
  final Future<void> Function() onRefresh;

  const CBRatesTab({
    super.key,
    required this.currencies,
    required this.currentLang,
    required this.statusKey,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    String l = currentLang;

    return RefreshIndicator(
      color: const Color(0xFF00ACC1),
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          FutureBuilder<SharedPreferences>(
            future: SharedPreferences.getInstance(),
            builder: (context, snapshot) {
              final prefs = snapshot.data;
              final timestamp = prefs?.getInt('LAST_UPDATE_TIMESTAMP');

              final formattedTime = AppStrings.formatTimestamp(timestamp);
              final updateText = AppStrings.getLastUpdateText(l, formattedTime);

              return Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                color: Colors.grey[50],
                child: Center(
                  child: Text(
                    updateText,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppStrings.get(l, 'currency'), style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold, fontSize: 14)),
                Row(
                  children: [
                    SizedBox(width: 75, child: Text(AppStrings.get(l, 'buy'), style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold, fontSize: 14), textAlign: TextAlign.right)),
                    const SizedBox(width: 20),
                    SizedBox(width: 75, child: Text(AppStrings.get(l, 'sell'), style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold, fontSize: 14), textAlign: TextAlign.right)),
                  ],
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey[200]),
          ...currencies.map((c) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            if (c.flag != null) ...[
                              Text(c.flag!, style: const TextStyle(fontSize: 24)),
                              const SizedBox(width: 12),
                            ],
                            Text(c.code, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.black87)),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          // Առք (Buy Rate)
                          SizedBox(width: 75, child: Text(c.buyRate.toStringAsFixed(2), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.black87), textAlign: TextAlign.right)),
                          const SizedBox(width: 20),
                          SizedBox(width: 75, child: Text(c.sellRate.toStringAsFixed(2), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.black87), textAlign: TextAlign.right)),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, color: Colors.grey[100]),
              ],
            );
          }),
        ],
      ),
    );
  }
}