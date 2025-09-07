import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../../widgets/custom_widgets.dart';
import 'therapist_directory_screen.dart';
import 'anonymous_feed_screen.dart';
import '../booking/booking_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final firestoreService = context.read<FirestoreService>();
      firestoreService.fetchTherapists();
      firestoreService.fetchAnonymousPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(),

              const SizedBox(height: 32),

              // Welcome Card
              _buildWelcomeCard(),

              const SizedBox(height: 24),

              // Quick Actions
              _buildQuickActions(),

              const SizedBox(height: 32),

              // Featured Therapists
              _buildFeaturedTherapists(),

              const SizedBox(height: 32),

              // Recent Community Posts
              _buildRecentPosts(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        final user = authService.currentAppUser;
        final firstName = user?.name.split(' ').first ?? 'Guest';

        return Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good ${_getGreeting()},',
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.mediumGray,
                    ),
                  ),
                  Text(
                    firstName,
                    style: AppTheme.headingMedium,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.lightGray,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.notifications_outlined,
                color: AppTheme.darkGray,
              ),
            ),
          ],
        )
            .animate()
            .fadeIn(duration: const Duration(milliseconds: 600))
            .slideY(begin: -0.2, end: 0);
      },
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your mental wellness\njourney matters',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Connect with qualified therapists and\njoin a supportive community',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const TherapistDirectoryScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppTheme.primaryBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: const Text(
                        'Find a Therapist',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: const Icon(
                  Icons.psychology_rounded,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: const Duration(milliseconds: 200), duration: const Duration(milliseconds: 600))
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: AppTheme.headingSmall,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                icon: Icons.calendar_month,
                title: 'Book Session',
                subtitle: 'Schedule with therapist',
                color: AppTheme.primaryBlue,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const BookingFormScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildActionCard(
                icon: Icons.forum,
                title: 'Share Story',
                subtitle: 'Anonymous support',
                color: AppTheme.primaryGreen,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AnonymousFeedScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    )
        .animate()
        .fadeIn(delay: const Duration(milliseconds: 400), duration: const Duration(milliseconds: 600))
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: AppTheme.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: AppTheme.bodySmall.copyWith(
                color: AppTheme.mediumGray,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedTherapists() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Featured Therapists',
              style: AppTheme.headingSmall,
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const TherapistDirectoryScreen(),
                  ),
                );
              },
              child: const Text(
                'View All',
                style: TextStyle(color: AppTheme.primaryBlue),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Consumer<FirestoreService>(
          builder: (context, firestoreService, child) {
            if (firestoreService.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final featuredTherapists = firestoreService.therapists.take(3).toList();

            return Column(
              children: featuredTherapists.map((therapist) {
                return TherapistCard(
                  id: therapist.id,
                  name: therapist.name,
                  specialty: therapist.specialty,
                  qualification: therapist.qualification,
                  yearsOfExperience: therapist.yearsOfExperience,
                  rating: therapist.rating,
                  reviewCount: therapist.reviewCount,
                  profileImageUrl: therapist.profileImageUrl,
                  isAvailable: therapist.isAvailable,
                  onTap: () {
                    // TODO: Navigate to therapist detail
                  },
                );
              }).toList(),
            );
          },
        ),
      ],
    )
        .animate()
        .fadeIn(delay: const Duration(milliseconds: 600), duration: const Duration(milliseconds: 600))
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildRecentPosts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Community Stories',
              style: AppTheme.headingSmall,
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const AnonymousFeedScreen(),
                  ),
                );
              },
              child: const Text(
                'View All',
                style: TextStyle(color: AppTheme.primaryBlue),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Consumer<FirestoreService>(
          builder: (context, firestoreService, child) {
            if (firestoreService.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final recentPosts = firestoreService.anonymousPosts.take(2).toList();

            return Column(
              children: recentPosts.map((post) {
                return AnonymousPostCard(
                  content: post.content,
                  createdAt: post.createdAt,
                  likes: post.likes,
                );
              }).toList(),
            );
          },
        ),
      ],
    )
        .animate()
        .fadeIn(delay: const Duration(milliseconds: 800), duration: const Duration(milliseconds: 600))
        .slideY(begin: 0.2, end: 0);
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'morning';
    if (hour < 17) return 'afternoon';
    return 'evening';
  }
}