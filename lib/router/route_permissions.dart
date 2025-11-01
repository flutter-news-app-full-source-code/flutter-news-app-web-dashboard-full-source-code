import 'package:core/core.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/router/routes.dart';

/// A centralized mapping of dashboard user roles to their permitted routes.
///
/// This map is used by the router's redirect logic to enforce navigation
/// restrictions based on the authenticated user's role.
final Map<DashboardUserRole, Set<String>> routePermissions = {
  // Admins have access to all major sections of the dashboard.
  DashboardUserRole.admin: {
    Routes.overviewName,
    Routes.contentManagementName,
    Routes.userManagementName,
    Routes.appConfigurationName,
  },
  // Publishers have a more restricted access, focused on content creation
  // and management.
  DashboardUserRole.publisher: {
    Routes.overviewName,
    Routes.contentManagementName,
  },
};
