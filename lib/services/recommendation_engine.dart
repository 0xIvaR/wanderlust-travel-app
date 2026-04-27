import '../models/dashboard_models.dart';

class RecommendationEngine {
  RecommendationEngine._();

  static int calculateScore({
    required double distanceKm,
    required double rating,
    required bool isOpen,
    required int reviewCount,
    required String category,
    required int currentHour,
  }) {
    double distanceScore;
    if (distanceKm <= 1) {
      distanceScore = 100;
    } else if (distanceKm <= 3) {
      distanceScore = 75;
    } else if (distanceKm <= 5) {
      distanceScore = 50;
    } else {
      distanceScore = 25;
    }

    double ratingScore;
    if (rating >= 4.5) {
      ratingScore = 100;
    } else if (rating >= 4.0) {
      ratingScore = 75;
    } else if (rating >= 3.5) {
      ratingScore = 50;
    } else {
      ratingScore = 0;
    }

    final openScore = isOpen ? 100.0 : 0.0;

    double reviewScore;
    if (reviewCount >= 1000) {
      reviewScore = 100;
    } else if (reviewCount >= 500) {
      reviewScore = 75;
    } else if (reviewCount >= 100) {
      reviewScore = 50;
    } else {
      reviewScore = 25;
    }

    final timeScore = _timeOfDayScore(
      currentHour: currentHour,
      category: category,
    );

    final total = (distanceScore * 0.30) +
        (ratingScore * 0.25) +
        (openScore * 0.20) +
        (reviewScore * 0.15) +
        (timeScore * 0.10);

    return total.round().clamp(0, 100);
  }

  static List<PlaceRecommendation> getHighlights(List<PlaceRecommendation> all) {
    final currentHour = DateTime.now().hour;

    final scored = all.map((place) {
      final score = calculateScore(
        distanceKm: place.distanceKm,
        rating: place.rating,
        isOpen: place.isOpen,
        reviewCount: place.reviewCount,
        category: place.category,
        currentHour: currentHour,
      );
      return place.copyWith(recommendationScore: score);
    }).toList();

    scored.sort((a, b) => b.recommendationScore.compareTo(a.recommendationScore));
    return scored.take(3).toList();
  }

  static double _timeOfDayScore({
    required int currentHour,
    required String category,
  }) {
    final normalizedCategory = category.toLowerCase();

    if (currentHour >= 5 && currentHour < 12) {
      return normalizedCategory == 'nature' ? 100 : 50;
    }

    if (currentHour >= 12 && currentHour < 17) {
      return normalizedCategory == 'culture' ? 100 : 50;
    }

    if (currentHour >= 17 && currentHour < 23) {
      return normalizedCategory == 'food' ? 100 : 50;
    }

    return 50;
  }
}
