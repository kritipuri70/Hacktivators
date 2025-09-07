import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_widgets.dart';  // This single import contains both CustomButton and CustomTextField
import '../home/main_navigation.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      final authService = context.read<AuthService>();

      final success = await authService.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (success && mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MainNavigation()),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authService.errorMessage ?? 'Login failed'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    final authService = context.read<AuthService>();

    final success = await authService.signInWithGoogle();

    if (success && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainNavigation()),
      );
    } else if (mounted && authService.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authService.errorMessage!),
          backgroundColor: AppTheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),

                // Logo and Welcome Text
                Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.psychology_rounded,
                        size: 40,
                        color: Colors.white,
                      ),
                    )
                        .animate()
                        .scale(
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.elasticOut,
                    )
                        .fadeIn(),

                    const SizedBox(height: 32),

                    const Text(
                      'Welcome Back',
                      style: AppTheme.headingLarge,
                      textAlign: TextAlign.center,
                    )
                        .animate()
                        .fadeIn(delay: const Duration(milliseconds: 200))
                        .slideY(begin: 0.2, end: 0),

                    const SizedBox(height: 8),

                    const Text(
                      'Sign in to continue your wellness journey',
                      style: AppTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    )
                        .animate()
                        .fadeIn(delay: const Duration(milliseconds: 400))
                        .slideY(begin: 0.2, end: 0),
                  ],
                ),

                const SizedBox(height: 48),

                // Login Form
                Column(
                  children: [
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
                        .fadeIn(delay: const Duration(milliseconds: 600))
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
                        .fadeIn(delay: const Duration(milliseconds: 700))
                        .slideX(begin: -0.2, end: 0),

                    const SizedBox(height: 16),

                    // Remember Me & Forgot Password
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = value ?? false;
                                });
                              },
                              activeColor: AppTheme.primaryBlue,
                            ),
                            const Text(
                              'Remember me',
                              style: AppTheme.bodySmall,
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            // TODO: Implement forgot password
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(color: AppTheme.primaryBlue),
                          ),
                        ),
                      ],
                    )
                        .animate()
                        .fadeIn(delay: const Duration(milliseconds: 800)),

                    const SizedBox(height: 32),

                    // Sign In Button
                    Consumer<AuthService>(
                      builder: (context, authService, child) {
                        return CustomButton(
                          text: 'Sign In',
                          onPressed: authService.isLoading ? null : _signIn,
                          isLoading: authService.isLoading,
                        );
                      },
                    )
                        .animate()
                        .fadeIn(delay: const Duration(milliseconds: 900))
                        .slideY(begin: 0.2, end: 0),

                    const SizedBox(height: 24),

                    // Or Divider
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'OR',
                            style: AppTheme.bodySmall.copyWith(
                              color: AppTheme.mediumGray,
                            ),
                          ),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    )
                        .animate()
                        .fadeIn(delay: const Duration(milliseconds: 1000)),

                    const SizedBox(height: 24),

                    // Google Sign In Button
                    Consumer<AuthService>(
                      builder: (context, authService, child) {
                        return OutlinedButton.icon(
                          onPressed: authService.isLoading ? null : _signInWithGoogle,
                          icon: const Icon(Icons.g_mobiledata, size: 24),
                          label: const Text('Continue with Google'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(color: AppTheme.mediumGray),
                          ),
                        );
                      },
                    )
                        .animate()
                        .fadeIn(delay: const Duration(milliseconds: 1100))
                        .slideY(begin: 0.2, end: 0),

                    const SizedBox(height: 48),

                    // Sign Up Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account? ",
                          style: AppTheme.bodyMedium,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const SignUpScreen()),
                            );
                          },
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              color: AppTheme.primaryBlue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    )
                        .animate()
                        .fadeIn(delay: const Duration(milliseconds: 1200)),
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