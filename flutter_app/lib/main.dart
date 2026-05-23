import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'design/colors.dart';
import 'state/app_state.dart';
import 'screens/onboarding.dart';
import 'screens/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(const SmidgeApp());
}

class SmidgeApp extends StatelessWidget {
  const SmidgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smidge',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: C.paper,
        textTheme: GoogleFonts.manropeTextTheme().apply(
          bodyColor: C.ink,
          displayColor: C.ink,
        ),
        primaryColor: C.terra,
        useMaterial3: true,
      ),
      home: const _Root(),
    );
  }
}

class _Root extends StatefulWidget {
  const _Root();
  @override
  State<_Root> createState() => _RootState();
}

class _RootState extends State<_Root> {
  final _state = AppState();
  bool? _onboarded;
  int _obStep = 0; // 0=splash 1=welcome 2=cats 3=pref 4=pins

  final Set<String> _obCats = {'length','mass','temperature','cooking'};
  String _obSystem = 'metric';
  final Set<String> _obPins = {'temp','flour','glucose'};

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _state.load();
    final done = await AppState.isOnboarded();
    setState(() => _onboarded = done);
    if (!done) {
      // splash → welcome after 1.5s
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted && _obStep == 0) setState(() => _obStep = 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_onboarded == null) {
      return const ScrSplash();
    }
    if (!_onboarded!) {
      Widget body;
      switch (_obStep) {
        case 0: body = const ScrSplash(); break;
        case 1: body = ScrWelcome(onNext: () => setState(() => _obStep = 2)); break;
        case 2:
          body = ScrPickCats(
            selected: _obCats,
            onToggle: (id) => setState(() {
              if (_obCats.contains(id)) {
                _obCats.remove(id);
              } else {
                _obCats.add(id);
              }
            }),
            onNext: () => setState(() => _obStep = 3),
          );
          break;
        case 3:
          body = ScrPref(
            system: _obSystem,
            onChange: (s) => setState(() => _obSystem = s),
            onNext: () => setState(() => _obStep = 4),
          );
          break;
        default:
          body = ScrPinThree(
            pins: _obPins,
            onToggle: (id) => setState(() {
              if (_obPins.contains(id)) {
                _obPins.remove(id);
              } else if (_obPins.length >= 3) {
                _obPins.remove(_obPins.first);
                _obPins.add(id);
              } else {
                _obPins.add(id);
              }
            }),
            onDone: () async {
              _state.setSystem(_obSystem);
              _state.setPins(_obPins.toList());
              await AppState.setOnboarded();
              if (!mounted) return;
              setState(() => _onboarded = true);
            },
          );
      }
      return body;
    }
    return AnimatedBuilder(
      animation: _state,
      builder: (_, __) => ScrHome(state: _state),
    );
  }
}
