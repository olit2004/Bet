import '../models/property_model.dart';

class MockPropertyData {
  static const List<Property> properties = [
    Property(
      id: '1',
      title: 'Exquisite Villa',
      description:
          'Designed by renowned architect Marcus Thorne, this residence serves as a masterful dialogue between organic textures and stark industrial lines. Featuring floor-to-ceiling glass that dissolves the boundary between the interior gallery and the surrounding eucalyptus groves.',
      price: 12450000,
      currency: 'ETB',
      address: 'Garment',
      imageUrls: [
        'assets/images/the-glass-Pavillion.png',
      ],
      category: PropertyCategory.buy,
      specs: [
        PropertySpec(label: 'Beds', value: '5', icon: 'bed'),
        PropertySpec(label: 'Baths', value: '4', icon: 'bathtub'),
        PropertySpec(label: 'SQM', value: '500', icon: 'square_foot'),
      ],
      isVerified: true,
      isFeatured: true,
      sellerName: 'Abebe Tola',
      locale: 'Bole Medhanialem',
    ),
    Property(
      id: '2',
      title: 'Elegant Apartments',
      description:
          'Designed by the visionary studio these residences offer a sophisticated interplay between urban rhythm and curated tranquility. Featuring expansive steel-framed windows that pull the city\'s shifting skyline into the living space, each unit balances raw exposed concrete with the warmth of hand-finished oak.',
      price: 7450000,
      currency: 'ETB',
      address: 'Tsehay Realstate',
      imageUrls: [
        'assets/images/properties/apartment.png',
      ],
      category: PropertyCategory.commercial,
      specs: [
        PropertySpec(label: '3-Bedrooms', value: '10', icon: 'bed'),
        PropertySpec(label: '2-Bedrooms', value: '15', icon: 'bed'),
        PropertySpec(label: 'Studios', value: '25', icon: 'bed'),
      ],
      isVerified: true,
      sellerName: 'Mikias Yared',
      locale: 'Sarbet',
    ),
    Property(
      id: '3',
      title: 'Modern Loft',
      description:
          'Spacious open-plan office in a prime business district. Suitable for startups or established firms. Features high-speed internet connectivity and ample parking.',
      price: 850000,
      currency: 'ETB',
      address: 'Mexico, Addis Ababa',
      imageUrls: ['assets/images/skyline-retreat.png'],
      category: PropertyCategory.rent,
      specs: [
        PropertySpec(label: 'Space', value: '120 sqm', icon: 'square_foot'),
        PropertySpec(
          label: 'Parking',
          value: 'Available',
          icon: 'local_parking',
        ),
      ],
      sellerName: 'Yonas Habte',
      locale: 'Mexico',
    ),
  ];
}
