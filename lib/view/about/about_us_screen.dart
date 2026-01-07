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
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSection(
                        icon: Icons.info_outline,
                        title: 'Who We Are',
                        content: aboutContent,
                      ),
                      const SizedBox(height: 24),
                      _buildSection(
                        icon: Icons.visibility,
                        title: 'Our Vision',
                        content:
                            'To become the premier digital platform for agricultural trade in West Africa, empowering farmers and traders to reach wider markets, increase their income, and contribute to food security in the region.',
                      ),
                      const SizedBox(height: 24),
                      _buildSection(
                        icon: Icons.flag,
                        title: 'Our Mission',
                        content:
                            'To connect agricultural stakeholders through innovative technology, facilitate fair trade, and support sustainable farming practices while making agricultural products more accessible to everyone.',
                      ),
                      const SizedBox(height: 24),
                      _buildSection(
                        icon: Icons.star,
                        title: 'What We Offer',
                        content:
                            '• Easy product listing and management\n• Direct communication between buyers and sellers\n• Secure transaction facilitation\n• Product search and filtering\n• Wishlist and favorites\n• Order tracking and management\n• Multi-language support',
                      ),
                      const SizedBox(height: 24),
                      _buildTeamSection(),
                      const SizedBox(height: 24),
                      _buildStatsSection(),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1B834F).withOpacity(0.05),
            const Color(0xFF1B834F).withOpacity(0.1),
          ],
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1B834F).withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Center(
              child: Text(
                'SAIMPEX',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1B834F),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'SAIMPEX AGRO Connect Pro',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Connecting Agriculture, Empowering Farmers',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B834F).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: const Color(0xFF1B834F), size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade700,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B834F).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.people,
                  color: Color(0xFF1B834F),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Our Team',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'We are a dedicated team of agricultural experts, technology enthusiasts, and business professionals working together to transform the agricultural marketplace in Mauritania.',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade700,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildTeamMember(
                  name: 'Agricultural Experts',
                  role: 'Product & Quality',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTeamMember(name: 'Tech Team', role: 'Development'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMember({required String name, required String role}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF1B834F).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: Color(0xFF1B834F), size: 30),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            role,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1B834F).withOpacity(0.05),
            const Color(0xFF1B834F).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Our Impact',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                value: '500+',
                label: 'Active Users',
                icon: Icons.people,
              ),
              _buildStatItem(
                value: '1000+',
                label: 'Products',
                icon: Icons.shopping_bag,
              ),
              _buildStatItem(
                value: '50+',
                label: 'Categories',
                icon: Icons.category,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String value,
    required String label,
    required IconData icon,
  }) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF1B834F), size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B834F),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
