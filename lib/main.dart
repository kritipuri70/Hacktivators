import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/therapist_provider.dart';
import 'providers/ai_service_provider.dart';
import 'providers/user_profile_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'screens/therapist_signup_screen.dart';
import 'screens/therapist_directory_screen.dart';
import 'screens/ai_therapist_screen.dart';
import 'screens/ai_companion_screen.dart';
import 'screens/meditation_screen.dart';
import 'screens/affirmations_screen.dart';
import 'screens/suggestions_screen.dart';
import 'screens/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  runApp(const LuminaApp());
}

class LuminaApp extends StatelessWidget {
  const LuminaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TherapistProvider()),
        ChangeNotifierProvider(create: (_) => AIServiceProvider()),
        ChangeNotifierProvider(create: (_) => UserProfileProvider()),
      ],
      child: MaterialApp(
        title: 'Lumina',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6B73FF),
            brightness: Brightness.light,
          ),
          // fontFamily: 'Inter', // Commented out for now
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6B73FF),
            brightness: Brightness.dark,
          ),
          // fontFamily: 'Inter', // Commented out for now
        ),
        home: const SplashScreen(),
        routes: {
          '/auth': (context) => const AuthScreen(),
          '/home': (context) => const HomeScreen(),
          '/therapist-signup': (context) => const TherapistSignupScreen(),
          '/therapist-directory': (context) => const TherapistDirectoryScreen(),
          '/ai-therapist': (context) => const AITherapistScreen(),
          '/ai-companion': (context) => const AICompanionScreen(),
          '/meditation': (context) => const MeditationScreen(),
          '/affirmations': (context) => const AffirmationsScreen(),
          '/suggestions': (context) => const SuggestionsScreen(),
          '/profile': (context) => const ProfileScreen(),
        },
      ),
    );
  }
}