import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app/bloc/app_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/router/routes.dart';
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
    final theme = Theme.of(context);

    // Use the same text style as the NavigationRail labels for consistency.
    final navRailLabelStyle = theme.textTheme.labelMedium;

    return Scaffold(
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
            icon: const Icon(Icons.people_outline),
            selectedIcon: const Icon(Icons.people),
            label: l10n.userManagement,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_applications_outlined),
            selectedIcon: const Icon(Icons.settings_applications),
            label: l10n.appConfiguration,
          ),
        ],
        leadingUnextendedNavRail: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
          child: Icon(
            Icons.newspaper_outlined,
            color: theme.colorScheme.primary,
          ),
        ),
        leadingExtendedNavRail: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              Icon(
                Icons.newspaper_outlined,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                l10n.dashboardTitle,
                style: theme.textTheme.titleLarge,
              ),
            ],
          ),
        ),
        trailingNavRail: Builder(
          builder: (context) {
            final isExtended =
                Breakpoints.mediumLargeAndUp.isActive(context) ||
                Breakpoints.small.isActive(context);
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Settings Tile
                    InkWell(
                      onTap: () => context.goNamed(Routes.settingsName),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: AppSpacing.md,
                          horizontal: isExtended ? 24 : 16,
                        ),
                        child: Row(
                          mainAxisAlignment: isExtended
                              ? MainAxisAlignment.start
                              : MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.settings_outlined,
                              color: theme.colorScheme.onSurfaceVariant,
                              size: 24,
                            ),
                            if (isExtended) ...[
                              const SizedBox(width: AppSpacing.lg),
                              Text(
                                l10n.settings,
                                style: navRailLabelStyle,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    // Sign Out Tile
                    InkWell(
                      onTap: () => context.read<AppBloc>().add(
                        const AppLogoutRequested(),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: AppSpacing.md,
                          horizontal: isExtended ? 24 : 16,
                        ),
                        child: Row(
                          mainAxisAlignment: isExtended
                              ? MainAxisAlignment.start
                              : MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.logout,
                              color: theme.colorScheme.error,
                              size: 24,
                            ),
                            if (isExtended) ...[
                              const SizedBox(width: AppSpacing.lg),
                              Text(
                                l10n.signOut,
                                style: navRailLabelStyle?.copyWith(
                                  color: theme.colorScheme.error,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
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
