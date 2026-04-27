import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/hotel_model.dart';
import '../services/firestore_service.dart';

class BookingProvider extends ChangeNotifier {
  final List<BookingRequest> _bookings = [];

  List<BookingRequest> get bookings => List.unmodifiable(_bookings);

  Future<void> addBooking(BookingRequest booking) async {
    _bookings.add(booking);
    notifyListeners();

    // Save to Firestore if a user session exists (anonymous or signed-in)
    try {
      User? user = FirebaseAuth.instance.currentUser;
      user ??= await FirebaseAuth.instance.signInAnonymously().then((c) => c.user);
      if (user != null) {
        await FirestoreService.saveBooking(user.uid, booking);
      }
    } catch (_) {
      // Firestore unavailable — booking is still saved in memory for this session
    }
  }

  void removeBooking(String bookingId) {
    _bookings.removeWhere((b) => b.id == bookingId);
    notifyListeners();
  }
}
