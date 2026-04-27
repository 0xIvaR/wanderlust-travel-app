import 'package:flutter/material.dart';
import '../constants/city_options.dart';
import '../providers/user_profile_provider.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final profileProvider = UserProfileProvider.of(context);
    final profile = profileProvider?.profile ?? const UserProfile();

    return SafeArea(
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          const SizedBox(height: 32),

          Center(
            child: Hero(
              tag: 'profile_avatar',
              child: CircleAvatar(
                radius: 56,
                backgroundColor: colorScheme.primaryContainer,
                backgroundImage: AssetImage(profile.avatarAsset),
              ),
            ),
          ),
          const SizedBox(height: 16),

          Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                profile.name,
                key: ValueKey(profile.name),
                style: textTheme.headlineMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),

          Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                _buildSubtitle(profile),
                key: ValueKey(_buildSubtitle(profile)),
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),

          // Mobile number
          if (profile.mobileNumber != null &&
              profile.mobileNumber!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Center(
              child: Text(
                profile.mobileNumber!,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],

          const SizedBox(height: 24),

          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton.icon(
                onPressed: () => _showEditProfileSheet(context, profile),
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Edit Profile'),
              ),
              const SizedBox(width: 12),
              FilledButton.tonalIcon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const SettingsScreen()),
                  );
                },
                icon: const Icon(Icons.settings_outlined),
                label: const Text('Settings'),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Menu items
          Card(
            elevation: 0,
            color: colorScheme.surfaceContainerLow,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.bookmark_outline,
                      color: colorScheme.primary),
                  title: const Text('Saved Destinations'),
                  trailing: Icon(Icons.chevron_right,
                      color: colorScheme.onSurfaceVariant),
                  onTap: () => _showEmptyState(
                    context,
                    icon: Icons.bookmark_outline,
                    title: 'No saved destinations yet',
                    subtitle:
                        'Places you save will appear here for quick access.',
                  ),
                ),
                Divider(height: 1, color: colorScheme.outlineVariant),
                ListTile(
                  leading: Icon(Icons.history_outlined,
                      color: colorScheme.primary),
                  title: const Text('Travel History'),
                  trailing: Icon(Icons.chevron_right,
                      color: colorScheme.onSurfaceVariant),
                  onTap: () => _showEmptyState(
                    context,
                    icon: Icons.history_outlined,
                    title: 'No travel history yet',
                    subtitle:
                        'Your visited destinations will be recorded here.',
                  ),
                ),
                Divider(height: 1, color: colorScheme.outlineVariant),
                ListTile(
                  leading:
                      Icon(Icons.help_outline, color: colorScheme.primary),
                  title: const Text('Help & Support'),
                  trailing: Icon(Icons.chevron_right,
                      color: colorScheme.onSurfaceVariant),
                  onTap: () => _showHelpSupport(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Destination selector
          _DestinationSelector(
            selectedCity: profile.selectedCity,
            onCityChanged: (city) {
              profileProvider?.onProfileChanged(
                profile.copyWith(selectedCity: city),
              );
            },
          ),
          const SizedBox(height: 24),

          // Sign out
          Center(
            child: OutlinedButton.icon(
              onPressed: () => _showSignOutDialog(context),
              icon: const Icon(Icons.logout),
              label: const Text('Sign Out'),
              style: OutlinedButton.styleFrom(
                foregroundColor: colorScheme.error,
                side: BorderSide(color: colorScheme.error),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  String _buildSubtitle(UserProfile profile) {
    final parts = <String>[];
    if (profile.gender != null && profile.gender!.isNotEmpty) {
      parts.add(profile.gender!);
    }
    if (profile.age != null) {
      parts.add('${profile.age}');
    }
    if (parts.isEmpty) return 'Travel Enthusiast';
    return parts.join(', ');
  }

  void _showEditProfileSheet(BuildContext context, UserProfile profile) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => _EditProfileSheet(initialProfile: profile),
    );
  }

  void _showEmptyState(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 0, 32, 48),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 64, color: colorScheme.onSurfaceVariant),
              const SizedBox(height: 16),
              Text(
                title,
                style: textTheme.titleLarge?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showHelpSupport(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.support_agent_outlined,
                size: 56, color: colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              'Help & Support',
              style: textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 0,
              color: colorScheme.surfaceContainerLow,
              child: Column(
                children: [
                  ListTile(
                    leading:
                        Icon(Icons.email_outlined, color: colorScheme.primary),
                    title: const Text('Email'),
                    subtitle: const Text('support@wanderlust.app'),
                  ),
                  Divider(height: 1, color: colorScheme.outlineVariant),
                  ListTile(
                    leading:
                        Icon(Icons.phone_outlined, color: colorScheme.primary),
                    title: const Text('Phone'),
                    subtitle: const Text('+91 98765 43210'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: Icon(Icons.logout, color: colorScheme.error),
        title: const Text('Sign Out?'),
        content: const Text(
          'Are you sure you want to sign out? Your profile data will be reset.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              final provider = UserProfileProvider.of(context);
              provider?.onProfileChanged(const UserProfile());
            },
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}

class _EditProfileSheet extends StatefulWidget {
  final UserProfile initialProfile;

  const _EditProfileSheet({required this.initialProfile});

  @override
  State<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<_EditProfileSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _ageController;
  late final TextEditingController _mobileController;
  late String? _selectedGender;
  late String _selectedAvatar;

  static const _avatarAssets = [
    'assets/avatar_1.png',
    'assets/avatar_2.png',
    'assets/avatar_3.png',
    'assets/avatar_4.png',
    'assets/avatar_5.png',
    'assets/avatar_6.png',
    'assets/avatar_7.png',
  ];

  static const _genderOptions = [
    'Male',
    'Female',
    'Other',
    'Prefer not to say',
  ];

  @override
  void initState() {
    super.initState();
    final profile = widget.initialProfile;
    _nameController = TextEditingController(text: profile.name);
    _ageController =
        TextEditingController(text: profile.age?.toString() ?? '');
    _mobileController =
        TextEditingController(text: profile.mobileNumber ?? '');
    _selectedGender = profile.gender;
    _selectedAvatar = profile.avatarAsset;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        0,
        24,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Edit Profile',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Avatar picker
            Text(
              'Choose Avatar',
              style: textTheme.labelLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 72,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _avatarAssets.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final asset = _avatarAssets[index];
                  final isSelected = asset == _selectedAvatar;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedAvatar = asset),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(
                                color: colorScheme.primary, width: 3)
                            : null,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: colorScheme.primaryContainer,
                          backgroundImage: AssetImage(asset),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Name
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest,
              ),
            ),
            const SizedBox(height: 16),

            // Age
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Age',
                prefixIcon: const Icon(Icons.cake_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest,
              ),
            ),
            const SizedBox(height: 16),

            // Gender
            DropdownButtonFormField<String>(
              value: _selectedGender,
              decoration: InputDecoration(
                labelText: 'Gender',
                prefixIcon: const Icon(Icons.wc_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest,
              ),
              items: _genderOptions
                  .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                  .toList(),
              onChanged: (value) => setState(() => _selectedGender = value),
            ),
            const SizedBox(height: 16),

            // Mobile Number
            TextField(
              controller: _mobileController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Mobile Number',
                prefixIcon: const Icon(Icons.phone_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest,
              ),
            ),
            const SizedBox(height: 28),

            // Save button
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _saveProfile,
                icon: const Icon(Icons.check),
                label: const Text('Save Changes'),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _saveProfile() {
    final provider = UserProfileProvider.of(context);
    if (provider == null) return;

    final name = _nameController.text.trim();
    final ageText = _ageController.text.trim();
    final mobile = _mobileController.text.trim();

    final int? age = ageText.isNotEmpty ? int.tryParse(ageText) : null;

    provider.onProfileChanged(
      provider.profile.copyWith(
        name: name.isNotEmpty ? name : 'Alex',
        avatarAsset: _selectedAvatar,
        age: age,
        clearAge: age == null,
        gender: _selectedGender,
        clearGender: _selectedGender == null,
        mobileNumber: mobile.isNotEmpty ? mobile : null,
        clearMobileNumber: mobile.isEmpty,
      ),
    );

    Navigator.pop(context);
  }
}

class _DestinationSelector extends StatelessWidget {
  final String selectedCity;
  final ValueChanged<String> onCityChanged;

  const _DestinationSelector({
    required this.selectedCity,
    required this.onCityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.travel_explore,
                    color: colorScheme.primary, size: 22),
                const SizedBox(width: 8),
                Text(
                  'Dashboard Destination',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Text(
                'Select a place to view on the Dashboard tab',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ...CityOptions.all.map((city) {
              final isSelected = city.name == selectedCity;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Material(
                  color: isSelected
                      ? colorScheme.primaryContainer
                      : colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => onCityChanged(city.name),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Icon(
                            city.icon,
                            color: isSelected
                                ? colorScheme.onPrimaryContainer
                                : colorScheme.onSurfaceVariant,
                            size: 24,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  city.name,
                                  style: textTheme.bodyLarge?.copyWith(
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                    color: isSelected
                                        ? colorScheme.onPrimaryContainer
                                        : colorScheme.onSurface,
                                  ),
                                ),
                                Text(
                                  city.subtitle,
                                  style: textTheme.bodySmall?.copyWith(
                                    color: isSelected
                                        ? colorScheme.onPrimaryContainer
                                            .withValues(alpha: 0.7)
                                        : colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_circle,
                              color: colorScheme.primary,
                              size: 22,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
