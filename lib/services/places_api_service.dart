import 'dart:convert';
import 'package:http/http.dart' as http;

class PlacesApiService {
  static const String _apiKey = String.fromEnvironment('GOOGLE_MAPS_API_KEY');
  static const String _placesBaseUrl = 'https://places.googleapis.com/v1/places';
  static const String _geocodeBaseUrl = 'https://maps.googleapis.com/maps/api/geocode/json';
  static const String _distanceMatrixBaseUrl =
      'https://maps.googleapis.com/maps/api/distancematrix/json';

  PlacesApiService._();

  static String get _requiredApiKey {
    if (_apiKey.isEmpty) {
      throw StateError(
        'GOOGLE_MAPS_API_KEY is missing. Run Flutter with '
        '--dart-define=GOOGLE_MAPS_API_KEY=your_key.',
      );
    }
    return _apiKey;
  }

  static Future<Map<String, dynamic>> geocodeCity(String cityName) async {
    final uri = Uri.parse(_geocodeBaseUrl).replace(queryParameters: {
      'address': cityName,
      'key': _requiredApiKey,
    });
    final response = await http.get(uri);
    return _decodeOrThrow(
      response,
      operation: 'Geocoding',
    );
  }

  static Future<Map<String, dynamic>> searchNearbyPlaces({
    required double lat,
    required double lng,
    required List<String> includedTypes,
    double radius = 5000,
    int maxResultCount = 10,
  }) async {
    final uri = Uri.parse('$_placesBaseUrl:searchNearby');
    final body = json.encode({
      'includedTypes': includedTypes,
      'maxResultCount': maxResultCount,
      'locationRestriction': {
        'circle': {
          'center': {
            'latitude': lat,
            'longitude': lng,
          },
          'radius': radius,
        },
      },
    });

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'X-Goog-Api-Key': _requiredApiKey,
        'X-Goog-FieldMask':
            'places.id,places.name,places.displayName,places.rating,'
                'places.userRatingCount,places.location,places.photos,'
                'places.currentOpeningHours,places.regularOpeningHours,'
                'places.priceLevel,places.types,places.formattedAddress,'
                'places.primaryType,places.websiteUri',
      },
      body: body,
    );

    return _decodeOrThrow(
      response,
      operation: 'Nearby search',
    );
  }

  static Future<Map<String, dynamic>> getDistanceMatrix({
    required double originLat,
    required double originLng,
    required List<({double lat, double lng})> destinations,
  }) async {
    if (destinations.isEmpty) {
      return {'rows': []};
    }

    final destinationParam = destinations
        .map((d) => '${d.lat},${d.lng}')
        .join('|');

    final uri = Uri.parse(_distanceMatrixBaseUrl).replace(queryParameters: {
      'origins': '$originLat,$originLng',
      'destinations': destinationParam,
      'units': 'metric',
      'key': _requiredApiKey,
    });

    final response = await http.get(uri);
    return _decodeOrThrow(
      response,
      operation: 'Distance Matrix',
    );
  }

  static Future<Map<String, dynamic>> getPlaceDetails(String placeId) async {
    final uri = Uri.parse('$_placesBaseUrl/$placeId');
    final response = await http.get(
      uri,
      headers: {
        'X-Goog-Api-Key': _requiredApiKey,
        'X-Goog-FieldMask':
            'id,name,displayName,regularOpeningHours,priceLevel,websiteUri',
      },
    );
    return _decodeOrThrow(
      response,
      operation: 'Place details',
    );
  }

  static String getPhotoUrl({
    required String photoName,
    int maxWidthPx = 400,
  }) {
    return 'https://places.googleapis.com/v1/$photoName/media'
        '?maxWidthPx=$maxWidthPx&key=$_requiredApiKey';
  }

  static Map<String, dynamic> _decodeOrThrow(
    http.Response response, {
    required String operation,
  }) {
    final decoded = response.body.isEmpty
        ? <String, dynamic>{}
        : json.decode(response.body) as Map<String, dynamic>;

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final errorMessage = decoded['error'] is Map<String, dynamic>
          ? (decoded['error']['message'] as String? ?? response.body)
          : response.body;
      throw Exception('$operation failed (${response.statusCode}): $errorMessage');
    }

    return decoded;
  }
}
