import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/user_navigation_rail_footer.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

/// A responsive scaffold shell for the main application sections.
///
/// Uses [AdaptiveScaffold] to provide appropriate navigation
/// (bottom bar, rail, or drawer) based on screen size.
class AppShell extends StatelessWidget {
  /// Creates an [AppShell].
  ///
  /// Requires a [navigationShell] to manage the nested navigators
  /// for each section.
  const AppShell({required this.navigationShell, super.key});

  /// The [StatefulNavigationShell] provided by [GoRouter] for managing nested
  /// navigators in a stateful way.
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.dashboardTitle),
        // Removed PopupMenuButton for user actions
        actions: const [
          SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: AdaptiveScaffold(
        selectedIndex: navigationShell.currentIndex,
        onSelectedIndexChange: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.dashboard_outlined),
            selectedIcon: const Icon(Icons.dashboard),
            label: l10n.overview,
          ),
          NavigationDestination(
            icon: const Icon(Icons.folder_open_outlined),
            selectedIcon: const Icon(Icons.folder),
            label: l10n.contentManagement,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_applications_outlined),
            selectedIcon: const Icon(Icons.settings_applications),
            label: l10n.appConfiguration,
          ),
        ],
        // Add the app name at the top of the navigation rail
        leadingExtendedNavRail: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
          child: Text(
            l10n.dashboardTitle, // App name at the top
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        // Add the UserNavigationRailFooter at the bottom of the navigation rail
        trailingNavRail: const UserNavigationRailFooter(),
        body: (_) => Padding(
          padding: const EdgeInsets.fromLTRB(
            0,
            AppSpacing.sm,
            AppSpacing.sm,
            AppSpacing.sm,
          ),
          child: navigationShell,
        ),
      ),
    );
  }
}
