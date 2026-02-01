import 'package:flutter_test/flutter_test.dart';

import 'package:newt_merge/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const NewtMergeApp());

    // Verify the scoreboard is visible
    expect(find.text('Creek Level'), findsOneWidget);
    expect(find.text('Points'), findsOneWidget);

    // Verify the incubator button is present
    expect(find.text('Incubate Egg'), findsOneWidget);
  });
}
