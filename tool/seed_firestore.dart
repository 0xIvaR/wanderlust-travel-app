// One-time script to seed Firestore with hotel data.
//
// HOW TO RUN (after Firestore is enabled in Firebase Console):
//   flutter run -t tool/seed_firestore.dart
//
// Run it once. After it finishes, your Firestore will have all 5 hotels.
// You can then delete this file or keep it for future reference.

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wanderlust/firebase_options.dart';
import 'package:wanderlust/services/firestore_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  print('Seeding hotels to Firestore...');
  try {
    await FirestoreService.seedHotels();
    print('Done! 5 hotels written to Firestore collection "hotels".');
  } catch (e) {
    print('Error: $e');
    print('Make sure Firestore is enabled in your Firebase Console.');
  }

  runApp(const _SeedApp());
}

class _SeedApp extends StatelessWidget {
  const _SeedApp();

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text(
            'Seed complete!\nCheck your Firestore Console.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
