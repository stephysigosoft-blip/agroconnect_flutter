import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/api_service.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  final ApiService _apiService = Get.find<ApiService>();
  Future<Map<String, dynamic>?>? _aboutFuture;

  @override
  void initState() {
    super.initState();
    _aboutFuture = _apiService.getAboutUs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Center(
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: const Color(0xFF1B834F),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.chevron_left,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
        ),
        title: const Text(
          'About Us',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _aboutFuture,
        builder: (context, snapshot) {
          String aboutContent =
              'SAIMPEX AGRO Connect Pro is a leading agricultural marketplace platform connecting farmers, suppliers, and buyers across Mauritania. We are committed to revolutionizing the agricultural sector by providing a seamless digital platform for trading agricultural products.';

          if (snapshot.hasData && snapshot.data != null) {
            final data = snapshot.data!;
            if (data['data'] != null && data['data']['about'] != null) {
              final about = data['data']['about'];
              final currentLocale = Get.locale?.languageCode ?? 'en';
              if (currentLocale == 'ar') {
                aboutContent = about['content_ar'] ?? aboutContent;
              } else if (currentLocale == 'fr') {
                aboutContent = about['content_fr'] ?? aboutContent;
              } else {
                aboutContent = about['content_en'] ?? aboutContent;
              }
            }
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  aboutContent,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade700,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }
}
