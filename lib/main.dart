import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/home_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/profile_screen.dart';
import 'providers/user_profile_provider.dart';
import 'providers/app_settings_provider.dart';
import 'providers/dashboard_data_provider.dart';
import 'widgets/dashboard_map_widget.dart';
import 'services/profile_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final savedProfile = await ProfileStorageService.load();
  runApp(MyApp(initialProfile: savedProfile));
}

class MyApp extends StatefulWidget {
  final UserProfile initialProfile;

  const MyApp({super.key, required this.initialProfile});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late UserProfile _userProfile = widget.initialProfile;
  AppSettings _appSettings = const AppSettings();
  late final ThemeData _lightTheme = _buildLightTheme();
  late final ThemeData _darkTheme = _buildDarkTheme();

  void _updateProfile(UserProfile newProfile) {
    setState(() {
      _userProfile = newProfile;
    });
    ProfileStorageService.save(newProfile);
  }

  void _updateSettings(AppSettings newSettings) {
    setState(() {
      _appSettings = newSettings;
    });
  }

  ThemeData _buildLightTheme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: 'Outfit',
      typography: Typography.material2021(),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 2,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        surfaceTintColor: colorScheme.surfaceTint,
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 3,
        backgroundColor: colorScheme.surfaceContainer,
        indicatorColor: colorScheme.secondaryContainer,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(
              fontFamily: 'Outfit',
              color: colorScheme.onSurface,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            );
          }
          return TextStyle(
            fontFamily: 'Outfit',
            color: colorScheme.onSurfaceVariant,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(
              color: colorScheme.onSecondaryContainer,
              size: 24,
            );
          }
          return IconThemeData(
            color: colorScheme.onSurfaceVariant,
            size: 24,
          );
        }),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(fontFamily: 'Outfit'),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        surfaceTintColor: colorScheme.surfaceTint,
      ),
      searchBarTheme: SearchBarThemeData(
        elevation: WidgetStateProperty.all(1),
        backgroundColor: WidgetStateProperty.all(colorScheme.surfaceContainerHigh),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  // Dark theme with Material 3
  ThemeData _buildDarkTheme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: 'Outfit',
      typography: Typography.material2021(),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 2,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        surfaceTintColor: colorScheme.surfaceTint,
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 3,
        backgroundColor: colorScheme.surfaceContainer,
        indicatorColor: colorScheme.secondaryContainer,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(
              fontFamily: 'Outfit',
              color: colorScheme.onSurface,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            );
          }
          return TextStyle(
            fontFamily: 'Outfit',
            color: colorScheme.onSurfaceVariant,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(
              color: colorScheme.onSecondaryContainer,
              size: 24,
            );
          }
          return IconThemeData(
            color: colorScheme.onSurfaceVariant,
            size: 24,
          );
        }),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(fontFamily: 'Outfit'),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        surfaceTintColor: colorScheme.surfaceTint,
      ),
      searchBarTheme: SearchBarThemeData(
        elevation: WidgetStateProperty.all(1),
        backgroundColor: WidgetStateProperty.all(colorScheme.surfaceContainerHigh),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return UserProfileProvider(
      profile: _userProfile,
      onProfileChanged: _updateProfile,
      child: AppSettingsProvider(
        settings: _appSettings,
        onSettingsChanged: _updateSettings,
        child: MaterialApp(
          title: 'Wanderlust',
          debugShowCheckedModeBanner: false,
          theme: _lightTheme,
          darkTheme: _darkTheme,
          themeMode: _appSettings.themeMode,
          home: const MyHomePage(),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final DashboardDataProvider _dashboardProvider = DashboardDataProvider();
  String _lastCity = '';

  @override
  void initState() {
    super.initState();
    _dashboardProvider.addListener(_onDataChanged);
  }

  @override
  void dispose() {
    _dashboardProvider.removeListener(_onDataChanged);
    _dashboardProvider.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final profileProvider = UserProfileProvider.of(context);
    final selectedCity = profileProvider?.profile.selectedCity ?? 'Darjeeling';
    _ensureCityLoaded(selectedCity);
  }

  void _onDataChanged() {
    if (mounted) setState(() {});
  }

  void _ensureCityLoaded(String city) {
    if (_lastCity != city) {
      _lastCity = city;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _dashboardProvider.loadCity(city);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = UserProfileProvider.of(context);
    final selectedCity = profileProvider?.profile.selectedCity ?? 'Darjeeling';

    final cityData = _dashboardProvider.currentCityData;
    final isLoading = _dashboardProvider.isLoading;
    final error = _dashboardProvider.error;

    Widget dashboardScreen;
    if (isLoading || cityData == null && error == null) {
      dashboardScreen = DashboardScreen(
        cityName: selectedCity,
        attractions: const [],
        foodPlaces: const [],
        transportOptions: const [],
        ticketInfos: const [],
        safetyTips: const [],
        isLoading: true,
      );
    } else if (error != null && cityData == null) {
      dashboardScreen = DashboardScreen(
        cityName: selectedCity,
        attractions: const [],
        foodPlaces: const [],
        transportOptions: const [],
        ticketInfos: const [],
        safetyTips: const [],
        errorMessage: error,
        onRetry: () {
          _lastCity = '';
          _ensureCityLoaded(selectedCity);
        },
      );
    } else {
      dashboardScreen = DashboardScreen(
        cityName: cityData!.cityName,
        mapWidget: DashboardMapWidget(
          key: ValueKey('map_${cityData.cityName}'),
          attractions: cityData.attractions,
          foodPlaces: cityData.foodPlaces,
          initialLat: cityData.initialLat,
          initialLng: cityData.initialLng,
        ),
        attractions: cityData.attractions,
        foodPlaces: cityData.foodPlaces,
        transportOptions: cityData.transportOptions,
        ticketInfos: cityData.ticketInfos,
        safetyTips: cityData.safetyTips,
      );
    }

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          const RepaintBoundary(child: HomeScreen()),
          RepaintBoundary(child: dashboardScreen),
          const RepaintBoundary(child: ProfileScreen()),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.view_comfy_outlined),
            selectedIcon: Icon(Icons.view_comfy),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

