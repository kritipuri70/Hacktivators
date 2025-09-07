import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../services/auth_service.dart';
import '../../models/user_models.dart';
import '../../widgets/custom_widgets.dart';
import '../home/main_navigation.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;
  UserRole _selectedRole = UserRole.user;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate() && _agreeToTerms) {
      final authService = context.read<AuthService>();

      final success = await authService.signUpWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        name: _nameController.text.trim(),
        role: _selectedRole,
      );

      if (success && mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MainNavigation()),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authService.errorMessage ?? 'Sign up failed'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    } else if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to the terms and conditions'),
          backgroundColor: AppTheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Column(
                  children: [
                    const Text(
                      'Create Account',
                      style: AppTheme.headingLarge,
                      textAlign: TextAlign.center,
                    )
                        .animate()
                        .fadeIn()
                        .slideY(begin: -0.2, end: 0),

                    const SizedBox(height: 8),

                    const Text(
                      'Join our community and start your wellness journey',
                      style: AppTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    )
                        .animate()
                        .fadeIn(delay: const Duration(milliseconds: 200))
                        .slideY(begin: -0.2, end: 0),
                  ],
                ),

                const SizedBox(height: 32),

                // Role Selection
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'I am a:',
                      style: AppTheme.bodyLarge,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedRole = UserRole.user;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: _selectedRole == UserRole.user
                                    ? AppTheme.softBlue
                                    : AppTheme.lightGray,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _selectedRole == UserRole.user
                                      ? AppTheme.primaryBlue
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.person_outline,
                                    color: _selectedRole == UserRole.user
                                        ? AppTheme.primaryBlue
                                        : AppTheme.mediumGray,
                                    size: 32,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'User',
                                    style: TextStyle(
                                      color: _selectedRole == UserRole.user
                                          ? AppTheme.primaryBlue
                                          : AppTheme.mediumGray,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const Text(
                                    'Seeking support',
                                    style: AppTheme.bodySmall,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedRole = UserRole.therapist;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: _selectedRole == UserRole.therapist
                                    ? AppTheme.softGreen
                                    : AppTheme.lightGray,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _selectedRole == UserRole.therapist
                                      ? AppTheme.primaryGreen
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.psychology_outlined,
                                    color: _selectedRole == UserRole.therapist
                                        ? AppTheme.primaryGreen
                                        : AppTheme.mediumGray,
                                    size: 32,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Therapist',
                                    style: TextStyle(
                                      color: _selectedRole == UserRole.therapist
                                          ? AppTheme.primaryGreen
                                          : AppTheme.mediumGray,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const Text(
                                    'Providing support',
                                    style: AppTheme.bodySmall,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
                    .animate()
                    .fadeIn(delay: const Duration(milliseconds: 300))
                    .slideY(begin: 0.2, end: 0),

                const SizedBox(height: 32),

                // Form Fields
                Column(
                  children: [
                    CustomTextField(
                      controller: _nameController,
                      label: 'Full Name',
                      hint: 'Enter your full name',
                      prefixIcon: Icons.person_outline,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        if (value.length < 2) {
                          return 'Name must be at least 2 characters';
                        }
                        return null;
                      },
                    )
                        .animate()
                        .fadeIn(delay: const Duration(milliseconds: 400))
                        .slideX(begin: -0.2, end: 0),

                    const SizedBox(height: 16),

                    CustomTextField(
                      controller: _emailController,
                      label: 'Email',
                      hint: 'Enter your email',
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icons.email_outlined,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    )
                        .animate()
                        .fadeIn(delay: const Duration(milliseconds: 500))
                        .slideX(begin: -0.2, end: 0),

                    const SizedBox(height: 16),

                    CustomTextField(
                      controller: _passwordController,
                      label: 'Password',
                      hint: 'Enter your password',
                      obscureText: _obscurePassword,
                      prefixIcon: Icons.lock_outline,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    )
                        .animate()
                        .fadeIn(delay: const Duration(milliseconds: 600))
                        .slideX(begin: -0.2, end: 0),

                    const SizedBox(height: 16),

                    CustomTextField(
                      controller: _confirmPasswordController,
                      label: 'Confirm Password',
                      hint: 'Confirm your password',
                      obscureText: _obscureConfirmPassword,
                      prefixIcon: Icons.lock_outline,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                        icon: Icon(
                          _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    )
                        .animate()
                        .fadeIn(delay: const Duration(milliseconds: 700))
                        .slideX(begin: -0.2, end: 0),

                    const SizedBox(height: 24),

                    // Terms and Conditions
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: _agreeToTerms,
                          onChanged: (value) {
                            setState(() {
                              _agreeToTerms = value ?? false;
                            });
                          },
                          activeColor: AppTheme.primaryBlue,
                        ),
                        Expanded(
                          child: RichText(
                            text: const TextSpan(
                              style: AppTheme.bodySmall,
                              children: [
                                TextSpan(text: 'I agree to the '),
                                TextSpan(
                                  text: 'Terms of Service',
                                  style: TextStyle(
                                    color: AppTheme.primaryBlue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                TextSpan(text: ' and '),
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: TextStyle(
                                    color: AppTheme.primaryBlue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                        .animate()
                        .fadeIn(delay: const Duration(milliseconds: 800)),

                    const SizedBox(height: 32),

                    // Sign Up Button
                    Consumer<AuthService>(
                      builder: (context, authService, child) {
                        return CustomButton(
                          text: 'Create Account',
                          onPressed: authService.isLoading ? null : _signUp,
                          isLoading: authService.isLoading,
                        );
                      },
                    )
                        .animate()
                        .fadeIn(delay: const Duration(milliseconds: 900))
                        .slideY(begin: 0.2, end: 0),

                    const SizedBox(height: 24),

                    // Sign In Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account? ',
                          style: AppTheme.bodyMedium,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                              color: AppTheme.primaryBlue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    )
                        .animate()
                        .fadeIn(delay: const Duration(milliseconds: 1000)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}