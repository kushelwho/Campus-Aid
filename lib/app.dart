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

class CampusAidApp extends StatelessWidget {
  const CampusAidApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Create a single instance of the LostFoundProvider to ensure we're using the same one everywhere
    final lostFoundProvider = LostFoundProvider();

    print('App initialized - creating providers');

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CanteenProvider(GeminiService())),
        // Use the instance we created to ensure consistency
        ChangeNotifierProvider.value(value: lostFoundProvider),
      ],
      child: Builder(
        builder: (context) {
          // Verify provider is accessible in the root
          final provider = Provider.of<LostFoundProvider>(
            context,
            listen: false,
          );
          print(
            'LostFoundProvider initialized with ${provider.items.length} items',
          );

          return MaterialApp(
            title: 'Campus Aid',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF3066BE),
                brightness: Brightness.light,
              ),
              useMaterial3: true,
              fontFamily: 'Poppins',
            ),
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
            },
          );
        },
      ),
    );
  }
}
