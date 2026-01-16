import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/product.dart';
import '../../controllers/product_controller.dart';
import '../../l10n/app_localizations.dart';

class SellerProfileScreen extends StatelessWidget {
  const SellerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Retrieve product from arguments
    // Retrieve product from arguments
    final Product? productArg = Get.arguments as Product?;

    final String sellerName =
        (productArg?.sellerName.isNotEmpty ?? false)
            ? productArg!.sellerName
            : "Unknown";
    final String avatarPath =
        (productArg?.sellerImage.isNotEmpty ?? false)
            ? productArg!.sellerImage
            : 'lib/assets/images/farmer image.png';
    final String sellerId = productArg?.sellerId ?? '';

    final ProductController controller = Get.find<ProductController>();

    // Trigger fetch for seller ads
    if (sellerId.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.fetchSellerAds(sellerId);
      });
    }

    return Obx(() {
      // Filter ads by sellerId from the dedicated sellerAds list
      final List<Product> sellerProducts = controller.sellerAds;

      final List<Product> activeAds =
          sellerProducts
              .where((p) => p.status == 'active' && p.availableQuantityKg > 0)
              .toList();
      final List<Product> soldAds =
          sellerProducts.where((p) => p.status == 'sold').toList();

      final int publishedAds = activeAds.length + soldAds.length;

      return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            surfaceTintColor: Colors.white,
            centerTitle: true,
            leading: Center(
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B834F),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.chevron_left,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),
            title: Text(
              l10n.profile,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),
          body: Column(
            children: [
              const SizedBox(height: 16),
              // Profile Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child:
                            avatarPath.startsWith('http')
                                ? Image.network(
                                  avatarPath,
                                  width: 60,
                                  height: 65,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (
                                        context,
                                        error,
                                        stackTrace,
                                      ) => Image.asset(
                                        'lib/assets/images/farmer image.png',
                                        width: 60,
                                        height: 65,
                                        fit: BoxFit.cover,
                                      ),
                                )
                                : Image.asset(
                                  avatarPath,
                                  width: 60,
                                  height: 65,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) => Container(
                                        width: 60,
                                        height: 65,
                                        color: Colors.grey.shade200,
                                        child: const Icon(
                                          Icons.person,
                                          color: Colors.grey,
                                        ),
                                      ),
                                ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              sellerName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              l10n.publishedAds(publishedAds),
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF1B834F),
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (controller.isFetchingSellerAds.value &&
                  sellerProducts.isEmpty)
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(color: Color(0xFF1B834F)),
                  ),
                )
              else ...[
                // Custom TabBar
                TabBar(
                  indicatorColor: Color(0xFF1B834F),
                  indicatorWeight: 3,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.black54,
                  labelStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  tabs: [Tab(text: l10n.activeAds), Tab(text: l10n.sold)],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildProductGrid(context, activeAds),
                      _buildProductGrid(context, soldAds),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    });
  }

  Widget _buildProductGrid(BuildContext context, List<Product> products) {
    if (products.isEmpty) {
      return Center(child: Text(AppLocalizations.of(context)!.noProductsFound));
    }
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 12,
        childAspectRatio: 0.70,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _buildProductCard(product);
      },
    );
  }

  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () => Get.toNamed('/product', arguments: product),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
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
                        height: 130,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) =>
                                _buildErrorPlaceholder(),
                      )
                      : Image.asset(
                        product.imagePath,
                        height: 130,
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
                      fontSize: 17,
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
                      fontSize: 14,
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
                                fontSize: 13,
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
                          fontSize: 13,
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
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      color: Colors.grey.shade100,
      child: const Icon(
        Icons.image_not_supported,
        size: 40,
        color: Colors.grey,
      ),
    );
  }
}
