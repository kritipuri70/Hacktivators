import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_theme.dart';
import '../../models/user_models.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../../widgets/custom_widgets.dart';

class BookingFormScreen extends StatefulWidget {
  final Therapist? therapist;

  const BookingFormScreen({
    super.key,
    this.therapist,
  });

  @override
  State<BookingFormScreen> createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _concernController = TextEditingController();
  final _dateController = TextEditingController();

  DateTime? _selectedDate;
  String? _selectedTime;
  Therapist? _selectedTherapist;

  final List<String> _timeSlots = [
    '09:00 AM',
    '10:00 AM',
    '11:00 AM',
    '02:00 PM',
    '03:00 PM',
    '04:00 PM',
    '05:00 PM',
  ];

  @override
  void initState() {
    super.initState();
    _selectedTherapist = widget.therapist;

    // Pre-fill user information if logged in
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authService = context.read<AuthService>();
      final user = authService.currentAppUser;
      if (user != null) {
        _nameController.text = user.name;
        _emailController.text = user.email;
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _concernController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primaryBlue,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('EEEE, MMM dd, yyyy').format(picked);
      });
    }
  }

  Future<void> _submitBooking() async {
    if (_formKey.currentState!.validate() &&
        _selectedTherapist != null &&
        _selectedDate != null &&
        _selectedTime != null) {
      final authService = context.read<AuthService>();
      final firestoreService = context.read<FirestoreService>();

      if (authService.currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please sign in to book a session'),
            backgroundColor: AppTheme.error,
          ),
        );
        return;
      }

      final success = await firestoreService.createBooking(
        userId: authService.currentUser!.uid,
        therapistId: _selectedTherapist!.id,
        userName: _nameController.text.trim(),
        userEmail: _emailController.text.trim(),
        userPhone: _phoneController.text.trim(),
        preferredDate: _selectedDate!,
        preferredTime: _selectedTime!,
        concern: _concernController.text.trim(),
      );

      if (success && mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: AppTheme.softGreen,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: AppTheme.primaryGreen,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Booking Submitted!',
                  style: AppTheme.headingSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Your booking request has been sent to ${_selectedTherapist!.name}. They will contact you soon to confirm the appointment.',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.mediumGray,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog
                      Navigator.of(context).pop(); // Close booking form
                    },
                    child: const Text('Done'),
                  ),
                ),
              ],
            ),
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(firestoreService.errorMessage ?? 'Booking failed'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Session'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                if (_selectedTherapist != null) ...[
                  _buildTherapistCard(),
                  const SizedBox(height: 32),
                ],

                // Select Therapist (if not pre-selected)
                if (_selectedTherapist == null) ...[
                  _buildTherapistSelector(),
                  const SizedBox(height: 24),
                ],

                // Personal Information
                _buildPersonalInfoSection(),

                const SizedBox(height: 32),

                // Date & Time Selection
                _buildDateTimeSection(),

                const SizedBox(height: 32),

                // Concern/Reason
                _buildConcernSection(),

                const SizedBox(height: 40),

                // Submit Button
                Consumer<FirestoreService>(
                  builder: (context, firestoreService, child) {
                    return CustomButton(
                      text: 'Submit Booking Request',
                      onPressed:
                      firestoreService.isLoading ? null : _submitBooking,
                      isLoading: firestoreService.isLoading,
                      icon: Icons.send,
                    );
                  },
                ),

                const SizedBox(height: 16),

                // Disclaimer
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.softBlue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: AppTheme.primaryBlue,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Your booking request will be sent to the therapist. They will contact you within 24 hours to confirm the appointment.',
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTherapistCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.lightGray,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppTheme.softBlue,
            backgroundImage: _selectedTherapist!.profileImageUrl != null
                ? NetworkImage(_selectedTherapist!.profileImageUrl!)
                : null,
            child: _selectedTherapist!.profileImageUrl == null
                ? const Icon(Icons.person,
                size: 30, color: AppTheme.primaryBlue)
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selectedTherapist!.name,
                  style: AppTheme.headingSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  _selectedTherapist!.specialty,
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.primaryBlue,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, size: 16, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      _selectedTherapist!.rating.toStringAsFixed(1),
                      style: AppTheme.bodySmall,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${_selectedTherapist!.yearsOfExperience} years exp.',
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.mediumGray,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: const Duration(milliseconds: 600))
        .slideY(begin: -0.2, end: 0);
  }

  Widget _buildTherapistSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Therapist',
          style: AppTheme.headingSmall,
        ),
        const SizedBox(height: 16),
        Consumer<FirestoreService>(
          builder: (context, firestoreService, child) {
            if (firestoreService.therapists.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppTheme.lightGray,
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<Therapist>(
                  value: _selectedTherapist,
                  hint: const Text('Choose a therapist'),
                  isExpanded: true,
                  items: firestoreService.therapists.map((therapist) {
                    return DropdownMenuItem<Therapist>(
                      value: therapist,
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: AppTheme.softBlue,
                            backgroundImage: therapist.profileImageUrl != null
                                ? NetworkImage(therapist.profileImageUrl!)
                                : null,
                            child: therapist.profileImageUrl == null
                                ? const Icon(Icons.person, size: 16)
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  therapist.name,
                                  style: AppTheme.bodyMedium,
                                ),
                                Text(
                                  therapist.specialty,
                                  style: AppTheme.bodySmall.copyWith(
                                    color: AppTheme.mediumGray,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (therapist) {
                    setState(() {
                      _selectedTherapist = therapist;
                    });
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPersonalInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Personal Information',
          style: AppTheme.headingSmall,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _nameController,
          label: 'Full Name',
          hint: 'Enter your full name',
          prefixIcon: Icons.person_outline,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your name';
            }
            return null;
          },
        )
            .animate()
            .fadeIn(delay: const Duration(milliseconds: 200))
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
            // ✅ fixed regex
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,}$')
                .hasMatch(value)) {
              return 'Please enter a valid email';
            }
            return null;
          },
        )
            .animate()
            .fadeIn(delay: const Duration(milliseconds: 300))
            .slideX(begin: -0.2, end: 0),

        const SizedBox(height: 16),

        CustomTextField(
          controller: _phoneController,
          label: 'Phone Number',
          hint: 'Enter your phone number',
          keyboardType: TextInputType.phone,
          prefixIcon: Icons.phone_outlined,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your phone number';
            }
            return null;
          },
        )
            .animate()
            .fadeIn(delay: const Duration(milliseconds: 400))
            .slideX(begin: -0.2, end: 0),
      ],
    );
  }

  Widget _buildDateTimeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Preferred Date & Time',
          style: AppTheme.headingSmall,
        ),
        const SizedBox(height: 16),

        // Date Selection
        CustomTextField(
          controller: _dateController,
          label: 'Preferred Date',
          hint: 'Select a date',
          prefixIcon: Icons.calendar_month,
          onTap: _selectDate,
          enabled: false,
          validator: (value) {
            if (_selectedDate == null) {
              return 'Please select a date';
            }
            return null;
          },
        )
            .animate()
            .fadeIn(delay: const Duration(milliseconds: 500))
            .slideX(begin: -0.2, end: 0),

        const SizedBox(height: 20),

        // Time Selection
        const Text(
          'Preferred Time',
          style: AppTheme.bodyMedium,
        ),
        const SizedBox(height: 12),

        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _timeSlots.map((time) {
            final isSelected = _selectedTime == time;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTime = time;
                });
              },
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color:
                  isSelected ? AppTheme.primaryBlue : AppTheme.lightGray,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color:
                    isSelected ? AppTheme.primaryBlue : Colors.transparent,
                  ),
                ),
                child: Text(
                  time,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppTheme.darkGray,
                    fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        )
            .animate()
            .fadeIn(delay: const Duration(milliseconds: 600))
            .slideY(begin: 0.2, end: 0),
      ],
    );
  }

  Widget _buildConcernSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Reason for Booking',
          style: AppTheme.headingSmall,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _concernController,
          label: 'Describe your concern or what you\'d like to discuss',
          hint:
          'Please provide details about what you\'d like help with...',
          maxLines: 4,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please describe your concern';
            }
            return null;
          },
        )
            .animate()
            .fadeIn(delay: const Duration(milliseconds: 700))
            .slideY(begin: 0.2, end: 0),
      ],
    );
  }
}
