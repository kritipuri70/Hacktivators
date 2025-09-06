import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ai_service_provider.dart';
import '../providers/user_profile_provider.dart';
import '../widgets/affirmation_card.dart';

class AffirmationsScreen extends StatefulWidget {
  const AffirmationsScreen({super.key});

  @override
  State<AffirmationsScreen> createState() => _AffirmationsScreenState();
}

class _AffirmationsScreenState extends State<AffirmationsScreen> {
  List<String> _affirmations = [
    "I am worthy of love and happiness",
    "I have the strength to overcome any challenge",
    "I am enough, just as I am",
    "I choose to focus on what I can control",
    "I am grateful for this moment",
  ];
  bool _isGenerating = false;
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Affirmations'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _generatePersonalizedAffirmations,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemCount: _affirmations.length,
              itemBuilder: (context, index) {
                return AffirmationCard(
                  affirmation: _affirmations[index],
                  onFavorite: () => _toggleFavorite(_affirmations[index]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: _currentPage > 0 ? _previousAffirmation : null,
                  icon: const Icon(Icons.arrow_back),
                ),
                Row(
                  children: List.generate(_affirmations.length, (index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage == index
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey[300],
                      ),
                    );
                  }),
                ),
                IconButton(
                  onPressed: _currentPage < _affirmations.length - 1
                      ? _nextAffirmation
                      : null,
                  icon: const Icon(Icons.arrow_forward),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isGenerating ? null : _generatePersonalizedAffirmations,
                    icon: _isGenerating
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                        : const Icon(Icons.auto_awesome),
                    label: Text(_isGenerating ? 'Generating...' : 'Personalize'),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.share),
                  style: IconButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _nextAffirmation() {
    if (_currentPage < _affirmations.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousAffirmation() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _generatePersonalizedAffirmations() async {
    setState(() {
      _isGenerating = true;
    });

    final userProfile = context.read<UserProfileProvider>().profile;
    final mood = userProfile?.currentMood ?? 'neutral';
    final needs = userProfile?.mentalHealthNeeds ?? ['general wellness'];

    final aiService = context.read<AIServiceProvider>();
    final newAffirmations = await aiService.generateAffirmations(mood, needs);

    setState(() {
      if (newAffirmations.isNotEmpty) {
        _affirmations = newAffirmations;
        _currentPage = 0;
        _pageController.animateToPage(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
      _isGenerating = false;
    });
  }

  void _toggleFavorite(String affirmation) {
    // Implementation for favoriting affirmations
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Added to favorites!')),
    );
  }
}