import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/product.dart';
import '../../controllers/product_controller.dart';

class SellerProfileScreen extends StatelessWidget {
  const SellerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // For demo/static purposes, we'll use sample data or passed arguments
    // In a real app, you might fetch this based on a seller ID
    final String sellerName = "Mohamed Ould Salem";
    final int publishedAds = 10;
    final String avatarPath = 'lib/assets/images/about farmer iamge.png';

    final ProductController controller = Get.find<ProductController>();
    final List<Product> activeAds = controller.allProducts; // Sample data
    final List<Product> soldAds =
        controller.allProducts.take(2).toList(); // Sample data

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
          title: const Text(
            'Profile',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          // bottom: PreferredSize(
          //   preferredSize: const Size.fromHeight(1.0),
          //   child: Container(color: Colors.grey.shade300, height: 1.0),
          // ),
        ),
        body: Column(
          children: [
            const SizedBox(height: 16),
            // Profile Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                // padding: const EdgeInsets.all(12),
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
                      child: Image.asset(
                        avatarPath,
                        width: 60,
                        height: 65,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sellerName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$publishedAds Published Ads',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF1B834F),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Custom TabBar
            const TabBar(
              indicatorColor: Color(0xFF1B834F),
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.black54,
              labelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              tabs: [Tab(text: 'Active Ads'), Tab(text: 'Sold')],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildProductGrid(activeAds),
                  _buildProductGrid(soldAds),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductGrid(List<Product> products) {
    if (products.isEmpty) {
      return const Center(child: Text("No ads found"));
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
              child: Image.asset(
                product.imagePath,
                height: 130,
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
}
