import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:newt_merge/main.dart';
import 'package:newt_merge/providers/persistence_providers.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Initialize mock values
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    // Build our app wrapped in ProviderScope with overrides and trigger a frame.
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const NewtMergeApp(),
      ),
    );

    // Verify the scoreboard is visible
    expect(find.text('Creek Level'), findsOneWidget);
    expect(find.text('Points'), findsOneWidget);

    // Verify the incubator button is present
    expect(find.text('Incubate Egg'), findsOneWidget);
  });
}
