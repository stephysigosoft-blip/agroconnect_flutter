import 'package:agroconnect_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';
import '../../controllers/product_controller.dart';
import '../../models/product.dart';
import '../../widgets/product_card.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();
    final ProductController productController = Get.find<ProductController>();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'SAIMPEX AGRO',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: Color(0xFF1B834F),
            letterSpacing: 0.5,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.notifications_outlined,
            color: Colors.black87,
            size: 28,
          ),
          onPressed: () {
            Get.toNamed('/notifications');
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black87, size: 28),
            onPressed: () {
              Get.toNamed('/search');
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.favorite_border,
              color: Colors.black87,
              size: 28,
            ),
            onPressed: () {
              Get.toNamed('/wishlist');
              // Navigate to Wishlist tab (index 3)
              // controller.jumpToTab(3);
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // Promotional Banner
            _buildPromotionalBanner(l10n, controller),
            const SizedBox(height: 24),

            // Categories Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                l10n.categories,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            _buildCategoriesSection(l10n, productController),
            const SizedBox(height: 10),

            // Recently Added Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.recentlyAdded,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            _buildRecentlyAddedSection(l10n),
            const SizedBox(height: 16),

            // Recommendations Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                l10n.recommendationsForYou,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildRecommendationsSection(l10n, productController),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildPromotionalBanner(
    AppLocalizations l10n,
    HomeController controller,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
      child: Stack(
        children: [
          // Carousel pages
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: PageView.builder(
              controller: PageController(),
              itemCount: controller.bannerImages.length,
              onPageChanged: controller.onBannerPageChanged,
              itemBuilder: (context, index) {
                return Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      controller.bannerImages[index],
                      fit: BoxFit.fill,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback if image not found
                        return Container(
                          color: Colors.white,
                          child: const Icon(
                            Icons.landscape,
                            // color: Color(0xFF1B834F),
                            size: 50,
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          // Carousel dots overlay
          Positioned(
            left: 0,
            right: 0,
            bottom: 5,
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(controller.bannerImages.length, (
                  index,
                ) {
                  final isActive = index == controller.currentBannerIndex.value;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: _buildCarouselDot(isActive),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselDot(bool isActive) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white.withOpacity(0.5),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildCategoriesSection(
    AppLocalizations l10n,
    ProductController productController,
  ) {
    final categories = productController.categories;
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final label = categories[index];
          // Map to existing localized labels for icons
          final displayLabel = () {
            if (label.startsWith('Grains')) return l10n.grainsCereals;
            if (label.startsWith('Vegetables')) return l10n.vegetables;
            if (label.startsWith('Livestock')) return l10n.livestockMeat;
            return l10n.poultryEggs;
          }();
          final imagePath = () {
            switch (index) {
              case 0:
                return 'lib/assets/images/categories/Rounded rectangle.png';
              case 1:
                return 'lib/assets/images/categories/Rounded rectangle (1).png';
              case 2:
                return 'lib/assets/images/categories/Rounded rectangle (2).png';
              default:
                return 'lib/assets/images/categories/Rounded rectangle (3).png';
            }
          }();
          return Container(
            width: 90,
            margin: const EdgeInsets.only(right: 16),
            child: Column(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF1B834F),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1B834F).withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      imagePath,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback to icon if image not found
                        return Container(
                          color: Colors.grey.shade100,
                          child: Icon(
                            _getCategoryIcon(displayLabel),
                            color: const Color(0xFF1B834F),
                            size: 32,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  displayLabel,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecentlyAddedSection(AppLocalizations l10n) {
    final ProductController productController = Get.find<ProductController>();
    final List<Product> products = List<Product>.from(
      productController.allProducts,
    )..sort((a, b) => a.daysAgo.compareTo(b.daysAgo));

    final recent = products.take(3).toList();

    return SizedBox(
      height: 230, // Adjusted height for ProductCard
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: recent.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ProductCard(product: recent[index], isHorizontal: true),
          );
        },
      ),
    );
  }

  Widget _buildRecommendationsSection(
    AppLocalizations l10n,
    ProductController productController,
  ) {
    final List<Product> products = productController.allProducts;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.72,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ProductCard(product: products[index]);
        },
      ),
    );
  }

  // _buildProductCard method removed as it's replaced by ProductCard widget

  // _getProductIcon method removed as it's no longer needed

  IconData _getCategoryIcon(String categoryLabel) {
    if (categoryLabel.contains('Grains') || categoryLabel.contains('Cereals')) {
      return Icons.grass;
    } else if (categoryLabel.contains('Vegetables')) {
      return Icons.eco;
    } else if (categoryLabel.contains('Livestock') ||
        categoryLabel.contains('Meat')) {
      return Icons.set_meal;
    } else if (categoryLabel.contains('Poultry') ||
        categoryLabel.contains('Eggs')) {
      return Icons.egg;
    }
    return Icons.category;
  }
}
