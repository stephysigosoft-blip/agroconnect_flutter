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
        title: Text(
          AppLocalizations.of(context)!.buyPackages,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            if (controller.hasMoreAllPackages.value &&
                !controller.isLoadingMoreAllPackages.value) {
              controller.fetchAllPackages(loadMore: true);
            }
          }
          return false;
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBanner(context, controller),
              const SizedBox(height: 24),
              Text(
                AppLocalizations.of(context)!.buyPackages,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              Obx(() {
                if (controller.isLoading.value &&
                    controller.allPackages.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: CircularProgressIndicator(
                        color: Color(0xFF1B834F),
                      ),
                    ),
                  );
                }

                if (controller.allPackages.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Text(
                        AppLocalizations.of(context)!.noPackagesAvailable,
                      ),
                    ),
                  );
                }

                return Column(
                  children: [
                    ...controller.allPackages.map((package) {
                      final l10n = AppLocalizations.of(context)!;
                      final ads = package['no_ads']?.toString() ?? '0';
                      final validity = l10n.validityLabel(
                        (package['duration'] ?? '0').toString(),
                      );
                      final price = '${package['amount'] ?? '0'} MRU';

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildPackageCard(
                          packageId: package['id'],
                          ads: l10n.adsAvailable(ads),
                          validity: validity,
                          price: price,
                          controller: controller,
                          l10n: l10n,
                        ),
                      );
                    }).toList(),
                    if (controller.isLoadingMoreAllPackages.value)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFF1B834F),
                          ),
                        ),
                      ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBanner(BuildContext context, SubscriptionController controller) {
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
            Text(
              AppLocalizations.of(context)!.buyMorePackages,
              style: const TextStyle(
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
          ],
        ),
      ),
    );
  }

  Widget _buildPackageCard({
    required dynamic packageId,
    required String ads,
    required String validity,
    required String price,
    required SubscriptionController controller,
    required AppLocalizations l10n,
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
                    '/kycVerification',
                    arguments: {
                      'packageId': packageId,
                      'paymentMethod': '1', // Default as per Postman
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
                child: Text(
                  l10n.buyNow,
                  style: const TextStyle(
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
