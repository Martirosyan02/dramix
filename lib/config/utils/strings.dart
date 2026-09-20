class AppStrings {
  static const Map<String, Map<String, String>> localizedValues = {
    'hy': {
      'ratesTitle': 'Փոխարժեքներ',
      'calcTitle': 'Dramix',
      'currency': 'Արժույթ',
      'buy': 'Առք',
      'sell': 'Վաճառք',
      'iHave': 'Ես ունեմ',
      'iGet': 'Ես կստանամ',
      'rates': 'Փոխարժեքներ',
      'calculator': 'Հաշվիչ',
      'start': 'Սկսել',
      'online': 'Առցանց (Թարմացված է)',
      'offline': 'Անցանց ռեժիմ (Պահեստային տվյալներ)',
    },
    'ru': {
      'ratesTitle': 'Курсы',
      'calcTitle': 'Dramix',
      'currency': 'Валюта',
      'buy': 'Покупка',
      'sell': 'Продажа',
      'iHave': 'У меня есть',
      'iGet': 'Я получу',
      'rates': 'Курсы',
      'calculator': 'Калькулятор',
      'start': 'Начать',
      'online': 'Онлайн (Обновлено)',
      'offline': 'Офлайн режим (Резервные данные)',
    },
    'en': {
      'ratesTitle': 'Exchange Rates',
      'calcTitle': 'Dramix',
      'currency': 'Currency',
      'buy': 'Buy',
      'sell': 'Sell',
      'iHave': 'I have',
      'iGet': 'I will get',
      'rates': 'Rates',
      'calculator': 'Calculator',
      'start': 'Start',
      'online': 'Online (Updated)',
      'offline': 'Offline Mode (Fallback Data)',
    },
  };

  static String get(String lang, String key) {
    return localizedValues[lang]?[key] ?? localizedValues['en']![key]!;
  }

  static String formatTimestamp(int? timestamp) {
    if (timestamp == null) return '--.--.----, --:--';

    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final day = twoDigits(date.day);
    final month = twoDigits(date.month);
    final year = date.year;
    final hour = twoDigits(date.hour);
    final minute = twoDigits(date.minute);

    return '$day.$month.$year, $hour:$minute';
  }

  static String getLastUpdateText(String languageCode, String formattedDateTime) {
    switch (languageCode) {
      case 'hy':
        return 'Վերջին թարմացումը՝ $formattedDateTime';
      case 'ru':
        return 'Последнее обновление: $formattedDateTime';
      case 'en':
      default:
        return 'Last update: $formattedDateTime';
    }
  }
}