import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../core/theme/app_theme.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../services/notification_service.dart';
import 'auth/login_screen.dart';
import 'home/main_navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Initialize services
    final notificationService = context.read<NotificationService>();
    final firestoreService = context.read<FirestoreService>();

    await notificationService.initialize();
    await firestoreService.initializeDummyData();
    await firestoreService.fetchTherapists();
    await firestoreService.fetchAnonymousPosts();

    // Wait for minimum splash duration
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      final authService = context.read<AuthService>();

      // Navigate based on authentication status
      if (authService.currentUser != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MainNavigation()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.primaryGradient,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Container
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.psychology_rounded,
                  size: 60,
                  color: AppTheme.primaryBlue,
                ),
              )
                  .animate()
                  .scale(
                delay: const Duration(milliseconds: 300),
                duration: const Duration(milliseconds: 800),
                curve: Curves.elasticOut,
              )
                  .fadeIn(duration: const Duration(milliseconds: 600)),

              const SizedBox(height: 40),

              // App Name
              const Text(
                'Lumina',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              )
                  .animate()
                  .fadeIn(
                delay: const Duration(milliseconds: 800),
                duration: const Duration(milliseconds: 600),
              )
                  .slideY(
                begin: 0.3,
                end: 0,
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOut,
              ),

              const SizedBox(height: 16),

              // Tagline
              const Text(
                'Your mental wellness journey starts here',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              )
                  .animate()
                  .fadeIn(
                delay: const Duration(milliseconds: 1200),
                duration: const Duration(milliseconds: 600),
              )
                  .slideY(
                begin: 0.2,
                end: 0,
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOut,
              ),

              const SizedBox(height: 80),

              // Loading Indicator
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 3,
                ),
              )
                  .animate(onPlay: (controller) => controller.repeat())
                  .fadeIn(
                delay: const Duration(milliseconds: 1600),
                duration: const Duration(milliseconds: 400),
              )
                  .scale(
                delay: const Duration(milliseconds: 1600),
                duration: const Duration(milliseconds: 400),
              ),

              const SizedBox(height: 24),

              // Loading Text
              const Text(
                'Setting up your wellness space...',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white60,
                ),
              )
                  .animate()
                  .fadeIn(
                delay: const Duration(milliseconds: 2000),
                duration: const Duration(milliseconds: 400),
              ),
            ],
          ),
        ),
      ),
    );
  }
}