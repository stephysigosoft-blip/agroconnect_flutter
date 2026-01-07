import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/api_service.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final ApiService _apiService = Get.find<ApiService>();
  String _email = 'support@agroconnect.com';
  String _phone = '+222 45 12 34 56';

  @override
  void initState() {
    super.initState();
    _fetchContactInfo();
  }

  Future<void> _fetchContactInfo() async {
    final response = await _apiService.getContact();
    if (response != null && response['status'] == true) {
      final contactData = response['data']['contact'];
      if (contactData != null) {
        setState(() {
          _email = contactData['email'] ?? _email;
          _phone =
              '${contactData['country_code'] ?? ''} ${contactData['mobile'] ?? ''}'
                  .trim();
          if (_phone.isEmpty) _phone = '+222 45 12 34 56';
        });
      }
    } else {
      // Handle error case if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
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
          'Help & Support',
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
            _buildSearchSection(),
            const SizedBox(height: 24),
            _buildSectionTitle('Frequently Asked Questions'),
            const SizedBox(height: 16),
            _buildFAQItem(
              question: 'How do I post a product?',
              answer:
                  'To post a product, tap the "Sell" button in the bottom navigation bar. Fill in the product details, upload images, set the price and quantity, then tap "Post".',
            ),
            _buildFAQItem(
              question: 'How do I contact a seller?',
              answer:
                  'You can contact a seller by tapping "Make a Deal" on any product listing. This will open a chat where you can negotiate the price and quantity.',
            ),
            _buildFAQItem(
              question: 'How do I add items to wishlist?',
              answer:
                  'Tap the heart icon on any product card to add it to your wishlist. You can view all your wishlist items from the Wishlist tab.',
            ),
            _buildFAQItem(
              question: 'How do I update my profile?',
              answer:
                  'Go to Profile > Settings > Edit Profile. You can update your name, phone number, and profile picture from there.',
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Contact Us'),
            const SizedBox(height: 16),
            _buildContactCard(
              icon: Icons.email,
              title: 'Email Support',
              subtitle: _email,
              onTap: () {
                // TODO: Open email client
              },
            ),
            const SizedBox(height: 12),
            _buildContactCard(
              icon: Icons.phone,
              title: 'Phone Support',
              subtitle: _phone,
              onTap: () {
                // TODO: Make phone call
              },
            ),
            const SizedBox(height: 12),
            _buildContactCard(
              icon: Icons.chat_bubble,
              title: 'Live Chat',
              subtitle: 'Available 24/7',
              onTap: () {
                // TODO: Open live chat
              },
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Report an Issue'),
            const SizedBox(height: 16),
            _buildActionCard(
              icon: Icons.bug_report,
              title: 'Report a Bug',
              subtitle: 'Found something that\'s not working? Let us know!',
              onTap: () {
                // TODO: Open bug report form
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Search for help...',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildFAQItem({required String question, required String answer}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        title: Text(
          question,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        children: [
          Text(
            answer,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF1B834F).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: const Color(0xFF1B834F), size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.orange.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.orange, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }
}
