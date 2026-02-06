import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agroconnect_flutter/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' as dio;
import '../../services/api_service.dart';

class RegisterNameInputScreen extends StatefulWidget {
  final String phoneNumber;
  final String countryCode;

  const RegisterNameInputScreen({
    super.key,
    required this.phoneNumber,
    required this.countryCode,
  });

  @override
  State<RegisterNameInputScreen> createState() =>
      _RegisterNameInputScreenState();
}

class _RegisterNameInputScreenState extends State<RegisterNameInputScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _onDone() async {
    final l10n = AppLocalizations.of(context)!;
    if (_nameController.text.trim().isEmpty) {
      Get.snackbar(
        l10n.required,
        l10n.pleaseEnterName,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    if (_nameController.text.trim().isNotEmpty) {
      final name = _nameController.text.trim();

      // Call API to update profile with the name
      final apiService = Get.find<ApiService>();

      try {
        // Create FormData to send name to backend
        final formData = dio.FormData.fromMap({
          'name': name,
          'country_code': widget.countryCode,
          'mobile': widget.phoneNumber,
        });

        final response = await apiService.updateProfile(formData);

        if (response != null && response['status'] == true) {
          // Save user details to SharedPreferences after successful API call
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('user_name', name);
          await prefs.setString('user_phone', widget.phoneNumber);
          await prefs.setString('user_country_code', widget.countryCode);

          // Call Home API to verify token/session
          await apiService.getHome();

          if (!mounted) return;

          Get.snackbar(
            l10n.success,
            l10n.registrationSuccessful(name),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color(0xFF1B834F),
            colorText: Colors.white,
            margin: const EdgeInsets.all(16),
            borderRadius: 12,
          );
          Get.offAllNamed('/home');
        } else {
          // API call failed
          if (!mounted) return;
          Get.snackbar(
            l10n.error,
            l10n.failedToSaveProfile,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
            margin: const EdgeInsets.all(16),
            borderRadius: 12,
          );
        }
      } catch (e) {
        // Handle error
        if (!mounted) return;
        Get.snackbar(
          l10n.error,
          l10n.errorOccurred,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 100),
              // Name input title
              Text(
                l10n.whatsYourName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              // Name input field
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: l10n.enterYourName,
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 14,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                      width: 1.2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: Color(0xFF1B834F),
                      width: 1.5,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                ),
                style: const TextStyle(fontSize: 14),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 350),
              // Done button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onDone,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B834F),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    l10n.done,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
