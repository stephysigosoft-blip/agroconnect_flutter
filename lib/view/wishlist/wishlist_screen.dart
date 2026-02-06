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
          return _buildEmptyState(l10n);
        }
        return _buildWishlistGrid(context, controller, l10n);
      }),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            l10n.noItemsInWishlist,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.noItemsInWishlistDesc,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistGrid(
    BuildContext context,
    WishlistController controller,
    AppLocalizations l10n,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: RefreshIndicator(
        onRefresh: () async {
          await controller.fetchWishlist();
        },
        color: const Color(0xFF1B834F),
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels >=
                scrollInfo.metrics.maxScrollExtent * 0.8) {
              if (controller.hasMore.value && !controller.isLoadingMore.value) {
                controller.fetchWishlist(loadMore: true);
              }
            }
            return false;
          },
          child: GridView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.54, // Reverted to accommodate outside buttons
            ),
            itemCount:
                controller.wishlistItems.length +
                (controller.isLoadingMore.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == controller.wishlistItems.length) {
                return const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Color(0xFF1B834F),
                      strokeWidth: 2,
                    ),
                  ),
                );
              }
              final product = controller.wishlistItems[index];
              return _buildWishlistCard(context, product, controller, l10n);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildWishlistCard(
    BuildContext context,
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
              onTap:
                  () => _showDeleteConfirmationDialog(
                    context,
                    product,
                    controller,
                  ),
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
                onPressed: () => _showMakeOfferDialog(product, l10n),
                icon: const Icon(Icons.chat_bubble_outline, size: 14),
                label: Text(
                  l10n.makeADeal,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
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
    BuildContext context,
    Product product,
    WishlistController controller,
  ) {
    final l10n = AppLocalizations.of(context)!;
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
              Text(
                l10n.removeFromWishlist,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.removeFromWishlistConfirmation,
                style: const TextStyle(
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
                      child: Text(
                        l10n.cancel,
                        style: const TextStyle(
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
                      child: Text(
                        l10n.remove,
                        style: const TextStyle(
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

  void _showMakeOfferDialog(Product product, AppLocalizations l10n) {
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
              Center(
                child: Text(
                  l10n.makeAnOffer,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                l10n.quantityKg,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
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
              Text(
                l10n.yourOfferPrice,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
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
                      child: Text(
                        l10n.cancel,
                        style: const TextStyle(
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
                        final price = noteController.text.trim();

                        if (qty.isEmpty) {
                          Get.snackbar(
                            l10n.required,
                            l10n.pleaseEnterQuantity,
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.redAccent,
                            colorText: Colors.white,
                            margin: const EdgeInsets.all(16),
                            borderRadius: 12,
                          );
                          return;
                        }
                        if (double.tryParse(qty) == null ||
                            double.parse(qty) <= 0) {
                          Get.snackbar(
                            l10n.invalidInput,
                            l10n.validNumericQuantity,
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.redAccent,
                            colorText: Colors.white,
                            margin: const EdgeInsets.all(16),
                            borderRadius: 12,
                          );
                          return;
                        }
                        if (price.isNotEmpty &&
                            (double.tryParse(price) == null ||
                                double.parse(price) <= 0)) {
                          Get.snackbar(
                            l10n.invalidInput,
                            l10n.validNumericPrice,
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.redAccent,
                            colorText: Colors.white,
                            margin: const EdgeInsets.all(16),
                            borderRadius: 12,
                          );
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
                      child: Text(
                        l10n.sendOffer,
                        style: const TextStyle(
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
