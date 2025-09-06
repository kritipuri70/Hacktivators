import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import '../providers/user_profile_provider.dart';
import '../widgets/mood_button.dart';
import '../widgets/quick_action_card.dart';

class HomeTabScreen extends StatelessWidget {
  const HomeTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Good morning! ☀️'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMoodCheckIn(context),
            const SizedBox(height: 24),
            _buildQuickActions(context),
            const SizedBox(height: 24),
            _buildDailyAffirmation(context),
            const SizedBox(height: 24),
            _buildRecentSessions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodCheckIn(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'How are you feeling today?',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MoodButton(emoji: '😊', label: 'Great', mood: 'great'),
                MoodButton(emoji: '😌', label: 'Good', mood: 'good'),
                MoodButton(emoji: '😐', label: 'Okay', mood: 'okay'),
                MoodButton(emoji: '😔', label: 'Low', mood: 'low'),
                MoodButton(emoji: '😢', label: 'Sad', mood: 'sad'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            QuickActionCard(
              icon: Icons.psychology,
              title: 'AI Therapist',
              subtitle: 'Get personalized support',
              onTap: () => Navigator.pushNamed(context, '/ai-therapist'),
            ),
            QuickActionCard(
              icon: Icons.self_improvement,
              title: 'Meditation',
              subtitle: 'Find your inner peace',
              onTap: () => Navigator.pushNamed(context, '/meditation'),
            ),
            QuickActionCard(
              icon: Icons.favorite,
              title: 'Affirmations',
              subtitle: 'Daily positive thoughts',
              onTap: () => Navigator.pushNamed(context, '/affirmations'),
            ),
            QuickActionCard(
              icon: Icons.lightbulb,
              title: 'Suggestions',
              subtitle: 'Self-care tips',
              onTap: () => Navigator.pushNamed(context, '/suggestions'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDailyAffirmation(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.auto_awesome,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                const SizedBox(width: 8),
                Text(
                  'Daily Affirmation',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '"You are stronger than you think, braver than you believe, and more loved than you know."',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontStyle: FontStyle.italic,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentSessions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Sessions',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Color(0xFF6B73FF),
              child: Icon(Icons.psychology, color: Colors.white),
            ),
            title: const Text('AI Therapy Session'),
            subtitle: const Text('Anxiety Management - 2 hours ago'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => Navigator.pushNamed(context, '/ai-therapist'),
          ),
        ),
        Card(
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Color(0xFF4CAF50),
              child: Icon(Icons.self_improvement, color: Colors.white),
            ),
            title: const Text('Meditation'),
            subtitle: const Text('Stress Relief - Yesterday'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => Navigator.pushNamed(context, '/meditation'),
          ),
        ),
      ],
    );
  }
}