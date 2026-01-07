import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'edit_item_screen.dart';
import '../../models/product.dart';
import '../../widgets/product_card.dart';

class MyAdsScreen extends StatefulWidget {
  const MyAdsScreen({super.key});

  @override
  State<MyAdsScreen> createState() => _MyAdsScreenState();
}

class _MyAdsScreenState extends State<MyAdsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'My Ads',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
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
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF1B834F),
          unselectedLabelColor: Colors.black,
          indicatorColor: const Color(0xFF1B834F),
          indicatorWeight: 3,
          indicatorSize: TabBarIndicatorSize.tab,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          padding: EdgeInsets.zero,
          labelPadding: const EdgeInsets.symmetric(horizontal: 16),
          tabs: const [
            Tab(text: 'Active ads'),
            Tab(text: 'Sold'),
            Tab(text: 'Rejected'),
            Tab(text: 'Deactivated'),
            Tab(text: 'Expired'),
          ],
        ),
      ),
      body: Container(
        color: Colors.white,
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildAdsGrid(status: 'Active'),
            _buildAdsGrid(status: 'Sold'),
            _buildAdsGrid(status: 'Rejected'),
            _buildAdsGrid(status: 'Deactivated'),
            _buildAdsGrid(status: 'Expired'),
          ],
        ),
      ),
    );
  }

  Widget _buildAdsGrid({required String status}) {
    // Exact realistic data matching provided assets
    final List<Product> ads = [
      Product(
        id: '1',
        name: 'Millet',
        imagePath: "lib/assets/images/product's/millet.png",
        pricePerKg: 100,
        availableQuantityKg: 1000,
        location: 'Nouakchott',
        category: 'Grains',
        daysAgo: 1,
      ),
      Product(
        id: '2',
        name: 'Tomato',
        imagePath: "lib/assets/images/product's/tomato.png",
        pricePerKg: 90,
        availableQuantityKg: 600,
        location: 'Nouakchott',
        category: 'Vegetables',
        daysAgo: 2,
      ),
      Product(
        id: '3',
        name: 'Sorghum',
        imagePath: "lib/assets/images/product's/sorghum.png",
        pricePerKg: 110,
        availableQuantityKg: 1200,
        location: 'Rosso',
        category: 'Grains',
        daysAgo: 3,
      ),
      Product(
        id: '4',
        name: 'Millet',
        imagePath: "lib/assets/images/product's/millet.png",
        pricePerKg: 100,
        availableQuantityKg: 800,
        location: 'Nouakchott',
        category: 'Grains',
        daysAgo: 1,
      ),
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: status == 'Expired' ? 0.60 : 0.68,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: ads.length,
      itemBuilder: (context, index) {
        return _buildAdItem(product: ads[index], status: status);
      },
    );
  }

  Widget _buildAdItem({required Product product, required String status}) {
    if (status == 'Expired') {
      return Column(
        children: [
          Expanded(
            child: ProductCard(
              product: product,
              showStatus: true,
              status: status,
              showWishlist: false,
              isGrayscale: true,
              topTrailing: _buildPopupMenu(),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 38,
            child: OutlinedButton(
              onPressed: () => Get.to(() => const EditItemScreen()),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF1B834F), width: 1.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Repost',
                style: TextStyle(
                  color: Color(0xFF1B834F),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      );
    }

    final bool isSold = status == 'Sold';
    final bool isDeactivated = status == 'Deactivated';

    return ProductCard(
      product: product,
      showStatus: true,
      status: status,
      showWishlist: false,
      isGrayscale: isSold || isDeactivated,
      isHaze: isDeactivated,
      topTrailing: _buildPopupMenu(),
      onTap: () => Get.toNamed('/adDetailsSeller'),
    );
  }

  Widget _buildPopupMenu() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: PopupMenuButton<String>(
        padding: EdgeInsets.zero,
        icon: const Icon(Icons.more_vert, size: 20, color: Colors.black),
        onSelected: (value) {},
        itemBuilder:
            (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, size: 20, color: Colors.black),
                    SizedBox(width: 8),
                    Text('Edit'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'sold',
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 20,
                      color: Color(0xFF1B834F),
                    ),
                    SizedBox(width: 8),
                    Text('Mark as Sold'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'deactivate',
                child: Row(
                  children: [
                    Icon(Icons.pause_circle, size: 20, color: Colors.orange),
                    SizedBox(width: 8),
                    Text('Deactivate'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, size: 20, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Delete'),
                  ],
                ),
              ),
            ],
      ),
    );
  }
}
