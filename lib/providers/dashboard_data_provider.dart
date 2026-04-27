import 'package:flutter/material.dart';
import '../models/dashboard_models.dart';
import '../services/places_api_service.dart';
import '../services/places_data_mapper.dart';

class DashboardDataProvider extends ChangeNotifier {
  final Map<String, CityData> _cache = {};
  CityData? _currentCityData;
  bool _isLoading = false;
  String? _error;
  String _currentCity = '';

  CityData? get currentCityData => _currentCityData;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get currentCity => _currentCity;

  Future<void> loadCity(String cityName) async {
    if (_currentCity == cityName && _currentCityData != null) return;

    _currentCity = cityName;

    if (_cache.containsKey(cityName)) {
      _currentCityData = _cache[cityName];
      _error = null;
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final geocodeResponse = await PlacesApiService.geocodeCity(cityName);
      final coords = PlacesDataMapper.extractLatLngFromGeocode(geocodeResponse);

      final responses = await Future.wait([
        PlacesApiService.searchNearbyPlaces(
          lat: coords.lat,
          lng: coords.lng,
          includedTypes: [
            'tourist_attraction',
            'museum',
            'park',
            'historical_place',
            'cultural_landmark',
          ],
          radius: 10000,
          maxResultCount: 12,
        ),
        PlacesApiService.searchNearbyPlaces(
          lat: coords.lat,
          lng: coords.lng,
          includedTypes: ['restaurant', 'cafe'],
          radius: 5000,
          maxResultCount: 8,
        ),
        PlacesApiService.searchNearbyPlaces(
          lat: coords.lat,
          lng: coords.lng,
          includedTypes: [
            'transit_station',
            'train_station',
            'bus_station',
            'subway_station',
            'taxi_stand',
          ],
          radius: 8000,
          maxResultCount: 6,
        ),
      ]);

      var attractions = PlacesDataMapper.mapPlaces(
        response: responses[0],
        category: 'attraction',
        originLat: coords.lat,
        originLng: coords.lng,
      );

      var foodPlaces = PlacesDataMapper.mapPlaces(
        response: responses[1],
        category: 'food',
        originLat: coords.lat,
        originLng: coords.lng,
      );

      final allPlaces = [...attractions, ...foodPlaces];
      final distanceResponse = await PlacesApiService.getDistanceMatrix(
        originLat: coords.lat,
        originLng: coords.lng,
        destinations: allPlaces
            .map((p) => (lat: p.lat, lng: p.lng))
            .toList(growable: false),
      );
      final allPlacesWithRoadDistance = PlacesDataMapper.applyDistanceMatrix(
        places: allPlaces,
        distanceMatrixResponse: distanceResponse,
      );

      final attractionCount = attractions.length;
      attractions = allPlacesWithRoadDistance.take(attractionCount).toList();
      foodPlaces = allPlacesWithRoadDistance.skip(attractionCount).toList();

      var transportOptions = PlacesDataMapper.mapTransportOptions(responses[2]);
      if (transportOptions.isEmpty) {
        transportOptions = const [
          TransportOption(
            name: 'Ride Hailing',
            description: 'App-based cabs around the city center',
            approximateCost: 'Varies',
            type: 'car',
          ),
          TransportOption(
            name: 'Metro or Rail',
            description: 'Fast option for major transit corridors',
            approximateCost: 'Varies',
            type: 'train',
          ),
          TransportOption(
            name: 'Bike Rental',
            description: 'Short-distance city exploration',
            approximateCost: 'Varies',
            type: 'bike',
          ),
          TransportOption(
            name: 'Walking',
            description: 'Best for nearby points of interest',
            approximateCost: 'Free',
            type: 'walk',
          ),
        ];
      }

      final ticketInfos = await _buildTicketInfos(attractions);
      final safetyTips = _buildSafetyTips(cityName);

      final cityData = CityData(
        cityName: cityName,
        initialLat: coords.lat,
        initialLng: coords.lng,
        attractions: attractions,
        foodPlaces: foodPlaces,
        transportOptions: transportOptions,
        ticketInfos: ticketInfos,
        safetyTips: safetyTips,
      );

      _cache[cityName] = cityData;
      if (_currentCity == cityName) {
        _currentCityData = cityData;
        _error = null;
      }
    } catch (e) {
      if (_currentCity == cityName) {
        _error = e.toString();
      }
    } finally {
      if (_currentCity == cityName) {
        _isLoading = false;
      }
      notifyListeners();
    }
  }

  Future<List<TicketInfo>> _buildTicketInfos(
      List<PlaceRecommendation> attractions) async {
    final topAttractions = attractions.take(4).toList(growable: false);
    final tickets = <TicketInfo>[];

    for (final place in topAttractions) {
      try {
        final details = await PlacesApiService.getPlaceDetails(place.id);
        final fee = _entryFeeFromPriceLevel(details['priceLevel'] as String?);
        final timings =
            _openingHoursFromDetails(details) ?? place.openingHours ?? 'Timings unavailable';
        final bookingAvailable = (details['websiteUri'] as String?)?.isNotEmpty ?? false;

        tickets.add(
          TicketInfo(
            placeName: place.name,
            entryFee: fee,
            timings: timings,
            bookingAvailable: bookingAvailable,
          ),
        );
      } catch (_) {
        tickets.add(
          TicketInfo(
            placeName: place.name,
            entryFee: _entryFeeFromPriceLevel(null),
            timings: place.openingHours ?? 'Timings unavailable',
            bookingAvailable: false,
          ),
        );
      }
    }

    return tickets;
  }

  String _entryFeeFromPriceLevel(String? level) {
    switch (level) {
      case 'PRICE_LEVEL_FREE':
        return 'Free entry';
      case 'PRICE_LEVEL_INEXPENSIVE':
        return 'Low entry fee';
      case 'PRICE_LEVEL_MODERATE':
        return 'Moderate entry fee';
      case 'PRICE_LEVEL_EXPENSIVE':
      case 'PRICE_LEVEL_VERY_EXPENSIVE':
        return 'Premium entry fee';
      default:
        return 'Check venue website';
    }
  }

  String? _openingHoursFromDetails(Map<String, dynamic> details) {
    final regularHours = details['regularOpeningHours'] as Map<String, dynamic>?;
    final weekdays = regularHours?['weekdayDescriptions'] as List<dynamic>?;
    if (weekdays == null || weekdays.isEmpty) return null;

    final dayIndex = (DateTime.now().weekday - 1) % weekdays.length;
    return weekdays[dayIndex] as String;
  }

  List<SafetyTip> _buildSafetyTips(String cityName) {
    return [
      SafetyTip(
        tip: 'Verify local emergency numbers in $cityName before long day trips.',
        type: 'info',
      ),
      const SafetyTip(
        tip: 'Keep identity documents and payment cards in separate secure pockets.',
        type: 'warning',
      ),
      const SafetyTip(
        tip: 'Use trusted ride options and avoid unmetered fares late at night.',
        type: 'warning',
      ),
      const SafetyTip(
        tip: 'Carry offline maps in case mobile data is weak in crowded areas.',
        type: 'info',
      ),
    ];
  }
}
