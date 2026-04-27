enum PropertyCategory { buy, rent, auction, commercial }

class PropertySpec {
  final String label;
  final String value;
  final String? icon;

  const PropertySpec({
    required this.label,
    required this.value,
    this.icon,
  });
}

class Property {
  final String id;
  final String title;
  final String description;
  final double price;
  final String currency;
  final String address;
  final List<String> imageUrls;
  final PropertyCategory category;
  final List<PropertySpec> specs;
  final bool isVerified;
  final bool isFeatured;
  final DateTime? createdAt;

  const Property({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.currency = 'ETB',
    required this.address,
    required this.imageUrls,
    required this.category,
    required this.specs,
    this.isVerified = false,
    this.isFeatured = false,
    this.createdAt,
  });

  /// Helper to get a string representation of the category
  String get categoryName {
    switch (category) {
      case PropertyCategory.buy:
        return 'Buy';
      case PropertyCategory.rent:
        return 'Rent';
      case PropertyCategory.auction:
        return 'Auction';
      case PropertyCategory.commercial:
        return 'Commercial';
    }
  }
}
