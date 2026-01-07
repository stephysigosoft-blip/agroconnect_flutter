import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/product.dart';

class ProductController extends GetxController {
  /// Categories (4)
  final List<String> categories = const [
    'Grains & Cereals',
    'Vegetables',
    'Livestock & Meat',
    'Poultry & Eggs',
  ];

  /// All products (10)
  final RxList<Product> allProducts =
      <Product>[
        const Product(
          id: 'p1',
          name: 'Millet',
          category: 'Grains & Cereals',
          pricePerKg: 120,
          availableQuantityKg: 800,
          location: 'Nouakchott',
          daysAgo: 1,
          imagePath: "lib/assets/images/product's/millet.png",
        ),
        const Product(
          id: 'p2',
          name: 'Sorghum',
          category: 'Grains & Cereals',
          pricePerKg: 110,
          availableQuantityKg: 1200,
          location: 'Rosso',
          daysAgo: 2,
          imagePath: "lib/assets/images/product's/sorghum.png",
        ),
        const Product(
          id: 'p3',
          name: 'Rice',
          category: 'Grains & Cereals',
          pricePerKg: 150,
          availableQuantityKg: 2000,
          location: 'Bogué',
          daysAgo: 3,
          imagePath: "lib/assets/images/product's/millet.png",
        ),
        const Product(
          id: 'p4',
          name: 'Tomato',
          category: 'Vegetables',
          pricePerKg: 90,
          availableQuantityKg: 600,
          location: 'Nouakchott',
          daysAgo: 1,
          imagePath: "lib/assets/images/product's/tomato.png",
        ),
        const Product(
          id: 'p5',
          name: 'Potato',
          category: 'Vegetables',
          pricePerKg: 80,
          availableQuantityKg: 1000,
          location: 'Kiffa',
          daysAgo: 4,
          imagePath: "lib/assets/images/product's/tomato.png",
        ),
        const Product(
          id: 'p6',
          name: 'Onion',
          category: 'Vegetables',
          pricePerKg: 70,
          availableQuantityKg: 900,
          location: 'Kaédi',
          daysAgo: 2,
          imagePath: "lib/assets/images/product's/tomato.png",
        ),
        const Product(
          id: 'p7',
          name: 'Beef',
          category: 'Livestock & Meat',
          pricePerKg: 450,
          availableQuantityKg: 500,
          location: 'Nouakchott',
          daysAgo: 1,
          imagePath: "lib/assets/images/product's/millet.png",
        ),
        const Product(
          id: 'p8',
          name: 'Mutton',
          category: 'Livestock & Meat',
          pricePerKg: 420,
          availableQuantityKg: 400,
          location: 'Tidjikja',
          daysAgo: 3,
          imagePath: "lib/assets/images/product's/millet.png",
        ),
        const Product(
          id: 'p9',
          name: 'Chicken',
          category: 'Poultry & Eggs',
          pricePerKg: 220,
          availableQuantityKg: 700,
          location: 'Nouadhibou',
          daysAgo: 2,
          imagePath: "lib/assets/images/product's/millet.png",
        ),
        const Product(
          id: 'p10',
          name: 'Eggs',
          category: 'Poultry & Eggs',
          pricePerKg: 200,
          availableQuantityKg: 300,
          location: 'Nouakchott',
          daysAgo: 1,
          imagePath: "lib/assets/images/product's/millet.png",
        ),
      ].obs;

  /// Search & filters state
  final RxString searchQuery = ''.obs;
  final Rx<RangeValues> priceRange = const RangeValues(50, 500).obs;
  final RxInt selectedQuantityIndex = 0.obs;
  final RxInt selectedSortIndex = 0.obs;

  /// Quantity ranges used for filtering
  /// 0 -> Any quantity (no restriction)
  /// Others -> narrow ranges
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
          final matchesQuery =
              query.isEmpty ||
              p.name.toLowerCase().contains(query) ||
              p.category.toLowerCase().contains(query) ||
              p.location.toLowerCase().contains(query);

          final matchesPrice =
              p.pricePerKg >= price.start && p.pricePerKg <= price.end;

          final matchesQuantity =
              p.availableQuantityKg >= quantityRange.start &&
              p.availableQuantityKg <= quantityRange.end;

          return matchesQuery && matchesPrice && matchesQuantity;
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
    priceRange.value = const RangeValues(50, 500);
    selectedQuantityIndex.value = 0;
    selectedSortIndex.value = 0;
  }
}
