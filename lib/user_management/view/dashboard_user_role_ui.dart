import 'package:core/core.dart';

/// An extension on [DashboardUserRole] to provide UI-related helpers.
extension DashboardUserRoleUI on DashboardUserRole {
  /// A convenience getter to check if the user has a privileged dashboard role.
  bool get isPrivileged {
    return this == DashboardUserRole.admin ||
        this == DashboardUserRole.publisher;
  }
}
