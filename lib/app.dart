import 'package:flutter/material.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/register_screen.dart';
import 'features/dashboard/screens/home_dashboard.dart';
import 'features/canteen/screens/canteen_home.dart';
import 'features/lost_found/screens/lost_found_home.dart';
import 'features/scholarship/screens/scholarship_home.dart';

class CampusAidApp extends StatelessWidget {
  const CampusAidApp({super.key});

  @override
  Widget build(BuildContext context) {
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
        '/lost-found': (context) => const LostFoundHome(),
        '/scholarship': (context) => const ScholarshipHome(),
      },
    );
  }
}
