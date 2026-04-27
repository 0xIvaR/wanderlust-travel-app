import 'package:flutter/material.dart';
import '../providers/user_profile_provider.dart';

class CustomAppBar extends StatelessWidget {
  final VoidCallback? onSettingsPressed;

  const CustomAppBar({
    super.key,
    this.onSettingsPressed,
  });

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final profileProvider = UserProfileProvider.of(context);
    final userName = profileProvider?.profile.name ?? 'Alex';
    final avatarAsset = profileProvider?.profile.avatarAsset ?? 'assets/avatar_1.png';
    final greeting = _getGreeting();

    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(avatarAsset),
              backgroundColor: colorScheme.primaryContainer,
            ),
            const SizedBox(width: 12),
            // Greeting text
            Expanded(
              child: Text(
                '$greeting, $userName',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            // Settings button - M3 FilledTonalIconButton style
            IconButton.filledTonal(
              onPressed: onSettingsPressed ?? () {},
              icon: const Icon(Icons.settings_outlined),
              style: IconButton.styleFrom(
                backgroundColor: colorScheme.secondaryContainer,
                foregroundColor: colorScheme.onSecondaryContainer,
              ),
            ),
          ],
        ),
    );
  }
}

