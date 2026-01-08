import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../services/api_service.dart';

class TermsConditionsScreen extends StatefulWidget {
  const TermsConditionsScreen({super.key});

  @override
  State<TermsConditionsScreen> createState() => _TermsConditionsScreenState();
}

class _TermsConditionsScreenState extends State<TermsConditionsScreen> {
  final ApiService _apiService = Get.find<ApiService>();
  Future<Map<String, dynamic>?>? _termsFuture;

  @override
  void initState() {
    super.initState();
    _termsFuture = _apiService.getTermsAndConditions();
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
          'Terms & Conditions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _termsFuture,
        builder: (context, snapshot) {
          String dynamicContent = '';
          if (snapshot.hasData && snapshot.data != null) {
            final data = snapshot.data!;
            if (data['data'] != null && data['data']['terms'] != null) {
              final terms = data['data']['terms'];
              final currentLocale = Get.locale?.languageCode ?? 'en';
              if (currentLocale == 'ar') {
                dynamicContent = terms['content_ar'] ?? '';
              } else if (currentLocale == 'fr') {
                dynamicContent = terms['content_fr'] ?? '';
              } else {
                dynamicContent = terms['content_en'] ?? '';
              }
            }
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (dynamicContent.isNotEmpty) ...[
                  Html(
                    data: dynamicContent,
                    style: {
                      "body": Style(
                        margin: Margins.all(0),
                        fontSize: FontSize(14),
                        color: Colors.grey.shade700,
                        lineHeight: LineHeight(1.6),
                      ),
                      "h1": Style(
                        fontSize: FontSize(18),
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      "h2": Style(
                        fontSize: FontSize(16),
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    },
                  ),
                  const SizedBox(height: 32),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
