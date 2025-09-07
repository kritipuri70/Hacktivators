import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/app_theme.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeChat() {
    // Add welcome message
    setState(() {
      _messages.add(
        ChatMessage(
          text: "Hello! I'm Luna, your AI wellness companion. I'm here to provide support, answer questions about mental health, and help you on your wellness journey. How are you feeling today?",
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
    });
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    // Add user message
    setState(() {
      _messages.add(
        ChatMessage(
          text: text,
          isUser: true,
          timestamp: DateTime.now(),
        ),
      );
    });

    _messageController.clear();
    _scrollToBottom();

    // Simulate AI response (in real implementation, this would call your AI service)
    Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() {
        _messages.add(
          ChatMessage(
            text: _generateResponse(text),
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );
      });
      _scrollToBottom();
    });
  }

  String _generateResponse(String userMessage) {
    // This is a simple demo response generator
    // In production, integrate with your AI service (OpenAI, Google AI, etc.)
    final lowercaseMessage = userMessage.toLowerCase();

    if (lowercaseMessage.contains('anxious') || lowercaseMessage.contains('anxiety')) {
      return "I understand you're feeling anxious. Anxiety is very common and treatable. Try some deep breathing exercises: breathe in for 4 counts, hold for 4, breathe out for 4. Would you like me to guide you through a longer relaxation exercise?";
    } else if (lowercaseMessage.contains('sad') || lowercaseMessage.contains('depressed')) {
      return "I'm sorry you're feeling this way. It's important to acknowledge these feelings. Remember that seeking help is a sign of strength. Have you considered talking to one of our qualified therapists? I can help you find someone who specializes in your area of concern.";
    } else if (lowercaseMessage.contains('stress') || lowercaseMessage.contains('stressed')) {
      return "Stress can really impact our wellbeing. Some effective stress management techniques include mindfulness meditation, regular exercise, and maintaining a healthy sleep schedule. What's been causing you the most stress lately?";
    } else if (lowercaseMessage.contains('thank')) {
      return "You're very welcome! I'm here to support you whenever you need it. Remember, taking care of your mental health is just as important as taking care of your physical health.";
    } else if (lowercaseMessage.contains('help') || lowercaseMessage.contains('support')) {
      return "I'm here to help! I can provide information about mental health topics, suggest coping strategies, or help you connect with our professional therapists. What specific area would you like support with?";
    } else {
      return "Thank you for sharing that with me. Mental health is a journey, and every step towards understanding yourself better is valuable. Is there anything specific you'd like to explore or discuss further?";
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.smart_toy,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Luna AI',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'AI Wellness Companion',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.mediumGray,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'clear') {
                setState(() {
                  _messages.clear();
                });
                _initializeChat();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: [
                    Icon(Icons.clear_all, size: 20),
                    SizedBox(width: 8),
                    Text('Clear Chat'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Disclaimer Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: AppTheme.softBlue,
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: AppTheme.primaryBlue,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'This is a demo AI feature. For professional help, please book a session with our therapists.',
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Chat Messages
          Expanded(
            child: _messages.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(message, index);
              },
            ),
          ),

          // Message Input
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.smart_toy,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
          ],

          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isUser ? AppTheme.primaryBlue : AppTheme.lightGray,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: AppTheme.bodyMedium.copyWith(
                      color: message.isUser ? Colors.white : AppTheme.darkGray,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message.timestamp),
                    style: AppTheme.bodySmall.copyWith(
                      color: message.isUser ? Colors.white70 : AppTheme.mediumGray,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (message.isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: AppTheme.softBlue,
              child: const Icon(
                Icons.person,
                size: 16,
                color: AppTheme.primaryBlue,
              ),
            ),
          ],
        ],
      ),
    )
        .animate()
        .fadeIn(
      delay: Duration(milliseconds: index * 100),
      duration: const Duration(milliseconds: 400),
    )
        .slideY(begin: 0.3, end: 0);
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppTheme.lightGray,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: 'Type your message...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: AppTheme.mediumGray),
                  ),
                  style: AppTheme.bodyMedium,
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(24),
              ),
              child: IconButton(
                onPressed: _sendMessage,
                icon: const Icon(
                  Icons.send,
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

    return '${displayHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}