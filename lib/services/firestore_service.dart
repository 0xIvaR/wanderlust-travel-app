import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/hotel_model.dart';

class FirestoreService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ── Hotels ────────────────────────────────────────────────────────────────

  static Future<List<Hotel>> fetchHotels() async {
    final snapshot = await _db.collection('hotels').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return Hotel.fromMap(data);
    }).toList();
  }

  static Stream<List<Hotel>> hotelsStream() {
    return _db.collection('hotels').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Hotel.fromMap(data);
      }).toList();
    });
  }

  // ── Bookings ──────────────────────────────────────────────────────────────

  static Future<void> saveBooking(
      String userId, BookingRequest booking) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('bookings')
        .doc(booking.id)
        .set({
      'hotelId': booking.hotelId,
      'hotelName': booking.hotelName,
      'checkIn': Timestamp.fromDate(booking.checkIn),
      'checkOut': Timestamp.fromDate(booking.checkOut),
      'guests': booking.guests,
      'roomType': booking.roomType,
      'totalPrice': booking.totalPrice,
      'createdAt': Timestamp.fromDate(booking.createdAt),
    });
  }

  static Future<List<BookingRequest>> fetchBookings(String userId) async {
    final snapshot = await _db
        .collection('users')
        .doc(userId)
        .collection('bookings')
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return BookingRequest(
        id: doc.id,
        hotelId: data['hotelId'] as String,
        hotelName: data['hotelName'] as String,
        checkIn: (data['checkIn'] as Timestamp).toDate(),
        checkOut: (data['checkOut'] as Timestamp).toDate(),
        guests: data['guests'] as int,
        roomType: data['roomType'] as String,
        totalPrice: (data['totalPrice'] as num).toDouble(),
        createdAt: (data['createdAt'] as Timestamp).toDate(),
      );
    }).toList();
  }

  // ── Seed hotels (call once to populate Firestore) ─────────────────────────

  static Future<void> seedHotels() async {
    final batch = _db.batch();
    for (final hotel in SampleHotels.all) {
      final ref = _db.collection('hotels').doc(hotel.id);
      batch.set(ref, {
        'name': hotel.name,
        'city': hotel.city,
        'stars': hotel.stars,
        'pricePerNight': hotel.pricePerNight,
        'description': hotel.description,
        'imageKey': 'hotels/${hotel.name.toLowerCase().replaceAll(' ', '_')}',
        'amenities': hotel.amenities,
      });
    }
    await batch.commit();
  }
}
