import 'package:agroconnect_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/product_controller.dart';
import '../../controllers/chat_controller.dart';
import '../../controllers/wishlist_controller.dart';
import '../../models/product.dart';
import '../../services/api_service.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final args = Get.arguments;
    late final Product product;
    bool showCancel = false;

    if (args is Map) {
      product = args['product'] as Product;
      showCancel = args['showCancel'] == true;
    } else if (args is Product) {
      product = args;
    } else if (args is ChatThread) {
      // Fallback mapping from chat thread to minimal product
      product = Product(
        id: args.productId,
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
      product = Product(
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

    // Trigger fetch details
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchProductDetails(product.id);
    });

    final ApiService apiService = Get.find<ApiService>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: Center(
          child: InkWell(
            onTap: () {
              if (showCancel) {
                Get.offAllNamed('/home');
              } else {
                Get.back();
              }
            },
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
        title: Text(
          l10n.details,
          style: const TextStyle(
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
                    decoration: const BoxDecoration(
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
      body: FutureBuilder<bool>(
        future: apiService.isGuest(),
        builder: (context, snapshot) {
          final isGuest = snapshot.data ?? false;
          return Obx(() {
            if (controller.isFetchingDetails.value &&
                controller.currentProductDetails.value == null) {
              return const Center(child: CircularProgressIndicator());
            }

            final p = controller.currentProductDetails.value ?? product;

            final related =
                controller.allProducts
                    .where(
                      (item) => item.id != p.id && item.category == p.category,
                    )
                    .toList();

            return SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 16),
              child: GestureDetector(
                onTap: isGuest ? () => _showLoginRequiredDialog(context) : null,
                behavior: HitTestBehavior.opaque,
                child: IgnorePointer(
                  ignoring: isGuest,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      _buildImageCarousel(p),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _buildMainInfo(context, p),
                      ),
                      const SizedBox(height: 16),
                      if (showCancel)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => Get.offAllNamed('/home'),
                                  style: OutlinedButton.styleFrom(
                                    minimumSize: const Size.fromHeight(48),
                                    side: const BorderSide(
                                      color: Color(0xFF1B834F),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                  ),
                                  child: const Text(
                                    'Back',
                                    style: TextStyle(
                                      color: Color(0xFF1B834F),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => Get.offAllNamed('/home'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1B834F),
                                    minimumSize: const Size.fromHeight(48),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    l10n.cancel,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: _buildMakeDealButton(p, l10n),
                        ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _buildDescription(p, l10n),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _buildPostedBy(p, l10n),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9F9F9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: _buildAdMeta(context, controller, p),
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          l10n.relatedAds,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _buildRelatedAds(
                          context,
                          related.isEmpty ? controller.allProducts : related,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }

  void _showLoginRequiredDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.lock_outline,
                    size: 40,
                    color: Colors.orangeAccent,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Login Required',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Text(
                  'please login to access the application',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back(); // Close dialog
                      Get.offAllNamed('/languageSelection');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B834F),
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageCarousel(Product product) {
    final images =
        product.images.isNotEmpty ? product.images : [product.imagePath];

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
              final img = images[index];
              final isNetwork = img.startsWith('http');
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child:
                      isNetwork
                          ? Image.network(
                            img,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder:
                                (context, error, stackTrace) =>
                                    _buildErrorPlaceholder(),
                          )
                          : Image.asset(
                            img,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder:
                                (context, error, stackTrace) =>
                                    _buildErrorPlaceholder(),
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

  Widget _buildMainInfo(BuildContext context, Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          AppLocalizations.of(
            context,
          )!.pricePerKg(product.pricePerKg.toStringAsFixed(0)),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1B834F),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          AppLocalizations.of(
            context,
          )!.available(product.availableQuantityKg.toStringAsFixed(0)),
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

  Widget _buildMakeDealButton(Product product, AppLocalizations l10n) {
    return OutlinedButton.icon(
      onPressed: () => _showMakeOfferDialog(product, l10n),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        side: const BorderSide(color: Color(0xFF1B834F)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      icon: Image.asset(
        'lib/assets/images/Icons/Chat Agro.png',
        height: 20,
        width: 20,
      ),
      label: Text(
        l10n.makeADeal,
        style: const TextStyle(
          color: Color(0xFF1B834F),
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
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
              Text(
                l10n.yourOfferPrice,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
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
                      child: Text(
                        l10n.cancel,
                        style: const TextStyle(
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
                        if (double.tryParse(qty) == null) {
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
                            double.tryParse(price) == null) {
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
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        l10n.sendOffer,
                        style: const TextStyle(
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

  Widget _buildDescription(Product product, AppLocalizations l10n) {
    return Text(
      product.description.isNotEmpty ? product.description : l10n.noDescription,
      style: const TextStyle(fontSize: 13, color: Colors.black, height: 1.4),
    );
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      color: Colors.grey.shade100,
      child: const Icon(
        Icons.image_not_supported,
        size: 50,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildPostedBy(Product product, AppLocalizations l10n) {
    final sellerName =
        product.sellerName.isNotEmpty
            ? product.sellerName
            : 'Mohamed Ould Salem';
    final sellerImage = product.sellerImage;
    final isNetworkImage = sellerImage.startsWith('http');

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
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
            child:
                isNetworkImage
                    ? Image.network(
                      sellerImage,
                      width: 60,
                      height: 65,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) => Image.asset(
                            'lib/assets/images/farmer image.png',
                            width: 60,
                            height: 65,
                            fit: BoxFit.cover,
                          ),
                    )
                    : Image.asset(
                      'lib/assets/images/farmer image.png',
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
                Text(
                  l10n.postedBy,
                  style: const TextStyle(fontSize: 12, color: Colors.black),
                ),
                const SizedBox(height: 2),
                Text(
                  sellerName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                GestureDetector(
                  onTap:
                      () => Get.toNamed('/sellerProfile', arguments: product),
                  child: Text(
                    l10n.viewProfile,
                    style: const TextStyle(
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

  Widget _buildAdMeta(
    BuildContext context,
    ProductController controller,
    Product product,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.adId(product.id),
                style: const TextStyle(fontSize: 13, color: Colors.black87),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        TextButton.icon(
          onPressed:
              () => _showReportAdBottomSheet(context, controller, product),
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
          label: Text(
            l10n.reportAd,
            style: const TextStyle(
              color: const Color(0xFF1B834F),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRelatedAds(BuildContext context, List<Product> products) {
    final l10n = AppLocalizations.of(context)!;
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
                  child:
                      product.imagePath.startsWith('http')
                          ? Image.network(
                            product.imagePath,
                            height: 110,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) =>
                                    _buildErrorPlaceholder(),
                          )
                          : Image.asset(
                            product.imagePath,
                            height: 110,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) =>
                                    _buildErrorPlaceholder(),
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
                        l10n.pricePerKg(product.pricePerKg.toStringAsFixed(0)),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1B834F),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.available(
                          product.availableQuantityKg.toStringAsFixed(0),
                        ),
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
                            l10n.daysAgo(product.daysAgo),
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

void _showReportAdBottomSheet(
  BuildContext context,
  ProductController controller,
  Product product,
) {
  final reasons = [
    'Offensive Content',
    'Fraud',
    'Duplicate Ad',
    'Product Already Sold',
    'Other',
  ];
  final selectedReason = "".obs;
  final commentController = TextEditingController();

  Get.bottomSheet(
    SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey,
              ),
              child: const Icon(Icons.close, size: 24, color: Colors.black),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Report Ad',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                ...reasons.map(
                  (reason) => Obx(
                    () => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: () => selectedReason.value = reason,
                        child: Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color:
                                      selectedReason.value == reason
                                          ? const Color(0xFF1B834F)
                                          : Colors.grey.shade400,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(4),
                                color:
                                    selectedReason.value == reason
                                        ? const Color(0xFF1B834F)
                                        : Colors.transparent,
                              ),
                              child:
                                  selectedReason.value == reason
                                      ? const Icon(
                                        Icons.check,
                                        size: 16,
                                        color: Colors.white,
                                      )
                                      : null,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              reason,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: commentController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Comment',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 13,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF9F9F9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.all(12),
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
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Color(0xFF1B834F),
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (selectedReason.value.isEmpty) {
                            Get.snackbar(
                              'Required',
                              'Please select a reason',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.redAccent,
                              colorText: Colors.white,
                              margin: const EdgeInsets.all(16),
                              borderRadius: 12,
                            );
                            return;
                          }

                          final l10n = AppLocalizations.of(context)!;
                          final success = await controller.reportAd(
                            productId: product.id,
                            reason: selectedReason.value,
                            comment: commentController.text,
                          );

                          Get.back();

                          if (success) {
                            Get.snackbar(
                              l10n.success,
                              l10n.adReported,
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: const Color(0xFF1B834F),
                              colorText: Colors.white,
                              margin: const EdgeInsets.all(16),
                              borderRadius: 12,
                            );
                          } else {
                            Get.snackbar(
                              l10n.error,
                              l10n.failedReport,
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.redAccent,
                              colorText: Colors.white,
                              margin: const EdgeInsets.all(16),
                              borderRadius: 12,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1B834F),
                          minimumSize: const Size.fromHeight(48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Send',
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
        ],
      ),
    ),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
  );
}
