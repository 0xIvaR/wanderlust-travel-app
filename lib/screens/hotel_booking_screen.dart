import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/hotel_model.dart';
import '../providers/booking_provider.dart';

class HotelBookingScreen extends StatefulWidget {
  final Hotel hotel;
  final BookingProvider bookingProvider;

  const HotelBookingScreen({
    super.key,
    required this.hotel,
    required this.bookingProvider,
  });

  @override
  State<HotelBookingScreen> createState() => _HotelBookingScreenState();
}

class _HotelBookingScreenState extends State<HotelBookingScreen> {
  DateTimeRange? _dateRange;
  int _guests = 2;
  int _selectedRoomIndex = 0;

  static const _roomTypes = ['Standard', 'Deluxe', 'Suite'];
  static const _roomMultipliers = [1.0, 1.5, 2.2];

  Hotel get hotel => widget.hotel;

  double get _totalPrice {
    if (_dateRange == null) return 0;
    final nights = _dateRange!.end.difference(_dateRange!.start).inDays;
    return hotel.pricePerNight * nights * _roomMultipliers[_selectedRoomIndex];
  }

  int get _nights {
    if (_dateRange == null) return 0;
    return _dateRange!.end.difference(_dateRange!.start).inDays;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: Text(hotel.name),
            expandedHeight: 220,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  _buildHeroImage(colorScheme),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          colorScheme.surface.withValues(alpha: 0.8),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Hotel info header
                Row(
                  children: [
                    _buildStars(hotel.stars, colorScheme),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        hotel.city,
                        style: textTheme.labelMedium?.copyWith(
                          color: colorScheme.onSecondaryContainer,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  hotel.description,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),

                // Amenities
                if (hotel.amenities.isNotEmpty) ...[
                  Text(
                    'Amenities',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: hotel.amenities
                        .map((a) => Chip(
                              label: Text(a),
                              avatar: Icon(
                                _amenityIcon(a),
                                size: 16,
                                color: colorScheme.primary,
                              ),
                              backgroundColor:
                                  colorScheme.surfaceContainerHighest,
                              side: BorderSide.none,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 24),
                ],

                // Date selection
                Text(
                  'Select Dates',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  elevation: 0,
                  color: colorScheme.surfaceContainerLow,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: _pickDateRange,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_month_rounded,
                              color: colorScheme.primary),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _dateRange == null
                                ? Text(
                                    'Tap to select check-in & check-out',
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${DateFormat.MMMd().format(_dateRange!.start)} — ${DateFormat.MMMd().format(_dateRange!.end)}',
                                        style: textTheme.bodyLarge?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: colorScheme.onSurface,
                                        ),
                                      ),
                                      Text(
                                        '$_nights ${_nights == 1 ? 'night' : 'nights'}',
                                        style: textTheme.bodySmall?.copyWith(
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                          Icon(Icons.chevron_right,
                              color: colorScheme.onSurfaceVariant),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Guests
                Text(
                  'Guests',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  elevation: 0,
                  color: colorScheme.surfaceContainerLow,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Icon(Icons.people_rounded,
                            color: colorScheme.primary),
                        const SizedBox(width: 12),
                        Text(
                          '$_guests ${_guests == 1 ? 'Guest' : 'Guests'}',
                          style: textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const Spacer(),
                        IconButton.filledTonal(
                          onPressed: _guests > 1
                              ? () => setState(() => _guests--)
                              : null,
                          icon: const Icon(Icons.remove, size: 18),
                          constraints: const BoxConstraints(
                              minWidth: 36, minHeight: 36),
                          padding: EdgeInsets.zero,
                        ),
                        const SizedBox(width: 4),
                        IconButton.filledTonal(
                          onPressed: _guests < 6
                              ? () => setState(() => _guests++)
                              : null,
                          icon: const Icon(Icons.add, size: 18),
                          constraints: const BoxConstraints(
                              minWidth: 36, minHeight: 36),
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Room type
                Text(
                  'Room Type',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                SegmentedButton<int>(
                  segments: List.generate(
                    _roomTypes.length,
                    (i) => ButtonSegment(
                      value: i,
                      label: Text(_roomTypes[i]),
                      icon: Icon(_roomTypeIcon(i)),
                    ),
                  ),
                  selected: {_selectedRoomIndex},
                  onSelectionChanged: (selection) {
                    setState(() => _selectedRoomIndex = selection.first);
                  },
                  style: SegmentedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '${_roomTypes[_selectedRoomIndex]} room — \u20B9${(hotel.pricePerNight * _roomMultipliers[_selectedRoomIndex]).toInt().toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')} / night',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final canBook = _dateRange != null;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (canBook) ...[
                  Text(
                    '\u20B9${_totalPrice.toInt().toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.primary,
                    ),
                  ),
                  Text(
                    'Total for $_nights ${_nights == 1 ? 'night' : 'nights'}',
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ] else
                  Text(
                    'Select dates to see price',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          FilledButton.icon(
            onPressed: canBook ? _confirmBooking : null,
            icon: const Icon(Icons.check_circle_outline),
            label: const Text('Confirm'),
            style: FilledButton.styleFrom(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroImage(ColorScheme colorScheme) {
    if (hotel.imageUrl != null && hotel.imageUrl!.isNotEmpty) {
      return Image.network(hotel.imageUrl!, fit: BoxFit.cover);
    }
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primaryContainer,
            colorScheme.tertiaryContainer,
          ],
        ),
      ),
      child: Center(
        child: Icon(Icons.hotel_rounded, size: 64,
            color: colorScheme.onPrimaryContainer.withValues(alpha: 0.5)),
      ),
    );
  }

  Widget _buildStars(double stars, ColorScheme colorScheme) {
    final fullStars = stars.floor();
    final hasHalf = (stars - fullStars) >= 0.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < fullStars; i++)
          Icon(Icons.star_rounded, size: 18, color: colorScheme.tertiary),
        if (hasHalf)
          Icon(Icons.star_half_rounded, size: 18, color: colorScheme.tertiary),
      ],
    );
  }

  IconData _amenityIcon(String amenity) {
    switch (amenity.toLowerCase()) {
      case 'pool':
        return Icons.pool_rounded;
      case 'spa':
      case 'ayurveda spa':
        return Icons.spa_rounded;
      case 'wi-fi':
        return Icons.wifi_rounded;
      case 'restaurant':
      case 'fine dining':
        return Icons.restaurant_rounded;
      case 'gym':
        return Icons.fitness_center_rounded;
      case 'garden':
        return Icons.park_rounded;
      case 'lake view':
      case 'mountain view':
        return Icons.landscape_rounded;
      case 'cafe':
        return Icons.local_cafe_rounded;
      case 'common area':
        return Icons.groups_rounded;
      case 'shikara':
      case 'houseboat':
        return Icons.sailing_rounded;
      default:
        return Icons.check_circle_outline;
    }
  }

  IconData _roomTypeIcon(int index) {
    switch (index) {
      case 0:
        return Icons.bed_rounded;
      case 1:
        return Icons.king_bed_rounded;
      case 2:
        return Icons.villa_rounded;
      default:
        return Icons.bed_rounded;
    }
  }

  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      initialDateRange: _dateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _dateRange = picked);
    }
  }

  Future<void> _confirmBooking() async {
    if (_dateRange == null) return;

    final booking = BookingRequest(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      hotelId: hotel.id,
      hotelName: hotel.name,
      checkIn: _dateRange!.start,
      checkOut: _dateRange!.end,
      guests: _guests,
      roomType: _roomTypes[_selectedRoomIndex],
      totalPrice: _totalPrice,
      createdAt: DateTime.now(),
    );

    await widget.bookingProvider.addBooking(booking);

    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      showDragHandle: true,
      builder: (ctx) => _BookingConfirmationSheet(
        booking: booking,
        onDone: () {
          Navigator.pop(ctx);
          Navigator.pop(context);
        },
      ),
    );
  }
}

class _BookingConfirmationSheet extends StatelessWidget {
  final BookingRequest booking;
  final VoidCallback onDone;

  const _BookingConfirmationSheet({
    required this.booking,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check_rounded, size: 40,
                color: colorScheme.onPrimaryContainer),
          ),
          const SizedBox(height: 16),
          Text(
            'Booking Confirmed!',
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            booking.hotelName,
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 0,
            color: colorScheme.surfaceContainerLow,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _infoRow(context, Icons.calendar_today_rounded,
                      '${DateFormat.MMMd().format(booking.checkIn)} — ${DateFormat.MMMd().format(booking.checkOut)}'),
                  const SizedBox(height: 8),
                  _infoRow(context, Icons.nights_stay_rounded,
                      '${booking.nights} ${booking.nights == 1 ? 'night' : 'nights'}'),
                  const SizedBox(height: 8),
                  _infoRow(context, Icons.people_rounded,
                      '${booking.guests} ${booking.guests == 1 ? 'guest' : 'guests'}'),
                  const SizedBox(height: 8),
                  _infoRow(context, Icons.bed_rounded,
                      '${booking.roomType} Room'),
                  const SizedBox(height: 8),
                  _infoRow(context, Icons.currency_rupee_rounded,
                      '\u20B9${booking.totalPrice.toInt().toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onDone,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text('Done'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(BuildContext context, IconData icon, String text) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 18, color: colorScheme.primary),
        const SizedBox(width: 12),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
        ),
      ],
    );
  }
}
