import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_profile_provider.dart';

class MoodButton extends StatelessWidget {
  final String emoji;
  final String label;
  final String mood;

  const MoodButton({
    super.key,
    required this.emoji,
    required this.label,
    required this.mood,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProfileProvider>(
      builder: (context, provider, child) {
        final isSelected = provider.profile?.currentMood == mood;
        return GestureDetector(
          onTap: () => provider.updateMood(mood),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            decoration: BoxDecoration(
              color: isSelected ? Theme.of(context).colorScheme.primary.withOpacity(0.1) : null,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 24)),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected ? Theme.of(context).colorScheme.primary : null,
                    fontWeight: isSelected ? FontWeight.bold : null,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}