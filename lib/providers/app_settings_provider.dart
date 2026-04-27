import 'package:flutter/material.dart';

class AppSettings {
  final ThemeMode themeMode;
  final bool notificationsEnabled;

  const AppSettings({
    this.themeMode = ThemeMode.system,
    this.notificationsEnabled = true,
  });

  AppSettings copyWith({
    ThemeMode? themeMode,
    bool? notificationsEnabled,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }
}

class AppSettingsProvider extends InheritedWidget {
  final AppSettings settings;
  final ValueChanged<AppSettings> onSettingsChanged;

  const AppSettingsProvider({
    super.key,
    required this.settings,
    required this.onSettingsChanged,
    required super.child,
  });

  static AppSettingsProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppSettingsProvider>();
  }

  @override
  bool updateShouldNotify(AppSettingsProvider oldWidget) {
    return settings.themeMode != oldWidget.settings.themeMode ||
        settings.notificationsEnabled != oldWidget.settings.notificationsEnabled;
  }
}
