import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/register_screen.dart';
import 'features/dashboard/screens/home_dashboard.dart';
import 'features/canteen/screens/canteen_home.dart';
import 'features/lost_found/screens/lost_found_home_screen.dart';
import 'features/scholarship/screens/scholarship_home.dart';
import 'features/settings/screens/settings_screen.dart';
import 'features/profile/screens/user_profile_screen.dart';
import 'features/canteen/providers/canteen_provider.dart';
import 'features/canteen/services/gemini_service.dart';
import 'features/lost_found/providers/lost_found_provider.dart';
import 'features/scholarship/providers/scholarship_provider.dart';
import 'features/events/providers/events_provider.dart';
import 'features/events/screens/events_calendar_screen.dart';
import 'features/faculty_rating/providers/faculty_rating_provider.dart';
import 'features/faculty_rating/screens/faculty_list_screen.dart';
import 'features/auth/providers/auth_provider.dart';
import 'core/providers/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';

class CampusAidApp extends StatelessWidget {
  const CampusAidApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Create instances of providers
    final lostFoundProvider = LostFoundProvider();
    final scholarshipProvider = ScholarshipProvider();
    final themeProvider = ThemeProvider();
    final eventsProvider = EventsProvider();
    final facultyRatingProvider = FacultyRatingProvider();
    final authProvider = AuthProvider();

    print('App initialized - creating providers');

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CanteenProvider(GeminiService())),
        ChangeNotifierProvider.value(value: lostFoundProvider),
        ChangeNotifierProvider.value(value: scholarshipProvider),
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider.value(value: eventsProvider),
        ChangeNotifierProvider.value(value: facultyRatingProvider),
        ChangeNotifierProvider.value(value: authProvider),
      ],
      child: Builder(
        builder: (context) {
          // Access providers
          final provider = Provider.of<LostFoundProvider>(
            context,
            listen: false,
          );
          final theme = Provider.of<ThemeProvider>(context);
          final auth = Provider.of<AuthProvider>(context);

          print(
            'LostFoundProvider initialized with ${provider.items.length} items',
          );

          // Define light and dark themes
          final lightTheme = ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF3066BE),
              brightness: Brightness.light,
            ),
            useMaterial3: true,
            fontFamily: 'Poppins',
          );

          final darkTheme = ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF3066BE),
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
            fontFamily: 'Poppins',
          );

          // Apply font size adjustments to both themes
          final adjustedLightTheme = lightTheme.copyWith(
            textTheme: theme.getAdjustedTextTheme(lightTheme.textTheme),
          );

          final adjustedDarkTheme = darkTheme.copyWith(
            textTheme: theme.getAdjustedTextTheme(darkTheme.textTheme),
          );

          return MaterialApp(
            title: 'Campus Aid',
            debugShowCheckedModeBanner: false,
            theme: adjustedLightTheme,
            darkTheme: adjustedDarkTheme,
            themeMode: theme.themeMode,
            initialRoute: '/login',
            routes: {
              '/login': (context) => const LoginScreen(),
              '/register': (context) => const RegisterScreen(),
              '/dashboard': (context) => const HomeDashboard(),
              '/canteen': (context) => const CanteenHome(),
              '/lost-found': (context) {
                // Debug print when navigating to Lost & Found
                print('Navigating to Lost & Found screen');
                return const LostFoundHomeScreen();
              },
              '/scholarship': (context) => const ScholarshipHome(),
              '/settings': (context) => const SettingsScreen(),
              '/profile': (context) => const UserProfileScreen(),
              '/faculty-rating': (context) => const FacultyListScreen(),
              '/events': (context) => const EventsCalendarScreen(),
            },
          );
        },
      ),
    );
  }
}
