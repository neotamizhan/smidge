import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'convert.dart';

const _kRatesKey = 'fx_rates_json';
const _kTimestampKey = 'fx_rates_ts';
const _kMaxAgeMs = 4 * 60 * 60 * 1000; // 4 hours

class FxService {
  static Future<Map<String, double>> getRates() async {
    final prefs = await SharedPreferences.getInstance();

    // 1. Check cache freshness
    final ts = prefs.getInt(_kTimestampKey) ?? 0;
    final age = DateTime.now().millisecondsSinceEpoch - ts;

    if (age < _kMaxAgeMs) {
      final cached = prefs.getString(_kRatesKey);
      if (cached != null) return _parse(cached);
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
        return _parse(res.body);
      }
    } catch (_) {
      // network dead → fall through
    }

    // 3. Last resort: stale cache or bundled snapshot
    final stale = prefs.getString(_kRatesKey);
    if (stale != null) return _parse(stale);

    return _bundled(); // kCurrencies fallback
  }

  static Map<String, double> _parse(String json) {
    final data = jsonDecode(json) as Map<String, dynamic>;
    final rates = Map<String, double>.from(
      (data['rates'] as Map).map((k, v) => MapEntry(k, (v as num).toDouble())),
    );
    rates['USD'] = 1.0; // base
    return rates;
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