import 'package:get/get.dart';
import '../models/product.dart';
import '../utils/snackbar_helper.dart';

class WishlistController extends GetxController {
  /// List of wishlist items
  final RxList<Product> wishlistItems = <Product>[].obs;

  /// Check if a product is in wishlist
  bool isInWishlist(String productId) {
    return wishlistItems.any((product) => product.id == productId);
  }

  /// Add product to wishlist
  void addToWishlist(Product product) {
    if (!isInWishlist(product.id)) {
      wishlistItems.add(product);
      SnackBarHelper.showSuccess(
        'Added to Wishlist',
        '${product.name} has been added to your wishlist',
      );
    } else {
      SnackBarHelper.showError(
        'Already in Wishlist',
        '${product.name} is already in your wishlist',
      );
    }
  }

  /// Remove product from wishlist
  void removeFromWishlist(String productId) {
    final product = wishlistItems.firstWhereOrNull((p) => p.id == productId);
    if (product != null) {
      wishlistItems.removeWhere((p) => p.id == productId);
      SnackBarHelper.showError(
        'Removed from Wishlist',
        '${product.name} has been removed from your wishlist',
      );
    }
  }

  /// Toggle wishlist status
  void toggleWishlist(Product product) {
    if (isInWishlist(product.id)) {
      removeFromWishlist(product.id);
    } else {
      addToWishlist(product);
    }
  }

  /// Clear all wishlist items
  void clearWishlist() {
    wishlistItems.clear();
    SnackBarHelper.showError(
      'Wishlist Cleared',
      'All items have been removed from your wishlist',
    );
  }

  /// Get wishlist count
  int get wishlistCount => wishlistItems.length;
}
