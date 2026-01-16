import 'package:agroconnect_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';
import '../../controllers/product_controller.dart';
import '../../widgets/product_card.dart';
import '../search/search_screen.dart';

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
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.fetchHomeData();
        },
        color: const Color(0xFF1B834F),
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels ==
                scrollInfo.metrics.maxScrollExtent) {
              if (controller.hasMoreAllProducts.value &&
                  !controller.isLoadingMoreAll.value) {
                controller.fetchAllProducts(loadMore: true);
              }
            }
            return false;
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
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

                // All Products Section
                Obx(() {
                  if (controller.allProducts.isEmpty)
                    return const SizedBox.shrink();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          l10n.allProducts,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildAllProductsSection(l10n),
                      if (controller.isLoadingMoreAll.value)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFF1B834F),
                            ),
                          ),
                        ),
                      const SizedBox(height: 24),
                    ],
                  );
                }),
              ],
            ),
          ),
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
          Obx(
            () => ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: PageView.builder(
                controller: PageController(),
                itemCount: controller.bannerImages.length,
                onPageChanged: controller.onBannerPageChanged,
                itemBuilder: (context, index) {
                  final imagePath = controller.bannerImages[index];
                  final isNetwork = imagePath.startsWith('http');
                  return Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child:
                          isNetwork
                              ? Image.network(
                                imagePath,
                                fit: BoxFit.fill,
                                width: double.infinity,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.white,
                                    child: const Icon(
                                      Icons.image_not_supported_outlined,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                  );
                                },
                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          progress.expectedTotalBytes != null
                                              ? progress.cumulativeBytesLoaded /
                                                  progress.expectedTotalBytes!
                                              : null,
                                      color: const Color(0xFF1B834F),
                                      strokeWidth: 2,
                                    ),
                                  );
                                },
                              )
                              : Image.asset(
                                imagePath,
                                fit: BoxFit.fill,
                                width: double.infinity,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.white,
                                    child: const Icon(
                                      Icons.landscape,
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
    final HomeController controller = Get.find<HomeController>();

    return Obx(() {
      final categories = controller.categories;

      if (categories.isEmpty) {
        return const SizedBox.shrink();
      }

      return SizedBox(
        height: 120,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final cat = categories[index];
            final langCode = Get.locale?.languageCode ?? 'en';
            String label = '';
            if (langCode == 'ar') {
              label =
                  cat['category_name_ar'] ??
                  cat['name_ar'] ??
                  cat['name'] ??
                  cat['category_name'] ??
                  '';
            } else if (langCode == 'fr') {
              label =
                  cat['category_name_fr'] ??
                  cat['name_fr'] ??
                  cat['name'] ??
                  cat['category_name'] ??
                  '';
            } else {
              label =
                  cat['category_name_en'] ??
                  cat['name_en'] ??
                  cat['name'] ??
                  cat['category_name'] ??
                  '';
            }
            final imageUrl = cat['category_image'] ?? cat['image'] ?? '';
            final isNetwork = imageUrl.startsWith('http');

            return GestureDetector(
              onTap: () {
                productController.setSearchQuery(label);
                Get.to(() => const SearchScreen());
              },
              child: Container(
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
                        child:
                            isNetwork
                                ? Image.network(
                                  imageUrl,
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) =>
                                          _buildCategoryPlaceholder(label),
                                  loadingBuilder: (context, child, progress) {
                                    if (progress == null) return child;
                                    return const Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Color(0xFF1B834F),
                                      ),
                                    );
                                  },
                                )
                                : Image.asset(
                                  imageUrl,
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) =>
                                          _buildCategoryPlaceholder(label),
                                ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      label,
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
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildCategoryPlaceholder(String label) {
    return Container(
      color: Colors.grey.shade100,
      child: Icon(
        _getCategoryIcon(label),
        color: const Color(0xFF1B834F),
        size: 32,
      ),
    );
  }

  Widget _buildRecentlyAddedSection(AppLocalizations l10n) {
    final HomeController controller = Get.find<HomeController>();

    return Obx(() {
      final recent = controller.recentlyAddedProducts;

      if (recent.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              l10n.noProductsFound,
              style: TextStyle(color: Colors.grey.shade400),
            ),
          ),
        );
      }

      return SizedBox(
        height: 230,
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels >=
                scrollInfo.metrics.maxScrollExtent * 0.8) {
              if (controller.hasMoreRecent.value &&
                  !controller.isLoadingMoreRecent.value) {
                controller.fetchRecent(loadMore: true);
              }
            }
            return false;
          },
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: recent.length + (controller.hasMoreRecent.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == recent.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFF1B834F),
                      ),
                    ),
                  ),
                );
              }
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: ProductCard(product: recent[index], isHorizontal: true),
              );
            },
          ),
        ),
      );
    });
  }

  Widget _buildRecommendationsSection(
    AppLocalizations l10n,
    ProductController productController,
  ) {
    final HomeController controller = Get.find<HomeController>();

    return Obx(() {
      final products = controller.recommendedProducts;

      if (products.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              l10n.noRecommendationsFound,
              style: TextStyle(color: Colors.grey.shade400),
            ),
          ),
        );
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            GridView.builder(
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
            if (controller.hasMoreRecommended.value)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Center(
                  child:
                      controller.isLoadingMoreRecommended.value
                          ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFF1B834F),
                            ),
                          )
                          : TextButton(
                            onPressed:
                                () =>
                                    controller.fetchRecommended(loadMore: true),
                            child: Text(
                              'Load More',
                              style: TextStyle(
                                color: const Color(0xFF1B834F),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildAllProductsSection(AppLocalizations l10n) {
    final HomeController controller = Get.find<HomeController>();

    return Obx(() {
      final products = controller.allProducts;

      if (products.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              l10n.noProductsFound,
              style: TextStyle(color: Colors.grey.shade400),
            ),
          ),
        );
      }

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
    });
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
