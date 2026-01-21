import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import 'package:dio/dio.dart' as dio;
import 'product_controller.dart';
import '../l10n/app_localizations.dart';

class MyAdsController extends GetxController {
  final RxList<Product> activeAds = <Product>[].obs;
  final RxList<Product> soldAds = <Product>[].obs;
  final RxList<Product> rejectedAds = <Product>[].obs;
  final RxList<Product> deactivatedAds = <Product>[].obs;
  final RxList<Product> expiredAds = <Product>[].obs;

  final RxBool isLoading = false.obs;

  // Pagination State keyed by ad type
  final RxMap<int, int> pages = {0: 1, 1: 1, 2: 1, 3: 1, 4: 1}.obs;
  final RxMap<int, bool> hasMore =
      {0: true, 1: true, 2: true, 3: true, 4: true}.obs;
  final RxMap<int, bool> isLoadingMore =
      {0: false, 1: false, 2: false, 3: false, 4: false}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMyAds();
  }

  Future<void> fetchMyAds() async {
    try {
      isLoading.value = true;

      // Fetch Active (1), Sold (2), Rejected (3), Deactivated (0), and Expired (4) in parallel
      await Future.wait([
        fetchAdsByType(1), // Active
        fetchAdsByType(2), // Sold
        fetchAdsByType(3), // Rejected
        fetchAdsByType(0), // Deactivated
        fetchAdsByType(4), // Expired
      ]);

      print(
        '✅ [MyAdsController] All categories refreshed. Active: ${activeAds.length}, Sold: ${soldAds.length}, Deactivated: ${deactivatedAds.length}',
      );
    } catch (e) {
      print('❌ [MyAdsController] Error fetching My Ads: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchAdsByType(int type, {bool loadMore = false}) async {
    if (loadMore) {
      if (isLoadingMore[type] == true || hasMore[type] == false) return;
      isLoadingMore[type] = true;
    } else {
      // Reset for fresh load if not loading more
      pages[type] = 1;
      hasMore[type] = true;
    }

    final apiService = Get.find<ApiService>();
    print(
      '🔵 [MyAdsController] Fetching Ads for type=$type, page=${pages[type]}...',
    );
    final response = await apiService.getMyAds(type: type, page: pages[type]!);

    try {
      if (response != null && response['status'] == true) {
        var rawData = response['data'];
        if (rawData is Map &&
            rawData.containsKey('ads') &&
            rawData['ads'] is Map) {
          rawData = rawData['ads'];
        }

        final List data = _extractDataList(rawData);
        final List<Product> ads =
            data.map((json) => Product.fromJson(json)).toList();

        print('📋 [MyAdsController] Type $type: Extracted ${ads.length} ads');

        if (loadMore) {
          _appendAds(type, ads);
        } else {
          _assignAds(type, ads);
        }

        // update pagination state
        hasMore[type] = ads.length >= 10; // Assuming limit is 10
        if (ads.isNotEmpty) {
          pages[type] = pages[type]! + 1;
        }
      } else {
        print('⚠️ [MyAdsController] No data or error for type $type');
      }
    } finally {
      if (loadMore) {
        isLoadingMore[type] = false;
      }
    }
  }

  void _assignAds(int type, List<Product> ads) {
    if (type == 1) {
      activeAds.assignAll(ads);
    } else if (type == 2) {
      soldAds.assignAll(ads);
    } else if (type == 3) {
      rejectedAds.assignAll(ads);
    } else if (type == 0) {
      deactivatedAds.assignAll(ads);
    } else if (type == 4) {
      expiredAds.assignAll(ads);
    }
  }

  void _appendAds(int type, List<Product> ads) {
    if (type == 1) {
      activeAds.addAll(ads);
    } else if (type == 2) {
      soldAds.addAll(ads);
    } else if (type == 3) {
      rejectedAds.addAll(ads);
    } else if (type == 0) {
      deactivatedAds.addAll(ads);
    } else if (type == 4) {
      expiredAds.addAll(ads);
    }
  }

  // Public method to manually refresh ads
  Future<void> refreshMyAds() async {
    await fetchMyAds();
  }

  List _extractDataList(dynamic rawData) {
    if (rawData == null) return [];
    if (rawData is List) return rawData;
    if (rawData is Map) {
      if (rawData.containsKey('data') && rawData['data'] is List) {
        return rawData['data'];
      }

      // If the map contains multiple groups (e.g., active_ads, sold_ads),
      // aggregate all of them into a single list.
      List aggregatedList = [];
      for (var value in rawData.values) {
        if (value is Map &&
            value.containsKey('data') &&
            value['data'] is List) {
          aggregatedList.addAll(value['data']);
        } else if (value is List) {
          aggregatedList.addAll(value);
        }
      }
      return aggregatedList;
    }
    return [];
  }

  Future<void> deleteAd(dynamic id) async {
    try {
      final l10n = AppLocalizations.of(Get.context!)!;
      print('🔵 [MyAdsController] Deleting ad, ID: $id');
      Get.snackbar(
        l10n.processing,
        l10n.deletingAd,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blueAccent,
        colorText: Colors.white,
        duration: const Duration(seconds: 1),
      );
      isLoading.value = true;
      final apiService = Get.find<ApiService>();
      final response = await apiService.deleteAd(id);
      print('📦 [MyAdsController] Delete ad response: $response');
      if (response != null && response['status'] == true) {
        print('✅ [MyAdsController] Success! Refreshing ads list...');
        Get.snackbar(
          l10n.success,
          l10n.adDeletedSuccessfully,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF1B834F),
          colorText: Colors.white,
        );
        fetchMyAds(); // Refresh
      } else {
        print('⚠️ [MyAdsController] Delete ad failed or status false');
        String errorMsg = l10n.failedToDeleteAd;
        if (response != null && response['message'] != null) {
          final msg = response['message'];
          if (msg is Map && msg.containsKey('message_en')) {
            errorMsg = msg['message_en'][0];
          } else {
            errorMsg = msg.toString();
          }
        }
        Get.snackbar(
          'Error',
          errorMsg,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markAsSold(dynamic id) async {
    try {
      final l10n = AppLocalizations.of(Get.context!)!;
      print('🔵 [MyAdsController] Marking as sold, ID: $id');
      Get.snackbar(
        l10n.processing,
        l10n.markingAsSold,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blueAccent,
        colorText: Colors.white,
        duration: const Duration(seconds: 1),
      );
      isLoading.value = true;
      final apiService = Get.find<ApiService>();
      final response = await apiService.markAsSold(id);
      print('📦 [MyAdsController] Mark as sold response: $response');
      if (response != null && response['status'] == true) {
        print('✅ [MyAdsController] Success! Refreshing ads list...');
        Get.snackbar(
          l10n.success,
          l10n.adMarkedAsSold,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF1B834F),
          colorText: Colors.white,
        );
        fetchMyAds(); // Refresh
      } else {
        print('⚠️ [MyAdsController] Mark as sold failed or status false');
        String errorMsg = l10n.failedToMarkAsSold;
        if (response != null && response['message'] != null) {
          final msg = response['message'];
          if (msg is Map && msg.containsKey('message_en')) {
            errorMsg = msg['message_en'][0];
          } else {
            errorMsg = msg.toString();
          }
        }
        Get.snackbar(
          l10n.error,
          errorMsg,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deactivateAd(dynamic id) async {
    try {
      final l10n = AppLocalizations.of(Get.context!)!;
      print('🔵 [MyAdsController] Deactivating ad, ID: $id');
      Get.snackbar(
        l10n.processing,
        l10n.deactivatingAd,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blueAccent,
        colorText: Colors.white,
        duration: const Duration(seconds: 1),
      );
      isLoading.value = true;
      final apiService = Get.find<ApiService>();
      final response = await apiService.deactivateAds(id);
      print('📦 [MyAdsController] Deactivate ad response: $response');
      if (response != null && response['status'] == true) {
        print('✅ [MyAdsController] Success! Refreshing ads list...');
        Get.snackbar(
          l10n.success,
          l10n.adDeactivatedSuccessfully,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF1B834F),
          colorText: Colors.white,
        );
        fetchMyAds(); // Refresh
      } else {
        print('⚠️ [MyAdsController] Deactivate ad failed or status false');
        String errorMsg = l10n.failedToDeactivateAd;
        if (response != null && response['message'] != null) {
          final msg = response['message'];
          if (msg is Map && msg.containsKey('message_en')) {
            errorMsg = msg['message_en'][0];
          } else {
            errorMsg = msg.toString();
          }
        }
        Get.snackbar(
          l10n.error,
          errorMsg,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateAd({
    required String adId,
    required String title,
    required String description,
    required String pricePerKg,
    required String quantity,
  }) async {
    try {
      final l10n = AppLocalizations.of(Get.context!)!;
      print('🚀 [MyAdsController] Updating ad ID: $adId');
      isLoading.value = true;
      final apiService = Get.find<ApiService>();
      final formData = dio.FormData.fromMap({
        'title': title,
        'description': description,
        'price_per_kg': pricePerKg,
        'quantity': quantity,
      });

      final response = await apiService.updateAd(adId, formData);
      if (response != null && response['status'] == true) {
        print('✅ [MyAdsController] Ad updated successfully');

        // Update ProductController if it's showing this ad
        try {
          final productController = Get.find<ProductController>();
          if (productController.currentProductDetails.value?.id.toString() ==
              adId.toString()) {
            // Re-fetch details or update locally
            productController.fetchProductDetails(adId);
          }
        } catch (e) {
          print(
            'ℹ️ [MyAdsController] ProductController not found or error: $e',
          );
        }

        fetchMyAds(); // Refresh the main list
        return true;
      } else {
        print('❌ [MyAdsController] Update failed: $response');
        String errorMsg = l10n.failedToUpdateAd;
        if (response != null && response['message'] != null) {
          final msg = response['message'];
          if (msg is Map && msg.containsKey('message_en')) {
            errorMsg = (msg['message_en'] as List).first;
          } else {
            errorMsg = msg.toString();
          }
        }

        Get.snackbar(
          l10n.error,
          errorMsg,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      print('❌ [MyAdsController] Error in updateAd: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
