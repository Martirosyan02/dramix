import 'package:flutter/material.dart';
import '../../domain/entities/currency_entity.dart';

class CalculatorTab extends StatefulWidget {
  final List<CurrencyEntity> currencies;
  final String currentLang;

  const CalculatorTab({
    super.key,
    required this.currencies,
    required this.currentLang,
  });

  @override
  State<CalculatorTab> createState() => _CalculatorTabState();
}

class _CalculatorTabState extends State<CalculatorTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _amountController = TextEditingController(text: '1');

  CurrencyEntity? _fromCurrency;
  CurrencyEntity? _toCurrency;
  double _result = 0.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      if (mounted) {
        setState(() {
          _calculate();
        });
      }
    });

    if (widget.currencies.isNotEmpty) {
      _fromCurrency = widget.currencies.first;
      _toCurrency = widget.currencies.firstWhere(
            (c) => c.code == 'AMD',
        orElse: () => widget.currencies.length > 1 ? widget.currencies[1] : widget.currencies.first,
      );
    }
    _calculate();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  String _formatNumber(double value) {
    String s = value.toStringAsFixed(2);
    List<String> parts = s.split('.');
    String integral = parts[0];
    String fractional = parts[1];

    RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    integral = integral.replaceAllMapped(reg, (Match m) => '${m[1]},');
    return '$integral.$fractional';
  }

  String _formatInputNumber(String input) {
    String cleanStr = input.replaceAll(',', '');
    if (cleanStr.isEmpty) return '';

    List<String> parts = cleanStr.split('.');
    String integral = parts[0];

    RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    integral = integral.replaceAllMapped(reg, (Match m) => '${m[1]},');

    if (parts.length > 1) {
      return '$integral.${parts[1]}';
    }
    return integral;
  }

  // Օգտագործում ենք առկա buyRate / sellRate դաշտերը՝ ըստ Կանխիկ/Անկախիկ թաբերի
  double _getRate(CurrencyEntity currency, bool isCash) {
    if (currency.code == 'AMD') return 1.0;
    // Եթե Կանխիկ է՝ buyRate, Անկախիկ է՝ sellRate (կամ հակառակը ըստ քո ցանկության)
    return isCash ? currency.buyRate : currency.sellRate;
  }

  void _calculate() {
    if (_fromCurrency == null || _toCurrency == null) return;

    double amount = double.tryParse(_amountController.text.replaceAll(',', '')) ?? 0.0;
    bool isCash = _tabController.index == 0;

    if (_fromCurrency!.code == _toCurrency!.code) {
      _result = amount;
      return;
    }

    double rateFrom = _getRate(_fromCurrency!, isCash);
    double rateTo = _getRate(_toCurrency!, isCash);

    // 1. AMD -> X
    if (_fromCurrency!.code == 'AMD') {
      _result = rateTo > 0 ? amount / rateTo : 0.0;
    }
    // 2. X -> AMD
    else if (_toCurrency!.code == 'AMD') {
      _result = amount * rateFrom;
    }
    // 3. X -> Y (Խաչաձև փոխարկում)
    else {
      double amountInAmd = amount * rateFrom;
      _result = rateTo > 0 ? amountInAmd / rateTo : 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    String l = widget.currentLang;
    bool isArmenian = l == 'hy';
    bool isRussian = l == 'ru';

    return Column(
      children: [
        Container(
          color: Colors.white,
          child: TabBar(
            controller: _tabController,
            labelColor: Colors.black87,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.black87,
            indicatorWeight: 2,
            tabs: [
              Tab(text: isArmenian ? 'Կանխիկ' : (isRussian ? 'Наличные' : 'Cash')),
              Tab(text: isArmenian ? 'Անկախիկ' : (isRussian ? 'Безналичные' : 'Non-cash')),
            ],
          ),
        ),
        const Divider(height: 1, color: Colors.grey),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isArmenian ? 'Ես ունեմ' : (isRussian ? 'У меня есть' : 'I have'),
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _amountController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        onChanged: (value) {
                          String formatted = _formatInputNumber(value);
                          if (formatted != value) {
                            _amountController.value = TextEditingValue(
                              text: formatted,
                              selection: TextSelection.collapsed(offset: formatted.length),
                            );
                          }
                          setState(() {
                            _calculate();
                          });
                        },
                      ),
                    ),
                    if (widget.currencies.isNotEmpty)
                      DropdownButton<CurrencyEntity>(
                        value: _fromCurrency,
                        underline: const SizedBox(),
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.black54),
                        items: widget.currencies.map((currency) {
                          return DropdownMenuItem(
                            value: currency,
                            child: Row(
                              children: [
                                if (currency.flag != null) ...[
                                  Text(currency.flag!, style: const TextStyle(fontSize: 18)),
                                  const SizedBox(width: 8),
                                ],
                                Text(currency.code, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            _fromCurrency = val;
                            _calculate();
                          });
                        },
                      ),
                  ],
                ),
                const Divider(color: Colors.grey, thickness: 0.5),
                const SizedBox(height: 10),
                Center(
                  child: IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: const Icon(Icons.swap_vert, color: Colors.black54),
                    ),
                    onPressed: () {
                      setState(() {
                        final temp = _fromCurrency;
                        _fromCurrency = _toCurrency;
                        _toCurrency = temp;
                        _calculate();
                      });
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  isArmenian ? 'Ես կստանամ' : (isRussian ? 'Я получу' : 'I will get'),
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        _formatNumber(_result),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                    ),
                    if (widget.currencies.isNotEmpty)
                      DropdownButton<CurrencyEntity>(
                        value: _toCurrency,
                        underline: const SizedBox(),
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.black54),
                        items: widget.currencies.map((currency) {
                          return DropdownMenuItem(
                            value: currency,
                            child: Row(
                              children: [
                                if (currency.flag != null) ...[
                                  Text(currency.flag!, style: const TextStyle(fontSize: 18)),
                                  const SizedBox(width: 8),
                                ],
                                Text(currency.code, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            _toCurrency = val;
                            _calculate();
                          });
                        },
                      ),
                  ],
                ),
                const Divider(color: Colors.grey, thickness: 0.5),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    (_fromCurrency != null && _toCurrency != null)
                        ? () {
                      bool isCash = _tabController.index == 0;
                      double rFrom = _getRate(_fromCurrency!, isCash);
                      double rTo = _getRate(_toCurrency!, isCash);

                      double singleRate = 0.0;
                      if (_fromCurrency!.code == 'AMD') {
                        singleRate = rTo > 0 ? 1 / rTo : 0.0;
                      } else if (_toCurrency!.code == 'AMD') {
                        singleRate = rFrom;
                      } else {
                        singleRate = rTo > 0 ? rFrom / rTo : 0.0;
                      }

                      String formattedRate = (singleRate < 1 && singleRate > 0)
                          ? singleRate.toStringAsFixed(4)
                          : singleRate.toStringAsFixed(3);

                      return '1 ${_fromCurrency!.code} = $formattedRate ${_toCurrency!.code}';
                    }()
                        : '',
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}