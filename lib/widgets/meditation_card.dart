import 'package:flutter/material.dart';
import '../models/meditation_type.dart';

class MeditationCard extends StatelessWidget {
  final MeditationType meditation;
  final VoidCallback onTap;
  final bool isGenerating;

  const MeditationCard({
    super.key,
    required this.meditation,
    required this.onTap,
    required this.isGenerating,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: isGenerating ? null : onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: meditation.color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(
                  meditation.icon,
                  size: 32,
                  color: meditation.color,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                meditation.title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                meditation.description,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (isGenerating) ...[
                const SizedBox(height: 8),
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}