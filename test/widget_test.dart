import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:newt_merge/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app wrapped in ProviderScope and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: NewtMergeApp(),
      ),
    );

    // Verify the scoreboard is visible
    expect(find.text('Creek Level'), findsOneWidget);
    expect(find.text('Points'), findsOneWidget);

    // Verify the incubator button is present
    expect(find.text('Incubate Egg'), findsOneWidget);
  });
}
