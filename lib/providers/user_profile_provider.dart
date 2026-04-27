import 'package:flutter/material.dart';

class UserProfile {
  final String name;
  final String avatarAsset;
  final String selectedCity;
  final int? age;
  final String? gender;
  final String? mobileNumber;

  const UserProfile({
    this.name = 'Alex',
    this.avatarAsset = 'assets/avatar_1.png',
    this.selectedCity = 'Darjeeling',
    this.age,
    this.gender,
    this.mobileNumber,
  });

  UserProfile copyWith({
    String? name,
    String? avatarAsset,
    String? selectedCity,
    int? age,
    String? gender,
    String? mobileNumber,
    bool clearAge = false,
    bool clearGender = false,
    bool clearMobileNumber = false,
  }) {
    return UserProfile(
      name: name ?? this.name,
      avatarAsset: avatarAsset ?? this.avatarAsset,
      selectedCity: selectedCity ?? this.selectedCity,
      age: clearAge ? null : (age ?? this.age),
      gender: clearGender ? null : (gender ?? this.gender),
      mobileNumber: clearMobileNumber ? null : (mobileNumber ?? this.mobileNumber),
    );
  }
}

class UserProfileProvider extends InheritedWidget {
  final UserProfile profile;
  final ValueChanged<UserProfile> onProfileChanged;

  const UserProfileProvider({
    super.key,
    required this.profile,
    required this.onProfileChanged,
    required super.child,
  });

  static UserProfileProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<UserProfileProvider>();
  }

  @override
  bool updateShouldNotify(UserProfileProvider oldWidget) {
    return profile.name != oldWidget.profile.name ||
        profile.avatarAsset != oldWidget.profile.avatarAsset ||
        profile.selectedCity != oldWidget.profile.selectedCity ||
        profile.age != oldWidget.profile.age ||
        profile.gender != oldWidget.profile.gender ||
        profile.mobileNumber != oldWidget.profile.mobileNumber;
  }
}
