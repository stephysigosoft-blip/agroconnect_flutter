import 'package:agroconnect_flutter/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../main.dart';
import '../../services/api_service.dart';
import '../../utils/localization_helper.dart';

class RegisterPhoneInputScreen extends StatefulWidget {
  const RegisterPhoneInputScreen({super.key});

  @override
  State<RegisterPhoneInputScreen> createState() =>
      _RegisterPhoneInputScreenState();
}

class _RegisterPhoneInputScreenState extends State<RegisterPhoneInputScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final ApiService _apiService = Get.find<ApiService>();

  String _selectedCountryCode = '+222';
  String _selectedFlag = '🇲🇷';
  bool _isSendingOtp = false;

  @override
  void initState() {
    super.initState();
    // Country code is now locked to +222 (Mauritania)
    _selectedCountryCode = '+222';
    _selectedFlag = '🇲🇷';
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _onContinue() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      final l10n = AppLocalizations.of(context)!;
      Get.snackbar(
        l10n.required,
        l10n.pleaseEnterPhoneNumber,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    final isMauritania =
        _selectedCountryCode == '+222' || _selectedCountryCode == '222';
    if (!isMauritania && phone.length < 6) {
      final l10n = AppLocalizations.of(context)!;
      Get.snackbar(
        l10n.invalidInput,
        l10n.pleaseEnterPhoneNumber,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    if (isMauritania && phone.length != 8) {
      Get.snackbar(
        'Invalid Input',
        'Please enter a valid 8-digit phone number',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    // Always proceed with OTP flow
    if (!_isSendingOtp) {
      setState(() {
        _isSendingOtp = true;
      });

      try {
        final response = await _apiService.sendOtp(
          _selectedCountryCode,
          _phoneController.text,
        );

        if (response != null && response.status) {
          if (mounted) {
            final langCode = Localizations.localeOf(context).languageCode;
            Get.snackbar(
              AppLocalizations.of(context)!.success,
              response.getLocalizedMessage(langCode),
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: const Color(0xFF1B834F),
              colorText: Colors.white,
              margin: const EdgeInsets.all(16),
              borderRadius: 12,
            );

            // Navigate to OTP verification
            Navigator.pushNamed(
              context,
              '/register/otp',
              arguments: {
                'phoneNumber': _phoneController.text,
                'countryCode': _selectedCountryCode,
                'mobileNumber': _phoneController.text,
              },
            );
          }
        } else {
          if (mounted) {
            String langCode = 'en';
            try {
              langCode = Localizations.localeOf(context).languageCode;
            } catch (e) {
              // Error getting locale
            }
            String errorMsg =
                response?.getLocalizedMessage(langCode) ?? 'Failed to send OTP';
            Get.snackbar(
              AppLocalizations.of(context)!.error,
              errorMsg,
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.redAccent,
              colorText: Colors.white,
              margin: const EdgeInsets.all(16),
              borderRadius: 12,
            );
          }
        }
      } catch (e) {
        if (mounted) {
          Get.snackbar(
            AppLocalizations.of(context)!.error,
            'An unexpected error occurred',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
            margin: const EdgeInsets.all(16),
            borderRadius: 12,
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isSendingOtp = false;
          });
        }
      }
    }
  }

  void _showLanguageSelection() {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder:
          (context) => _LanguageSelectionDialog(
            onLanguageSelected: (locale) {
              MyApp.of(context)?.setLocale(locale);
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   automaticallyImplyLeading: false,
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.language, color: Colors.black),
      //       onPressed: _showLanguageSelection,
      //       tooltip: l10n.selectLanguage,
      //     ),
      //   ],
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),
              // Logo
              Image.asset(
                'lib/assets/images/logo.png',
                width: 250,
                height: 250,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 40),

              // Redesigned Card-like Container
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 40,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  border: const Border(
                    top: BorderSide(color: Color(0xFFBACCC1), width: 1.5),
                    left: BorderSide(color: Color(0xFFBACCC1), width: 1.5),
                    right: BorderSide(color: Color(0xFFBACCC1), width: 1.5),
                  ),
                ),
                child: Column(
                  children: [
                    // Welcome Message
                    Text(
                      l10n.welcomeMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Divider with darker lines
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.grey.shade400,
                            thickness: 1.5,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            l10n.loginOrSignUp,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.grey.shade400,
                            thickness: 1.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Compact Phone input field with darker border
                    Row(
                      children: [
                        // Flag Container
                        GestureDetector(
                          onTap: null, // Picker disabled as per request
                          child: Container(
                            width: 60,
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey.shade400,
                                width: 1.2,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                _selectedFlag,
                                style: const TextStyle(fontSize: 24),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Phone Input Container
                        Expanded(
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey.shade400,
                                width: 1.2,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 12),
                                Text(
                                  _selectedCountryCode,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                VerticalDivider(
                                  color: Colors.grey.shade300,
                                  thickness: 1,
                                  indent: 12,
                                  endIndent: 12,
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: _phoneController,
                                    keyboardType: TextInputType.phone,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(
                                        _selectedCountryCode == '+222' ||
                                                _selectedCountryCode == '222'
                                            ? 8
                                            : 10,
                                      ),
                                    ],
                                    decoration: InputDecoration(
                                      hintText: l10n.enterWhatsappNumber,
                                      border: InputBorder.none,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            vertical: 10,
                                          ),
                                      hintStyle: TextStyle(
                                        color: Colors.grey.shade400,
                                        fontSize: 13,
                                      ),
                                    ),
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // Continue button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _onContinue,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1B834F),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        child:
                            _isSendingOtp
                                ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                : Text(
                                  l10n.continue_,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Guest Login button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          // Set null in bearer token (by removing it) and set guest flag
                          await prefs.remove('auth_token');
                          await prefs.setBool('is_guest', true);
                          if (mounted) {
                            Navigator.pushReplacementNamed(context, '/home');
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(
                            color: Color(0xFF1B834F),
                            width: 1.2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.white,
                        ),
                        child: Text(
                          l10n.guestLogin,
                          style: const TextStyle(
                            color: Color(0xFF1B834F),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageSelectionDialog extends StatefulWidget {
  final Function(Locale) onLanguageSelected;

  const _LanguageSelectionDialog({required this.onLanguageSelected});

  @override
  State<_LanguageSelectionDialog> createState() =>
      _LanguageSelectionDialogState();
}

class _LanguageSelectionDialogState extends State<_LanguageSelectionDialog> {
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

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.selectLanguage,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 24),
                // Language options
                _buildLanguageOption(l10n.french, 'Français'),
                const SizedBox(height: 16),
                _buildLanguageOption(l10n.arabic, 'عربي'),
                const SizedBox(height: 16),
                _buildLanguageOption(l10n.english, 'English'),
                const SizedBox(height: 32),
                // Continue button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      // Save selected language
                      await LocalizationHelper.saveLanguage(_selectedLanguage);
                      // Update app locale
                      final locale =
                          LocalizationHelper.getLocaleFromLanguageCode(
                            _selectedLanguage,
                          );

                      // Close dialog first
                      Navigator.pop(context);

                      // Update locale
                      widget.onLanguageSelected(locale);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B834F),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      l10n.continue_,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Circular X close button
          Positioned(
            top: -10,
            right: -10,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.close, size: 24, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(String displayName, String languageCode) {
    final isSelected = _selectedLanguage == languageCode;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedLanguage = languageCode;
        });
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade200, width: 1),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                displayName,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      isSelected
                          ? const Color(0xFF1B834F)
                          : Colors.grey.shade400,
                  width: 1.5,
                ),
              ),
              child:
                  isSelected
                      ? Container(
                        margin: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: Color(0xFF1B834F),
                          shape: BoxShape.circle,
                        ),
                      )
                      : null,
            ),
          ],
        ),
      ),
    );
  }
}
