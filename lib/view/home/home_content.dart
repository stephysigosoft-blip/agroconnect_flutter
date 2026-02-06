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
    final l10n = AppLocalizations.of(context);

    if (l10n == null) {
      return const Scaffold(backgroundColor: Colors.white);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          l10n.saimpexAgro,
          style: const TextStyle(
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
              productController.selectedCategoryId.value = '';
              productController.currentCategoryName.value = '';
              productController.setSearchQuery('');
              productController.fetchAllProductsApi();
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
                const SizedBox(height: 12),
                _buildPromotionalBanner(l10n, controller),
                const SizedBox(height: 24),
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
                Obx(() {
                  if (controller.allProducts.isEmpty &&
                      !controller.isFetchingHome.value) {
                    return const SizedBox.shrink();
                  }
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
      child: Stack(
        children: [
          Obx(
            () => ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: PageView.builder(
                controller: controller.bannerPageController,
                itemCount: controller.bannerImages.length,
                onPageChanged: controller.onBannerPageChanged,
                itemBuilder: (context, index) {
                  final imagePath = controller.bannerImages[index];
                  final isNetwork = imagePath.startsWith('http');
                  return isNetwork
                      ? Image.network(
                        imagePath,
                        fit: BoxFit.fill,
                        width: double.infinity,
                        height: 180,
                        errorBuilder:
                            (context, error, stackTrace) => Container(
                              color: Colors.white,
                              child: const Icon(
                                Icons.image_not_supported_outlined,
                                size: 50,
                                color: Colors.grey,
                              ),
                            ),
                      )
                      : Image.asset(
                        imagePath,
                        fit: BoxFit.fill,
                        width: double.infinity,
                        height: 180,
                      );
                },
              ),
            ),
          ),
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
      if (categories.isEmpty) return const SizedBox.shrink();

      return SizedBox(
        height: 120,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final dynamic catRaw = categories[index];
            if (catRaw == null || catRaw is! Map)
              return const SizedBox.shrink();
            final Map<String, dynamic> cat = Map<String, dynamic>.from(catRaw);
            final langCode = Get.locale?.languageCode ?? 'en';
            String label = '';
            if (langCode == 'ar') {
              label =
                  cat['category_name_ar']?.toString() ??
                  cat['name_ar']?.toString() ??
                  cat['name']?.toString() ??
                  '';
            } else if (langCode == 'fr') {
              label =
                  cat['category_name_fr']?.toString() ??
                  cat['name_fr']?.toString() ??
                  cat['name']?.toString() ??
                  '';
            } else {
              label =
                  cat['category_name_en']?.toString() ??
                  cat['name_en']?.toString() ??
                  cat['name']?.toString() ??
                  '';
            }
            final imageUrl =
                (cat['category_image'] ?? cat['image'] ?? '').toString();
            final isNetwork = imageUrl.startsWith('http');
            final catId = cat['id'];

            return GestureDetector(
              onTap: () {
                if (catId != null) {
                  productController.selectedCategoryId.value = catId.toString();
                  productController.currentCategoryName.value = label;
                  productController.setSearchQuery('');
                  productController.fetchAllProductsApi();
                }
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
      child: Icon(Icons.category, color: const Color(0xFF1B834F), size: 32),
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
}
