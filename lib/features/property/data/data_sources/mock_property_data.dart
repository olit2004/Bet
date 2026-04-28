import '../../domain/models/property_model.dart';

class MockPropertyData {
  static const List<Property> properties = [
    Property(
      id: '1',
      title: 'Exquisite Villa',
      description: 'A stunning modern villa located in the heart of Bole. This property features spacious rooms, a private garden, and state-of-the-art security systems. Perfect for families looking for luxury and comfort.',
      price: 4250000,
      currency: 'ETB',
      address: 'Bole, Addis Ababa',
      imageUrls: [
        'assets/images/properties/villa.png',
      ],
      category: PropertyCategory.buy,
      specs: [
        PropertySpec(label: 'Bedrooms', value: '4', icon: 'bed'),
        PropertySpec(label: 'Bathrooms', value: '3', icon: 'bathtub'),
        PropertySpec(label: 'Area', value: '350 sqm', icon: 'square_foot'),
      ],
      isVerified: true,
      isFeatured: true,
    ),
    Property(
      id: '2',
      title: 'Modern Apartment',
      description: 'Elegant high-rise apartment with breathtaking city views. Fully furnished with high-end appliances and modern finishes. Includes access to a communal gym and rooftop lounge.',
      price: 150000,
      currency: 'ETB',
      address: 'Kazanchis, Addis Ababa',
      imageUrls: [
        'assets/images/properties/apartment.png',
      ],
      category: PropertyCategory.rent,
      specs: [
        PropertySpec(label: 'Bedrooms', value: '2', icon: 'bed'),
        PropertySpec(label: 'Bathrooms', value: '2', icon: 'bathtub'),
        PropertySpec(label: 'Floor', value: '12th', icon: 'layers'),
      ],
      isVerified: true,
    ),
    Property(
      id: '3',
      title: 'Commercial Office Space',
      description: 'Spacious open-plan office in a prime business district. Suitable for startups or established firms. Features high-speed internet connectivity and ample parking.',
      price: 85000,
      currency: 'ETB',
      address: 'Mexico, Addis Ababa',
      imageUrls: [
        'assets/images/properties/apartment.png', // Reusing for mock
      ],
      category: PropertyCategory.commercial,
      specs: [
        PropertySpec(label: 'Space', value: '120 sqm', icon: 'square_foot'),
        PropertySpec(label: 'Parking', value: 'Available', icon: 'local_parking'),
      ],
    ),
  ];
}
