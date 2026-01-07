import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationHelper {
  static const String _languageKey = 'selected_language';

  // Supported locales
  static const List<Locale> supportedLocales = [
    Locale('en', ''), // English
    Locale('fr', ''), // French
    Locale('ar', ''), // Arabic
  ];

  // Get locale from language code
  static Locale getLocaleFromLanguageCode(String languageCode) {
    switch (languageCode) {
      case 'Français':
      case 'fr':
        return const Locale('fr', '');
      case 'عربي':
      case 'ar':
        return const Locale('ar', '');
      case 'English':
      case 'en':
      default:
        return const Locale('en', '');
    }
  }

  // Get language code from locale
  static String getLanguageCodeFromLocale(Locale locale) {
    switch (locale.languageCode) {
      case 'fr':
        return 'Français';
      case 'ar':
        return 'عربي';
      case 'en':
      default:
        return 'English';
    }
  }

  // Save selected language
  static Future<void> saveLanguage(String languageCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, languageCode);
    } catch (e) {
      debugPrint('Error saving language: $e');
    }
  }

  // Load saved language
  static Future<Locale> loadLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(_languageKey);
      if (languageCode != null) {
        return getLocaleFromLanguageCode(languageCode);
      }
    } catch (e) {
      debugPrint('Error loading language: $e');
    }
    return const Locale('en', ''); // Default to English
  }
}
