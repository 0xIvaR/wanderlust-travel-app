import 'package:flutter/material.dart';
import '../providers/app_settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final settingsProvider = AppSettingsProvider.of(context);
    final settings = settingsProvider?.settings ?? const AppSettings();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          // Theme Mode
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Text(
              'Appearance',
              style: textTheme.labelLarge?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            elevation: 0,
            color: colorScheme.surfaceContainerLow,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Theme',
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: SegmentedButton<ThemeMode>(
                      segments: const [
                        ButtonSegment<ThemeMode>(
                          value: ThemeMode.system,
                          label: Text('System'),
                          icon: Icon(Icons.brightness_auto_outlined),
                        ),
                        ButtonSegment<ThemeMode>(
                          value: ThemeMode.light,
                          label: Text('Light'),
                          icon: Icon(Icons.light_mode_outlined),
                        ),
                        ButtonSegment<ThemeMode>(
                          value: ThemeMode.dark,
                          label: Text('Dark'),
                          icon: Icon(Icons.dark_mode_outlined),
                        ),
                      ],
                      selected: {settings.themeMode},
                      onSelectionChanged: (Set<ThemeMode> selected) {
                        settingsProvider?.onSettingsChanged(
                          settings.copyWith(themeMode: selected.first),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Notifications
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Text(
              'Preferences',
              style: textTheme.labelLarge?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            elevation: 0,
            color: colorScheme.surfaceContainerLow,
            child: Column(
              children: [
                SwitchListTile(
                  secondary: Icon(Icons.notifications_outlined,
                      color: colorScheme.primary),
                  title: const Text('Notifications'),
                  subtitle: const Text('Receive travel alerts and updates'),
                  value: settings.notificationsEnabled,
                  onChanged: (value) {
                    settingsProvider?.onSettingsChanged(
                      settings.copyWith(notificationsEnabled: value),
                    );
                  },
                ),
                Divider(height: 1, color: colorScheme.outlineVariant),
                ListTile(
                  leading: Icon(Icons.language_outlined,
                      color: colorScheme.primary),
                  title: const Text('Language'),
                  subtitle: const Text('English'),
                  trailing: Icon(Icons.chevron_right,
                      color: colorScheme.onSurfaceVariant),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('More languages coming soon'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Data & Storage
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Text(
              'Data & Storage',
              style: textTheme.labelLarge?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            elevation: 0,
            color: colorScheme.surfaceContainerLow,
            child: ListTile(
              leading: Icon(Icons.delete_outline, color: colorScheme.primary),
              title: const Text('Clear Cache'),
              subtitle: const Text('Free up storage space'),
              trailing: Icon(Icons.chevron_right,
                  color: colorScheme.onSurfaceVariant),
              onTap: () => _showClearCacheDialog(context),
            ),
          ),

          const SizedBox(height: 16),

          // About
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Text(
              'About',
              style: textTheme.labelLarge?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            elevation: 0,
            color: colorScheme.surfaceContainerLow,
            child: Column(
              children: [
                ListTile(
                  leading:
                      Icon(Icons.info_outline, color: colorScheme.primary),
                  title: const Text('App Version'),
                  trailing: Text(
                    '1.0.0',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Divider(height: 1, color: colorScheme.outlineVariant),
                ListTile(
                  leading: Icon(Icons.privacy_tip_outlined,
                      color: colorScheme.primary),
                  title: const Text('Privacy Policy'),
                  trailing: Icon(Icons.chevron_right,
                      color: colorScheme.onSurfaceVariant),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Privacy Policy coming soon'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                Divider(height: 1, color: colorScheme.outlineVariant),
                ListTile(
                  leading: Icon(Icons.description_outlined,
                      color: colorScheme.primary),
                  title: const Text('Terms of Service'),
                  trailing: Icon(Icons.chevron_right,
                      color: colorScheme.onSurfaceVariant),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Terms of Service coming soon'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _showClearCacheDialog(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(Icons.delete_outline, color: colorScheme.error),
        title: const Text('Clear Cache?'),
        content: const Text(
          'This will remove all cached data including saved place information. You\'ll need to reload data next time.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cache cleared'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}
