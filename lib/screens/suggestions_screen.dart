import 'package:flutter/material.dart';

class SuggestionsScreen extends StatelessWidget {
  const SuggestionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Self-Care Suggestions'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Personalized Recommendations',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Based on your current mood and goals',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            _buildSuggestionCategory(
              context,
              'Mindfulness & Relaxation',
              Icons.spa,
              Colors.blue,
              [
                'Take 5 deep breaths focusing on the sensation',
                'Practice progressive muscle relaxation',
                'Try a 10-minute guided meditation',
                'Listen to calming nature sounds',
              ],
            ),
            const SizedBox(height: 16),
            _buildSuggestionCategory(
              context,
              'Physical Wellness',
              Icons.fitness_center,
              Colors.green,
              [
                'Take a 15-minute walk outdoors',
                'Do gentle stretching exercises',
                'Dance to your favorite music',
                'Practice yoga poses',
              ],
            ),
            const SizedBox(height: 16),
            _buildSuggestionCategory(
              context,
              'Mental Clarity',
              Icons.psychology,
              Colors.purple,
              [
                'Write in a gratitude journal',
                'Practice mindful observation',
                'Do a brain dump of your thoughts',
                'Organize your living space',
              ],
            ),
            const SizedBox(height: 16),
            _buildSuggestionCategory(
              context,
              'Social Connection',
              Icons.people,
              Colors.orange,
              [
                'Call a friend or family member',
                'Send a thoughtful message',
                'Join a community group',
                'Practice active listening',
              ],
            ),
            const SizedBox(height: 16),
            _buildSuggestionCategory(
              context,
              'Creative Expression',
              Icons.palette,
              Colors.pink,
              [
                'Draw or sketch something',
                'Write a poem or story',
                'Play a musical instrument',
                'Try a new creative hobby',
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionCategory(
      BuildContext context,
      String title,
      IconData icon,
      Color color,
      List<String> suggestions,
      ) {
    return Card(
      child: ExpansionTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        children: suggestions.map((suggestion) {
          return ListTile(
            leading: const Icon(Icons.check_circle_outline),
            title: Text(suggestion),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Added "$suggestion" to your routine!')),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}