import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ai_service_provider.dart';
import '../models/meditation_type.dart';
import '../widgets/meditation_card.dart';

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({super.key});

  @override
  State<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  String? _currentMeditation;
  bool _isGenerating = false;
  final List<MeditationType> _meditationTypes = [
    MeditationType(
      title: 'Stress Relief',
      description: 'Calm your mind and release tension',
      icon: Icons.spa,
      color: Colors.blue,
    ),
    MeditationType(
      title: 'Better Sleep',
      description: 'Prepare your body and mind for rest',
      icon: Icons.bedtime,
      color: Colors.indigo,
    ),
    MeditationType(
      title: 'Focus & Clarity',
      description: 'Enhance concentration and mental clarity',
      icon: Icons.center_focus_strong,
      color: Colors.purple,
    ),
    MeditationType(
      title: 'Anxiety Relief',
      description: 'Find peace and reduce anxious thoughts',
      icon: Icons.favorite,
      color: Colors.green,
    ),
    MeditationType(
      title: 'Self-Compassion',
      description: 'Cultivate kindness towards yourself',
      icon: Icons.self_improvement,
      color: Colors.orange,
    ),
    MeditationType(
      title: 'Mindful Breathing',
      description: 'Connect with your breath and present moment',
      icon: Icons.air,
      color: Colors.cyan,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guided Meditations'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _currentMeditation == null
          ? _buildMeditationSelection()
          : _buildMeditationPlayer(),
    );
  }

  Widget _buildMeditationSelection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Find Your Peace',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose a meditation that fits your current needs',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.8,
            ),
            itemCount: _meditationTypes.length,
            itemBuilder: (context, index) {
              final meditation = _meditationTypes[index];
              return MeditationCard(
                meditation: meditation,
                onTap: () => _generateMeditation(meditation),
                isGenerating: _isGenerating,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMeditationPlayer() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary.withOpacity(0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Icon(
                Icons.self_improvement,
                size: 80,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () => setState(() => _currentMeditation = null),
                icon: const Icon(Icons.arrow_back),
                iconSize: 32,
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.play_circle_fill),
                iconSize: 64,
                color: Theme.of(context).colorScheme.primary,
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.favorite_border),
                iconSize: 32,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _currentMeditation ?? '',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    height: 1.6,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _generateMeditation(MeditationType type) async {
    setState(() {
      _isGenerating = true;
    });

    final aiService = context.read<AIServiceProvider>();
    final meditation = await aiService.generateMeditation(type.title, 10);

    setState(() {
      _currentMeditation = meditation;
      _isGenerating = false;
    });
  }
}