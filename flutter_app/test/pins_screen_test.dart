import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smidge/screens/pins.dart';
import 'package:smidge/state/app_state.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Future<AppState> pump(WidgetTester tester) async {
    tester.view.physicalSize = const Size(420, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    final state = AppState(); // defaults: temp, flour, glucose
    await tester.pumpWidget(MaterialApp(home: ScrPins(state: state)));
    return state;
  }

  double topOf(WidgetTester tester, String note) =>
      tester.getTopLeft(find.text(note)).dy;

  testWidgets('shows all five candidates with pinned ones first',
      (tester) async {
    await pump(tester);
    for (final note in [
      'temperature', 'all-purpose flour', 'blood glucose', 'distance', 'mass'
    ]) {
      expect(find.text(note), findsOneWidget, reason: note);
    }
    // pinned (temp, flour, glucose) appear above unpinned (dist, weight)
    expect(topOf(tester, 'blood glucose'), lessThan(topOf(tester, 'distance')));
    expect(topOf(tester, 'distance'), lessThan(topOf(tester, 'mass')));
  });

  testWidgets('tapping the star of an unpinned item pins it (oldest replaced)',
      (tester) async {
    final state = await pump(tester);
    await tester.tap(find.byKey(const Key('pin-star-dist')));
    await tester.pump();
    expect(state.pins, ['flour', 'glucose', 'dist']);
    // screen reordered: now-unpinned temperature sits below pinned distance
    expect(topOf(tester, 'distance'), lessThan(topOf(tester, 'temperature')));
  });

  testWidgets('tapping the star of a pinned item unpins it', (tester) async {
    final state = await pump(tester);
    await tester.tap(find.byKey(const Key('pin-star-flour')));
    await tester.pump();
    expect(state.pins, ['temp', 'glucose']);
  });

  testWidgets('long-pressing a card toggles its pin too', (tester) async {
    final state = await pump(tester);
    await tester.longPress(find.byKey(const Key('pin-card-weight')));
    await tester.pump();
    expect(state.pins, ['flour', 'glucose', 'weight']);
  });

  testWidgets('header copy no longer advertises swap-only', (tester) async {
    await pump(tester);
    expect(find.textContaining('long-press to swap'), findsNothing);
    expect(find.textContaining('star to pin'), findsOneWidget);
  });
}
