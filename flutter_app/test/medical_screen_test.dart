import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smidge/screens/medical.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  Future<void> pump(WidgetTester tester) async {
    tester.view.physicalSize = const Size(420, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const MaterialApp(home: ScrMedical()));
  }

  testWidgets('defaults to glucose tab', (tester) async {
    await pump(tester);
    expect(find.text('blood glucose'), findsOneWidget);
    expect(find.text('94'), findsOneWidget);
  });

  testWidgets('tapping HbA1c tab switches analyte', (tester) async {
    await pump(tester);
    await tester.tap(find.text('HbA1c'));
    await tester.pump();

    expect(find.text('haemoglobin A1c'), findsOneWidget);
    expect(find.text('5.6'), findsOneWidget); // default input
    expect(find.text('mmol/mol'), findsWidgets); // converted unit
    expect(find.text('blood glucose'), findsNothing);
  });

  testWidgets('each tab shows its own conversion and verdict', (tester) async {
    await pump(tester);

    await tester.tap(find.text('Cholest.'));
    await tester.pump();
    expect(find.text('total cholesterol'), findsOneWidget);
    expect(find.textContaining('Desirable'), findsOneWidget); // 180 mg/dL

    await tester.tap(find.text('Creat.'));
    await tester.pump();
    expect(find.text('serum creatinine'), findsOneWidget);
    expect(find.textContaining('Typical.'), findsOneWidget); // 1.0 mg/dL

    await tester.scrollUntilVisible(find.text('Trig.'), 50,
        scrollable: find.byType(Scrollable).first);
    await tester.tap(find.text('Trig.'));
    await tester.pump();
    expect(find.text('triglycerides'), findsOneWidget);
    expect(find.textContaining('Normal'), findsOneWidget); // 120 mg/dL
  });

  testWidgets('unit toggle still swaps input unit on glucose', (tester) async {
    await pump(tester);
    await tester.tap(find.textContaining('mg/dL ↕'));
    await tester.pump();
    expect(find.textContaining('mmol/L ↕'), findsOneWidget);
  });
}
