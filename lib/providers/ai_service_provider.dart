import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AIServiceProvider extends ChangeNotifier {
  static const String _apiKey = 'YOUR_OPENAI_API_KEY'; // Replace with your API key
  static const String _baseUrl = 'https://api.openai.com/v1/chat/completions';

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<String> getChatResponse(String message, String context) async {
    try {
      _isLoading = true;
      notifyListeners();

      final systemPrompt = _getSystemPrompt(context);

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {'role': 'system', 'content': systemPrompt},
            {'role': 'user', 'content': message},
          ],
          'max_tokens': 500,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'].trim();
      } else {
        return _getFallbackResponse(context);
      }
    } catch (e) {
      print('AI Service error: $e');
      return _getFallbackResponse(context);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String _getSystemPrompt(String context) {
    switch (context) {
      case 'therapist':
        return '''You are Lumina AI, a supportive mental health companion. You are NOT a replacement for professional therapy or medical advice. 
        
        Your role is to:
        - Provide emotional support and active listening
        - Suggest coping strategies and self-care techniques
        - Encourage positive thinking patterns
        - Validate feelings and experiences
        - Always remind users to seek professional help for serious mental health concerns
        
        Be empathetic, non-judgmental, and warm. Keep responses concise but meaningful. Always prioritize user safety.''';

      case 'companion':
        return '''You are Lumina, a caring AI companion focused on mental well-being. You're here to chat, listen, and provide emotional support.
        
        Be:
        - Warm, friendly, and conversational
        - Empathetic and understanding
        - Encouraging and positive
        - A good listener who validates feelings
        
        Avoid giving medical advice. Focus on being a supportive friend who cares about the user's well-being.''';

      case 'meditation':
        return '''You are Lumina's meditation guide. Create personalized, calming meditation scripts that promote relaxation and mindfulness.
        
        Your meditations should:
        - Use soothing, peaceful language
        - Include breathing exercises
        - Focus on present moment awareness
        - Be adaptable to different needs (stress, sleep, focus)
        - Last 5-15 minutes when read aloud
        
        Always promote a sense of peace and well-being.''';

      case 'affirmations':
        return '''You are Lumina's affirmation specialist. Create personalized, positive affirmations that boost self-esteem and promote mental well-being.
        
        Your affirmations should be:
        - Personal and meaningful
        - Present tense and positive
        - Empowering and uplifting
        - Focused on self-worth and capability
        - Easy to remember and repeat
        
        Tailor them to the user's specific needs and goals.''';

      default:
        return '''You are Lumina AI, a mental health companion focused on positivity and well-being. Always be supportive, encouraging, and remind users to seek professional help when needed.''';
    }
  }

  String _getFallbackResponse(String context) {
    switch (context) {
      case 'therapist':
        return "I'm here to listen and support you. While I can't replace professional therapy, I want you to know that your feelings are valid and you deserve care. Would you like to talk about what's on your mind?";
      case 'companion':
        return "I'm here for you! Sometimes it helps just to have someone listen. What's been on your mind lately?";
      case 'meditation':
        return "Let's take a moment to breathe together. Close your eyes, take a deep breath in through your nose, hold for 4 seconds, then slowly exhale. Feel your body relaxing with each breath.";
      case 'affirmations':
        return "You are worthy of love and happiness. You have the strength to overcome challenges. You are enough, just as you are.";
      default:
        return "I'm here to support you on your mental health journey. How can I help you today?";
    }
  }

  Future<List<String>> generateAffirmations(String mood, List<String> needs) async {
    final prompt = "Generate 5 personalized positive affirmations for someone feeling $mood who needs support with: ${needs.join(', ')}";
    final response = await getChatResponse(prompt, 'affirmations');

    // Parse the response into individual affirmations
    return response.split('\n').where((line) => line.trim().isNotEmpty).take(5).toList();
  }

  Future<String> generateMeditation(String type, int duration) async {
    final prompt = "Create a $duration-minute $type meditation script with breathing exercises and mindfulness guidance.";
    return await getChatResponse(prompt, 'meditation');
  }

  Future<List<String>> getSelfCareRecommendations(String mood, List<String> preferences) async {
    final prompt = "Suggest 5 self-care activities for someone feeling $mood with interests in: ${preferences.join(', ')}";
    final response = await getChatResponse(prompt, 'companion');

    return response.split('\n').where((line) => line.trim().isNotEmpty).take(5).toList();
  }
}