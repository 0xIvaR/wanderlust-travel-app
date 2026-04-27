import 'package:firebase_storage/firebase_storage.dart';

class ImageResolver {
  static final Map<String, String> _cache = {};

  static Future<String?> resolveImageUrl(String imageKey,
      {String? fallbackUrl}) async {
    if (_cache.containsKey(imageKey)) return _cache[imageKey];

    try {
      final ref = FirebaseStorage.instance.ref('curated/$imageKey.jpg');
      final url = await ref.getDownloadURL();
      _cache[imageKey] = url;
      return url;
    } catch (_) {
      return fallbackUrl;
    }
  }

  static void clearCache() {
    _cache.clear();
  }
}
