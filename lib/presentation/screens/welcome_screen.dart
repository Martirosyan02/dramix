import 'package:flutter/material.dart';
import '../../config/utils/strings.dart';
import 'main_screen.dart';


class WelcomeScreen extends StatelessWidget {
  final String currentLang;
  final ValueChanged<String> onLanguageChanged;

  const WelcomeScreen({
    super.key,
    required this.currentLang,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey[300]!, width: 1),
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(canvasColor: Colors.white),
                    child: DropdownButton<String>(
                      value: currentLang,
                      dropdownColor: Colors.white,
                      underline: const SizedBox(),
                      icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF00ACC1)),
                      items: const [
                        DropdownMenuItem(value: 'hy', child: Text('🇦🇲 HY', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold))),
                        DropdownMenuItem(value: 'ru', child: Text('🇷🇺 RU', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold))),
                        DropdownMenuItem(value: 'en', child: Text('🇺🇸 EN', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold))),
                      ],
                      onChanged: (val) {
                        if (val != null) onLanguageChanged(val);
                      },
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFF00ACC1), width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00ACC1).withOpacity(0.15),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: Image.asset(
                        'assets/images/app_icon.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFF00ACC1), Color(0xFF7B1FA2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds),
                    child: Text(
                      AppStrings.get(currentLang, 'calcTitle'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00ACC1),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                  ),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainScreen(
                          currentLang: currentLang,
                          onLanguageChanged: onLanguageChanged,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    AppStrings.get(currentLang, 'start'),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}