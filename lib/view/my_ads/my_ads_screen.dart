import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'edit_item_screen.dart';
import '../../models/product.dart';
import '../../widgets/product_card.dart';
import '../../controllers/my_ads_controller.dart';
import 'package:agroconnect_flutter/l10n/app_localizations.dart';

class MyAdsScreen extends StatefulWidget {
  const MyAdsScreen({super.key});

  @override
  State<MyAdsScreen> createState() => _MyAdsScreenState();
}

class _MyAdsScreenState extends State<MyAdsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final MyAdsController _myAdsController = Get.put(MyAdsController());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        final tabs = [
          'Active ads',
          'Sold',
          'Rejected',
          'Deactivated',
          'Expired',
        ];
        debugPrint(
          '📂 [MyAdsScreen] Tab selected: ${tabs[_tabController.index]}',
        );
      }
    });
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
        title: Text(
          AppLocalizations.of(context)!.myAds,
          style: const TextStyle(
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
          tabs: [
            Tab(text: AppLocalizations.of(context)!.activeAds),
            Tab(text: AppLocalizations.of(context)!.sold),
            Tab(text: AppLocalizations.of(context)!.rejected),
            Tab(text: AppLocalizations.of(context)!.deactivated),
            Tab(text: AppLocalizations.of(context)!.expired),
          ],
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Obx(() {
          if (_myAdsController.isLoading.value &&
              _myAdsController.activeAds.isEmpty &&
              _myAdsController.soldAds.isEmpty &&
              _myAdsController.rejectedAds.isEmpty &&
              _myAdsController.deactivatedAds.isEmpty &&
              _myAdsController.expiredAds.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          return TabBarView(
            controller: _tabController,
            children: [
              _buildAdsGrid(
                status: 'Active',
                ads: _myAdsController.activeAds,
                type: 1,
              ),
              _buildAdsGrid(
                status: 'Sold',
                ads: _myAdsController.soldAds,
                type: 2,
              ),
              _buildAdsGrid(
                status: 'Rejected',
                ads: _myAdsController.rejectedAds,
                type: 3,
              ),
              _buildAdsGrid(
                status: 'Deactivated',
                ads: _myAdsController.deactivatedAds,
                type: 0,
              ),
              _buildAdsGrid(
                status: 'Expired',
                ads: _myAdsController.expiredAds,
                type: 4,
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildAdsGrid({
    required String status,
    required List<Product> ads,
    required int type,
  }) {
    if (ads.isEmpty) {
      return Center(
        child: Text(
          AppLocalizations.of(context)!.noAdsFound(
            status.toLowerCase() == 'active'
                ? AppLocalizations.of(context)!.active
                : status.toLowerCase() == 'sold'
                ? AppLocalizations.of(context)!.sold
                : status.toLowerCase() == 'rejected'
                ? AppLocalizations.of(context)!.rejected
                : status.toLowerCase() == 'deactivated'
                ? AppLocalizations.of(context)!.deactivated
                : status.toLowerCase() == 'expired'
                ? AppLocalizations.of(context)!.expired
                : status,
          ),
          style: const TextStyle(color: Colors.grey),
        ),
      );
    }

    return Obx(() {
      final isLoadingMore = _myAdsController.isLoadingMore[type] ?? false;
      final hasMore = _myAdsController.hasMore[type] ?? false;

      return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels >=
              scrollInfo.metrics.maxScrollExtent * 0.8) {
            if (hasMore && !isLoadingMore) {
              _myAdsController.fetchAdsByType(type, loadMore: true);
            }
          }
          return false;
        },
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: status == 'Expired' ? 0.60 : 0.68,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: ads.length + (isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == ads.length) {
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
            return _buildAdItem(product: ads[index], status: status);
          },
        ),
      );
    });
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
              topTrailing: _buildPopupMenu(product),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 38,
            child: OutlinedButton(
              onPressed: () => Get.to(() => EditItemScreen(product: product)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF1B834F), width: 1.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                AppLocalizations.of(context)!.repost,
                style: const TextStyle(
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
      topTrailing: _buildPopupMenu(product),
      onTap: () => Get.toNamed('/adDetailsSeller', arguments: product),
    );
  }

  Widget _buildPopupMenu(Product product) {
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
        onSelected: (value) {
          debugPrint(
            '🎯 [MyAdsScreen] Option selected: $value for ID: ${product.id}',
          );
          if (value == 'sold') {
            _myAdsController.markAsSold(product.id);
          } else if (value == 'deactivate') {
            _myAdsController.deactivateAd(product.id);
          } else if (value == 'delete') {
            _myAdsController.deleteAd(product.id);
          } else if (value == 'edit') {
            Get.to(() => EditItemScreen(product: product));
          }
        },
        itemBuilder:
            (context) => [
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    const Icon(Icons.edit, size: 20, color: Colors.black),
                    const SizedBox(width: 8),
                    Text(AppLocalizations.of(context)!.edit),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'sold',
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 20,
                      color: const Color(0xFF1B834F),
                    ),
                    const SizedBox(width: 8),
                    Text(AppLocalizations.of(context)!.markAsSold),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'deactivate',
                child: Row(
                  children: [
                    const Icon(
                      Icons.pause_circle,
                      size: 20,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 8),
                    Text(AppLocalizations.of(context)!.deactivate),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    const Icon(Icons.delete, size: 20, color: Colors.red),
                    const SizedBox(width: 8),
                    Text(AppLocalizations.of(context)!.delete),
                  ],
                ),
              ),
            ],
      ),
    );
  }
}
