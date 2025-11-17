import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeService {
  ThemeService._privateConstructor();
  static final ThemeService instance = ThemeService._privateConstructor();

  /// Value notifier the app listens to
  final ValueNotifier<ThemeMode> notifier = ValueNotifier(ThemeMode.system);

  static const _boxName = 'tradingData'; // re-use your box
  static const _key = 'themeMode'; // stored as String: 'system'|'light'|'dark'

  /// Call this once after Hive is open
  Future<void> init() async {
    try {
      final box = Hive.box(_boxName);
      final raw = box.get(_key);

      if (raw == null) {
        // default
        notifier.value = ThemeMode.system;
      } else if (raw == 'light') {
        notifier.value = ThemeMode.light;
      } else if (raw == 'dark') {
        notifier.value = ThemeMode.dark;
      } else {
        notifier.value = ThemeMode.system;
      }
    } catch (e) {
      // fallback
      notifier.value = ThemeMode.system;
    }
  }

  /// set and persist mode
  Future<void> setThemeMode(ThemeMode mode) async {
    notifier.value = mode;
    final box = Hive.box(_boxName);
    final String storeValue = mode == ThemeMode.light
        ? 'light'
        : mode == ThemeMode.dark
        ? 'dark'
        : 'system';
    await box.put(_key, storeValue);
  }

  /// convenience toggle: cycles light -> dark -> system -> light...
  Future<void> cycleTheme() async {
    final current = notifier.value;
    ThemeMode next;
    if (current == ThemeMode.light) {
      next = ThemeMode.dark;
    } else if (current == ThemeMode.dark) {
      next = ThemeMode.system;
    } else {
      next = ThemeMode.light;
    }
    await setThemeMode(next);
  }

  /// convenience toggle between light/dark only
  Future<void> toggleLightDark() async {
    final current = notifier.value;
    final next = (current == ThemeMode.dark) ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(next);
  }
}
