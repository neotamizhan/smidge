import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smidge/state/app_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('AppState.togglePin', () {
    test('unpins an already-pinned id', () {
      final s = AppState(); // defaults: temp, flour, glucose
      s.togglePin('flour');
      expect(s.pins, ['temp', 'glucose']);
    });

    test('appends when fewer than three are pinned', () {
      final s = AppState();
      s.togglePin('flour'); // down to 2
      s.togglePin('dist');
      expect(s.pins, ['temp', 'glucose', 'dist']);
    });

    test('replaces the oldest pin when three are already pinned', () {
      final s = AppState();
      s.togglePin('dist');
      expect(s.pins, ['flour', 'glucose', 'dist']);
    });

    test('notifies listeners', () {
      final s = AppState();
      var notified = 0;
      s.addListener(() => notified++);
      s.togglePin('weight');
      expect(notified, 1);
    });

    test('persists the change', () async {
      final s = AppState();
      s.togglePin('weight');
      await pumpEventQueue();

      final reloaded = AppState();
      await reloaded.load();
      expect(reloaded.pins, ['flour', 'glucose', 'weight']);
    });
  });
}
