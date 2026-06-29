import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/constants/support_links.dart';
import '../../core/services/assistant/faq_content.dart';
import '../../core/theme/app_palette.dart';
import '../../l10n/app_localizations.dart';

class ProfileSupportScreen extends StatelessWidget {
  const ProfileSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);
    final isRu = l10n.localeName.startsWith('ru');
    final topics = FaqContent.topics(isRu: isRu);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.supportCenterTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            l10n.supportCenterIntro,
            style: TextStyle(color: palette.textSecondary),
          ),
          const Gap(20),
          Text(
            l10n.supportCenterFaqTitle,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const Gap(8),
          ...topics.map(
            (topic) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ExpansionTile(
                title: Text(
                  topic.title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        topic.body,
                        style: TextStyle(
                          color: palette.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Gap(16),
          Text(
            l10n.supportCenterContactTitle,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const Gap(8),
          ListTile(
            leading: Icon(Iconsax.message_question, color: palette.accent),
            title: Text(l10n.supportCenterFeedback),
            subtitle: Text(SupportLinks.feedbackEmail),
            onTap: () => Share.share(
              '${l10n.supportCenterFeedback}: ${SupportLinks.feedbackEmail}',
            ),
          ),
          ListTile(
            leading: Icon(Iconsax.code, color: palette.accent),
            title: Text(l10n.supportCenterGithub),
            subtitle: Text(SupportLinks.githubIssues),
            onTap: () => Share.share(SupportLinks.githubIssues),
          ),
        ],
      ),
    );
  }
}
