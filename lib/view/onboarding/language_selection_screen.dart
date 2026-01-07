import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../main.dart';
import '../../utils/localization_helper.dart';
import '../../l10n/app_localizations.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String _selectedLanguage = 'English';

  @override
  void initState() {
    super.initState();
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final locale = await LocalizationHelper.loadLanguage();
    final languageCode = LocalizationHelper.getLanguageCodeFromLocale(locale);
    setState(() {
      _selectedLanguage = languageCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              // Logo
              Image.asset(
                'lib/assets/images/logo.png',
                width: 250,
                fit: BoxFit.contain,
              ),
              const Spacer(flex: 2),

              // Language Selector Pill
              Container(
                height: 52,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3EDE7), // Very light green background
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    _buildLanguageItem(l10n.french, 'Français'),
                    _buildLanguageItem(l10n.english, 'English'),
                    _buildLanguageItem(l10n.arabic, 'عربي'),
                  ],
                ),
              ),
              const SizedBox(height: 60),

              // Continue Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    // Save selected language
                    await LocalizationHelper.saveLanguage(_selectedLanguage);
                    // Update app locale
                    final locale = LocalizationHelper.getLocaleFromLanguageCode(
                      _selectedLanguage,
                    );

                    if (mounted) {
                      MyApp.of(context)?.setLocale(locale);
                      Get.offAllNamed('/register');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B834F),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    shadowColor: const Color(0xFF1B834F).withOpacity(0.4),
                  ),
                  child: Text(
                    l10n.continue_,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageItem(String title, String code) {
    bool isSelected = _selectedLanguage == code;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedLanguage = code;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF1B834F) : Colors.transparent,
            borderRadius: BorderRadius.circular(26),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
