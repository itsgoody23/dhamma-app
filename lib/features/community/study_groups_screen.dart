import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/routing/routes.dart';
import '../../data/services/study_group_service.dart';
import '../../shared/providers/auth_provider.dart';

final _studyGroupServiceProvider = Provider<StudyGroupService>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return StudyGroupService(client);
});

final _myGroupsProvider =
    FutureProvider.autoDispose<List<StudyGroup>>((ref) {
  return ref.watch(_studyGroupServiceProvider).getMyGroups();
});

class StudyGroupsScreen extends ConsumerWidget {
  const StudyGroupsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupsAsync = ref.watch(_myGroupsProvider);
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Study Groups')),
      body: currentUser == null
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(AppSizes.xl),
                child: Text(
                  'Sign in to create or join study groups',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          : groupsAsync.when(
              data: (groups) {
                if (groups.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSizes.xl),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.groups_outlined,
                              size: 64,
                              color: AppColors.green.withValues(alpha: 0.3)),
                          const SizedBox(height: AppSizes.md),
                          const Text(
                            'No study groups yet',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: AppSizes.sm),
                          const Text(
                            'Create a group or join one with an invite code',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(AppSizes.md),
                  itemCount: groups.length,
                  itemBuilder: (context, index) {
                    final group = groups[index];
                    return _GroupCard(group: group);
                  },
                );
              },
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
      floatingActionButton: currentUser != null
          ? FloatingActionButton.extended(
              backgroundColor: AppColors.green,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add),
              label: const Text('New Group'),
              onPressed: () => _showCreateOrJoinDialog(context, ref),
            )
          : null,
    );
  }

  void _showCreateOrJoinDialog(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(AppSizes.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppColors.green,
                child: Icon(Icons.add, color: Colors.white),
              ),
              title: const Text('Create a Group'),
              subtitle: const Text('Start a new study group'),
              onTap: () {
                Navigator.pop(ctx);
                _showCreateGroupDialog(context, ref);
              },
            ),
            const Divider(),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.green.withValues(alpha: 0.1),
                child: const Icon(Icons.link, color: AppColors.green),
              ),
              title: const Text('Join with Code'),
              subtitle: const Text('Enter an invite code'),
              onTap: () {
                Navigator.pop(ctx);
                _showJoinGroupDialog(context, ref);
              },
            ),
            const SizedBox(height: AppSizes.md),
          ],
        ),
      ),
    );
  }

  void _showCreateGroupDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Create Study Group'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Group Name',
                hintText: 'e.g. Weekly Sutta Study',
              ),
              autofocus: true,
            ),
            const SizedBox(height: AppSizes.md),
            TextField(
              controller: descController,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                hintText: 'What will you study?',
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final name = nameController.text.trim();
              if (name.isEmpty) return;
              Navigator.pop(ctx);

              try {
                final service = ref.read(_studyGroupServiceProvider);
                final group = await service.createGroup(
                  name,
                  description: descController.text.trim().isEmpty
                      ? null
                      : descController.text.trim(),
                );
                ref.invalidate(_myGroupsProvider);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Group created! Invite code: ${group.inviteCode}'),
                      action: SnackBarAction(
                        label: 'Copy',
                        onPressed: () => Clipboard.setData(
                            ClipboardData(text: group.inviteCode)),
                      ),
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$e')),
                  );
                }
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showJoinGroupDialog(BuildContext context, WidgetRef ref) {
    final codeController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Join Study Group'),
        content: TextField(
          controller: codeController,
          decoration: const InputDecoration(
            labelText: 'Invite Code',
            hintText: 'e.g. ABC123',
          ),
          textCapitalization: TextCapitalization.characters,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final code = codeController.text.trim();
              if (code.isEmpty) return;
              Navigator.pop(ctx);

              try {
                final service = ref.read(_studyGroupServiceProvider);
                final group = await service.joinGroup(code);
                ref.invalidate(_myGroupsProvider);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Joined "${group.name}"')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$e')),
                  );
                }
              }
            },
            child: const Text('Join'),
          ),
        ],
      ),
    );
  }
}

class _GroupCard extends StatelessWidget {
  const _GroupCard({required this.group});

  final StudyGroup group;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.green.withValues(alpha: 0.1),
          child: const Icon(Icons.groups, color: AppColors.green),
        ),
        title: Text(group.name,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: group.description != null
            ? Text(group.description!,
                maxLines: 1, overflow: TextOverflow.ellipsis)
            : null,
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.push('${Routes.community}/groups/${group.id}'),
      ),
    );
  }
}
