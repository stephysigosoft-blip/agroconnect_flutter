import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/product.dart';
import '../controllers/wishlist_controller.dart';
import '../l10n/app_localizations.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final bool isHorizontal;
  final bool showWishlist;
  final bool showStatus;
  final String? status;
  final Widget? topTrailing;
  final Widget? bottomActions;
  final VoidCallback? onTap;
  final bool isGrayscale;
  final bool isHaze;

  const ProductCard({
    super.key,
    required this.product,
    this.isHorizontal = false,
    this.showWishlist = true,
    this.showStatus = false,
    this.status,
    this.topTrailing,
    this.bottomActions,
    this.onTap,
    this.isGrayscale = false,
    this.isHaze = false,
  });

  @override
  Widget build(BuildContext context) {
    final WishlistController wishlistController =
        Get.find<WishlistController>();
    final l10n = AppLocalizations.of(context)!;

    Widget cardContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image Section
        Stack(
          children: [
            _buildImage(isGrayscale, isHaze),
            if (isHaze)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                ),
              ),
            if (showStatus && status != null) _buildStatusBadge(status!),
            if (showWishlist) _buildWishlistButton(wishlistController),
            if (topTrailing != null)
              Positioned(top: 8, right: 8, child: topTrailing!),
          ],
        ),
        // Info Section
        Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color:
                      (isGrayscale || isHaze)
                          ? Colors.black.withOpacity(0.6)
                          : Colors.black,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                l10n.pricePerKg(product.pricePerKg.toStringAsFixed(0)),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color:
                      (isGrayscale || isHaze)
                          ? const Color(0xFF1B834F).withOpacity(0.6)
                          : const Color(0xFF1B834F),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.available(product.availableQuantityKg.toStringAsFixed(0)),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              // Location and Time
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            product.location,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    l10n.daysAgo(product.daysAgo),
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (bottomActions != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: bottomActions!,
          ),
      ],
    );

    return GestureDetector(
      onTap: onTap ?? () => Get.toNamed('/product', arguments: product),
      child: Container(
        width: isHorizontal ? 160 : double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: cardContent,
      ),
    );
  }

  Widget _buildImage(bool grayscale, bool haze) {
    Widget image = Image.asset(
      product.imagePath,
      height: 120,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder:
          (context, error, stackTrace) => Container(
            height: 120,
            color: Colors.grey.shade100,
            child: const Icon(
              Icons.image_not_supported,
              size: 40,
              color: Colors.grey,
            ),
          ),
    );

    if (grayscale || haze) {
      image = ColorFiltered(
        colorFilter: const ColorFilter.matrix(<double>[
          0.2126,
          0.7152,
          0.0722,
          0,
          0,
          0.2126,
          0.7152,
          0.0722,
          0,
          0,
          0.2126,
          0.7152,
          0.0722,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
        ]),
        child: image,
      );
    }

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: image,
    );
  }

  Widget _buildStatusBadge(String statusText) {
    Color badgeColor = const Color(0xFF1B834F);
    if (statusText.toLowerCase() == 'rejected') {
      badgeColor = const Color(0xFFD32F2F);
    } else if (statusText.toLowerCase() == 'expired' ||
        statusText.toLowerCase() == 'deactivated') {
      badgeColor = const Color(0xFF6E6E6E);
    }

    return Positioned(
      top: 0,
      left: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: badgeColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            bottomRight: Radius.circular(12),
          ),
        ),
        child: Text(
          statusText,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildWishlistButton(WishlistController wishlistController) {
    return Positioned(
      top: 8,
      right: 8,
      child: Obx(() {
        final isInWishlist = wishlistController.isInWishlist(product.id);
        return GestureDetector(
          onTap: () => wishlistController.toggleWishlist(product),
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              isInWishlist ? Icons.favorite : Icons.favorite_border,
              size: 18,
              color: isInWishlist ? Colors.red : Colors.grey.shade700,
            ),
          ),
        );
      }),
    );
  }
}
