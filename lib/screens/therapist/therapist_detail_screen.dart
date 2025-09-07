import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../models/user_models.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_widgets.dart';
import '../booking/booking_form_screen.dart';

class TherapistDetailScreen extends StatelessWidget {
  final Therapist therapist;

  const TherapistDetailScreen({
    super.key,
    required this.therapist,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppTheme.primaryBlue,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                    ),
                  ),
                  if (therapist.profileImageUrl != null)
                    Image.network(
                      therapist.profileImageUrl!,
                      fit: BoxFit.cover,
                    ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          therapist.name,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          therapist.specialty,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats Row
                  _buildStatsRow(),

                  const SizedBox(height: 32),

                  // About Section
                  _buildAboutSection(),

                  const SizedBox(height: 32),

                  // Qualification Section
                  _buildQualificationSection(),

                  const SizedBox(height: 32),

                  // Contact Section
                  _buildContactSection(),

                  const SizedBox(height: 100), // Space for floating button
                ],
              ),
            ),
          ),
        ],
      ),

      // Floating Book Session Button
      floatingActionButton: Consumer<AuthService>(
        builder: (context, authService, child) {
          return Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: FloatingActionButton.extended(
              onPressed: () {
                if (authService.currentUser != null) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BookingFormScreen(therapist: therapist),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please sign in to book a session'),
                      backgroundColor: AppTheme.error,
                    ),
                  );
                }
              },
              backgroundColor: AppTheme.primaryBlue,
              foregroundColor: Colors.white,
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              label: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.calendar_month, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    'Book Session',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.star,
            value: therapist.rating.toStringAsFixed(1),
            label: 'Rating',
            color: Colors.amber,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            icon: Icons.work_outline,
            value: '${therapist.yearsOfExperience}',
            label: 'Years Exp.',
            color: AppTheme.primaryBlue,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            icon: Icons.reviews_outlined,
            value: '${therapist.reviewCount}',
            label: 'Reviews',
            color: AppTheme.primaryGreen,
          ),
        ),
      ],
    )
        .animate()
        .fadeIn(duration: const Duration(milliseconds: 600))
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTheme.headingSmall.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTheme.bodySmall.copyWith(
              color: AppTheme.mediumGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About',
          style: AppTheme.headingSmall,
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.lightGray,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            therapist.bio,
            style: AppTheme.bodyMedium.copyWith(
              height: 1.6,
            ),
          ),
        ),
      ],
    )
        .animate()
        .fadeIn(delay: const Duration(milliseconds: 200), duration: const Duration(milliseconds: 600))
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildQualificationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Qualifications & Expertise',
          style: AppTheme.headingSmall,
        ),
        const SizedBox(height: 16),
        _buildInfoTile(
          icon: Icons.school_outlined,
          title: 'Education',
          subtitle: therapist.qualification,
        ),
        const SizedBox(height: 12),
        _buildInfoTile(
          icon: Icons.psychology_outlined,
          title: 'Specialty',
          subtitle: therapist.specialty,
        ),
        const SizedBox(height: 12),
        _buildInfoTile(
          icon: Icons.location_on_outlined,
          title: 'Location',
          subtitle: therapist.location,
        ),
        const SizedBox(height: 12),
        _buildInfoTile(
          icon: Icons.access_time,
          title: 'Availability',
          subtitle: therapist.isAvailable ? 'Available for bookings' : 'Currently unavailable',
          subtitleColor: therapist.isAvailable ? AppTheme.primaryGreen : AppTheme.error,
        ),
      ],
    )
        .animate()
        .fadeIn(delay: const Duration(milliseconds: 400), duration: const Duration(milliseconds: 600))
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildContactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Contact Information',
          style: AppTheme.headingSmall,
        ),
        const SizedBox(height: 16),
        _buildInfoTile(
          icon: Icons.email_outlined,
          title: 'Email',
          subtitle: therapist.email,
        ),
        const SizedBox(height: 12),
        _buildInfoTile(
          icon: Icons.phone_outlined,
          title: 'Phone',
          subtitle: therapist.phone,
        ),
      ],
    )
        .animate()
        .fadeIn(delay: const Duration(milliseconds: 600), duration: const Duration(milliseconds: 600))
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Color? subtitleColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightGray,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.softBlue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppTheme.primaryBlue,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.mediumGray,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTheme.bodyMedium.copyWith(
                    color: subtitleColor ?? AppTheme.darkGray,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}