import 'package:flutter/material.dart';
import '../models/hotel_model.dart';
import '../services/firestore_service.dart';

class HotelProvider extends ChangeNotifier {
  List<Hotel> _hotels = [];
  bool _isLoading = false;
  String? _error;
  bool _seeded = false;

  List<Hotel> get hotels => _hotels;
  bool get isLoading => _isLoading;
  String? get error => _error;

  HotelProvider() {
    _loadHotels();
  }

  Future<void> _loadHotels() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final fetched = await FirestoreService.fetchHotels();

      if (fetched.isEmpty && !_seeded) {
        // Firestore is empty — seed it with the sample data automatically
        await FirestoreService.seedHotels();
        _seeded = true;
        final seeded = await FirestoreService.fetchHotels();
        _hotels = seeded.isEmpty ? SampleHotels.all : seeded;
      } else {
        _hotels = fetched;
      }
    } catch (_) {
      // Firestore unavailable (no internet, not set up yet) — fall back to local data
      _hotels = SampleHotels.all;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() => _loadHotels();
}
