# Wanderlust

Wanderlust is a Flutter travel planning app with destination discovery, real-time place recommendations, Google Maps integration, hotel booking screens, user profiles, and Material 3 light/dark themes.

## Download

After creating the GitHub repository, use this suggested repository name:

```text
wanderlust-travel-app
```

When you publish a GitHub Release, upload the Android APK with this exact file name:

```text
wanderlust.apk
```

Then this direct download link will work:

[Download Wanderlust APK](https://github.com/your-github-username/wanderlust-travel-app/releases/latest/download/wanderlust.apk)

Replace `your-github-username` with your GitHub username after the repository is created.

## Screenshots

Add your app screenshots inside `pics_github/` with these names so they render on GitHub:

| Home | Dashboard | Profile | Booking |
| --- | --- | --- | --- |
| <img src="pics_github/home.png" width="180" alt="Wanderlust home screen"> | <img src="pics_github/dashboard.png" width="180" alt="Wanderlust dashboard screen"> | <img src="pics_github/profile.png" width="180" alt="Wanderlust profile screen"> | <img src="pics_github/booking.png" width="180" alt="Wanderlust hotel booking screen"> |

## Features

- Destination carousel and search-focused home screen
- Google Maps-powered travel dashboard
- Real place, restaurant, rating, distance, and photo data from Google APIs
- Hotel cards and booking flow with room/date selection
- Editable user profile with saved preferences
- Firebase setup for app services
- Material 3 UI with custom Outfit typography

## Tech Stack

- Flutter and Dart
- Firebase Core, Auth, Firestore, and Storage
- Google Maps Flutter
- Google Places, Geocoding, and Distance Matrix APIs

## Setup

Install Flutter, then fetch dependencies:

```bash
flutter pub get
```

This repository intentionally does not commit local API keys or Firebase generated config. Create your Firebase files locally before running the app:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

Run the app with your Google Maps API key:

```bash
flutter run --dart-define=GOOGLE_MAPS_API_KEY=your_google_maps_api_key
```

For iOS, copy the sample secret config and add your key:

```bash
cp ios/Flutter/Secrets.xcconfig.example ios/Flutter/Secrets.xcconfig
```

For Android, the same `--dart-define` value is also passed into the native Google Maps manifest placeholder.

## Public Repository Notes

The `.gitignore` keeps local secrets, generated Firebase files, signing keys, build output, and machine-specific Flutter/Android settings out of Git. Before publishing, make sure your Google and Firebase API keys are restricted in their cloud consoles.
