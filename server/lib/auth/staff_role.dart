/// Роли staff на Home Server: moderator, editor, admin.
library;

abstract final class StaffRole {
  static const none = '';
  static const moderator = 'moderator';
  static const editor = 'editor';
  static const admin = 'admin';

  static const assignable = [moderator, editor, admin];

  static String normalize(String? raw) {
    final v = (raw ?? '').trim().toLowerCase();
    if (assignable.contains(v)) return v;
    return none;
  }

  static String resolve({String? role, int? legacyIsAdmin}) {
    final normalized = normalize(role);
    if (normalized.isNotEmpty) return normalized;
    if (legacyIsAdmin == 1) return admin;
    return none;
  }

  static bool isStaff(String? role) => normalize(role).isNotEmpty;

  static bool canModerate(String? role) {
    final r = normalize(role);
    return r == moderator || r == admin;
  }

  static bool canEditContent(String? role) {
    final r = normalize(role);
    return r == editor || r == admin;
  }

  static bool canManageUsers(String? role) => normalize(role) == admin;

  static bool canManageSettings(String? role) => normalize(role) == admin;

  static bool canViewAudit(String? role) => normalize(role) == admin;

  static bool isFullAdmin(String? role) => normalize(role) == admin;

  static String label(String? role) => switch (normalize(role)) {
        moderator => 'Moderator',
        editor => 'Editor',
        admin => 'Admin',
        _ => 'User',
      };
}
