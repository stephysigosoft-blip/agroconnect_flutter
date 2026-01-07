import 'package:agroconnect_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../services/api_service.dart';
import '../../models/send_otp_response.dart';
import '../../utils/snackbar_helper.dart';

class RegisterOtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String countryCode;
  final String mobileNumber;

  const RegisterOtpVerificationScreen({
    super.key,
    required this.phoneNumber,
    required this.countryCode,
    required this.mobileNumber,
  });

  @override
  State<RegisterOtpVerificationScreen> createState() =>
      _RegisterOtpVerificationScreenState();
}

class _RegisterOtpVerificationScreenState
    extends State<RegisterOtpVerificationScreen> {
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  final ApiService _apiService = Get.find<ApiService>();
  int _resendTimer = 30;
  bool _canResend = false;
  bool _isResending = false;
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          if (_resendTimer > 0) {
            _resendTimer--;
            _startTimer();
          } else {
            _canResend = true;
          }
        });
      }
    });
  }

  void _onOtpChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  Future<void> _onContinue() async {
    final otp = _otpControllers.map((e) => e.text).join();
    if (otp.length == 6) {
      setState(() {
        _isVerifying = true;
      });

      try {
        final response = await _apiService.verifyOtp(
          widget.countryCode,
          widget.mobileNumber,
          otp,
        );

        if (response != null && response.status) {
          if (mounted) {
            final langCode = Localizations.localeOf(context).languageCode;
            SnackBarHelper.showSuccess(
              'Success',
              response.getLocalizedMessage(langCode),
            );

            Navigator.pushNamed(
              context,
              '/register/name',
              arguments: {
                'phoneNumber': widget.phoneNumber,
                'countryCode': widget.countryCode,
              },
            );
          }
        } else {
          if (mounted) {
            final langCode = Localizations.localeOf(context).languageCode;
            SnackBarHelper.showError(
              'Error',
              response?.getLocalizedMessage(langCode) ?? 'Invalid OTP',
            );
          }
        }
      } catch (e) {
        if (mounted) {
          SnackBarHelper.showError('Error', 'An unexpected error occurred');
        }
      } finally {
        if (mounted) {
          setState(() {
            _isVerifying = false;
          });
        }
      }
    }
  }

  Future<void> _resendOtp() async {
    if (_canResend && !_isResending) {
      setState(() {
        _isResending = true;
      });

      try {
        final response = await _apiService.sendOtp(
          widget.countryCode,
          widget.mobileNumber,
        );

        if (response != null && response.status) {
          setState(() {
            _resendTimer = 30;
            _canResend = false;
          });
          _startTimer();
          final langCode = Localizations.localeOf(context).languageCode;
          SnackBarHelper.showSuccess(
            'Success',
            response.getLocalizedMessage(langCode),
          );
        } else if (response != null) {
          final langCode = Localizations.localeOf(context).languageCode;
          SnackBarHelper.showError(
            'Error',
            response.getLocalizedMessage(langCode),
          );
        }
      } catch (e) {
        SnackBarHelper.showError('Error', 'An unexpected error occurred');
      } finally {
        if (mounted) {
          setState(() {
            _isResending = false;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          l10n.otpVerification,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black, size: 32),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 48),
                    // Message text
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        l10n.otpSentMessage,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // OTP input fields
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(6, (index) {
                        return SizedBox(
                          width: 48,
                          height: 48,
                          child: TextField(
                            controller: _otpControllers[index],
                            focusNode: _focusNodes[index],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(1),
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChanged: (value) => _onOtpChanged(index, value),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color(0xFF1B834F),
                                  width: 1.5,
                                ),
                              ),
                              filled: false,
                            ),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 24),
                    // Timer
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        l10n.resendCodeIn(_resendTimer),
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Resend option
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${l10n.didntGetOtp} ',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        GestureDetector(
                          onTap: _resendOtp,
                          child: Text(
                            l10n.resendOtp,
                            style: TextStyle(
                              fontSize: 14,
                              color:
                                  _canResend
                                      ? const Color(0xFF1B834F)
                                      : Colors.grey.shade400,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 250),
                    // Continue button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isVerifying ? null : _onContinue,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1B834F),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child:
                            _isVerifying
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
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
