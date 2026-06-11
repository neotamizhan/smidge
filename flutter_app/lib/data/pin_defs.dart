import 'package:flutter/material.dart';
import '../design/colors.dart';
import '../design/doodles.dart';

/// The five pinnable quick conversions offered during onboarding.
/// Shared by the home pinned shelf and the Pins screen so the two
/// can't drift apart.
class PinDef {
  final String id;
  final String cat; // category id; cooking/medical open vertical screens
  final String? from; // unit keys for setCategory; null for verticals
  final String? to;
  final String a; // display labels
  final String b;
  final DoodleKind doodle;
  final Color accent;
  final String note;
  final String sampleVal; // example input shown on the Pins screen
  const PinDef(this.id, this.cat, this.from, this.to, this.a, this.b,
      this.doodle, this.accent, this.note, this.sampleVal);
}

const List<PinDef> kPinDefs = [
  PinDef('temp', 'temperature', 'F', 'C', '°F', '°C', DoodleKind.therm,
      C.terra, 'temperature', '72'),
  PinDef('flour', 'cooking', null, null, 'cup', 'g', DoodleKind.cup,
      C.mustard, 'all-purpose flour', '1'),
  PinDef('glucose', 'medical', null, null, 'mg/dL', 'mmol/L', DoodleKind.drop,
      C.sage, 'blood glucose', '94'),
  PinDef('dist', 'length', 'mi', 'km', 'mi', 'km', DoodleKind.ruler, C.sky,
      'distance', '1'),
  PinDef('weight', 'mass', 'lb', 'kg', 'lb', 'kg', DoodleKind.scale,
      C.inkSoft, 'mass', '1'),
];

final Map<String, PinDef> kPinDefById = {for (final p in kPinDefs) p.id: p};
