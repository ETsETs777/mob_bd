/// Роли staff Home Server (совпадают с сервером).
abstract final class StaffRoleId {
  static const moderator = 'moderator';
  static const editor = 'editor';
  static const admin = 'admin';
}

extension StaffRoleAuth on String {
  bool get isStaffRole =>
      this == StaffRoleId.moderator ||
      this == StaffRoleId.editor ||
      this == StaffRoleId.admin;

  bool get canModerateArticles =>
      this == StaffRoleId.moderator || this == StaffRoleId.admin;

  bool get canEditServerContent =>
      this == StaffRoleId.editor || this == StaffRoleId.admin;

  bool get isFullServerAdmin => this == StaffRoleId.admin;
}
