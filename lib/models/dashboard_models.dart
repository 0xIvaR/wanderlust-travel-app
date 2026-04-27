class PlaceRecommendation {
  final String id;
  final String name;
  final String category;
  final double rating;
  final int reviewCount;
  final double distanceKm;
  final bool isOpen;
  final String? imageUrl;
  final double lat;
  final double lng;
  final int priceLevel;
  final String? openingHours;
  final int recommendationScore;

  const PlaceRecommendation({
    required this.id,
    required this.name,
    required this.category,
    required this.rating,
    required this.reviewCount,
    required this.distanceKm,
    required this.isOpen,
    this.imageUrl,
    required this.lat,
    required this.lng,
    this.priceLevel = 0,
    this.openingHours,
    this.recommendationScore = 0,
  });

  PlaceRecommendation copyWith({
    String? id,
    String? name,
    String? category,
    double? rating,
    int? reviewCount,
    double? distanceKm,
    bool? isOpen,
    String? imageUrl,
    double? lat,
    double? lng,
    int? priceLevel,
    String? openingHours,
    int? recommendationScore,
  }) {
    return PlaceRecommendation(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      distanceKm: distanceKm ?? this.distanceKm,
      isOpen: isOpen ?? this.isOpen,
      imageUrl: imageUrl ?? this.imageUrl,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      priceLevel: priceLevel ?? this.priceLevel,
      openingHours: openingHours ?? this.openingHours,
      recommendationScore: recommendationScore ?? this.recommendationScore,
    );
  }
}

class TransportOption {
  final String name;
  final String description;
  final String approximateCost;
  final String type;

  const TransportOption({
    required this.name,
    required this.description,
    required this.approximateCost,
    required this.type,
  });
}

class TicketInfo {
  final String placeName;
  final String entryFee;
  final String timings;
  final bool bookingAvailable;

  const TicketInfo({
    required this.placeName,
    required this.entryFee,
    required this.timings,
    required this.bookingAvailable,
  });
}

class SafetyTip {
  final String tip;
  final String type;

  const SafetyTip({
    required this.tip,
    required this.type,
  });
}

class CityData {
  final String cityName;
  final double initialLat;
  final double initialLng;
  final List<PlaceRecommendation> attractions;
  final List<PlaceRecommendation> foodPlaces;
  final List<TransportOption> transportOptions;
  final List<TicketInfo> ticketInfos;
  final List<SafetyTip> safetyTips;

  const CityData({
    required this.cityName,
    required this.initialLat,
    required this.initialLng,
    this.attractions = const [],
    this.foodPlaces = const [],
    this.transportOptions = const [],
    this.ticketInfos = const [],
    this.safetyTips = const [],
  });

  CityData copyWith({
    String? cityName,
    double? initialLat,
    double? initialLng,
    List<PlaceRecommendation>? attractions,
    List<PlaceRecommendation>? foodPlaces,
    List<TransportOption>? transportOptions,
    List<TicketInfo>? ticketInfos,
    List<SafetyTip>? safetyTips,
  }) {
    return CityData(
      cityName: cityName ?? this.cityName,
      initialLat: initialLat ?? this.initialLat,
      initialLng: initialLng ?? this.initialLng,
      attractions: attractions ?? this.attractions,
      foodPlaces: foodPlaces ?? this.foodPlaces,
      transportOptions: transportOptions ?? this.transportOptions,
      ticketInfos: ticketInfos ?? this.ticketInfos,
      safetyTips: safetyTips ?? this.safetyTips,
    );
  }
}

