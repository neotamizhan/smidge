import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'convert.dart';

const _kRatesKey = 'fx_rates_json';
const _kTimestampKey = 'fx_rates_ts';
const _kMaxAgeMs = 4 * 60 * 60 * 1000; // 4 hours

class FxService {
  static const _required = [
    'EUR',
    'GBP',
    'INR',
    'JPY',
    'CAD',
    'AUD',
    'CHF',
    'CNY',
    'MXN',
    'BRL',
    'SGD',
    'AED',
    'KRW'
  ];

  static Future<Map<String, double>> getRates() async {
    final prefs = await SharedPreferences.getInstance();

    // 1. Check cache freshness
    final ts = prefs.getInt(_kTimestampKey) ?? 0;
    final age = DateTime.now().millisecondsSinceEpoch - ts;

    if (age < _kMaxAgeMs) {
      final cached = prefs.getString(_kRatesKey);
      if (cached != null) {
        final parsed = _safeParse(cached);
        if (parsed != null) return parsed; // valid → use
        // null = corrupted → fall through to fetch
      }
    }

    // 2. Try fetch
    try {
      final res = await http
          .get(Uri.parse('https://api.frankfurter.app/latest?base=USD'))
          .timeout(const Duration(seconds: 6));

      if (res.statusCode == 200) {
        // Save to cache
        await prefs.setString(_kRatesKey, res.body);
        await prefs.setInt(
            _kTimestampKey, DateTime.now().millisecondsSinceEpoch);
        final rates = _safeParse(res.body) ?? _bundled();
        for (final sym in _required) {
          rates.putIfAbsent(sym, () => kCurrencies[sym]?.rate ?? 1.0);
        }
        return rates;
      }
    } catch (e) {
      // network dead → fall through
      debugPrint('FxService.getRates: network error → $e');
    }

    final stale = prefs.getString(_kRatesKey);
    if (stale != null) {
      final parsed = _safeParse(stale);
      if (parsed != null) {
        for (final sym in _required) {
          parsed.putIfAbsent(sym, () => kCurrencies[sym]?.rate ?? 1.0);
        }
        return parsed;
      }
    }

    return _bundled(); // kCurrencies fallback
  }

  static Map<String, double>? _safeParse(String json) {
    try {
      final data = jsonDecode(json) as Map<String, dynamic>;
      final rates = Map<String, double>.from(
        (data['rates'] as Map)
            .map((k, v) => MapEntry(k, (v as num).toDouble())),
      );
      rates['USD'] = 1.0;
      return rates;
    } catch (e) {
      debugPrint('FxService._safeParse: corrupted cache → $e');
      return null;
    }
  }

  static Map<String, double> _bundled() {
    return {
      for (final e in kCurrencies.entries) e.key: e.value.rate,
    };
  }

  // Returns null if never fetched, else DateTime
  static Future<DateTime?> lastUpdated() async {
    final prefs = await SharedPreferences.getInstance();
    final ts = prefs.getInt(_kTimestampKey);
    if (ts == null || ts == 0) return null;
    return DateTime.fromMillisecondsSinceEpoch(ts);
  }

  static Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kRatesKey);
    await prefs.remove(_kTimestampKey);
  }
}
