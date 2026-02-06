import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:dio/dio.dart' as dio;
import '../models/product.dart';
import '../services/api_service.dart';

class ProductController extends GetxController {
  /// Categories (4)
  final List<String> categories = const [
    'Grains & Cereals',
    'Vegetables',
    'Livestock & Meat',
    'Poultry & Eggs',
  ];

  final RxList<Product> allProducts = <Product>[].obs;

  final RxInt currentPage = 1.obs;
  final RxBool hasMore = true.obs;
  final RxBool isLoadingMore = false.obs;

  final RxBool isFetchingAll = false.obs;
  final RxBool isFetchingDetails = false.obs;
  final RxBool isFetchingSellerAds = false.obs;
  final Rx<Product?> currentProductDetails = Rx<Product?>(null);
  final RxList<Product> sellerAds = <Product>[].obs;
  final RxString currentSellerId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllProductsApi();
  }

  final RxString selectedCategoryId = ''.obs;
  final RxString currentCategoryName = ''.obs;

  Future<void> fetchAllProductsApi({bool loadMore = false}) async {
    try {
      if (loadMore) {
        if (isLoadingMore.value || !hasMore.value) return;
        isLoadingMore.value = true;
      } else {
        isFetchingAll.value = true;
        currentPage.value = 1;
        hasMore.value = true;
      }
      final apiService = Get.find<ApiService>();
      final Map<String, dynamic> params = {
        'page': currentPage.value,
        'limit': selectedCategoryId.value.isNotEmpty ? 100 : 20,
      };

      if (selectedCategoryId.value.isNotEmpty) {
        params['category_id'] = selectedCategoryId.value;
        params['categories_id'] = selectedCategoryId.value;
        params['cat_id'] = selectedCategoryId.value;
        params['category'] = selectedCategoryId.value;
      }

      var response = await apiService.getAllProducts(queryParameters: params);

      // If category-specific fetch returns nothing, try fetching global list as a fallback
      if (!loadMore &&
          selectedCategoryId.value.isNotEmpty &&
          (response == null ||
              response['status'] == false ||
              _extractDataList(response['data']).isEmpty)) {
        print(
          '⚠️ [ProductController] Category-specific fetch empty, trying global list fallback...',
        );
        params.remove('category_id');
        params.remove('categories_id');
        params.remove('cat_id');
        params.remove('category');
        params['limit'] = 100; // Large batch for local filtering
        response = await apiService.getAllProducts(queryParameters: params);
      }

      if (response != null && response['status'] == true) {
        final List data = _extractDataList(response['data']);
        final newProducts = data.map((json) => Product.fromJson(json)).toList();

        if (loadMore) {
          allProducts.addAll(newProducts);
        } else {
          allProducts.value = newProducts;
        }

        hasMore.value = newProducts.length >= 20;
        if (newProducts.isNotEmpty) {
          currentPage.value++;
        }
      }
    } finally {
      isFetchingAll.value = false;
      isLoadingMore.value = false;
    }
  }

  List _extractDataList(dynamic rawData) {
    if (rawData == null) return [];
    if (rawData is List) return rawData;
    if (rawData is Map) {
      if (rawData.containsKey('data') && rawData['data'] is List) {
        return rawData['data'];
      }
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

  Future<void> fetchProductDetails(dynamic id) async {
    try {
      print('🚀 [ProductController] Fetching details for ID: $id');
      isFetchingDetails.value = true;
      // Only clear if we are fetching a DIFFERENT product to avoid flicker during refresh
      if (currentProductDetails.value?.id.toString() != id.toString()) {
        currentProductDetails.value = null;
      }

      final apiService = Get.find<ApiService>();
      // Use getAdDetails instead of getProductDetails for ads
      final response = await apiService.getAdDetails(id);

      if (response != null && response['status'] == true) {
        final dynamic rawData = response['data'];
        if (rawData is! Map) {
          print(
            '❌ [ProductController] Expected Map in data, got: ${rawData.runtimeType}',
          );
          return;
        }

        final Map<String, dynamic> data = Map<String, dynamic>.from(rawData);
        print('✅ [ProductController] Data received for ID: $id');

        if (data.containsKey('ad') && data['ad'] != null) {
          print('📦 [ProductController] Parsing main ad...');
          currentProductDetails.value = Product.fromJson(
            Map<String, dynamic>.from(data['ad']),
          );
        } else if (data.containsKey('product') && data['product'] != null) {
          print('📦 [ProductController] Parsing main product...');
          currentProductDetails.value = Product.fromJson(
            Map<String, dynamic>.from(data['product']),
          );
        } else {
          print('📦 [ProductController] Parsing data as product directly...');
          currentProductDetails.value = Product.fromJson(data);
        }
      } else {
        print(
          '❌ [ProductController] getAdDetails failed. Trying fallback getProductDetails...',
        );
        final fallbackResponse = await apiService.getProductDetails(id);
        if (fallbackResponse != null && fallbackResponse['status'] == true) {
          final fallbackData = fallbackResponse['data'];
          if (fallbackData is Map) {
            final Map<String, dynamic> fData = Map<String, dynamic>.from(
              fallbackData,
            );
            if (fData.containsKey('product') && fData['product'] != null) {
              currentProductDetails.value = Product.fromJson(
                Map<String, dynamic>.from(fData['product']),
              );
            } else {
              currentProductDetails.value = Product.fromJson(fData);
            }
            print('✅ [ProductController] Fallback parsed successfully');
          }
        } else {
          print(
            '❌ [ProductController] Both getAdDetails and fallback failed. Response: $response',
          );
        }
      }
    } catch (e, stack) {
      print('❌ [ProductController] Error in fetchProductDetails: $e');
      print(stack);
    } finally {
      isFetchingDetails.value = false;
    }
  }

  Future<void> fetchSellerAds(String sellerId) async {
    try {
      if (sellerId.isEmpty) return;
      if (currentSellerId.value == sellerId && sellerAds.isNotEmpty) return;

      print('🚀 [ProductController] Fetching ads for seller: $sellerId');
      isFetchingSellerAds.value = true;
      currentSellerId.value = sellerId;
      sellerAds.clear();

      final apiService = Get.find<ApiService>();
      final response = await apiService.getAllProducts(
        queryParameters: {'seller_id': sellerId, 'limit': 100},
      );

      if (response != null && response['status'] == true) {
        final List data = _extractDataList(response['data']);
        final products = data.map((json) => Product.fromJson(json)).toList();
        sellerAds.assignAll(products);

        // Also add unique products to allProducts to keep the main list updated
        for (var p in products) {
          if (!allProducts.any((existing) => existing.id == p.id)) {
            allProducts.add(p);
          }
        }
        print(
          '✅ [ProductController] Loaded ${products.length} ads for seller $sellerId',
        );
      }
    } catch (e) {
      print('❌ [ProductController] Error fetching seller ads: $e');
    } finally {
      isFetchingSellerAds.value = false;
    }
  }

  /// Search & filters state
  final RxString searchQuery = ''.obs;
  final Rx<RangeValues> priceRange = const RangeValues(0, 1000000).obs;
  final RxInt selectedQuantityIndex = 0.obs;
  final RxInt selectedSortIndex = 0.obs;

  /// Quantity ranges used for filtering
  final List<RangeValues> quantityRanges = const [
    RangeValues(0, 5000), // Any quantity
    RangeValues(50, 100),
    RangeValues(100, 500),
    RangeValues(500, 1000),
  ];

  /// Computed filtered list
  List<Product> get filteredProducts {
    final query = searchQuery.value.toLowerCase().trim();
    final price = priceRange.value;
    final quantityRange = quantityRanges[selectedQuantityIndex.value];

    List<Product> products =
        allProducts.where((p) {
          String pCategory = p.category;
          final int? catId = p.categoryId;
          if (catId != null) {
            // Simple mapping based on known IDs if the server doesn't provide names
            final int idInt = catId;
            if (pCategory == 'Category' ||
                pCategory == 'General' ||
                pCategory == 'Unknown') {
              pCategory = 'Category $idInt';
            }
          }

          final matchesCategory =
              selectedCategoryId.value.isEmpty ||
              p.categoryId.toString() == selectedCategoryId.value ||
              (currentCategoryName.value.isNotEmpty &&
                  (pCategory.toLowerCase().contains(
                        currentCategoryName.value.toLowerCase(),
                      ) ||
                      currentCategoryName.value.toLowerCase().contains(
                        pCategory.toLowerCase(),
                      ) ||
                      p.name.toLowerCase().contains(
                        currentCategoryName.value.toLowerCase(),
                      )));

          final matchesQuery =
              query.isEmpty ||
              p.name.toLowerCase().contains(query) ||
              pCategory.toLowerCase().contains(query) ||
              p.location.toLowerCase().contains(query);

          final matchesPrice =
              p.pricePerKg >= price.start && p.pricePerKg <= price.end;

          final matchesQuantity =
              p.availableQuantityKg >= quantityRange.start &&
              p.availableQuantityKg <= quantityRange.end;

          return matchesCategory &&
              matchesQuery &&
              matchesPrice &&
              matchesQuantity;
        }).toList();

    // Sort
    switch (selectedSortIndex.value) {
      case 1: // Recently posted (lower daysAgo first)
        products.sort((a, b) => a.daysAgo.compareTo(b.daysAgo));
        break;
      case 2: // Newest first (same as above)
        products.sort((a, b) => a.daysAgo.compareTo(b.daysAgo));
        break;
      default:
        break;
    }

    return products;
  }

  // Actions
  void setSearchQuery(String value) {
    searchQuery.value = value;
  }

  void setPriceRange(RangeValues values) {
    priceRange.value = values;
  }

  void setQuantityIndex(int index) {
    selectedQuantityIndex.value = index;
  }

  void setSortIndex(int index) {
    selectedSortIndex.value = index;
  }

  void resetFilters() {
    priceRange.value = const RangeValues(0, 1000000);
    selectedQuantityIndex.value = 0;
    selectedSortIndex.value = 0;
  }

  Future<bool> reportAd({
    required String productId,
    required String reason,
    String? comment,
  }) async {
    try {
      final apiService = Get.find<ApiService>();
      final formData = dio.FormData.fromMap({
        'product_id': productId,
        'reason': reason,
        'comment': comment ?? '',
      });

      final response = await apiService.reportAd(formData);
      return response != null && response['status'] == true;
    } catch (e) {
      return false;
    }
  }
}
