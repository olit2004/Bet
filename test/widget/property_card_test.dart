import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bet/features/buyer/presentation/widgets/property_card.dart';
import 'package:bet/core/property/models/property_model.dart';
import 'package:bet/core/constants/app_colors.dart';

void main() {
  group('PropertyCard Widget Tests', () {
    const defaultProperty = Property(
      id: '2',
      title: 'Beautiful Villa',
      description: 'A gorgeous modern villa in the suburbs.',
      price: 12500000.0,
      currency: 'ETB',
      address: 'Bole, Addis Ababa',
      imageUrls: [],
      category: PropertyCategory.buy,
      specs: [
        PropertySpec(label: 'Beds', value: '4', icon: 'bed'),
        PropertySpec(label: 'Baths', value: '3', icon: 'bathtub'),
        PropertySpec(label: 'SQM', value: '350', icon: 'sqm'),
      ],
      isVerified: false,
      isFeatured: false,
    );

    Widget buildTestableWidget(Property property, {VoidCallback? onTap}) {
      return MaterialApp(
        home: Scaffold(
          body: PropertyCard(
            property: property,
            onTap: onTap,
          ),
        ),
      );
    }

    testWidgets('renders basic property details (title, address, price)', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget(defaultProperty));

      expect(find.text('Beautiful Villa'), findsOneWidget);
      expect(find.text('Bole, Addis Ababa'), findsOneWidget);
      expect(find.text('ETB 12,500,000'), findsOneWidget);
    });

    testWidgets('displays verified badge only when property is verified', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget(defaultProperty));
      expect(find.text('VERIFIED'), findsNothing);

      final verifiedProperty = defaultProperty.copyWith(isVerified: true);
      await tester.pumpWidget(buildTestableWidget(verifiedProperty));
      expect(find.text('VERIFIED'), findsOneWidget);
    });

    testWidgets('shows correct category tag', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget(defaultProperty));
      expect(find.text('FREEHOLD'), findsOneWidget);

      final rentProperty = defaultProperty.copyWith(category: PropertyCategory.rent);
      await tester.pumpWidget(buildTestableWidget(rentProperty));
      expect(find.text('RENT'), findsOneWidget);

      final commProperty = defaultProperty.copyWith(category: PropertyCategory.commercial);
      await tester.pumpWidget(buildTestableWidget(commProperty));
      expect(find.text('COMMERCIAL'), findsOneWidget);
    });

    testWidgets('renders specifications (beds, baths, sqm)', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget(defaultProperty));

      expect(find.text('4'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(find.text('350'), findsOneWidget);

      expect(find.byIcon(Icons.king_bed_outlined), findsOneWidget);
      expect(find.byIcon(Icons.bathtub_outlined), findsOneWidget);
      expect(find.byIcon(Icons.square_foot_outlined), findsOneWidget);
    });

    testWidgets('triggers onTap callback when pressed', (WidgetTester tester) async {
      bool wasTapped = false;
      await tester.pumpWidget(
        buildTestableWidget(
          defaultProperty,
          onTap: () {
            wasTapped = true;
          },
        ),
      );

      await tester.tap(find.byType(PropertyCard));
      await tester.pump();

      expect(wasTapped, isTrue);
    });
  });
}

extension PropertyCopy on Property {
  Property copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    String? currency,
    String? address,
    List<String>? imageUrls,
    PropertyCategory? category,
    List<PropertySpec>? specs,
    bool? isVerified,
    bool? isFeatured,
  }) {
    return Property(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      address: address ?? this.address,
      imageUrls: imageUrls ?? this.imageUrls,
      category: category ?? this.category,
      specs: specs ?? this.specs,
      isVerified: isVerified ?? this.isVerified,
      isFeatured: isFeatured ?? this.isFeatured,
      createdAt: this.createdAt,
      endTime: this.endTime,
      sellerName: this.sellerName,
      sellerAvatarUrl: this.sellerAvatarUrl,
      sellerPhone: this.sellerPhone,
      sellerBio: this.sellerBio,
      locale: this.locale,
      status: this.status,
      isSellerVerified: this.isSellerVerified,
      sellerFaydaStatus: this.sellerFaydaStatus,
    );
  }
}
