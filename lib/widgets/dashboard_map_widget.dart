import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/dashboard_models.dart';

class DashboardMapWidget extends StatefulWidget {
  final List<PlaceRecommendation> attractions;
  final List<PlaceRecommendation> foodPlaces;
  final double initialLat;
  final double initialLng;

  const DashboardMapWidget({
    super.key,
    required this.attractions,
    required this.foodPlaces,
    required this.initialLat,
    required this.initialLng,
  });

  @override
  State<DashboardMapWidget> createState() => _DashboardMapWidgetState();
}

class _DashboardMapWidgetState extends State<DashboardMapWidget> {
  GoogleMapController? _mapController;
  late final Set<Marker> _markers;

  @override
  void initState() {
    super.initState();
    _markers = _buildMarkers();
  }

  Set<Marker> _buildMarkers() {
    final markers = <Marker>{};

    for (final place in widget.attractions) {
      markers.add(
        Marker(
          markerId: MarkerId(place.id),
          position: LatLng(place.lat, place.lng),
          infoWindow: InfoWindow(
            title: place.name,
            snippet: '${place.rating} - ${place.distanceKm} km',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueViolet,
          ),
        ),
      );
    }

    for (final place in widget.foodPlaces) {
      markers.add(
        Marker(
          markerId: MarkerId(place.id),
          position: LatLng(place.lat, place.lng),
          infoWindow: InfoWindow(
            title: place.name,
            snippet: '${place.rating} - ${place.distanceKm} km',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueOrange,
          ),
        ),
      );
    }

    return markers;
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(widget.initialLat, widget.initialLng),
        zoom: 13,
      ),
      markers: _markers,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      zoomGesturesEnabled: true,
      scrollGesturesEnabled: true,
      rotateGesturesEnabled: true,
      tiltGesturesEnabled: true,
      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
        Factory<EagerGestureRecognizer>(EagerGestureRecognizer.new),
      },
      onMapCreated: (controller) {
        _mapController = controller;
      },
    );
  }
}
