import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../services/firestore_service.dart';
import '../../widgets/custom_widgets.dart';

class AnonymousFeedScreen extends StatefulWidget {
  const AnonymousFeedScreen({super.key});

  @override
  State<AnonymousFeedScreen> createState() => _AnonymousFeedScreenState();
}

class _AnonymousFeedScreenState extends State<AnonymousFeedScreen> {
  final TextEditingController _postController = TextEditingController();
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FirestoreService>().fetchAnonymousPosts();
    });
  }

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  Future<void> _submitPost() async {
    final content = _postController.text.trim();
    if (content.isEmpty) return;

    final firestoreService = context.read<FirestoreService>();
    final success = await firestoreService.createAnonymousPost(content);

    if (success && mounted) {
      _postController.clear();
      setState(() {
        _isExpanded = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your story has been shared anonymously'),
          backgroundColor: AppTheme.success,
        ),
      );

      // Refresh the feed
      firestoreService.fetchAnonymousPosts();
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(firestoreService.errorMessage ?? 'Failed to share post'),
          backgroundColor: AppTheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Stories'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              context.read<FirestoreService>().fetchAnonymousPosts();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          // Share Experience Section
          _buildShareSection(),

          // Posts Feed
          Expanded(
            child: _buildPostsFeed(),
          ),
        ],
      ),
    );
  }

  Widget _buildShareSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.softGradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryBlue.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.psychology_outlined,
                  color: AppTheme.primaryBlue,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Share Your Experience Anonymously',
                  style: AppTheme.headingSmall,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          const Text(
            'Your stories can inspire and support others on their journey. Share anonymously and connect with our community.',
            style: AppTheme.bodyMedium,
          ),

          const SizedBox(height: 16),

          // Expandable Text Field
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isExpanded = true;
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _isExpanded ? AppTheme.primaryBlue : AppTheme.lightGray,
                        width: _isExpanded ? 2 : 1,
                      ),
                    ),
                    child: _isExpanded
                        ? TextField(
                      controller: _postController,
                      maxLines: 4,
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: 'Share your story, insights, or words of encouragement...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: AppTheme.mediumGray),
                      ),
                      style: AppTheme.bodyMedium,
                    )
                        : const Text(
                      'What\'s on your mind? Share your story...',
                      style: TextStyle(
                        color: AppTheme.mediumGray,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),

                if (_isExpanded) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(
                        Icons.lock_outline,
                        size: 16,
                        color: AppTheme.mediumGray,
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Your identity will remain completely anonymous',
                        style: AppTheme.bodySmall,
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isExpanded = false;
                            _postController.clear();
                          });
                        },
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 8),
                      Consumer<FirestoreService>(
                        builder: (context, firestoreService, child) {
                          return ElevatedButton(
                            onPressed: firestoreService.isLoading || _postController.text.trim().isEmpty
                                ? null
                                : _submitPost,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryBlue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            ),
                            child: firestoreService.isLoading
                                ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                                : const Text('Share'),
                          );
                        },
                      ),
                    ],
                  ),
                ],
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

  Widget _buildPostsFeed() {
    return Consumer<FirestoreService>(
      builder: (context, firestoreService, child) {
        if (firestoreService.isLoading && firestoreService.anonymousPosts.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
            ),
          );
        }

        if (firestoreService.errorMessage != null && firestoreService.anonymousPosts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: AppTheme.error,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Failed to load stories',
                  style: AppTheme.headingSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  firestoreService.errorMessage!,
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.mediumGray,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => firestoreService.fetchAnonymousPosts(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (firestoreService.anonymousPosts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppTheme.softBlue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.forum_outlined,
                    size: 48,
                    color: AppTheme.primaryBlue,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'No stories yet',
                  style: AppTheme.headingSmall,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Be the first to share your experience\nand inspire others',
                  style: AppTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _isExpanded = true;
                    });
                  },
                  icon: const Icon(Icons.add, size: 20),
                  label: const Text('Share Your Story'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await firestoreService.fetchAnonymousPosts();
          },
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 16),
            itemCount: firestoreService.anonymousPosts.length,
            itemBuilder: (context, index) {
              final post = firestoreService.anonymousPosts[index];

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: AnonymousPostCard(
                  content: post.content,
                  createdAt: post.createdAt,
                  likes: post.likes,
                ),
              )
                  .animate()
                  .fadeIn(
                delay: Duration(milliseconds: 100 * index),
                duration: const Duration(milliseconds: 400),
              )
                  .slideX(begin: 0.2, end: 0);
            },
          ),
        );
      },
    );
  }
}