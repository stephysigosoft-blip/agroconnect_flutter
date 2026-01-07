import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/product_controller.dart';
import '../../controllers/chat_controller.dart';
import '../../controllers/wishlist_controller.dart';
import '../../models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    late final Product product;

    if (args is Product) {
      product = args;
    } else if (args is ChatThread) {
      // Fallback mapping from chat thread to minimal product
      product = Product(
        id: args.id,
        name: args.title,
        category: '',
        pricePerKg: 0,
        availableQuantityKg: 0,
        location: '',
        daysAgo: 0,
        imagePath: args.avatarPath,
      );
    } else {
      // Safe default to avoid crash
      product = const Product(
        id: 'unknown',
        name: 'Unknown',
        category: '',
        pricePerKg: 0,
        availableQuantityKg: 0,
        location: '',
        daysAgo: 0,
        imagePath: 'lib/assets/images/product\'s/millet.png',
      );
    }
    final ProductController controller = Get.find<ProductController>();
    final WishlistController wishlistController = Get.put(WishlistController());

    final related =
        controller.allProducts
            .where((p) => p.id != product.id && p.category == product.category)
            .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: Center(
          child: InkWell(
            onTap: () => Get.back(),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 35,
              height: 35, // Slightly larger square
              decoration: BoxDecoration(
                color: const Color(0xFF1B834F), // Green filled
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
          'Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        actions: [
          Obx(() {
            final isInWishlist = wishlistController.isInWishlist(product.id);
            return Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: InkWell(
                  onTap: () => wishlistController.toggleWishlist(product),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      color: Color(0xFF1B834F),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isInWishlist ? Icons.favorite : Icons.favorite_border,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            _buildImageCarousel(product),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildMainInfo(product),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildMakeDealButton(product),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildDescription(),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildPostedBy(),
            ),
            const SizedBox(height: 24),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF9F9F9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _buildAdMeta(),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Text(
                'Related Ads',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildRelatedAds(
                related.isEmpty ? controller.allProducts : related,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCarousel(Product product) {
    final images = [product.imagePath, product.imagePath, product.imagePath];

    final pageController = PageController();
    final currentPage = 0.obs;

    return SizedBox(
      height: 220,
      child: Stack(
        children: [
          PageView.builder(
            controller: pageController,
            itemCount: images.length,
            onPageChanged: (index) => currentPage.value = index,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    images[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              );
            },
          ),
          // Left arrow
          Positioned(
            left: 24,
            top: 0,
            bottom: 0,
            child: Center(
              child: _buildArrowButton(
                icon: Icons.chevron_left,
                onTap: () {
                  final prev = pageController.page!.round() - 1;
                  if (prev >= 0) {
                    pageController.animateToPage(
                      prev,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOut,
                    );
                  }
                },
              ),
            ),
          ),
          // Right arrow
          Positioned(
            right: 24,
            top: 0,
            bottom: 0,
            child: Center(
              child: _buildArrowButton(
                icon: Icons.chevron_right,
                onTap: () {
                  final next = pageController.page!.round() + 1;
                  if (next < images.length) {
                    pageController.animateToPage(
                      next,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOut,
                    );
                  }
                },
              ),
            ),
          ),
          // Dots
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(images.length, (index) {
                  final isActive = currentPage.value == index;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive ? const Color(0xFF1B834F) : Colors.white,
                      border: Border.all(color: Colors.white),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArrowButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }

  Widget _buildMainInfo(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          '${product.pricePerKg.toStringAsFixed(0)} MRU / Kg',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1B834F),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${product.availableQuantityKg.toStringAsFixed(0)} Kg Available',
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.location_on, size: 16, color: Colors.black),
            const SizedBox(width: 4),
            Text(
              product.location,
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMakeDealButton(Product product) {
    return OutlinedButton.icon(
      onPressed: () => _showMakeOfferDialog(product),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        side: const BorderSide(color: Color(0xFF1B834F)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      icon: const Icon(Icons.chat_bubble_outline, color: Color(0xFF1B834F)),
      label: const Text(
        'Make a Deal',
        style: TextStyle(
          color: const Color(0xFF1B834F),
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
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
                  fillColor: const Color(0xFFEEEEEE),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF1B834F)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Your Offer Price (MRU)',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: noteController,
                // Changed to 1 line as per typical number input, or 2 if notes. Image shows price input, so 1 line.
                maxLines: 1,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFEEEEEE),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF1B834F)),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        side: const BorderSide(color: Color(0xFF1B834F)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Color(0xFF1B834F), // Green Text
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
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
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Send Offer',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
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

  Widget _buildDescription() {
    return const Text(
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus rutrum ornare odio vel commodo. Quisque interdum dui at neque eleifend, ut laoreet sapien tempus. Etiam dui enim, ullamcorper id leo at, aliquam condimentum tortor.',
      style: TextStyle(fontSize: 13, color: Colors.black, height: 1.4),
    );
  }

  Widget _buildPostedBy() {
    return Container(
      // padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04), // Softer shadow
            blurRadius: 10,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'lib/assets/images/about farmer iamge.png',
              width: 60,
              height: 65,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Posted by',
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Mohamed Ould Salem',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                GestureDetector(
                  onTap: () => Get.toNamed('/sellerProfile'),
                  child: const Text(
                    'View Profile',
                    style: TextStyle(
                      color: Color(0xFF1B834F),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                      decorationColor: Color(0xFF1B834F),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdMeta() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Ad ID: 1290876589',
              style: TextStyle(fontSize: 13, color: Colors.black87),
            ),
          ],
        ),
        TextButton.icon(
          onPressed: () {},
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          icon: const Icon(
            Icons.flag_outlined,
            size: 16,
            color: Color(0xFF1B834F),
          ),
          label: const Text(
            'Report Ad',
            style: TextStyle(
              color: const Color(0xFF1B834F),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRelatedAds(List<Product> products) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.70, // Slightly taller to accommodate content
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return GestureDetector(
          onTap: () => Get.toNamed('/product', arguments: product),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              // border: Border.all(color: Colors.grey.shade100), // Removed border as per sleek look
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(
                    0.08,
                  ), // Slightly stronger shadow
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Image.asset(
                    product.imagePath,
                    height: 110,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${product.pricePerKg.toStringAsFixed(0)} MRU / Kg',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1B834F),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${product.availableQuantityKg.toStringAsFixed(0)} Kg Available',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 13,
                                color: Colors.black.withOpacity(0.6),
                              ),
                              const SizedBox(width: 2),
                              ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 55),
                                child: Text(
                                  product.location,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black.withOpacity(0.6),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '${product.daysAgo} day ago',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
