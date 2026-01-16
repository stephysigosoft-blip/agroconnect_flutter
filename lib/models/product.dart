import 'package:get/get.dart';
import '../utils/api_constants.dart';

class Product {
  final String id;
  final String category;
  final double pricePerKg;
  final double availableQuantityKg;
  final String location;
  final int daysAgo;
  final String imagePath;
  final List<String> images;
  final String status;
  final String sellerImage;
  final String sellerId;

  // Localized fields
  final Map<String, String> _nameMap;
  final Map<String, String> _descriptionMap;
  final Map<String, String> _sellerNameMap;

  Product({
    required this.id,
    required String name,
    required this.category,
    required this.pricePerKg,
    required this.availableQuantityKg,
    required this.location,
    required this.daysAgo,
    required this.imagePath,
    this.images = const [],
    this.status = 'active',
    String description = '',
    String sellerName = '',
    this.sellerImage = '',
    this.sellerId = '',
    Map<String, String>? nameMap,
    Map<String, String>? descriptionMap,
    Map<String, String>? sellerNameMap,
  }) : _nameMap = nameMap ?? {'en': name},
       _descriptionMap = descriptionMap ?? {'en': description},
       _sellerNameMap = sellerNameMap ?? {'en': sellerName};

  String get name {
    final lang = Get.locale?.languageCode ?? 'en';
    return _nameMap[lang] ??
        _nameMap['en'] ??
        _nameMap.values.firstWhere(
          (v) => v.isNotEmpty,
          orElse: () => 'Unknown',
        );
  }

  String get description {
    final lang = Get.locale?.languageCode ?? 'en';
    return _descriptionMap[lang] ??
        _descriptionMap['en'] ??
        _descriptionMap.values.firstWhere(
          (v) => v.isNotEmpty,
          orElse: () => 'No description available',
        );
  }

  String get sellerName {
    final lang = Get.locale?.languageCode ?? 'en';
    return _sellerNameMap[lang] ??
        _sellerNameMap['en'] ??
        _sellerNameMap.values.firstWhere(
          (v) => v.isNotEmpty,
          orElse: () => 'Unknown User',
        );
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    final root = json.containsKey('product') ? json['product'] : json;

    final id = (root['id'] ?? '').toString();

    // Collect all localized names
    final Map<String, String> nameMap = {};
    if (root['name_en'] != null) nameMap['en'] = root['name_en'].toString();
    if (root['name_ar'] != null) nameMap['ar'] = root['name_ar'].toString();
    if (root['name_fr'] != null) nameMap['fr'] = root['name_fr'].toString();
    if (root['name'] != null && nameMap.isEmpty)
      nameMap['en'] = root['name'].toString();

    // Collect all localized descriptions
    final Map<String, String> descriptionMap = {};
    if (root['description_en'] != null)
      descriptionMap['en'] = root['description_en'].toString();
    if (root['description_ar'] != null)
      descriptionMap['ar'] = root['description_ar'].toString();
    if (root['description_fr'] != null)
      descriptionMap['fr'] = root['description_fr'].toString();
    if (root['description'] != null && descriptionMap.isEmpty)
      descriptionMap['en'] = root['description'].toString();

    // Handle nested category or direct field
    String category = 'General';
    if (root['category'] is Map) {
      category =
          root['category']['name_en'] ?? root['category']['name'] ?? 'General';
    } else if (root['category_id'] != null) {
      category = 'Category ${root['category_id']}';
    }

    final price =
        double.tryParse(
          (root['price_per_kg'] ?? root['price'] ?? 0).toString(),
        ) ??
        0.0;
    final quantity =
        double.tryParse(
          (root['quantity'] ?? root['pending_quantity'] ?? 0).toString(),
        ) ??
        0.0;
    final location = root['region'] ?? root['location'] ?? 'N/A';

    int days = 0;
    if (root['created_at'] != null) {
      try {
        final createdAt = DateTime.parse(root['created_at']);
        days = DateTime.now().difference(createdAt).inDays;
      } catch (_) {}
    }

    final List<String> images = [];
    String normalizeUrl(String url) {
      if (url.contains('localhost')) {
        return url.replaceFirst(
          RegExp(r'https?://localhost/storage/'),
          ApiConstants.imageBaseUrl,
        );
      }
      return url;
    }

    if (root['media'] is List) {
      for (var item in root['media']) {
        if (item is Map && item.containsKey('file_url')) {
          images.add(normalizeUrl(item['file_url'].toString()));
        }
      }
    } else if (root['product_media'] is List) {
      for (var item in root['product_media']) {
        if (item is Map && item.containsKey('file_url')) {
          images.add(normalizeUrl(item['file_url'].toString()));
        }
      }
    } else if (root['images'] is List) {
      for (var item in root['images']) {
        final path = item.toString();
        if (path.startsWith('http')) {
          images.add(normalizeUrl(path));
        } else {
          images.add('${ApiConstants.imageBaseUrl}$path');
        }
      }
    }

    final imagePath =
        images.isNotEmpty ? images[0] : (root['image_path'] ?? '');

    // Seller info
    Map<String, String> sNameMap = {};
    String sImage = '';
    String sId = '';
    if (root['seller'] is Map) {
      final s = root['seller'];
      sId = s['id']?.toString() ?? '';
      if (s['name_en'] != null) sNameMap['en'] = s['name_en'].toString();
      if (s['name_ar'] != null) sNameMap['ar'] = s['name_ar'].toString();
      if (s['name_fr'] != null) sNameMap['fr'] = s['name_fr'].toString();
      if (s['name'] != null && sNameMap.isEmpty)
        sNameMap['en'] = s['name'].toString();

      sImage = s['image'] ?? '';
      if (sImage.isNotEmpty) {
        if (!sImage.startsWith('http')) {
          sImage = '${ApiConstants.imageBaseUrl}$sImage';
        } else {
          sImage = normalizeUrl(sImage);
        }
      }
    } else {
      sId = root['seller_id']?.toString() ?? '';
    }

    return Product(
      id: id,
      name: nameMap['en'] ?? 'Unknown',
      category: category,
      pricePerKg: price,
      availableQuantityKg: quantity,
      location: location,
      daysAgo: days,
      imagePath: imagePath,
      images: images,
      status: _parseStatus(root['status']),
      description: descriptionMap['en'] ?? '',
      sellerName: sNameMap['en'] ?? '',
      sellerImage: sImage,
      sellerId: sId,
      nameMap: nameMap,
      descriptionMap: descriptionMap,
      sellerNameMap: sNameMap,
    );
  }

  static String _parseStatus(dynamic status) {
    if (status == null) return 'active';
    if (status is int || status is double) {
      if (status == 1) return 'active';
      if (status == 2) return 'sold';
      if (status == 0) return 'deactivated';
      return 'inactive';
    }
    final statusStr = status.toString().toLowerCase();
    if (statusStr == '1') return 'active';
    if (statusStr == '2') return 'sold';
    if (statusStr == '0') return 'deactivated';
    return statusStr;
  }
}
