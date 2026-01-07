import 'package:agroconnect_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/wishlist_controller.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/chat_controller.dart';
import '../../models/product.dart';
import '../../widgets/product_card.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final WishlistController controller = Get.put(WishlistController());
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Center(
            child: GestureDetector(
              onTap: () {
                if (Navigator.canPop(context)) {
                  Get.back();
                } else {
                  final HomeController homeController =
                      Get.find<HomeController>();
                  homeController.tabController.index = 0;
                }
              },
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
          l10n.wishlist,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.wishlistItems.isEmpty) {
          return _buildEmptyState();
        }
        return _buildWishlistGrid(controller, l10n);
      }),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No items in wishlist',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Text(
            'Add products to your wishlist to save them for later',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistGrid(
    WishlistController controller,
    AppLocalizations l10n,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.54, // Reverted to accommodate outside buttons
        ),
        itemCount: controller.wishlistItems.length,
        itemBuilder: (context, index) {
          final product = controller.wishlistItems[index];
          return _buildWishlistCard(product, controller, l10n);
        },
      ),
    );
  }

  Widget _buildWishlistCard(
    Product product,
    WishlistController controller,
    AppLocalizations l10n,
  ) {
    return Column(
      children: [
        ProductCard(
          product: product,
          // bottomActions is null, so they stay inside the ProductCard
        ),
        // const SizedBox(height: 5),
        Row(
          children: [
            // Delete Button
            GestureDetector(
              onTap: () => _showDeleteConfirmationDialog(product, controller),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFF1B834F)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.delete_outline,
                  color: Colors.black,
                  size: 18,
                ),
              ),
            ),
            const SizedBox(width: 5),
            // Make a Deal Button
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _showMakeOfferDialog(product),
                icon: const Icon(Icons.chat_bubble_outline, size: 14),
                label: const Text(
                  'Make a Deal',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF1B834F),
                  side: const BorderSide(color: Color(0xFF1B834F)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 32),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showDeleteConfirmationDialog(
    Product product,
    WishlistController controller,
  ) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 40),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              const Text(
                'Remove from Wishlist',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Are you sure to delete this product from wishlist?',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF1B834F)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Color(0xFF1B834F),
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        controller.removeFromWishlist(product.id);
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B834F),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Remove',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierColor: Colors.black54,
    );
  }

  void _showMakeOfferDialog(Product product) {
    final quantityController = TextEditingController();
    final noteController = TextEditingController();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Make an Offer',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Quantity (Kg)',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color.fromARGB(255, 218, 217, 217),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF1B834F)),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Your Offer Price (MRU)',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: noteController,
                keyboardType: TextInputType.number,
                maxLines: 2,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color.fromARGB(255, 218, 217, 217),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF1B834F)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(44),
                        side: const BorderSide(color: Color(0xFF1B834F)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: const Color(0xFF1B834F),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final qty = quantityController.text.trim();
                        if (qty.isEmpty) {
                          return;
                        }
                        final chatController = Get.put(ChatController());
                        chatController.sendOffer(
                          product: product,
                          quantityKg: qty,
                        );
                        Get.back(); // close dialog
                        Get.toNamed('/chatList');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B834F),
                        minimumSize: const Size.fromHeight(44),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text(
                        'Send Offer',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierColor: Colors.black54,
    );
  }
}
