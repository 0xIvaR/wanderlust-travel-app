import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/destination_search_bar.dart';
import '../widgets/hotel_card.dart';
import '../models/hotel_model.dart';
import '../providers/booking_provider.dart';
import '../providers/hotel_provider.dart';
import 'hotel_booking_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final CarouselController _controller =
      CarouselController(initialItem: 0);
  final BookingProvider _bookingProvider = BookingProvider();
  final HotelProvider _hotelProvider = HotelProvider();

  static const int _imageCardCount = 4;

  static const List<String> _cardImages = [
    'pics/KASHMIR.png',
    'pics/KERALA.png',
    'pics/MEGHALAYA.png',
    'pics/RAJASTHAN.png',
  ];

  static const List<String> _cardLabels = [
    'Kashmir',
    'Kerala',
    'Meghalaya',
    'Rajasthan',
  ];

  @override
  void dispose() {
    _hotelProvider.removeListener(_onHotelsChanged);
    _controller.dispose();
    _bookingProvider.dispose();
    _hotelProvider.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _hotelProvider.addListener(_onHotelsChanged);
  }

  void _onHotelsChanged() {
    if (mounted) setState(() {});
  }

  void _openBookingScreen(Hotel hotel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HotelBookingScreen(
          hotel: hotel,
          bookingProvider: _bookingProvider,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double carouselHeight =
              (constraints.maxHeight - 280).clamp(120.0, 280.0);

          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomAppBar(),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                    child: Text(
                      'Where to\nnext?',
                      style: textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w400,
                        color: colorScheme.onSurface,
                        height: 1.1,
                      ),
                    ),
                  ),

                  const DestinationSearchBar(),
                  const SizedBox(height: 12),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: SizedBox(
                      height: carouselHeight,
                      child: CarouselView.weighted(
                        controller: _controller,
                        itemSnapping: true,
                        flexWeights: const <int>[7, 2],
                        consumeMaxWeight: false,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        children: [
                          ...List.generate(_imageCardCount, (index) {
                            return LayoutBuilder(
                              builder: (context, cardConstraints) {
                                final bool isBig = cardConstraints.maxWidth > 120;
                                final double opacity = isBig
                                    ? ((cardConstraints.maxWidth - 120) / 80)
                                        .clamp(0.0, 1.0)
                                    : 0.0;
                                return Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(28),
                                      child: Image.asset(
                                        _cardImages[index],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(28),
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.transparent,
                                            Colors.black.withValues(alpha: 0.55),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 16,
                                      bottom: 16,
                                      child: AnimatedOpacity(
                                        opacity: opacity,
                                        duration: const Duration(milliseconds: 250),
                                        curve: Curves.easeInOut,
                                        child: Text(
                                          _cardLabels[index],
                                          style: textTheme.titleLarge?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            shadows: const [
                                              Shadow(
                                                blurRadius: 6,
                                                color: Colors.black54,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          }),

                          LayoutBuilder(
                            builder: (context, cardConstraints) {
                              final double opacity =
                                  ((cardConstraints.maxWidth - 20) / 60)
                                      .clamp(0.0, 1.0);
                              return Container(
                                color: colorScheme.surfaceContainerHighest,
                                child: Center(
                                  child: AnimatedOpacity(
                                    opacity: opacity,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                    child: Icon(
                                      Icons.explore_rounded,
                                      size: 32,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Hotel booking section
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Book a Hotel',
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        FilledButton.tonal(
                          onPressed: () {},
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            minimumSize: Size.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text('See All'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  AnimatedBuilder(
                    animation: _hotelProvider,
                    builder: (context, _) {
                      if (_hotelProvider.isLoading) {
                        return SizedBox(
                          height: 310,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: 3,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 12),
                            itemBuilder: (_, __) => _HotelCardSkeleton(
                                colorScheme: colorScheme),
                          ),
                        );
                      }
                      final hotels = _hotelProvider.hotels;
                      return SizedBox(
                        height: 310,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: hotels.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            final hotel = hotels[index];
                            return HotelCard(
                              hotel: hotel,
                              onTap: () => _openBookingScreen(hotel),
                              onBookNow: () => _openBookingScreen(hotel),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _HotelCardSkeleton extends StatelessWidget {
  final ColorScheme colorScheme;

  const _HotelCardSkeleton({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 130,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
              child: Container(
                height: 14,
                width: 140,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 6),
              child: Container(
                height: 12,
                width: 80,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
