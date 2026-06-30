// =============================================================================
// EcoPulse · lib/features/profile/profile_screen.dart
// Автор: Цымбал Е. В.
// Дата: 21.06.2026
// Модуль EcoPulse. Файл: profile_screen.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_palette.dart';
import '../../data/models/user_profile.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/home_server_provider.dart';
import '../../providers/user_profile_provider.dart';
import '../../shared/widgets/profile_avatar.dart';

/// Класс [ProfileScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.06.2026
class ProfileScreen extends ConsumerStatefulWidget {
/// Создаёт [ProfileScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.06.2026
  const ProfileScreen({super.key});

/// Создаёт State для [ProfileScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 24.06.2026
  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

/// Приватный класс [_ProfileScreenState] — экран/state.
///
/// Автор: Цымбал Е. В.
/// Дата: 25.06.2026
class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(userProfileProvider);
    _nameController = TextEditingController(text: profile.displayName);
    _emailController = TextEditingController(text: profile.email);
    _phoneController = TextEditingController(text: profile.phone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

/// Отрисовывает UI [_ProfileScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 24.06.2026
  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileProvider);
    final palette = AppPalette.of(context);
    final l10n = AppLocalizations.of(context)!;
    final countries = AppConstants.inflationCountries;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: ProfileAvatar(
              size: 96,
              onTap: () => _pickCustomAvatar(context, l10n),
            ),
          ),
          const Gap(8),
          Center(
            child: Text(
              l10n.profileAvatarHint,
              textAlign: TextAlign.center,
              style: TextStyle(color: palette.textSecondary, fontSize: 12),
            ),
          ),
          const Gap(12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _pickCustomAvatar(context, l10n),
                  icon: const Icon(Iconsax.gallery, size: 18),
                  label: Text(l10n.profileAvatarPickPhoto),
                ),
              ),
              if (profile.useCustomAvatar) ...[
                const Gap(8),
                TextButton(
                  onPressed: () async {
                    await ref.read(userProfileProvider.notifier).clearCustomAvatar();
                  },
                  child: Text(l10n.profileAvatarRemovePhoto),
                ),
              ],
            ],
          ),
          const Gap(12),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 10,
            children: profileAvatarOptions.map((emoji) {
              final selected =
                  !profile.useCustomAvatar && profile.avatarEmoji == emoji;
              return ChoiceChip(
                label: Text(emoji, style: const TextStyle(fontSize: 22)),
                selected: selected,
                onSelected: (_) async {
                  await ref
                      .read(userProfileProvider.notifier)
                      .setAvatarEmoji(emoji);
                  final home = ref.read(homeServerProvider);
                  if (home.auth.isLoggedIn) {
                    await ref.read(homeServerProvider.notifier).syncProfileToServer(
                          displayName: profile.displayName,
                          avatarEmoji: emoji,
                        );
                  }
                },
              );
            }).toList(),
          ),
          const Gap(16),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: l10n.profileDisplayName,
              hintText: l10n.profileDisplayNameHint,
            ),
            textCapitalization: TextCapitalization.words,
            onSubmitted: (v) =>
                ref.read(userProfileProvider.notifier).setDisplayName(v),
          ),
          const Gap(16),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: l10n.profileEmail,
              hintText: l10n.profileEmailHint,
              prefixIcon: const Icon(Icons.email_outlined),
            ),
            keyboardType: TextInputType.emailAddress,
            onSubmitted: (v) => ref.read(userProfileProvider.notifier).setEmail(v),
          ),
          const Gap(16),
          TextField(
            controller: _phoneController,
            decoration: InputDecoration(
              labelText: l10n.profilePhone,
              hintText: l10n.profilePhoneHint,
              prefixIcon: const Icon(Icons.phone_outlined),
            ),
            keyboardType: TextInputType.phone,
            onSubmitted: (v) => ref.read(userProfileProvider.notifier).setPhone(v),
          ),
          const Gap(16),
          DropdownButtonFormField<String>(
            initialValue: profile.countryCode,
            decoration: InputDecoration(labelText: l10n.profileCountry),
            items: countries.entries
                .map(
                  (e) => DropdownMenuItem(
                    value: e.key,
                    child: Text('${e.key} · ${e.value}'),
                  ),
                )
                .toList(),
            onChanged: (code) {
              if (code != null) {
                ref.read(userProfileProvider.notifier).setCountryCode(code);
              }
            },
          ),
          const Gap(8),
          Text(
            l10n.profileCountryHint,
            style: TextStyle(color: palette.textSecondary, fontSize: 12),
          ),
          const Gap(24),
          if (profile.profileId != null && profile.profileId!.isNotEmpty) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: palette.surfaceLight,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: palette.border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.profileIdLabel,
                          style: TextStyle(
                            color: palette.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                        const Gap(4),
                        Text(
                          profile.profileId!,
                          style: TextStyle(
                            color: palette.textPrimary,
                            fontSize: 12,
                            fontFamily: 'monospace',
                          ),
                        ),
                        const Gap(4),
                        Text(
                          l10n.profileIdHint,
                          style: TextStyle(
                            color: palette.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.copy, size: 18, color: palette.accent),
                    onPressed: () {
                      Clipboard.setData(
                        ClipboardData(text: profile.profileId!),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.homeServerProfileIdCopied)),
                      );
                    },
                  ),
                ],
              ),
            ),
            const Gap(24),
          ],
          FilledButton(
            onPressed: () async {
              await ref
                  .read(userProfileProvider.notifier)
                  .setDisplayName(_nameController.text);
              await ref
                  .read(userProfileProvider.notifier)
                  .setEmail(_emailController.text);
              await ref
                  .read(userProfileProvider.notifier)
                  .setPhone(_phoneController.text);
              final home = ref.read(homeServerProvider);
              if (home.auth.isLoggedIn) {
                await ref.read(homeServerProvider.notifier).syncProfileToServer(
                      displayName: _nameController.text.trim(),
                      avatarEmoji: profile.avatarEmoji,
                    );
              }
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.profileSaved),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                Navigator.pop(context);
              }
            },
            child: Text(l10n.profileSave),
          ),
        ],
      ),
    );
  }

  Future<void> _pickCustomAvatar(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    final ok = await ref.read(userProfileProvider.notifier).setCustomAvatarFromPicker();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok ? l10n.profileAvatarPickSuccess : l10n.profileAvatarPickFailed,
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
