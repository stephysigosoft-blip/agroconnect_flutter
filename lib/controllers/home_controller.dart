import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../utils/api_constants.dart';

class HomeController extends GetxController {
  /// Bottom navigation current index
  final RxInt currentIndex = 0.obs;

  /// Navigation controller for PersistentTabView
  final PersistentTabController tabController = PersistentTabController(
    initialIndex: 0,
  );

  final RxList<Product> allProducts = <Product>[].obs;
  final RxList<Product> recommendedProducts = <Product>[].obs;
  final RxList<Product> recentlyAddedProducts = <Product>[].obs;
  final RxList<dynamic> categories = <dynamic>[].obs;
  final RxList<String> bannerImages = <String>[].obs;

  final RxBool isFetchingAll = false.obs;
  final RxBool isFetchingRecommended = false.obs;
  final RxBool isFetchingRecent = false.obs;
  final RxBool isFetchingHome = false.obs;

  // Pagination state for recommended and recent products
  final RxInt recommendedPage = 1.obs;
  final RxInt recentPage = 1.obs;
  final RxBool hasMoreRecommended = true.obs;
  final RxBool hasMoreRecent = true.obs;
  final RxBool isLoadingMoreRecommended = false.obs;
  final RxBool isLoadingMoreRecent = false.obs;

  /// Promotional banner current page index
  final RxInt currentBannerIndex = 0.obs;

  void onBottomNavChanged(int index) {
    currentIndex.value = index;
  }

  String _normalizeUrl(String url) {
    if (url.contains('localhost')) {
      return url.replaceFirst(
        RegExp(r'https?://localhost/storage/'),
        ApiConstants.imageBaseUrl,
      );
    }
    return url;
  }

  void onBannerPageChanged(int index) {
    currentBannerIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    // Initialize with default banners for immediate display
    bannerImages.assignAll([
      'lib/assets/images/about farmer iamge.png',
      'lib/assets/images/about farmer iamge.png',
    ]);
    fetchHomeData();
  }

  Future<void> fetchHomeData() async {
    print('🏁 [HomeController] Starting Home Data Recollection (4 APIs)...');
    isFetchingHome.value = true;

    // Call all 4 APIs individually and concurrently
    await Future.wait([
      fetchBannersAndCategories(),
      fetchRecommended(),
      fetchRecent(),
      fetchAllProducts(),
    ]);

    isFetchingHome.value = false;
    print('🏁 [HomeController] Home Data Recollection Complete.');
  }

  Future<void> fetchBannersAndCategories() async {
    try {
      final apiService = Get.find<ApiService>();
      print('🔄 [HomeController] Calling getHome API...');
      final response = await apiService.getHome();

      if (response != null && response['status'] == true) {
        final data = response['data'] ?? {};

        // Parse Sliders
        if (data['sliders'] is List) {
          final List sliders = data['sliders'];
          bannerImages.assignAll(
            sliders.map((s) {
              final img = s['image'].toString();
              return img.startsWith('http')
                  ? _normalizeUrl(img)
                  : '${ApiConstants.imageBaseUrl}$img';
            }).toList(),
          );
        }

        // Parse Categories
        if (data['categories'] is List) {
          final List rawCats = data['categories'];
          categories.assignAll(
            rawCats.map((c) {
              final img = (c['category_image'] ?? c['image'] ?? '').toString();
              if (img.isNotEmpty) {
                if (!img.startsWith('http')) {
                  c['category_image'] = '${ApiConstants.imageBaseUrl}$img';
                } else {
                  c['category_image'] = _normalizeUrl(img);
                }
              }
              return c;
            }).toList(),
          );
        }

        // Initial Recollection from getHome (as backup/fast-load)
        if (data['recommended_products'] is List) {
          final List recList = data['recommended_products'];
          recommendedProducts.assignAll(
            recList.map((j) => Product.fromJson(j)).toList(),
          );
        }
        if (data['recent_added_products'] is List) {
          final List recentList = data['recent_added_products'];
          recentlyAddedProducts.assignAll(
            recentList.map((j) => Product.fromJson(j)).toList(),
          );
        }

        print(
          '✅ [HomeController] getHome Response: Loaded ${bannerImages.length} banners and ${categories.length} categories',
        );
      } else {
        print('⚠️ [HomeController] getHome Response: Status False or Null');
      }
    } catch (e) {
      print('❌ [HomeController] getHome API Error: $e');
    } finally {
      // Fallback if empty
      if (bannerImages.isEmpty) {
        bannerImages.assignAll([
          'lib/assets/images/about farmer iamge.png',
          'lib/assets/images/about farmer iamge.png',
        ]);
      }
    }
  }

  Future<void> fetchRecommended({bool loadMore = false}) async {
    try {
      if (loadMore) {
        if (isLoadingMoreRecommended.value || !hasMoreRecommended.value) return;
        isLoadingMoreRecommended.value = true;
      } else {
        isFetchingRecommended.value = true;
        recommendedPage.value = 1;
        hasMoreRecommended.value = true;
      }

      final apiService = Get.find<ApiService>();
      print(
        '🔵 [HomeController] CALLING Recommended Products API (Page ${recommendedPage.value})...',
      );
      final response = await apiService.getRecommendedProducts(
        page: recommendedPage.value,
      );

      if (response != null) {
        print(
          '✅ [HomeController] RESPONSE Recommended Products: Status=${response['status']}',
        );
        if (response['status'] == true) {
          final List data = _extractDataList(response['data']);
          final newProducts =
              data.map((json) => Product.fromJson(json)).toList();

          if (loadMore) {
            recommendedProducts.addAll(newProducts);
          } else {
            recommendedProducts.value = newProducts;
          }

          // Check if there are more products
          hasMoreRecommended.value = newProducts.length >= 20;
          if (newProducts.isNotEmpty) {
            recommendedPage.value++;
          }

          print(
            '📦 [HomeController] PROCESSED: ${newProducts.length} recommended products ${loadMore ? "added" : "loaded"}. Total: ${recommendedProducts.length}',
          );
        }
      }
    } catch (e) {
      print('❌ [HomeController] Recommended Products ERROR: $e');
    } finally {
      isFetchingRecommended.value = false;
      isLoadingMoreRecommended.value = false;
    }
  }

  Future<void> fetchRecent({bool loadMore = false}) async {
    try {
      if (loadMore) {
        if (isLoadingMoreRecent.value || !hasMoreRecent.value) return;
        isLoadingMoreRecent.value = true;
      } else {
        isFetchingRecent.value = true;
        recentPage.value = 1;
        hasMoreRecent.value = true;
      }

      final apiService = Get.find<ApiService>();
      print(
        '🔵 [HomeController] CALLING Recently Added Products API (Page ${recentPage.value})...',
      );
      final response = await apiService.getRecentlyAddedProducts(
        page: recentPage.value,
      );

      if (response != null) {
        print(
          '✅ [HomeController] RESPONSE Recently Added: Status=${response['status']}',
        );
        if (response['status'] == true) {
          final List data = _extractDataList(response['data']);
          final newProducts =
              data.map((json) => Product.fromJson(json)).toList();

          if (loadMore) {
            recentlyAddedProducts.addAll(newProducts);
          } else {
            recentlyAddedProducts.value = newProducts;
          }

          // Check if there are more products
          hasMoreRecent.value = newProducts.length >= 20;
          if (newProducts.isNotEmpty) {
            recentPage.value++;
          }

          print(
            '📦 [HomeController] PROCESSED: ${newProducts.length} recent products ${loadMore ? "added" : "loaded"}. Total: ${recentlyAddedProducts.length}',
          );
        }
      }
    } catch (e) {
      print('❌ [HomeController] Recently Added ERROR: $e');
    } finally {
      isFetchingRecent.value = false;
      isLoadingMoreRecent.value = false;
    }
  }

  // Pagination State for All Products
  final RxInt allProductsPage = 1.obs;
  final RxBool hasMoreAllProducts = true.obs;
  final RxBool isLoadingMoreAll = false.obs;

  Future<void> fetchAllProducts({bool loadMore = false}) async {
    try {
      if (loadMore) {
        if (isLoadingMoreAll.value || !hasMoreAllProducts.value) return;
        isLoadingMoreAll.value = true;
      } else {
        isFetchingAll.value = true;
        allProductsPage.value = 1;
        hasMoreAllProducts.value = true;
      }

      final apiService = Get.find<ApiService>();
      print(
        '🔵 [HomeController] CALLING All Products API (Page: ${allProductsPage.value})...',
      );
      final response = await apiService.getAllProducts(
        queryParameters: {'page': allProductsPage.value, 'limit': 10},
      );

      if (response != null) {
        print(
          '✅ [HomeController] RESPONSE All Products: Status=${response['status']}',
        );
        if (response['status'] == true) {
          final List data = _extractDataList(response['data']);
          final List<Product> products =
              data.map((json) => Product.fromJson(json)).toList();

          if (loadMore) {
            allProducts.addAll(products);
          } else {
            allProducts.assignAll(products);
          }

          if (products.length < 10) {
            hasMoreAllProducts.value = false;
            print('🏁 [HomeController] No more products to load.');
          } else {
            allProductsPage.value++;
          }

          print(
            '📦 [HomeController] PROCESSED: ${products.length} products (Total: ${allProducts.length}).',
          );
        }
      }
    } catch (e) {
      print('❌ [HomeController] All Products ERROR: $e');
    } finally {
      if (loadMore) {
        isLoadingMoreAll.value = false;
      } else {
        isFetchingAll.value = false;
      }
    }
  }

  List _extractDataList(dynamic rawData) {
    if (rawData == null) return [];
    if (rawData is List) return rawData;
    if (rawData is Map) {
      // Case 1: Standard Laravel pagination {data: [...]}
      if (rawData.containsKey('data') && rawData['data'] is List) {
        return rawData['data'];
      }
      // Case 2: Nested pagination or other Map-wrapped list
      for (var value in rawData.values) {
        if (value is Map &&
            value.containsKey('data') &&
            value['data'] is List) {
          return value['data'];
        }
        if (value is List) return value;
      }
    }
    return [];
  }

  void jumpToTab(int index) {
    tabController.jumpToTab(index);
    onBottomNavChanged(index);
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
