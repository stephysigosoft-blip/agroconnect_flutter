import 'package:get/get.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../utils/snackbar_helper.dart';

class WishlistController extends GetxController {
  /// List of wishlist items
  final RxList<Product> wishlistItems = <Product>[].obs;
  final RxBool isLoading = false.obs;

  final RxInt page = 1.obs;
  final RxBool hasMore = true.obs;
  final RxBool isLoadingMore = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchWishlist(); // Fetch on init to sync with server
  }

  Future<void> fetchWishlist({bool loadMore = false}) async {
    try {
      if (loadMore) {
        if (isLoadingMore.value || !hasMore.value) return;
        isLoadingMore.value = true;
      } else {
        isLoading.value = true;
        page.value = 1;
        hasMore.value = true;
      }

      final apiService = Get.find<ApiService>();
      final response = await apiService.getWishlist(page: page.value);
      if (response != null && response['status'] == true) {
        final List data = _extractDataList(response['data']);
        final newItems = data.map((json) => Product.fromJson(json)).toList();

        if (loadMore) {
          wishlistItems.addAll(newItems);
        } else {
          wishlistItems.assignAll(newItems);
        }

        hasMore.value = newItems.length >= 20;
        if (newItems.isNotEmpty) {
          page.value++;
        }
      }
    } finally {
      isLoading.value = false;
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

  /// Check if a product is in wishlist
  bool isInWishlist(String productId) {
    return wishlistItems.any((product) => product.id == productId);
  }

  /// Add product to wishlist
  Future<void> addToWishlist(Product product) async {
    if (!isInWishlist(product.id)) {
      // Optimistic update
      wishlistItems.add(product);
      try {
        final apiService = Get.find<ApiService>();
        await apiService.addToWishlist(product.id);
        SnackBarHelper.showSuccess(
          'Added to Wishlist',
          '${product.name} has been added to your wishlist',
        );
      } catch (e) {
        // Revert if failed
        wishlistItems.remove(product);
      }
    } else {
      SnackBarHelper.showError(
        'Already in Wishlist',
        '${product.name} is already in your wishlist',
      );
    }
  }

  /// Remove product from wishlist
  Future<void> removeFromWishlist(String productId) async {
    final product = wishlistItems.firstWhereOrNull((p) => p.id == productId);
    if (product != null) {
      // Optimistic update
      wishlistItems.removeWhere((p) => p.id == productId);
      try {
        final apiService = Get.find<ApiService>();
        await apiService.deleteFromWishlist(productId);
        SnackBarHelper.showError(
          'Removed from Wishlist',
          '${product.name} has been removed from your wishlist',
        );
      } catch (e) {
        // Revert if failed
        wishlistItems.add(product);
      }
    }
  }

  /// Toggle wishlist status
  Future<void> toggleWishlist(Product product) async {
    if (isInWishlist(product.id)) {
      await removeFromWishlist(product.id);
    } else {
      await addToWishlist(product);
    }
  }

  /// Clear all wishlist items
  void clearWishlist() {
    wishlistItems.clear();
    // Assuming backend doesn't have a clear-all endpoint or we call delete individually
    // This method might need adjustment if a clear-all API exists.
    SnackBarHelper.showError(
      'Wishlist Cleared',
      'All items have been removed from your wishlist',
    );
  }

  /// Get wishlist count
  int get wishlistCount => wishlistItems.length;
}
