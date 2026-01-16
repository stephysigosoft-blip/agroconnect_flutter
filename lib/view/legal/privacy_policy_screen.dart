import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agroconnect_flutter/l10n/app_localizations.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../services/api_service.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  final ApiService _apiService = Get.find<ApiService>();
  Future<Map<String, dynamic>?>? _privacyFuture;

  @override
  void initState() {
    super.initState();
    _privacyFuture = _apiService.getPrivacyPolicy();
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
        title: Text(
          AppLocalizations.of(context)!.privacyPolicy,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _privacyFuture,
        builder: (context, snapshot) {
          String dynamicContent = '';
          if (snapshot.hasData && snapshot.data != null) {
            final data = snapshot.data!;
            if (data['data'] != null &&
                data['data']['privacy_policy'] != null) {
              final privacy = data['data']['privacy_policy'];
              final currentLocale = Get.locale?.languageCode ?? 'en';
              if (currentLocale == 'ar') {
                dynamicContent = privacy['content_ar'] ?? '';
              } else if (currentLocale == 'fr') {
                dynamicContent = privacy['content_fr'] ?? '';
              } else {
                dynamicContent = privacy['content_en'] ?? '';
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
