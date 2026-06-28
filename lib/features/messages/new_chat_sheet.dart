import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../core/theme/app_palette.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/messages_provider.dart';

class NewChatSheet extends ConsumerStatefulWidget {
  const NewChatSheet({super.key});

  @override
  ConsumerState<NewChatSheet> createState() => _NewChatSheetState();
}

class _NewChatSheetState extends ConsumerState<NewChatSheet> {
  final _queryController = TextEditingController();
  List<Map<String, dynamic>> _results = [];
  bool _searching = false;

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    setState(() => _searching = true);
    final results =
        await ref.read(messagesProvider.notifier).searchUsers(_queryController.text);
    if (mounted) {
      setState(() {
        _results = results;
        _searching = false;
      });
    }
  }

  Future<void> _openSelf() async {
    final thread = await ref.read(messagesProvider.notifier).openDirect(self: true);
    if (mounted && thread != null) Navigator.pop(context, thread);
  }

  Future<void> _openUser(String profileId) async {
    final thread = await ref
        .read(messagesProvider.notifier)
        .openDirect(targetProfileId: profileId);
    if (mounted && thread != null) Navigator.pop(context, thread);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.messagesNewChat,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: palette.textPrimary,
            ),
          ),
          const Gap(12),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: Text(l10n.messagesSelfChat),
            onTap: _openSelf,
          ),
          const Divider(),
          TextField(
            controller: _queryController,
            decoration: InputDecoration(
              labelText: l10n.messagesSearchHint,
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: _searching ? null : _search,
              ),
            ),
            onSubmitted: (_) => _search(),
          ),
          const Gap(8),
          if (_searching)
            const Center(child: CircularProgressIndicator())
          else if (_results.isEmpty && _queryController.text.isNotEmpty)
            Text(
              l10n.messagesSearchEmpty,
              style: TextStyle(color: palette.textSecondary, fontSize: 13),
            )
          else
            ..._results.map((user) {
              final name = (user['displayName'] as String? ?? '').trim();
              final login = user['login'] as String? ?? '';
              return ListTile(
                title: Text(name.isEmpty ? login : name),
                subtitle: Text(user['profileId'] as String? ?? ''),
                onTap: () => _openUser(user['profileId'] as String),
              );
            }),
        ],
      ),
    );
  }
}
