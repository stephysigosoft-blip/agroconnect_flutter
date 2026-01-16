import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agroconnect_flutter/l10n/app_localizations.dart';
import '../../controllers/subscription_controller.dart';

class BuyPackagesScreen extends StatelessWidget {
  const BuyPackagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SubscriptionController controller = Get.put(SubscriptionController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
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
        title: Text(
          AppLocalizations.of(context)!.buyPackages,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.allPackages.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF1B834F)),
          );
        }

        if (controller.allPackages.isEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            controller.fetchAllPackages();
          });
          return Center(
            child: Text(AppLocalizations.of(context)!.noPackagesAvailable),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: controller.allPackages.length,
          separatorBuilder: (context, index) => const SizedBox(height: 20),
          itemBuilder: (context, index) {
            final pkg = controller.allPackages[index];

            // Assign colors based on index to keep the multi-color UI style
            Color pkgColor;
            bool isPremium = false;
            if (index == 0) {
              pkgColor = const Color(0xFF1B834F);
            } else if (index == 1) {
              pkgColor = const Color(0xFFF39600);
            } else {
              pkgColor = const Color(0xFFE65100);
              isPremium = index >= 2; // Mark third and beyond as premium
            }

            return _buildPackagePlan(
              context: context,
              controller: controller,
              name: pkg['name_en'] ?? pkg['name'] ?? 'Plan',
              price: pkg['price']?.toString() ?? '0',
              ads: (pkg['total_ads'] ?? pkg['ads'])?.toString() ?? '0',
              duration: pkg['validity_days'] ?? pkg['duration'] ?? '0',
              packageId: pkg['id'],
              color: pkgColor,
              isPremium: isPremium,
            );
          },
        );
      }),
    );
  }

  Widget _buildPackagePlan({
    required BuildContext context,
    required SubscriptionController controller,
    required String name,
    required String price,
    required String ads,
    required String duration,
    required dynamic packageId,
    required Color color,
    bool isPremium = false,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '$price MRU',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 24),
          _buildFeature(l10n.numberOfAds(ads)),
          _buildFeature(l10n.validityLabel(duration)),
          _buildFeature(l10n.support247),
          if (isPremium) _buildFeature(l10n.featuredAdPlacement),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              Get.toNamed(
                '/kycVerification',
                arguments: {
                  'packageId': packageId,
                  'paymentMethod': '1', // Defaulting to 1 as per Postman
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              minimumSize: const Size.fromHeight(54),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: Text(
              l10n.buyNow,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeature(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF1B834F), size: 18),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(fontSize: 15, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
