import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
          'Privacy Policy',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildSection(
              title: '1. Information We Collect',
              content:
                  'We collect information that you provide directly to us, including:\n\n• Personal information (name, phone number, email address)\n• Product listings and descriptions\n• Transaction information\n• Profile information and preferences\n• Communications with other users\n• Device information and usage data',
            ),
            _buildSection(
              title: '2. How We Use Your Information',
              content:
                  'We use the information we collect to:\n\n• Provide, maintain, and improve our services\n• Process transactions and send related information\n• Send you technical notices and support messages\n• Respond to your comments and questions\n• Monitor and analyze trends and usage\n• Personalize your experience\n• Detect, prevent, and address technical issues',
            ),
            _buildSection(
              title: '3. Information Sharing',
              content:
                  'We do not sell your personal information. We may share your information only in the following circumstances:\n\n• With other users as necessary to facilitate transactions\n• With service providers who assist us in operating our platform\n• When required by law or to protect our rights\n• In connection with a business transfer or merger',
            ),
            _buildSection(
              title: '4. Data Security',
              content:
                  'We implement appropriate technical and organizational measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction. However, no method of transmission over the internet is 100% secure.',
            ),
            _buildSection(
              title: '5. Your Rights',
              content:
                  'You have the right to:\n\n• Access your personal information\n• Correct inaccurate information\n• Request deletion of your information\n• Object to processing of your information\n• Request data portability\n• Withdraw consent at any time',
            ),
            _buildSection(
              title: '6. Cookies and Tracking',
              content:
                  'We use cookies and similar tracking technologies to track activity on our application and hold certain information. You can instruct your browser to refuse all cookies or to indicate when a cookie is being sent.',
            ),
            _buildSection(
              title: '7. Third-Party Services',
              content:
                  'Our application may contain links to third-party websites or services. We are not responsible for the privacy practices of these third parties. We encourage you to read their privacy policies.',
            ),
            _buildSection(
              title: '8. Children\'s Privacy',
              content:
                  'Our service is not intended for children under the age of 18. We do not knowingly collect personal information from children. If you are a parent or guardian and believe your child has provided us with personal information, please contact us.',
            ),
            _buildSection(
              title: '9. Changes to This Policy',
              content:
                  'We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the "Last Updated" date.',
            ),
            _buildSection(
              title: '10. Contact Us',
              content:
                  'If you have any questions about this Privacy Policy, please contact us at:\n\nEmail: privacy@agroconnect.com\nPhone: +222 45 12 34 56\nAddress: SAIMPEX AGRO Connect Pro, Nouakchott, Mauritania',
            ),
            const SizedBox(height: 32),
            _buildContactButton(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        children: [
          Icon(Icons.privacy_tip, size: 48, color: Colors.blue.shade700),
          const SizedBox(height: 12),
          const Text(
            'Last Updated: January 2024',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your privacy is important to us',
            style: TextStyle(
              fontSize: 14,
              color: Colors.blue.shade700,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
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

  Widget _buildContactButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          // TODO: Open contact form or email
          Get.snackbar(
            'Contact Us',
            'Email: privacy@agroconnect.com',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 3),
          );
        },
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.blue),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Contact Privacy Team',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
