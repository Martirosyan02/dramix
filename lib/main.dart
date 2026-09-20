import 'package:flutter/material.dart';
import 'injection.dart' as di;
import 'presentation/screens/welcome_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  di.init();

  runApp(const CurrencyApp());
}

class CurrencyApp extends StatefulWidget {
  const CurrencyApp({super.key});

  @override
  State<CurrencyApp> createState() => _CurrencyAppState();
}

class _CurrencyAppState extends State<CurrencyApp> {
  String _currentLang = 'hy';

  void _changeLanguage(String lang) {
    setState(() {
      _currentLang = lang;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dramix',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00ACC1),
          brightness: Brightness.light,
          primary: const Color(0xFF00ACC1),
        ),
      ),
      home: WelcomeScreen(
        currentLang: _currentLang,
        onLanguageChanged: _changeLanguage,
      ),
    );
  }
}