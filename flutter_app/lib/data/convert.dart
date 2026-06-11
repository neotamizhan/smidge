import 'units.dart';

double convertTemp(double val, String from, String to) {
  double toC;
  switch (from) {
    case 'C': toC = val; break;
    case 'F': toC = (val - 32) * 5 / 9; break;
    case 'K': toC = val - 273.15; break;
    case 'R': toC = (val - 491.67) * 5 / 9; break;
    default: return double.nan;
  }
  switch (to) {
    case 'C': return toC;
    case 'F': return toC * 9 / 5 + 32;
    case 'K': return toC + 273.15;
    case 'R': return toC * 9 / 5 + 491.67;
  }
  return double.nan;
}

double convert(double value, String fromKey, String toKey, String catKey) {
  if (!value.isFinite) return double.nan;
  final cat = kCategories[catKey];
  if (cat == null) return double.nan;
  if (cat.special) return convertTemp(value, fromKey, toKey);
  final from = cat.units[fromKey];
  final to = cat.units[toKey];
  if (from == null || to == null) return double.nan;
  return (value * from.factor) / to.factor;
}

// ── Cooking density data (grams per 1 US cup) ──
class Ingredient {
  final String id;
  final String name;
  final double gramsPerCup;
  const Ingredient(this.id, this.name, this.gramsPerCup);
}

const List<Ingredient> kIngredients = [
  Ingredient('flour_ap',    'All-purpose flour, unsifted', 125),
  Ingredient('flour_ap_s',  'All-purpose flour, sifted',   110),
  Ingredient('flour_bread', 'Bread flour',                 127),
  Ingredient('flour_cake',  'Cake flour, sifted',          100),
  Ingredient('sugar',       'Sugar, granulated',           200),
  Ingredient('sugar_br',    'Sugar, brown (packed)',       220),
  Ingredient('sugar_pw',    'Powdered sugar, sifted',      120),
  Ingredient('butter',      'Butter',                      227),
  Ingredient('honey',       'Honey',                       340),
  Ingredient('water',       'Water',                       237),
  Ingredient('milk',        'Milk, whole',                 244),
  Ingredient('oil',         'Vegetable oil',               218),
  Ingredient('rice',        'Rice, white (uncooked)',      185),
  Ingredient('oats',        'Oats, rolled',                90),
  Ingredient('cocoa',       'Cocoa powder, natural',       100),
  Ingredient('salt',        'Salt, fine',                  240),
  Ingredient('almond_fl',   'Almond flour',                96),
  Ingredient('cornstarch',  'Cornstarch',                  120),
  Ingredient('breadcrumbs', 'Breadcrumbs, dry',            108),
];

const double kUsCupMl = 236.588;

double cookingConvert(double cups, String ingredientId, String targetUnit) {
  final ing = kIngredients.firstWhere(
    (i) => i.id == ingredientId,
    orElse: () => kIngredients.first,
  );
  final grams = cups * ing.gramsPerCup;
  switch (targetUnit) {
    case 'g':  return grams;
    case 'oz': return grams / 28.3495;
    case 'lb': return grams / 453.592;
    case 'kg': return grams / 1000;
    case 'mL': return cups * kUsCupMl;
  }
  return grams;
}

// ── Medical — glucose ──
const double kGlucoseFactor = 18.016;

double convertGlucose(double val, String from, String to) {
  if (!val.isFinite) return double.nan;
  double mgdL;
  if (from == 'mgdL') {
    mgdL = val;
  } else if (from == 'mmolL') {
    mgdL = val * kGlucoseFactor;
  } else {
    return double.nan;
  }
  if (to == 'mgdL') return mgdL;
  if (to == 'mmolL') return mgdL / kGlucoseFactor;
  return double.nan;
}

// ── Medical — analytes (glucose, HbA1c, lipids, creatinine) ──
class AnalyteSeg {
  final int flex; // width weight in the range strip
  final double lo;
  final double hi; // last segment's hi is the visual max for the marker
  final String label; // short label under the strip
  final String rangeText; // bounds caption under the strip
  final String verdict; // sentence-case verdict for the context box
  final int colorValue; // ARGB
  const AnalyteSeg(this.flex, this.lo, this.hi, this.label, this.rangeText,
      this.verdict, this.colorValue);
}

class AnalyteReading {
  final AnalyteSeg seg;
  final double pct; // marker position across the strip, 0–100
  const AnalyteReading(this.seg, this.pct);
  String get verdict => seg.verdict;
  int get colorValue => seg.colorValue;
}

class Analyte {
  final String id;
  final String tabLabel;
  final String title; // e.g. 'blood glucose'
  final String unitA; // canonical input unit, e.g. 'mg/dL'
  final String unitB;
  final double factor; // B = (A − offset) × factor
  final double offset; // non-zero only for HbA1c (NGSP→IFCC)
  final int decimalsA; // display decimals when converting into unit A
  final int decimalsB;
  final String defaultValue; // initial input, in unit A
  final String rangeTitle;
  final String note;
  final List<AnalyteSeg> segs; // contiguous, in unit A
  const Analyte({
    required this.id,
    required this.tabLabel,
    required this.title,
    required this.unitA,
    required this.unitB,
    required this.factor,
    this.offset = 0,
    required this.decimalsA,
    required this.decimalsB,
    required this.defaultValue,
    required this.rangeTitle,
    required this.note,
    required this.segs,
  });

  double aToB(double a) => a.isFinite ? (a - offset) * factor : double.nan;
  double bToA(double b) => b.isFinite ? b / factor + offset : double.nan;

  AnalyteReading range(double valInA) {
    var below = 0.0;
    final total = segs.fold<int>(0, (s, e) => s + e.flex);
    for (final seg in segs) {
      final isLast = identical(seg, segs.last);
      if (valInA < seg.hi || isLast) {
        final span = seg.hi - seg.lo;
        final within =
            span > 0 ? ((valInA - seg.lo) / span).clamp(0.0, 1.0) : 0.0;
        final pct = (below + within * seg.flex) / total * 100;
        return AnalyteReading(seg, pct.clamp(0.0, 100.0));
      }
      below += seg.flex;
    }
    return AnalyteReading(segs.last, 100);
  }
}

const int _cSky = 0xFF7C95A8;
const int _cSage = 0xFF7B8A6F;
const int _cMustard = 0xFFC89A3A;
const int _cTerra = 0xFFC4593A;
const int _cTerraDeep = 0xFFA34428;

const List<Analyte> kAnalytes = [
  Analyte(
    id: 'glucose',
    tabLabel: 'Glucose',
    title: 'blood glucose',
    unitA: 'mg/dL',
    unitB: 'mmol/L',
    factor: 1 / kGlucoseFactor,
    decimalsA: 0,
    decimalsB: 2,
    defaultValue: '94',
    rangeTitle: 'where this sits · fasting (ADA)',
    note: 'ADA reference · educational only — discuss with your clinician.',
    segs: [
      AnalyteSeg(20, 0, 70, 'low', '< 70', 'Low', _cSky),
      AnalyteSeg(35, 70, 100, 'normal', '70–99', 'Normal', _cSage),
      AnalyteSeg(20, 100, 126, 'pre-diab', '100–125', 'Pre-diab.', _cMustard),
      AnalyteSeg(25, 126, 200, 'diabetic', '≥ 126', 'Diabetic', _cTerra),
    ],
  ),
  Analyte(
    id: 'hba1c',
    tabLabel: 'HbA1c',
    title: 'haemoglobin A1c',
    unitA: '%',
    unitB: 'mmol/mol',
    factor: 10.929, // IFCC = 10.929 × (NGSP% − 2.15)
    offset: 2.15,
    decimalsA: 1,
    decimalsB: 0,
    defaultValue: '5.6',
    rangeTitle: 'where this sits · HbA1c (ADA)',
    note: 'ADA reference · educational only — discuss with your clinician.',
    segs: [
      AnalyteSeg(15, 0, 4.0, 'low', '< 4.0', 'Low', _cSky),
      AnalyteSeg(35, 4.0, 5.7, 'normal', '4.0–5.6', 'Normal', _cSage),
      AnalyteSeg(25, 5.7, 6.5, 'pre-diab', '5.7–6.4', 'Pre-diabetic', _cMustard),
      AnalyteSeg(25, 6.5, 14, 'diabetic', '≥ 6.5', 'Diabetic', _cTerra),
    ],
  ),
  Analyte(
    id: 'cholesterol',
    tabLabel: 'Cholest.',
    title: 'total cholesterol',
    unitA: 'mg/dL',
    unitB: 'mmol/L',
    factor: 1 / 38.67,
    decimalsA: 0,
    decimalsB: 2,
    defaultValue: '180',
    rangeTitle: 'where this sits · total cholesterol',
    note:
        'NCEP ATP III reference · educational only — discuss with your clinician.',
    segs: [
      AnalyteSeg(40, 0, 200, 'desirable', '< 200', 'Desirable', _cSage),
      AnalyteSeg(
          30, 200, 240, 'borderline', '200–239', 'Borderline high', _cMustard),
      AnalyteSeg(30, 240, 320, 'high', '≥ 240', 'High', _cTerra),
    ],
  ),
  Analyte(
    id: 'creatinine',
    tabLabel: 'Creat.',
    title: 'serum creatinine',
    unitA: 'mg/dL',
    unitB: 'µmol/L',
    factor: 88.42,
    decimalsA: 2,
    decimalsB: 0,
    defaultValue: '1.0',
    rangeTitle: 'where this sits · adult reference',
    note:
        'Typical adult range — varies by sex & muscle mass · educational only — discuss with your clinician.',
    segs: [
      AnalyteSeg(25, 0, 0.6, 'low', '< 0.6', 'Below typical', _cSky),
      AnalyteSeg(45, 0.6, 1.3, 'typical', '0.6–1.3', 'Typical', _cSage),
      AnalyteSeg(30, 1.3, 2.6, 'high', '> 1.3', 'Above typical', _cTerra),
    ],
  ),
  Analyte(
    id: 'triglycerides',
    tabLabel: 'Trig.',
    title: 'triglycerides',
    unitA: 'mg/dL',
    unitB: 'mmol/L',
    factor: 1 / 88.57,
    decimalsA: 0,
    decimalsB: 2,
    defaultValue: '120',
    rangeTitle: 'where this sits · fasting',
    note: 'NCEP reference · educational only — discuss with your clinician.',
    segs: [
      AnalyteSeg(30, 0, 150, 'normal', '< 150', 'Normal', _cSage),
      AnalyteSeg(
          20, 150, 200, 'borderline', '150–199', 'Borderline high', _cMustard),
      AnalyteSeg(30, 200, 500, 'high', '200–499', 'High', _cTerra),
      AnalyteSeg(20, 500, 1000, 'very high', '≥ 500', 'Very high', _cTerraDeep),
    ],
  ),
];

// ── Trades — ft/in/fraction ──
class FtInFrac {
  final int feet;
  final int inches;
  final int num;
  final int den;
  FtInFrac(this.feet, this.inches, this.num, this.den);
}

int _gcd(int a, int b) => b == 0 ? a : _gcd(b, a % b);

FtInFrac mmToFtInFrac(double mm, {int denom = 16}) {
  final totalIn = mm / 25.4;
  final feet = totalIn ~/ 12;
  final rem = totalIn - feet * 12;
  final whole = rem.floor();
  final frac = rem - whole;
  var num = (frac * denom).round();
  final den = denom;
  if (num == den) return FtInFrac(feet, whole + 1, 0, 1);
  if (num == 0) return FtInFrac(feet, whole, 0, 1);
  final g = _gcd(num, den);
  return FtInFrac(feet, whole, num ~/ g, den ~/ g);
}

// ── Currency (static snapshot) ──
class Currency {
  final String sym;
  final String flag;
  final String name;
  final double rate; // relative to USD = 1
  const Currency(this.sym, this.flag, this.name, this.rate);
}

const Map<String, Currency> kCurrencies = {
  'USD': Currency(r'$',   '🇺🇸', 'US Dollar',        1),
  'EUR': Currency('€',    '🇪🇺', 'Euro',              0.9205),
  'GBP': Currency('£',    '🇬🇧', 'Pound Sterling',    0.7856),
  'INR': Currency('₹',    '🇮🇳', 'Indian Rupee',      83.33),
  'JPY': Currency('¥',    '🇯🇵', 'Japanese Yen',      155.0),
  'CAD': Currency(r'$',   '🇨🇦', 'Canadian Dollar',   1.365),
  'AUD': Currency(r'$',   '🇦🇺', 'Australian Dollar', 1.532),
  'CHF': Currency('Fr',   '🇨🇭', 'Swiss Franc',       0.897),
  'CNY': Currency('¥',    '🇨🇳', 'Chinese Yuan',      7.244),
  'MXN': Currency(r'$',   '🇲🇽', 'Mexican Peso',      17.15),
  'BRL': Currency(r'R$',  '🇧🇷', 'Brazilian Real',    5.08),
  'SGD': Currency(r'$',   '🇸🇬', 'Singapore Dollar',  1.342),
  'AED': Currency('د.إ',  '🇦🇪', 'UAE Dirham',        3.673),
  'KRW': Currency('₩',    '🇰🇷', 'South Korean Won',  1368),
};
