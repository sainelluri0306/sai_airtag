import 'package:flutter/material.dart';
import 'package:macless_haystack/dashboard/dashboard.dart';
import 'package:provider/provider.dart';
import 'package:macless_haystack/accessory/accessory_registry.dart';
import 'package:macless_haystack/location/location_model.dart';
import 'package:macless_haystack/preferences/user_preferences_model.dart';
import 'package:macless_haystack/splashscreen.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  Settings.init();
  initializeDateFormatting();
  runApp(const MyApp());
}

const _background = Color(0xFF050506);
const _surface = Color(0xFF121214);
const _surfaceHigh = Color(0xFF1C1C21);
const _primary = Color(0xFF7DD3C7);
const _onPrimary = Color(0xFF04201C);
const _secondary = Color(0xFFE2C58D);
const _onSurface = Color(0xFFEDEDEF);
const _muted = Color(0xFF8E8E96);

ThemeData _trackerDarkTheme() {
  final colorScheme = const ColorScheme.dark(
    primary: _primary,
    onPrimary: _onPrimary,
    secondary: _secondary,
    onSecondary: Color(0xFF1A1408),
    surface: _surface,
    onSurface: _onSurface,
    error: Color(0xFFFF8A80),
    onError: Color(0xFF3B0000),
  );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: _background,
    canvasColor: _background,
    appBarTheme: const AppBarTheme(
      backgroundColor: _background,
      foregroundColor: _onSurface,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: _surface,
      selectedItemColor: _primary,
      unselectedItemColor: _muted,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _primary,
      foregroundColor: _onPrimary,
      elevation: 2,
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: _surfaceHigh,
      contentTextStyle: TextStyle(color: _onSurface),
      behavior: SnackBarBehavior.floating,
    ),
    cardTheme: const CardThemeData(
      color: _surface,
      elevation: 0,
    ),
    dividerColor: const Color(0xFF2A2A30),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final darkTheme = _trackerDarkTheme();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => AccessoryRegistry()),
        ChangeNotifierProvider(create: (ctx) => UserPreferences()),
        ChangeNotifierProvider(create: (ctx) => LocationModel()),
      ],
      child: MaterialApp(
        title: 'My Trackers',
        theme: darkTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.dark,
        home: const AppLayout(),
      ),
    );
  }
}

class AppLayout extends StatefulWidget {
  const AppLayout({super.key});

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  @override
  initState() {
    super.initState();

    var accessoryRegistry =
        Provider.of<AccessoryRegistry>(context, listen: false);
    accessoryRegistry.loadAccessories();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // Precache logo for faster load times (e.g. on the splash screen)
    precacheImage(const AssetImage('assets/OpenHaystackIcon.png'), context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    bool isInitialized = context.watch<UserPreferences>().initialized;
    bool isLoading = context.watch<AccessoryRegistry>().loading;
    if (!isInitialized || isLoading) {
      return const Splashscreen();
    }

    return const Dashboard();
  }
}
