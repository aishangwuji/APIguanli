import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unibalance/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: UniBalanceApp(),
      ),
    );

    // Verify that the app title is displayed
    expect(find.text('UniBalance'), findsOneWidget);
  });
}
