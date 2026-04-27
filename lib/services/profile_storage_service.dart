import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/user_profile_provider.dart';

class ProfileStorageService {
  static const _key = 'wanderlust_user_profile';

  static Future<UserProfile> load() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_key);
    if (json == null) return const UserProfile();

    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return UserProfile(
        name: map['name'] as String? ?? 'Alex',
        avatarAsset: map['avatarAsset'] as String? ?? 'assets/avatar_1.png',
        selectedCity: map['selectedCity'] as String? ?? 'Darjeeling',
        age: map['age'] as int?,
        gender: map['gender'] as String?,
        mobileNumber: map['mobileNumber'] as String?,
      );
    } catch (_) {
      return const UserProfile();
    }
  }

  static Future<void> save(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    final map = {
      'name': profile.name,
      'avatarAsset': profile.avatarAsset,
      'selectedCity': profile.selectedCity,
      'age': profile.age,
      'gender': profile.gender,
      'mobileNumber': profile.mobileNumber,
    };
    await prefs.setString(_key, jsonEncode(map));
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
