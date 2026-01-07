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
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
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
                  const SizedBox(height: 24),
                ],
                _buildSection(
                  title: '1. Acceptance of Terms',
                  content:
                      'By accessing and using the SAIMPEX AGRO Connect Pro application, you accept and agree to be bound by the terms and provision of this agreement. If you do not agree to abide by the above, please do not use this service.',
                ),
                _buildSection(
                  title: '2. Use License',
                  content:
                      'Permission is granted to temporarily download one copy of the materials on SAIMPEX AGRO Connect Pro\'s application for personal, non-commercial transitory viewing only. This is the grant of a license, not a transfer of title, and under this license you may not:\n\n• Modify or copy the materials\n• Use the materials for any commercial purpose or for any public display\n• Attempt to reverse engineer any software contained in the application\n• Remove any copyright or other proprietary notations from the materials',
                ),
                _buildSection(
                  title: '3. User Accounts',
                  content:
                      'You are responsible for maintaining the confidentiality of your account and password. You agree to accept responsibility for all activities that occur under your account or password. You must notify us immediately of any unauthorized use of your account.',
                ),
                _buildSection(
                  title: '4. Product Listings',
                  content:
                      'Users are responsible for the accuracy of their product listings. All product information, including but not limited to descriptions, prices, quantities, and images, must be truthful and accurate. SAIMPEX AGRO Connect Pro reserves the right to remove any listings that violate these terms.',
                ),
                _buildSection(
                  title: '5. Transactions',
                  content:
                      'All transactions between buyers and sellers are the sole responsibility of the parties involved. SAIMPEX AGRO Connect Pro acts as a platform to facilitate connections but is not responsible for the quality, safety, or legality of products listed or the accuracy of listings.',
                ),
                _buildSection(
                  title: '6. Prohibited Activities',
                  content:
                      'You agree not to:\n\n• Post false, inaccurate, or misleading information\n• Post items that are illegal or prohibited\n• Infringe on any third party\'s copyright, patent, trademark, or other intellectual property rights\n• Harass, abuse, or harm other users\n• Use the service for any unlawful purpose',
                ),
                _buildSection(
                  title: '7. Privacy Policy',
                  content:
                      'Your use of the application is also governed by our Privacy Policy. Please review our Privacy Policy to understand our practices regarding the collection and use of your personal information.',
                ),
                _buildSection(
                  title: '8. Limitation of Liability',
                  content:
                      'SAIMPEX AGRO Connect Pro shall not be liable for any indirect, incidental, special, consequential, or punitive damages resulting from your use of or inability to use the service.',
                ),
                _buildSection(
                  title: '9. Changes to Terms',
                  content:
                      'SAIMPEX AGRO Connect Pro reserves the right to revise these terms at any time without notice. By using this application, you are agreeing to be bound by the then current version of these Terms and Conditions.',
                ),
                _buildSection(
                  title: '10. Contact Information',
                  content:
                      'If you have any questions about these Terms and Conditions, please contact us at:\n\nEmail: support@agroconnect.com\nPhone: +222 45 12 34 56',
                ),
                const SizedBox(height: 32),
                _buildAcceptButton(),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1B834F).withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1B834F).withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(Icons.description, size: 48, color: const Color(0xFF1B834F)),
          const SizedBox(height: 12),
          const Text(
            'Last Updated: January 2024',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAcceptButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Get.back();
          Get.snackbar(
            'Terms Accepted',
            'You have accepted the Terms & Conditions',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color(0xFF1B834F).withOpacity(0.8),
            colorText: Colors.white,
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1B834F),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'I Accept',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
