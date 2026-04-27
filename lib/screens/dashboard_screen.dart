import 'package:flutter/material.dart';
import '../models/dashboard_models.dart';
import '../services/recommendation_engine.dart';
import '../widgets/dashboard_widgets.dart';

class DashboardScreen extends StatefulWidget {
  final String cityName;
  final Widget? mapWidget;
  final List<PlaceRecommendation> attractions;
  final List<PlaceRecommendation> foodPlaces;
  final List<TransportOption> transportOptions;
  final List<TicketInfo> ticketInfos;
  final List<SafetyTip> safetyTips;
  final double? userLat;
  final double? userLng;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;

  const DashboardScreen({
    super.key,
    required this.cityName,
    this.mapWidget,
    required this.attractions,
    required this.foodPlaces,
    required this.transportOptions,
    required this.ticketInfos,
    required this.safetyTips,
    this.userLat,
    this.userLng,
    this.isLoading = false,
    this.errorMessage,
    this.onRetry,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late List<PlaceRecommendation> _highlights;

  @override
  void initState() {
    super.initState();
    _computeHighlights();
  }

  @override
  void didUpdateWidget(covariant DashboardScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.attractions != widget.attractions) {
      _computeHighlights();
    }
  }

  void _computeHighlights() {
    _highlights = RecommendationEngine.getHighlights(widget.attractions);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (widget.isLoading) {
      return SafeArea(
        child: Column(
          children: [
            _HeaderSection(cityName: widget.cityName),
            const SizedBox(height: 16),
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Fetching real-time data...'),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (widget.errorMessage != null) {
      return SafeArea(
        child: Column(
          children: [
            _HeaderSection(cityName: widget.cityName),
            const SizedBox(height: 16),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.cloud_off_outlined,
                          size: 56, color: colorScheme.error),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to load data',
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.errorMessage!,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 24),
                      if (widget.onRetry != null)
                        FilledButton.icon(
                          onPressed: widget.onRetry,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HeaderSection(cityName: widget.cityName),
            const SizedBox(height: 16),
            _MapContainer(mapWidget: widget.mapWidget),
            const SizedBox(height: 24),
            _AiHighlightsSection(highlights: _highlights),
            const SizedBox(height: 16),
            _CollapsibleSectionCard(
              icon: Icons.location_on_outlined,
              title: 'Top Attractions',
              itemCount: widget.attractions.length,
              child: Column(
                children: widget.attractions
                    .map((a) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: AttractionListTile(place: a),
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 8),
            _CollapsibleSectionCard(
              icon: Icons.restaurant_outlined,
              title: 'Food & Restaurants',
              itemCount: widget.foodPlaces.length,
              child: Column(
                children: widget.foodPlaces
                    .map((f) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: AttractionListTile(
                              place: f, showPriceLevel: true),
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 8),
            _CollapsibleSectionCard(
              icon: Icons.directions_bus_outlined,
              title: 'Getting Around',
              itemCount: widget.transportOptions.length,
              child: _TransportContent(options: widget.transportOptions),
            ),
            const SizedBox(height: 8),
            _CollapsibleSectionCard(
              icon: Icons.confirmation_number_outlined,
              title: 'Tickets & Entry',
              itemCount: widget.ticketInfos.length,
              child: _TicketsContent(tickets: widget.ticketInfos),
            ),
            const SizedBox(height: 24),
            _SafetySection(tips: widget.safetyTips),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Header
// ---------------------------------------------------------------------------

class _HeaderSection extends StatelessWidget {
  final String cityName;

  const _HeaderSection({required this.cityName});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          Icon(Icons.explore_outlined, size: 28, color: colorScheme.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cityName,
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  'Live Travel Guide',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Chip(
            avatar:
                Icon(Icons.auto_awesome, size: 16, color: colorScheme.primary),
            label: Text(
              'AI Powered',
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            side: BorderSide(color: colorScheme.outlineVariant),
            backgroundColor: colorScheme.surface,
            visualDensity: VisualDensity.compact,
            padding: const EdgeInsets.symmetric(horizontal: 4),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Map
// ---------------------------------------------------------------------------

class _MapContainer extends StatelessWidget {
  final Widget? mapWidget;

  const _MapContainer({this.mapWidget});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colorScheme.outlineVariant),
          color: colorScheme.surfaceContainerLow,
        ),
        clipBehavior: Clip.antiAlias,
        child: mapWidget ??
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map_outlined,
                      size: 48, color: colorScheme.onSurfaceVariant),
                  const SizedBox(height: 8),
                  Text(
                    'Map Loading...',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// AI Highlights (always visible)
// ---------------------------------------------------------------------------

class _AiHighlightsSection extends StatelessWidget {
  final List<PlaceRecommendation> highlights;

  const _AiHighlightsSection({required this.highlights});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(Icons.auto_awesome, size: 22, color: colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'AI Highlights',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 46),
          child: Text(
            'Top scenic attractions picked for you',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 220,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: highlights.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) =>
                PlaceHighlightCard(place: highlights[index]),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Collapsible Section Card
// ---------------------------------------------------------------------------

class _CollapsibleSectionCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final int itemCount;
  final Widget child;

  const _CollapsibleSectionCard({
    required this.icon,
    required this.title,
    required this.itemCount,
    required this.child,
  });

  @override
  State<_CollapsibleSectionCard> createState() =>
      _CollapsibleSectionCardState();
}

class _CollapsibleSectionCardState extends State<_CollapsibleSectionCard>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late final AnimationController _animController;
  late final Animation<double> _expandAnimation;
  late final Animation<double> _iconTurns;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );
    _iconTurns = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _expanded = !_expanded;
      if (_expanded) {
        _animController.forward();
      } else {
        _animController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: colorScheme.outlineVariant),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            InkWell(
              onTap: _toggle,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Icon(widget.icon, size: 22, color: colorScheme.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.title,
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    if (widget.itemCount > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${widget.itemCount}',
                          style: textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSecondaryContainer,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    const SizedBox(width: 8),
                    RotationTransition(
                      turns: _iconTurns,
                      child: Icon(
                        Icons.expand_more,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizeTransition(
              sizeFactor: _expandAnimation,
              child: Column(
                children: [
                  Divider(
                      height: 1,
                      color: colorScheme.outlineVariant),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: widget.child,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Transport content (used inside collapsible card)
// ---------------------------------------------------------------------------

class _TransportContent extends StatelessWidget {
  final List<TransportOption> options;

  const _TransportContent({required this.options});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final List<Widget> children = [];
    for (int i = 0; i < options.length; i++) {
      children.add(TransportOptionTile(option: options[i]));
      if (i < options.length - 1) {
        children.add(Divider(
          height: 1,
          indent: 16,
          endIndent: 16,
          color: colorScheme.outlineVariant,
        ));
      }
    }
    return Column(children: children);
  }
}

// ---------------------------------------------------------------------------
// Tickets content (used inside collapsible card)
// ---------------------------------------------------------------------------

class _TicketsContent extends StatelessWidget {
  final List<TicketInfo> tickets;

  const _TicketsContent({required this.tickets});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final List<Widget> children = [];
    for (int i = 0; i < tickets.length; i++) {
      children.add(TicketInfoTile(ticket: tickets[i]));
      if (i < tickets.length - 1) {
        children
            .add(Divider(height: 1, color: colorScheme.outlineVariant));
      }
    }
    return Column(children: children);
  }
}

// ---------------------------------------------------------------------------
// Safety section (always visible, not collapsible)
// ---------------------------------------------------------------------------

class _SafetySection extends StatelessWidget {
  final List<SafetyTip> tips;

  const _SafetySection({required this.tips});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(Icons.shield_outlined,
                  size: 22, color: colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'Safety & Tips',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Card(
            elevation: 1,
            color: colorScheme.surfaceContainerLow,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: colorScheme.outlineVariant.withValues(alpha: 0.5),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(
                children: tips
                    .map((t) => ListTile(
                          leading: Icon(
                            Icons.info_outline,
                            color: t.type == 'warning'
                                ? colorScheme.error
                                : colorScheme.primary,
                            size: 22,
                          ),
                          title: Text(
                            t.tip,
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          ),
                          dense: true,
                        ))
                    .toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
