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
  final DateTime? endTime;
  final String? sellerName;
  final String? sellerAvatarUrl;
  final String? sellerPhone;
  final String? sellerBio;
  final String? locale;
  final String status;
  final bool isSellerVerified;
  final String? sellerFaydaStatus;

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
    this.endTime,
    this.sellerName,
    this.sellerAvatarUrl,
    this.sellerPhone,
    this.sellerBio,
    this.locale,
    this.status = 'ACTIVE',
    this.isSellerVerified = false,
    this.sellerFaydaStatus,
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

  /// Maps a JSON object from the backend API to a [Property] model.
  factory Property.fromJson(Map<String, dynamic> json) {
    // Determine category from the 'type' field returned by backend
    final type = (json['type'] as String? ?? 'SALE').toUpperCase();
    PropertyCategory category;
    if (type == 'RENT') {
      category = PropertyCategory.rent;
    } else if (type == 'COMMERCIAL') {
      category = PropertyCategory.commercial;
    } else {
      category = PropertyCategory.buy;
    }

    // Build specs list from available fields
    final specs = <PropertySpec>[];
    if (json['beds'] != null) {
      specs.add(PropertySpec(label: 'Beds', value: '${json['beds']}', icon: 'bed'));
    }
    if (json['baths'] != null) {
      specs.add(PropertySpec(label: 'Baths', value: '${json['baths']}', icon: 'bathtub'));
    }
    if (json['sqFootage'] != null) {
      specs.add(PropertySpec(label: 'SQM', value: '${json['sqFootage']}', icon: 'square_foot'));
    }

    // Parse image URLs list
    final rawImages = json['imageUrls'];
    final imageUrls = rawImages is List
        ? List<String>.from(rawImages).map((url) {
            if (url.startsWith('/public')) {
              return 'http://localhost:8080$url';
            }
            return url;
          }).toList()
        : <String>[];

    return Property(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      currency: 'ETB',
      address: json['address'] as String? ?? '',
      imageUrls: imageUrls,
      category: category,
      specs: specs,
      isVerified: false,
      isFeatured: json['listingType'] == 'AUCTION',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      endTime: (json['endTime'] != null)
          ? DateTime.tryParse(json['endTime'] as String)
          : (json['endingAt'] != null)
              ? DateTime.tryParse(json['endingAt'] as String)
              : null,
      sellerName: json['owner']?['user']?['name'] as String?,
      sellerAvatarUrl: json['owner']?['user']?['avatarUrl'] as String?,
      sellerPhone: json['owner']?['user']?['phone'] as String?,
      sellerBio: json['owner']?['user']?['bio'] as String?,
      isSellerVerified: json['owner']?['user']?['isVerified'] as bool? ?? false,
      sellerFaydaStatus: json['owner']?['user']?['faydaStatus'] as String?,
      locale: json['locale'] as String?,
      status: json['status'] as String? ?? 'ACTIVE',
    );
  }
}

