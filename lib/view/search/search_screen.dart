import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agroconnect_flutter/l10n/app_localizations.dart';

import '../../controllers/product_controller.dart';
import '../../models/product.dart';
import '../../widgets/product_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  late final ProductController _productController;

  @override
  void initState() {
    super.initState();
    _productController = Get.put(ProductController());
    if (_productController.currentCategoryName.value.isNotEmpty &&
        _productController.searchQuery.value.isEmpty) {
      _searchController.text = _productController.currentCategoryName.value;
    } else {
      _searchController.text = _productController.searchQuery.value;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _buildFilterSheetV2();
      },
    );
  }

  Widget _buildFilterSheetV2() {
    final l10n = AppLocalizations.of(context)!;
    final priceRange = _productController.priceRange;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Floating Close Button
        InkWell(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.close,
              size: 24,
              color: Colors.black,
            ), // Assuming grey icon if bg transparent
          ),
        ),
        const SizedBox(height: 12),
        // Main Sheet Content
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            top: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Center(
                child: Text(
                  l10n.filtersSorting,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
              const SizedBox(height: 24),

              // Quantity Range
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  l10n.quantityRange,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    _quantityChip(l10n.anyQuantity, 0),
                    const SizedBox(width: 8),
                    _quantityChip('50-100 kg', 1),
                    const SizedBox(width: 8),
                    _quantityChip('100-500 kg', 2),
                    const SizedBox(width: 8),
                    _quantityChip('500-1000 kg', 3),
                    const SizedBox(width: 8),
                    _quantityChip('1000-2000 kg', 4),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              // Price Range
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  l10n.priceRangeLabel,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Obx(() {
                final range = priceRange.value;
                return Column(
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: const Color(0xFF1B834F),
                        inactiveTrackColor: Colors.grey.shade200,
                        thumbColor: Colors.grey.shade300,
                        trackHeight: 4,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 10,
                          elevation: 4,
                        ),
                        overlayColor: const Color(0xFF1B834F).withOpacity(0.1),
                      ),

                      child: RangeSlider(
                        min: 0,
                        max: 2000,
                        values: range,
                        onChanged: _productController.setPriceRange,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildPriceBox('${range.start.toInt()} MRU'),
                          Text(
                            l10n.to,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          _buildPriceBox('${range.end.toInt()} MRU'),
                        ],
                      ),
                    ),
                  ],
                );
              }),

              const SizedBox(height: 13),
              const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
              const SizedBox(height: 13),
              Center(
                child: Text(
                  l10n.sortBy,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 13),
              const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
              const SizedBox(height: 13),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    _sortChip(l10n.relevance, 0),
                    const SizedBox(width: 8),
                    _sortChip(l10n.recentlyPosted, 1),
                    const SizedBox(width: 8),
                    _sortChip(l10n.newestFirst, 2),
                  ],
                ),
              ),

              const SizedBox(height: 32),
              // Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          _productController.resetFilters();
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: Color(0xFF1B834F),
                            width: 1.5,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          l10n.clearAll,
                          style: const TextStyle(
                            color: Color(0xFF1B834F),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1B834F),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          l10n.apply,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceBox(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100, // Light grey box
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _quantityChip(String label, int index) {
    return Obx(() {
      final isSelected =
          _productController.selectedQuantityIndex.value == index;
      return ChoiceChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: const Color(0xFF1B834F),
        backgroundColor: Colors.grey.shade100,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 13,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Colors.transparent),
        ),
        showCheckmark: false,
        onSelected: (_) => _productController.setQuantityIndex(index),
      );
    });
  }

  Widget _sortChip(String label, int index) {
    return Obx(() {
      final isSelected = _productController.selectedSortIndex.value == index;
      return ChoiceChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: const Color(0xFF1B834F),
        backgroundColor: Colors.grey.shade100,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 13,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Colors.transparent),
        ),
        showCheckmark: false,
        onSelected: (_) => _productController.setSortIndex(index),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 72,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            InkWell(
              onTap: () => Navigator.pop(context),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 40,
                height: 40, // Slightly larger square
                decoration: BoxDecoration(
                  color: const Color(0xFF1B834F), // Green filled
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.chevron_left,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFF1B834F), width: 1),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 12),
                    const Icon(Icons.search, color: Colors.grey, size: 22),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText:
                              AppLocalizations.of(context)!.searchProductsHint,
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(bottom: 4),
                        ),
                        onChanged: _productController.setSearchQuery,
                      ),
                    ),
                    Obx(() {
                      final hasText =
                          _productController.searchQuery.value.isNotEmpty;
                      if (!hasText) return const SizedBox.shrink();
                      return IconButton(
                        icon: const Icon(
                          Icons.cancel_outlined,
                          size: 22,
                          color: Colors.grey,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        visualDensity: VisualDensity.compact,
                        splashRadius: 20,
                        onPressed: () {
                          _searchController.clear();
                          _productController.setSearchQuery('');
                        },
                      );
                    }),
                    // Divider
                    Container(
                      width: 1,
                      height: 24,
                      color: Colors.grey.shade300,
                    ),
                    InkWell(
                      onTap: _openFilterSheet,
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Image.asset(
                          'lib/assets/images/Icons/filter.png',
                          height: 24,
                          width: 24,
                          color: const Color(0xFF1B834F),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Obx(() {
          if (_productController.isFetchingAll.value &&
              _productController.allProducts.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF1B834F)),
            );
          }
          if (_productController.searchQuery.value.isEmpty &&
              _productController.selectedCategoryId.value.isEmpty) {
            return const SizedBox.shrink();
          }

          final List<Product> products = _productController.filteredProducts;

          return NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.pixels >=
                  scrollInfo.metrics.maxScrollExtent * 0.8) {
                if (_productController.hasMore.value &&
                    !_productController.isLoadingMore.value) {
                  _productController.fetchAllProductsApi(loadMore: true);
                }
              }
              return false;
            },
            child: GridView.builder(
              itemCount:
                  products.length +
                  (_productController.isLoadingMore.value ? 1 : 0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.72,
              ),
              itemBuilder: (context, index) {
                if (index == products.length) {
                  return const Center(
                    child: SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFF1B834F),
                      ),
                    ),
                  );
                }
                final product = products[index];
                return ProductCard(product: product);
              },
            ),
          );
        }),
      ),
    );
  }
}
