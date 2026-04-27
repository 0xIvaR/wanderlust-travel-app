class Hotel {
  final String id;
  final String name;
  final String city;
  final double stars;
  final double pricePerNight;
  final String description;
  final String? imageUrl;
  final String? imageKey;
  final List<String> amenities;

  const Hotel({
    required this.id,
    required this.name,
    required this.city,
    required this.stars,
    required this.pricePerNight,
    required this.description,
    this.imageUrl,
    this.imageKey,
    this.amenities = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'city': city,
      'stars': stars,
      'pricePerNight': pricePerNight,
      'description': description,
      'imageUrl': imageUrl,
      'imageKey': imageKey,
      'amenities': amenities,
    };
  }

  factory Hotel.fromMap(Map<String, dynamic> map) {
    return Hotel(
      id: map['id'] as String,
      name: map['name'] as String,
      city: map['city'] as String,
      stars: (map['stars'] as num).toDouble(),
      pricePerNight: (map['pricePerNight'] as num).toDouble(),
      description: map['description'] as String,
      imageUrl: map['imageUrl'] as String?,
      imageKey: map['imageKey'] as String?,
      amenities: List<String>.from(map['amenities'] ?? []),
    );
  }
}

class BookingRequest {
  final String id;
  final String hotelId;
  final String hotelName;
  final DateTime checkIn;
  final DateTime checkOut;
  final int guests;
  final String roomType;
  final double totalPrice;
  final DateTime createdAt;

  const BookingRequest({
    required this.id,
    required this.hotelId,
    required this.hotelName,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
    required this.roomType,
    required this.totalPrice,
    required this.createdAt,
  });

  int get nights {
    return checkOut.difference(checkIn).inDays;
  }
}

class SampleHotels {
  static const List<Hotel> all = [
    Hotel(
      id: 'h1',
      name: 'The Oberoi Grand',
      city: 'Kolkata',
      stars: 5,
      pricePerNight: 12500,
      description:
          'A heritage luxury hotel in the heart of Kolkata with world-class amenities and colonial charm.',
      amenities: ['Pool', 'Spa', 'Wi-Fi', 'Restaurant', 'Gym'],
    ),
    Hotel(
      id: 'h2',
      name: 'Taj Dal Lake',
      city: 'Srinagar',
      stars: 5,
      pricePerNight: 18000,
      description:
          'Stunning lakeside luxury on the banks of Dal Lake with Mughal garden views.',
      amenities: ['Lake View', 'Spa', 'Wi-Fi', 'Fine Dining', 'Shikara'],
    ),
    Hotel(
      id: 'h3',
      name: 'Windflower Prakruthi',
      city: 'Bangalore',
      stars: 4,
      pricePerNight: 6500,
      description:
          'A serene nature retreat surrounded by lush greenery on the outskirts of Bangalore.',
      amenities: ['Pool', 'Garden', 'Wi-Fi', 'Restaurant'],
    ),
    Hotel(
      id: 'h4',
      name: 'Zostel Darjeeling',
      city: 'Darjeeling',
      stars: 3,
      pricePerNight: 1800,
      description:
          'A vibrant backpacker hostel with stunning views of the Kanchenjunga range.',
      amenities: ['Mountain View', 'Cafe', 'Wi-Fi', 'Common Area'],
    ),
    Hotel(
      id: 'h5',
      name: 'Kumarakom Lake Resort',
      city: 'Kerala',
      stars: 5,
      pricePerNight: 22000,
      description:
          'Award-winning luxury resort on the tranquil Vembanad Lake with Ayurvedic spa.',
      amenities: ['Lake View', 'Ayurveda Spa', 'Pool', 'Houseboat', 'Wi-Fi'],
    ),
  ];
}
