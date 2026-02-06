import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _handleStartup();
  }

  Future<void> _handleStartup() async {
    // 2-second logo display
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final isGuest = prefs.getBool('is_guest') ?? false;

    if (isGuest) {
      // Guest login is not retained, clear and show language selection
      await prefs.remove('is_guest');
      await prefs.remove('auth_token');
      Get.offAllNamed('/languageSelection');
      return;
    }

    final token = prefs.getString('auth_token');

    if (token != null && token.isNotEmpty) {
      // User is logged in, skip to home
      Get.offAllNamed('/home');
    } else {
      // User is not logged in, show language selection/onboarding
      Get.offAllNamed('/languageSelection');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.green.shade50],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Image.asset(
                'lib/assets/images/logo.png',
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
