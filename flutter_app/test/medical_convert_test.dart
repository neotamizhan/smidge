import 'package:flutter_test/flutter_test.dart';
import 'package:smidge/data/convert.dart';

void main() {
  group('kAnalytes registry', () {
    test('contains the five analytes in tab order', () {
      expect(kAnalytes.map((a) => a.id).toList(),
          ['glucose', 'hba1c', 'cholesterol', 'creatinine', 'triglycerides']);
    });
  });

  group('conversions', () {
    Analyte byId(String id) => kAnalytes.firstWhere((a) => a.id == id);

    test('glucose mg/dL ↔ mmol/L matches convertGlucose', () {
      final a = byId('glucose');
      expect(a.aToB(94), closeTo(convertGlucose(94, 'mgdL', 'mmolL'), 1e-9));
      expect(a.aToB(94), closeTo(5.217, 0.001));
      expect(a.bToA(5.5), closeTo(99.09, 0.01));
    });

    test('HbA1c % (NGSP) ↔ mmol/mol (IFCC)', () {
      final a = byId('hba1c');
      // IFCC = 10.929 × (NGSP − 2.15)
      expect(a.aToB(5.7), closeTo(38.8, 0.1));
      expect(a.aToB(6.5), closeTo(47.5, 0.1));
      expect(a.bToA(48), closeTo(6.54, 0.01));
    });

    test('total cholesterol mg/dL ↔ mmol/L', () {
      final a = byId('cholesterol');
      expect(a.aToB(200), closeTo(5.17, 0.01));
      expect(a.bToA(5.0), closeTo(193.35, 0.1));
    });

    test('creatinine mg/dL ↔ µmol/L', () {
      final a = byId('creatinine');
      expect(a.aToB(1.0), closeTo(88.42, 0.01));
      expect(a.bToA(88.42), closeTo(1.0, 1e-9));
    });

    test('triglycerides mg/dL ↔ mmol/L', () {
      final a = byId('triglycerides');
      expect(a.aToB(150), closeTo(1.694, 0.001));
      expect(a.bToA(1.694), closeTo(150, 0.05));
    });

    test('round trips are identity', () {
      for (final a in kAnalytes) {
        expect(a.bToA(a.aToB(7.3)), closeTo(7.3, 1e-9), reason: a.id);
      }
    });

    test('non-finite input yields NaN', () {
      final a = kAnalytes.first;
      expect(a.aToB(double.nan).isNaN, isTrue);
      expect(a.bToA(double.infinity).isNaN, isTrue);
    });
  });

  group('reference ranges', () {
    Analyte byId(String id) => kAnalytes.firstWhere((a) => a.id == id);

    test('glucose verdicts match ADA fasting boundaries', () {
      final a = byId('glucose');
      expect(a.range(60).verdict, 'Low');
      expect(a.range(94).verdict, 'Normal');
      expect(a.range(110).verdict, 'Pre-diab.');
      expect(a.range(126).verdict, 'Diabetic');
    });

    test('HbA1c verdicts (ADA bands)', () {
      final a = byId('hba1c');
      expect(a.range(5.0).verdict, 'Normal');
      expect(a.range(5.7).verdict, 'Pre-diabetic');
      expect(a.range(6.4).verdict, 'Pre-diabetic');
      expect(a.range(6.5).verdict, 'Diabetic');
    });

    test('cholesterol verdicts', () {
      final a = byId('cholesterol');
      expect(a.range(150).verdict, 'Desirable');
      expect(a.range(200).verdict, 'Borderline high');
      expect(a.range(239).verdict, 'Borderline high');
      expect(a.range(240).verdict, 'High');
    });

    test('creatinine verdicts', () {
      final a = byId('creatinine');
      expect(a.range(0.5).verdict, 'Below typical');
      expect(a.range(1.0).verdict, 'Typical');
      expect(a.range(1.5).verdict, 'Above typical');
    });

    test('triglycerides verdicts', () {
      final a = byId('triglycerides');
      expect(a.range(100).verdict, 'Normal');
      expect(a.range(150).verdict, 'Borderline high');
      expect(a.range(200).verdict, 'High');
      expect(a.range(500).verdict, 'Very high');
    });

    test('marker pct is clamped to 0–100 and increases with value', () {
      for (final a in kAnalytes) {
        double prev = -1;
        for (final v in [0.0, 1.0, 5.0, 50.0, 200.0, 10000.0]) {
          final pct = a.range(v).pct;
          expect(pct, inInclusiveRange(0, 100), reason: '${a.id} @ $v');
          expect(pct, greaterThanOrEqualTo(prev), reason: '${a.id} @ $v');
          prev = pct;
        }
      }
    });

    test('every analyte exposes bar segments for the range strip', () {
      for (final a in kAnalytes) {
        expect(a.segs.length, greaterThanOrEqualTo(3), reason: a.id);
        for (final s in a.segs) {
          expect(s.flex, greaterThan(0));
          expect(s.label, isNotEmpty);
          expect(s.rangeText, isNotEmpty);
        }
      }
    });
  });
}
