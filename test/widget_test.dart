import 'package:flutter_test/flutter_test.dart';
import 'package:bet/main.dart';

void main() {
  testWidgets('App should load and show landing placeholder', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const BethApp());

    // Verify that our landing placeholder text is present.
    expect(find.text('Beth App - Landing Placeholder'), findsOneWidget);
  });
}
