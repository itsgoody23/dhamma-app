import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../data/services/discussion_service.dart';
import '../../../shared/providers/auth_provider.dart';

final _discussionServiceProvider = Provider<DiscussionService>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return DiscussionService(client);
});

final _discussionsProvider = FutureProvider.autoDispose
    .family<List<DiscussionComment>, String>((ref, textUid) {
  return ref.watch(_discussionServiceProvider).getDiscussions(textUid);
});

class DiscussionSheet extends ConsumerStatefulWidget {
  const DiscussionSheet({super.key, required this.textUid});

  final String textUid;

  @override
  ConsumerState<DiscussionSheet> createState() => _DiscussionSheetState();
}

class _DiscussionSheetState extends ConsumerState<DiscussionSheet> {
  final _controller = TextEditingController();
  int? _replyingTo;
  bool _posting = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _post() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() => _posting = true);
    try {
      final service = ref.read(_discussionServiceProvider);
      await service.postComment(
        widget.textUid,
        text,
        parentId: _replyingTo,
      );
      _controller.clear();
      setState(() => _replyingTo = null);
      ref.invalidate(_discussionsProvider(widget.textUid));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$e')),
        );
      }
    } finally {
      if (mounted) setState(() => _posting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final discussionsAsync = ref.watch(_discussionsProvider(widget.textUid));
    final currentUser = ref.watch(currentUserProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) => Column(
        children: [
          // Handle
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Container(
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
            child: Row(
              children: [
                const Text(
                  'Discussion',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () =>
                      ref.invalidate(_discussionsProvider(widget.textUid)),
                ),
              ],
            ),
          ),
          const Divider(),
          // Comments list
          Expanded(
            child: discussionsAsync.when(
              data: (comments) {
                if (comments.isEmpty) {
                  return const Center(
                    child: Text(
                      'No comments yet.\nBe the first to share your thoughts!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }
                return ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    return _CommentTile(
                      comment: comment,
                      isOwn: currentUser?.id == comment.userId,
                      onReply: () =>
                          setState(() => _replyingTo = comment.id),
                      onDelete: () async {
                        await ref
                            .read(_discussionServiceProvider)
                            .deleteComment(comment.id);
                        ref.invalidate(
                            _discussionsProvider(widget.textUid));
                      },
                    );
                  },
                );
              },
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
          // Input
          if (currentUser != null) ...[
            if (_replyingTo != null)
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.md, vertical: 4),
                color: AppColors.green.withValues(alpha: 0.05),
                child: Row(
                  children: [
                    const Text('Replying to comment',
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close, size: 16),
                      onPressed: () =>
                          setState(() => _replyingTo = null),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(AppSizes.md),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Share your thoughts...',
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      minLines: 1,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    icon: _posting
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child:
                                CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.send),
                    onPressed: _posting ? null : _post,
                  ),
                ],
              ),
            ),
          ] else
            Padding(
              padding: const EdgeInsets.all(AppSizes.md),
              child: Text(
                'Sign in to join the discussion',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
        ],
      ),
    );
  }
}

class _CommentTile extends StatelessWidget {
  const _CommentTile({
    required this.comment,
    required this.isOwn,
    required this.onReply,
    required this.onDelete,
  });

  final DiscussionComment comment;
  final bool isOwn;
  final VoidCallback onReply;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: AppColors.green.withValues(alpha: 0.1),
                child: Text(
                  (comment.displayName ?? '?')[0].toUpperCase(),
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.green),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                comment.displayName ?? 'Anonymous',
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(width: 8),
              Text(
                _timeAgo(comment.createdAt),
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 36, top: 4),
            child: Text(comment.content, style: const TextStyle(height: 1.5)),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 28),
            child: Row(
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.reply, size: 14),
                  label: const Text('Reply', style: TextStyle(fontSize: 12)),
                  onPressed: onReply,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
                if (isOwn)
                  TextButton.icon(
                    icon: const Icon(Icons.delete_outline,
                        size: 14, color: Colors.red),
                    label: const Text('Delete',
                        style: TextStyle(fontSize: 12, color: Colors.red)),
                    onPressed: onDelete,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
              ],
            ),
          ),
          // Replies
          if (comment.replies.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 36),
              child: Column(
                children: comment.replies
                    .map((r) => _CommentTile(
                          comment: r,
                          isOwn: false,
                          onReply: onReply,
                          onDelete: () {},
                        ))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inDays > 365) return '${diff.inDays ~/ 365}y ago';
    if (diff.inDays > 30) return '${diff.inDays ~/ 30}mo ago';
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'now';
  }
}
