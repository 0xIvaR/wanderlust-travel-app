import 'dart:math';
import '../models/dashboard_models.dart';
import 'places_api_service.dart';

class PlacesDataMapper {
  PlacesDataMapper._();

  static List<PlaceRecommendation> mapPlaces({
    required Map<String, dynamic> response,
    required String category,
    required double originLat,
    required double originLng,
  }) {
    final places = response['places'] as List<dynamic>?;
    if (places == null || places.isEmpty) return [];

    return places.map((placeJson) {
      final place = placeJson as Map<String, dynamic>;
      final location = place['location'] as Map<String, dynamic>? ?? {};
      final lat = (location['latitude'] as num?)?.toDouble() ?? 0.0;
      final lng = (location['longitude'] as num?)?.toDouble() ?? 0.0;
      final displayName = place['displayName'] as Map<String, dynamic>? ?? {};
      final name = (displayName['text'] as String?) ?? 'Unknown Place';
      final rating = (place['rating'] as num?)?.toDouble() ?? 0.0;
      final reviewCount = (place['userRatingCount'] as num?)?.toInt() ?? 0;
      final openingHours = place['currentOpeningHours'] as Map<String, dynamic>?;
      final isOpen = (openingHours?['openNow'] as bool?) ?? false;
      final weekdayText = openingHours?['weekdayDescriptions'] as List<dynamic>?;
      final openingHoursText = _extractTodayHours(weekdayText);
      final priceLevel = _mapPriceLevel(place['priceLevel'] as String?);
      final photos = place['photos'] as List<dynamic>?;
      final primaryType = place['primaryType'] as String?;
      final mappedCategory = _resolveCategory(
        defaultCategory: category,
        primaryType: primaryType,
      );

      String? imageUrl;
      if (photos != null && photos.isNotEmpty) {
        final photoName = (photos[0] as Map<String, dynamic>)['name'] as String?;
        if (photoName != null) {
          imageUrl = PlacesApiService.getPhotoUrl(photoName: photoName);
        }
      }

      final distanceKm = _haversineDistance(originLat, originLng, lat, lng);

      return PlaceRecommendation(
        id: (place['id'] as String?) ?? name.hashCode.toString(),
        name: name,
        category: mappedCategory,
        rating: rating,
        reviewCount: reviewCount,
        distanceKm: double.parse(distanceKm.toStringAsFixed(1)),
        isOpen: isOpen,
        imageUrl: imageUrl,
        lat: lat,
        lng: lng,
        priceLevel: priceLevel,
        openingHours: openingHoursText,
        recommendationScore: 0,
      );
    }).toList();
  }

  static List<PlaceRecommendation> applyDistanceMatrix({
    required List<PlaceRecommendation> places,
    required Map<String, dynamic> distanceMatrixResponse,
  }) {
    final rows = distanceMatrixResponse['rows'] as List<dynamic>?;
    if (rows == null || rows.isEmpty) return places;

    final firstRow = rows.first as Map<String, dynamic>;
    final elements = firstRow['elements'] as List<dynamic>?;
    if (elements == null || elements.isEmpty) return places;

    final updated = <PlaceRecommendation>[];
    for (var i = 0; i < places.length; i++) {
      if (i >= elements.length) {
        updated.add(places[i]);
        continue;
      }
      final element = elements[i] as Map<String, dynamic>;
      final status = element['status'] as String?;
      if (status != 'OK') {
        updated.add(places[i]);
        continue;
      }
      final distance = element['distance'] as Map<String, dynamic>?;
      final meters = (distance?['value'] as num?)?.toDouble();
      if (meters == null) {
        updated.add(places[i]);
        continue;
      }
      updated.add(
        places[i].copyWith(
          distanceKm: double.parse((meters / 1000).toStringAsFixed(1)),
        ),
      );
    }

    return updated;
  }

  static List<TransportOption> mapTransportOptions(
      Map<String, dynamic> response) {
    final places = response['places'] as List<dynamic>?;
    if (places == null || places.isEmpty) {
      return const [];
    }

    return places.take(4).map((placeJson) {
      final place = placeJson as Map<String, dynamic>;
      final displayName = place['displayName'] as Map<String, dynamic>? ?? {};
      final name = (displayName['text'] as String?) ?? 'Transit Option';
      final primaryType = place['primaryType'] as String?;
      final formattedAddress = place['formattedAddress'] as String?;

      return TransportOption(
        name: name,
        description: formattedAddress ?? 'Public transport option nearby',
        approximateCost: 'Varies',
        type: _mapTransportType(primaryType),
      );
    }).toList();
  }

  static int _mapPriceLevel(String? level) {
    switch (level) {
      case 'PRICE_LEVEL_FREE':
        return 0;
      case 'PRICE_LEVEL_INEXPENSIVE':
        return 1;
      case 'PRICE_LEVEL_MODERATE':
        return 2;
      case 'PRICE_LEVEL_EXPENSIVE':
      case 'PRICE_LEVEL_VERY_EXPENSIVE':
        return 3;
      default:
        return 0;
    }
  }

  static String? _extractTodayHours(List<dynamic>? weekdayTexts) {
    if (weekdayTexts == null || weekdayTexts.isEmpty) return null;
    final now = DateTime.now();
    final dayIndex = (now.weekday - 1) % 7;
    if (dayIndex < weekdayTexts.length) {
      return weekdayTexts[dayIndex] as String;
    }
    return weekdayTexts[0] as String;
  }

  static String _resolveCategory({
    required String defaultCategory,
    String? primaryType,
  }) {
    if (defaultCategory == 'food') {
      return 'food';
    }

    if (primaryType == null) {
      return defaultCategory;
    }

    const cultureTypes = {
      'museum',
      'art_gallery',
      'cultural_landmark',
      'historical_place',
      'church',
      'hindu_temple',
      'mosque',
      'synagogue',
    };

    if (cultureTypes.contains(primaryType)) {
      return 'culture';
    }

    return 'nature';
  }

  static String _mapTransportType(String? primaryType) {
    switch (primaryType) {
      case 'train_station':
      case 'subway_station':
      case 'transit_station':
        return 'train';
      case 'taxi_stand':
      case 'parking':
        return 'car';
      case 'bicycle_store':
      case 'bicycle_rental_service':
        return 'bike';
      case 'bus_station':
        return 'walk';
      default:
        return 'walk';
    }
  }

  static double _haversineDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const earthRadiusKm = 6371.0;
    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadiusKm * c;
  }

  static double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  static ({double lat, double lng}) extractLatLngFromGeocode(
      Map<String, dynamic> geocodeResponse) {
    final results = geocodeResponse['results'] as List<dynamic>?;
    if (results == null || results.isEmpty) {
      throw Exception('No geocoding results found');
    }
    final geometry = results[0]['geometry'] as Map<String, dynamic>;
    final location = geometry['location'] as Map<String, dynamic>;
    return (
      lat: (location['lat'] as num).toDouble(),
      lng: (location['lng'] as num).toDouble(),
    );
  }
}
