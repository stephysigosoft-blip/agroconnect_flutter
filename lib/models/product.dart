class Product {
  final String id;
  final String name;
  final String category;
  final double pricePerKg;
  final double availableQuantityKg;
  final String location;
  final int daysAgo;
  final String imagePath;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.pricePerKg,
    required this.availableQuantityKg,
    required this.location,
    required this.daysAgo,
    required this.imagePath,
  });
}
