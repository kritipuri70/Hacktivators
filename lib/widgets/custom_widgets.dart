// lib/widgets/custom_button.dart
import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double height;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height = 56,
  });

  @override
  Widget build(BuildContext context) {
    if (isOutlined) {
      return SizedBox(
        width: width,
        height: height,
        child: OutlinedButton.icon(
          onPressed: isLoading ? null : onPressed,
          icon: isLoading
              ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
            ),
          )
              : Icon(icon ?? Icons.add),
          label: Text(text),
          style: OutlinedButton.styleFrom(
            foregroundColor: textColor ?? AppTheme.primaryBlue,
            side: BorderSide(
              color: backgroundColor ?? AppTheme.primaryBlue,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppTheme.primaryBlue,
          foregroundColor: textColor ?? Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        )
            : icon != null
            ? Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        )
            : Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// lib/widgets/custom_text_field.dart
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final bool obscureText;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final int maxLines;
  final bool enabled;
  final VoidCallback? onTap;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.maxLines = 1,
    this.enabled = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.darkGray,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          maxLines: maxLines,
          enabled: enabled,
          onTap: onTap,
          style: AppTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: AppTheme.lightGray,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.primaryBlue, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.error, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.error, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }
}

// lib/widgets/therapist_card.dart
class TherapistCard extends StatelessWidget {
  final String id;
  final String name;
  final String specialty;
  final String qualification;
  final int yearsOfExperience;
  final double rating;
  final int reviewCount;
  final String? profileImageUrl;
  final bool isAvailable;
  final VoidCallback onTap;

  const TherapistCard({
    super.key,
    required this.id,
    required this.name,
    required this.specialty,
    required this.qualification,
    required this.yearsOfExperience,
    required this.rating,
    required this.reviewCount,
    this.profileImageUrl,
    required this.isAvailable,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: AppTheme.lightGray,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Profile Image
              CircleAvatar(
                radius: 30,
                backgroundColor: AppTheme.softBlue,
                backgroundImage: profileImageUrl != null
                    ? NetworkImage(profileImageUrl!)
                    : null,
                child: profileImageUrl == null
                    ? const Icon(
                  Icons.person,
                  size: 30,
                  color: AppTheme.primaryBlue,
                )
                    : null,
              ),

              const SizedBox(width: 16),

              // Therapist Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: AppTheme.headingSmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isAvailable
                                ? AppTheme.softGreen
                                : AppTheme.lightGray,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            isAvailable ? 'Available' : 'Busy',
                            style: AppTheme.bodySmall.copyWith(
                              color: isAvailable
                                  ? AppTheme.primaryGreen
                                  : AppTheme.mediumGray,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    Text(
                      specialty,
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.primaryBlue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      qualification,
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.mediumGray,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 16,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          rating.toStringAsFixed(1),
                          style: AppTheme.bodySmall.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '($reviewCount reviews)',
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.mediumGray,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '$yearsOfExperience years exp.',
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.mediumGray,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppTheme.mediumGray,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// lib/widgets/anonymous_post_card.dart
class AnonymousPostCard extends StatelessWidget {
  final String content;
  final DateTime createdAt;
  final int likes;

  const AnonymousPostCard({
    super.key,
    required this.content,
    required this.createdAt,
    required this.likes,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: AppTheme.lightGray,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppTheme.softBlue,
                  child: const Icon(
                    Icons.person_outline,
                    size: 16,
                    color: AppTheme.primaryBlue,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Anonymous',
                  style: AppTheme.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  _formatTime(createdAt),
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.mediumGray,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Text(
              content,
              style: AppTheme.bodyMedium,
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                IconButton(
                  onPressed: () {
                    // TODO: Implement like functionality
                  },
                  icon: const Icon(
                    Icons.favorite_border,
                    size: 20,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 4),
                Text(
                  likes.toString(),
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.mediumGray,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

// lib/widgets/loading_shimmer.dart
class LoadingShimmer extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const LoadingShimmer({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppTheme.lightGray,
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
    );
  }
}