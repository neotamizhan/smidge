import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../data/units.dart';
import '../data/convert.dart';
import '../data/format.dart';

enum InputSide { from, to }

class AppState extends ChangeNotifier {
  String category = 'length';
  String fromUnit = 'km';
  String toUnit = 'mi';
  String expression = '1';
  bool exprMode = false;
  InputSide inputSide = InputSide.from;
  List<String> pins = ['temp', 'flour', 'glucose'];
  List<String> preferredCategories = [
    'length',
    'mass',
    'temperature',
    'cooking',
  ];
  String system = 'metric';
  int decimals = 4;

  bool _loaded = false;
  bool get loaded => _loaded;

  Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    final raw = p.getString('smidge_state');
    if (raw != null) {
      try {
        final j = json.decode(raw) as Map<String, dynamic>;
        category = j['category'] ?? category;
        fromUnit = j['fromUnit'] ?? fromUnit;
        toUnit = j['toUnit'] ?? toUnit;
        expression = j['expression'] ?? expression;
        exprMode = j['exprMode'] ?? exprMode;
        inputSide = (j['inputSide'] == 'to') ? InputSide.to : InputSide.from;
        pins = (j['pins'] as List?)?.cast<String>() ?? pins;
        preferredCategories =
            (j['preferredCategories'] as List?)?.cast<String>() ??
                preferredCategories;
        system = j['system'] ?? system;
        decimals = j['decimals'] ?? decimals;
      } catch (_) {}
    }
    _loaded = true;
    notifyListeners();
  }

  Future<void> persist() async {
    final p = await SharedPreferences.getInstance();
    final j = json.encode({
      'category': category,
      'fromUnit': fromUnit,
      'toUnit': toUnit,
      'expression': expression,
      'exprMode': exprMode,
      'inputSide': inputSide == InputSide.to ? 'to' : 'from',
      'pins': pins,
      'preferredCategories': preferredCategories,
      'system': system,
      'decimals': decimals,
    });
    await p.setString('smidge_state', j);
  }

  static Future<bool> isOnboarded() async {
    final p = await SharedPreferences.getInstance();
    return p.getString('smidge_onboarded') == '1';
  }

  static Future<void> setOnboarded() async {
    final p = await SharedPreferences.getInstance();
    await p.setString('smidge_onboarded', '1');
  }

  // ── Actions ──
  void onKey(String k) {
    var expr = expression;
    if (k == '⌫') {
      expr = expr.length > 1 ? expr.substring(0, expr.length - 1) : '0';
    } else if (k == '.') {
      final m = RegExp(r'[^+\-×÷*/]*$').firstMatch(expr);
      final lastNum = m?.group(0) ?? '';
      if (!lastNum.contains('.')) expr = '$expr.';
    } else if (k == '=') {
      final val = evalExpr(expr);
      if (val != null) {
        expr = double.parse(val.toStringAsFixed(10)).toString();
        if (expr.endsWith('.0')) expr = expr.substring(0, expr.length - 2);
      }
    } else if ('0123456789'.contains(k)) {
      if (expr == '0') {
        expr = k;
      } else if (expr.length < 20) {
        expr = '$expr$k';
      }
    } else {
      if (expr.length < 40) expr = '$expr$k';
    }
    expression = expr;
    notifyListeners();
    persist();
  }

  void swap() {
    final tmp = fromUnit;
    fromUnit = toUnit;
    toUnit = tmp;
    notifyListeners();
    persist();
  }

  void setSide(InputSide side) {
    if (side == inputSide) return;
    final rawVal = evalExpr(expression) ?? double.tryParse(expression);
    String newExpr = '0';
    if (rawVal != null && rawVal.isFinite) {
      if (side == InputSide.to) {
        final c = convert(rawVal, fromUnit, toUnit, category);
        if (c.isFinite) {
          newExpr = double.parse(c.toStringAsFixed(10)).toString();
          if (newExpr.endsWith('.0')) {
            newExpr = newExpr.substring(0, newExpr.length - 2);
          }
        }
      } else {
        newExpr = double.parse(rawVal.toStringAsFixed(10)).toString();
        if (newExpr.endsWith('.0')) {
          newExpr = newExpr.substring(0, newExpr.length - 2);
        }
      }
    }
    inputSide = side;
    expression = newExpr;
    notifyListeners();
    persist();
  }

  void setCategory(String cat, {String? from, String? to}) {
    final c = kCategories[cat];
    if (c == null) return;
    category = cat;
    fromUnit = from ?? c.defaultFrom;
    toUnit = to ?? c.defaultTo;
    expression = '1';
    inputSide = InputSide.from;
    exprMode = false;
    notifyListeners();
    persist();
  }

  void setUnit(InputSide side, String unit) {
    if (side == InputSide.from) {
      fromUnit = unit;
    } else {
      toUnit = unit;
    }
    notifyListeners();
    persist();
  }

  void toggleExpr() {
    exprMode = !exprMode;
    notifyListeners();
    persist();
  }

  void setSystem(String s) {
    system = s;
    notifyListeners();
    persist();
  }

  void setPins(List<String> list) {
    pins = list;
    notifyListeners();
    persist();
  }

  void setPreferredCategories(List<String> list) {
    preferredCategories = list;

    // Safety fallback
    if (preferredCategories.isEmpty) {
      preferredCategories = ['length'];
    }

    // Ensure current category still exists
    if (!preferredCategories.contains(category)) {
      setCategory(preferredCategories.first);
      return;
    }

    notifyListeners();
    persist();
  }

  // Convenience: get currently shown values for from/to
  String get fromDisplay {
    final parsed = evalExpr(expression) ?? double.tryParse(expression);
    if (inputSide == InputSide.from) return expression;
    if (parsed == null || !parsed.isFinite) return '';
    final v = convert(parsed, toUnit, fromUnit, category);
    return fmt(v);
  }

  String get toDisplay {
    final parsed = evalExpr(expression) ?? double.tryParse(expression);
    if (inputSide == InputSide.to) return expression;
    if (parsed == null || !parsed.isFinite) return '';
    final v = convert(parsed, fromUnit, toUnit, category);
    return fmt(v);
  }
}
