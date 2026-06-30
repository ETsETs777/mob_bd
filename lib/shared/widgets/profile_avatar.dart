import 'package:flutter/material.dart';import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/avatar_storage.dart';
import '../../providers/user_profile_provider.dart';

/// Аватар профиля: своё фото или emoji.
class ProfileAvatar extends ConsumerWidget {
  const ProfileAvatar({
    super.key,
    this.size = 72,
    this.showBorder = true,
    this.onTap,
  });

  final double size;
  final bool showBorder;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);
    final bytes = profile.useCustomAvatar ? AvatarStorage.loadBytes() : null;

    Widget child;
    if (bytes != null && bytes.isNotEmpty) {
      child = ClipOval(
        child: Image.memory(
          bytes,
          width: size,
          height: size,
          fit: BoxFit.cover,
          gaplessPlayback: true,
          errorBuilder: (_, __, ___) => _emojiFallback(profile.avatarEmoji),
        ),
      );
    } else {
      child = _emojiFallback(profile.avatarEmoji);
    }

    final avatar = Container(
      width: size,
      height: size,
      decoration: showBorder
          ? BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.35),
                width: 2,
              ),
            )
          : null,
      alignment: Alignment.center,
      child: child,
    );

    if (onTap == null) return avatar;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: avatar,
      ),
    );
  }

  Widget _emojiFallback(String emoji) {
    return Text(
      emoji,
      style: TextStyle(fontSize: size * 0.52),
      textAlign: TextAlign.center,
    );
  }
}

/// Превью без Riverpod (backup/export cards).
class ProfileAvatarStatic extends StatelessWidget {
  const ProfileAvatarStatic({
    super.key,
    required this.emoji,
    required this.useCustomAvatar,
    this.size = 44,
  });

  final String emoji;
  final bool useCustomAvatar;
  final double size;

  @override
  Widget build(BuildContext context) {
    final bytes = useCustomAvatar ? AvatarStorage.loadBytes() : null;
    if (bytes != null && bytes.isNotEmpty) {
      return ClipOval(
        child: Image.memory(
          bytes,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Text(emoji, style: TextStyle(fontSize: size * 0.55)),
        ),
      );
    }
    return Text(emoji, style: TextStyle(fontSize: size * 0.55));
  }
}
