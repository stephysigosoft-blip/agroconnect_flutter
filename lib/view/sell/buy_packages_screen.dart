import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuyPackagesScreen extends StatelessWidget {
  const BuyPackagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: Center(
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
        title: const Text(
          'Buy Packages',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
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
            _buildBanner(),
            const SizedBox(height: 24),
            const Text(
              'Buy Packages',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            _buildPackageCard(
              ads: '10 Ads',
              validity: 'Valid for 30 days',
              price: '100 MRU',
            ),
            const SizedBox(height: 12),
            _buildPackageCard(
              ads: '20 Ads',
              validity: 'Valid for 30 days',
              price: '2000 MRU',
            ),
            const SizedBox(height: 12),
            _buildPackageCard(
              ads: '30 Ads',
              validity: 'Valid for 30 days',
              price: '3000 MRU',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      width: double.infinity,
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: const DecorationImage(
          image: AssetImage('lib/assets/images/plant.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.black.withOpacity(0.6), Colors.transparent],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Buy More Packages',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Vivamus vestibulum urna sed turpis\nimperdiet, eget posuere lacus rhoncus.\nSuspendisse molestie,',
              style: TextStyle(color: Colors.white, fontSize: 11),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.5)),
                ),
                child: const Text(
                  'Buy Now',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPackageCard({
    required String ads,
    required String validity,
    required String price,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF8DCFB0), width: 3),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.campaign_outlined,
                      color: Color(0xFFFDA45B),
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      ads,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.hourglass_empty_outlined,
                      color: Color(0xFFFDA45B),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      validity,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black.withOpacity(0.5),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B834F),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Get.toNamed(
                    '/adPostedSuccess',
                    arguments: {
                      'title': 'PACKAGE BOUGHT SUCCESSFULLY',
                      'buttonText': 'My Packages',
                      'onButtonPressed': () => Get.offNamed('/myPackages'),
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B834F),
                  minimumSize: const Size(90, 36),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                child: const Text(
                  'Buy Now',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
