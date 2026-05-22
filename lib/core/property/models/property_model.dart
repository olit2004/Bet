enum PropertyCategory { buy, rent, commercial }

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
  final String? sellerName;
  final String? locale;

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
    this.sellerName,
    this.locale,
  });

  /// Helper to get a string representation of the category
  String get categoryName {
    switch (category) {
      case PropertyCategory.buy:
        return 'Buy';
      case PropertyCategory.rent:
        return 'Rent';
      case PropertyCategory.commercial:
        return 'Commercial';
    }
  }

  factory Property.fromJson(Map<String, dynamic> json) {
    // Map backend type (SALE, RENT) to PropertyCategory
    PropertyCategory mappedCategory;
    final typeStr = (json['type'] as String?)?.toUpperCase() ?? 'SALE';
    if (typeStr == 'RENT') {
      mappedCategory = PropertyCategory.rent;
    } else {
      mappedCategory = PropertyCategory.buy;
    }

    // Build specs list dynamically from backend fields
    final List<PropertySpec> specsList = [];
    if (json['beds'] != null) {
      specsList.add(PropertySpec(label: 'Beds', value: json['beds'].toString(), icon: 'bed'));
    }
    if (json['baths'] != null) {
      specsList.add(PropertySpec(label: 'Baths', value: json['baths'].toString(), icon: 'bathtub'));
    }
    if (json['sqFootage'] != null) {
      specsList.add(PropertySpec(label: 'SqFt', value: json['sqFootage'].toString(), icon: 'square_foot'));
    }

    // Parse image URLs and prepend backend URL if necessary
    List<String> parsedImageUrls = [];
    if (json['imageUrls'] != null) {
      parsedImageUrls = (json['imageUrls'] as List).map((url) {
        final urlStr = url.toString();
        if (urlStr.startsWith('http')) return urlStr;
        return 'http://localhost:8080$urlStr';
      }).toList();
    }

    return Property(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      address: json['address'] as String? ?? json['location'] as String? ?? 'Unknown Location',
      imageUrls: parsedImageUrls,
      category: mappedCategory,
      specs: specsList,
      locale: json['locale'] as String?,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      isVerified: true, // Assuming properties fetched are verified
      sellerName: json['owner']?['company'] ?? 'Unknown Seller',
    );
  }
}
