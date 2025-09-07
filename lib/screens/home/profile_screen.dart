import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../../models/user_models.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authService = context.read<AuthService>();
      final firestoreService = context.read<FirestoreService>();

      if (authService.currentUser != null) {
        // Load user's bookings
        firestoreService.fetchUserBookings(authService.currentUser!.uid);
      }
    });
  }

  Future<void> _signOut() async {
    final authService = context.read<AuthService>();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await authService.signOut();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Navigate to settings
            },
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: Consumer<AuthService>(
        builder: (context, authService, child) {
          final user = authService.currentAppUser;

          if (user == null) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_off_outlined,
                    size: 64,
                    color: AppTheme.mediumGray,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Not signed in',
                    style: AppTheme.headingSmall,
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Profile Header
                _buildProfileHeader(user),

                const SizedBox(height: 32),

                // Quick Stats (if user)
                if (user.role == UserRole.user) ...[
                  _buildQuickStats(),
                  const SizedBox(height: 32),
                ],

                // Menu Items
                _buildMenuSection(),

                const SizedBox(height: 32),

                // Sign Out Button
                _buildSignOutButton(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(AppUser user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          // Profile Picture
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white.withOpacity(0.2),
                backgroundImage: user.profileImageUrl != null
                    ? NetworkImage(user.profileImageUrl!)
                    : null,
                child: user.profileImageUrl == null
                    ? const Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.white,
                )
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    user.role == UserRole.therapist ? Icons.psychology : Icons.person,
                    size: 16,
                    color: AppTheme.primaryBlue,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // User Name
          Text(
            user.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 4),

          // User Email
          Text(
            user.email,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),

          const SizedBox(height: 8),

          // User Role Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              user.role == UserRole.therapist ? 'Therapist' : 'Member',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: const Duration(milliseconds: 600))
        .slideY(begin: -0.2, end: 0);
  }

  Widget _buildQuickStats() {
    return Consumer<FirestoreService>(
      builder: (context, firestoreService, child) {
        final totalBookings = firestoreService.userBookings.length;
        final completedBookings = firestoreService.userBookings
            .where((booking) => booking.status == BookingStatus.completed)
            .length;
        final pendingBookings = firestoreService.userBookings
            .where((booking) => booking.status == BookingStatus.pending)
            .length;

        return Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.calendar_month,
                value: totalBookings.toString(),
                label: 'Total Sessions',
                color: AppTheme.primaryBlue,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                icon: Icons.check_circle_outline,
                value: completedBookings.toString(),
                label: 'Completed',
                color: AppTheme.success,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                icon: Icons.schedule,
                value: pendingBookings.toString(),
                label: 'Pending',
                color: AppTheme.primaryGreen,
              ),
            ),
          ],
        );
      },
    )
        .animate()
        .fadeIn(delay: const Duration(milliseconds: 200), duration: const Duration(milliseconds: 600))
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
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Account',
          style: AppTheme.headingSmall,
        ),
        const SizedBox(height: 16),

        _buildMenuItem(
          icon: Icons.person_outline,
          title: 'Edit Profile',
          subtitle: 'Update your personal information',
          onTap: () {
            // TODO: Navigate to edit profile
          },
        ),

        _buildMenuItem(
          icon: Icons.history,
          title: 'My Bookings',
          subtitle: 'View your session history',
          onTap: () {
            // TODO: Navigate to bookings history
          },
        ),

        _buildMenuItem(
          icon: Icons.notifications,
          title: 'Notifications',
          subtitle: 'Manage notification preferences',
          onTap: () {
            // TODO: Navigate to notification settings
          },
        ),

        const SizedBox(height: 24),

        const Text(
          'Support',
          style: AppTheme.headingSmall,
        ),
        const SizedBox(height: 16),

        _buildMenuItem(
          icon: Icons.help_outline,
          title: 'Help & Support',
          subtitle: 'Get help and contact support',
          onTap: () {
            // TODO: Navigate to help
          },
        ),

        _buildMenuItem(
          icon: Icons.privacy_tip_outlined,
          title: 'Privacy Policy',
          subtitle: 'Read our privacy policy',
          onTap: () {
            // TODO: Navigate to privacy policy
          },
        ),

        _buildMenuItem(
          icon: Icons.description_outlined,
          title: 'Terms of Service',
          subtitle: 'Read our terms of service',
          onTap: () {
            // TODO: Navigate to terms
          },
        ),

        _buildMenuItem(
          icon: Icons.info_outline,
          title: 'About Lumina',
          subtitle: 'Learn more about our platform',
          onTap: () {
            _showAboutDialog();
          },
        ),
      ],
    )
        .animate()
        .fadeIn(delay: const Duration(milliseconds: 400), duration: const Duration(milliseconds: 600))
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
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
        title: Text(
          title,
          style: AppTheme.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppTheme.bodySmall.copyWith(
            color: AppTheme.mediumGray,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppTheme.mediumGray,
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  Widget _buildSignOutButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.error.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: _signOut,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.logout,
                  color: AppTheme.error,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sign Out',
                      style: AppTheme.bodyLarge.copyWith(
                        color: AppTheme.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Sign out of your account',
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.error.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppTheme.error.withOpacity(0.7),
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: const Duration(milliseconds: 600), duration: const Duration(milliseconds: 600))
        .slideY(begin: 0.2, end: 0);
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.psychology_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text('About Lumina'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lumina Mental Health Platform',
              style: AppTheme.bodyLarge,
            ),
            SizedBox(height: 8),
            Text(
              'Version 1.0.0',
              style: AppTheme.bodySmall,
            ),
            SizedBox(height: 16),
            Text(
              'Lumina is a comprehensive mental health platform designed to connect users with qualified therapists and provide a supportive community environment.',
              style: AppTheme.bodyMedium,
            ),
            SizedBox(height: 16),
            Text(
              'Our mission is to make mental healthcare accessible, affordable, and stigma-free for everyone.',
              style: AppTheme.bodyMedium,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}