import 'package:flutter/material.dart';

class CityOption {
  final String name;
  final String subtitle;
  final IconData icon;

  const CityOption({
    required this.name,
    required this.subtitle,
    required this.icon,
  });
}

class CityOptions {
  CityOptions._();

  static const List<CityOption> all = [
    CityOption(
      name: 'Darjeeling',
      subtitle: 'West Bengal, India',
      icon: Icons.terrain,
    ),
    CityOption(
      name: 'Manali',
      subtitle: 'Himachal Pradesh, India',
      icon: Icons.landscape,
    ),
    CityOption(
      name: 'Goa',
      subtitle: 'India',
      icon: Icons.beach_access,
    ),
    CityOption(
      name: 'Tokyo',
      subtitle: 'Japan',
      icon: Icons.location_city,
    ),
  ];

  static const List<String> cityNames = [
    'Darjeeling',
    'Manali',
    'Goa',
    'Tokyo',
  ];
}

