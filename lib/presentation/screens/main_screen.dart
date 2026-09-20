import 'package:flutter/material.dart';
import '../../config/utils/strings.dart';
import '../../domain/entities/currency_entity.dart';
import '../../domain/repositories/currency_repository.dart';
import '../../injection.dart';
import 'cbrates_tab.dart';
import 'calculator_tab.dart';

class MainScreen extends StatefulWidget {
  final String currentLang;
  final ValueChanged<String> onLanguageChanged;

  const MainScreen({
    super.key,
    required this.currentLang,
    required this.onLanguageChanged,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  List<CurrencyEntity> currencies = [];
  bool isLoading = true;
  String connectionStatus = '';

  late final CurrencyRepository _currencyRepository;

  @override
  void initState() {
    super.initState();
    _currencyRepository = sl<CurrencyRepository>();
    _fetchCurrencyData();
  }

  Future<void> _fetchCurrencyData() async {
    setState(() => isLoading = true);

    try {
      final fetchedCurrencies = await _currencyRepository.getCurrencies();
      setState(() {
        currencies = fetchedCurrencies;
        isLoading = false;
        connectionStatus = fetchedCurrencies.length > 3 ? 'online' : 'offline';
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        connectionStatus = 'offline';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String l = widget.currentLang;

    final List<Widget> pages = [
      CBRatesTab(currencies: currencies, currentLang: l, statusKey: connectionStatus, onRefresh: _fetchCurrencyData),
      CalculatorTab(currencies: currencies, currentLang: l),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 16,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey[200], height: 1.0),
        ),
        title: Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF00ACC1), width: 1.2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.asset(
                    'assets/images/app_icon.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFF00ACC1), Color(0xFF7B1FA2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                child: Text(
                  _currentIndex == 0
                      ? AppStrings.get(l, 'ratesTitle')
                      : (l == 'hy'
                      ? 'Տարադրամի հաշվիչ'
                      : (l == 'ru' ? 'Калькулятор валют' : 'Currency Calculator')),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF00ACC1)))
          : pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey[200]!, width: 1)),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF00ACC1),
          unselectedItemColor: Colors.grey[400],
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Opacity(
                opacity: _currentIndex == 0 ? 1.0 : 0.5,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: _currentIndex == 0 ? const Color(0xFF00ACC1) : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.asset(
                      'assets/images/app_icon.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              label: AppStrings.get(l, 'rates'),
            ),
            BottomNavigationBarItem(
              icon: Opacity(
                opacity: _currentIndex == 1 ? 1.0 : 0.5,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: _currentIndex == 1 ? const Color(0xFF00ACC1) : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.asset(
                      'assets/images/app_icon.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              label: AppStrings.get(l, 'calculator'),
            ),
          ],
        ),
      ),
    );
  }
}