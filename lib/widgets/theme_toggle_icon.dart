import 'package:flutter/material.dart';
import 'package:heat_map/services/theme_service.dart';

class ThemeToggleIcon extends StatelessWidget {
  /// mode: if true toggles between light/dark only, else cycles through system/light/dark
  final bool simpleToggle;

  const ThemeToggleIcon({super.key, this.simpleToggle = true});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeService.instance.notifier,
      builder: (context, mode, _) {
        IconData icon;
        String tooltip;

        if (mode == ThemeMode.light) {
          icon = Icons.wb_sunny;
          tooltip = 'Light mode';
        } else if (mode == ThemeMode.dark) {
          icon = Icons.nights_stay;
          tooltip = 'Dark mode';
        } else {
          icon = Icons.brightness_auto;
          tooltip = 'System theme';
        }

        return IconButton(
          icon: Icon(icon),
          tooltip: tooltip,
          onPressed: () async {
            if (simpleToggle) {
              await ThemeService.instance.toggleLightDark();
            } else {
              await ThemeService.instance.cycleTheme();
            }
          },
        );
      },
    );
  }
}
