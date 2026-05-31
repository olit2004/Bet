import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as legacy_provider;
import 'package:bet/main.dart';
import 'package:bet/core/providers/navigation_provider.dart';
import 'package:bet/core/property/providers/property_provider.dart';
import 'package:bet/core/property/repositories/property_repository_impl.dart';

void main() {
  testWidgets('App should load and show landing placeholder', (WidgetTester tester) async {
    // Build our app with providers and trigger a frame.
    await tester.pumpWidget(
      ProviderScope(
        child: legacy_provider.MultiProvider(
          providers: [
            legacy_provider.ChangeNotifierProvider(create: (_) => NavigationProvider()),
            legacy_provider.ChangeNotifierProvider(
              create: (_) => PropertyProvider(repository: PropertyRepositoryImpl()),
            ),
          ],
          child: const BethApp(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify that our landing screen motto text is present.
    expect(find.text('WHERE HERITAGE MEETS MODERN OPPORTUNITY'), findsOneWidget);
  });
}
