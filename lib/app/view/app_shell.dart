import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ht_dashboard/app/bloc/app_bloc.dart';
import 'package:ht_dashboard/l10n/l10n.dart';
import 'package:ht_dashboard/router/routes.dart';
import 'package:ht_dashboard/shared/constants/app_spacing.dart';

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

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.dashboard),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'settings') {
                context.goNamed(Routes.settingsName);
              } else if (value == 'signOut') {
                context.read<AppBloc>().add(const AppLogoutRequested());
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'settings',
                child: Text(l10n.settings),
              ),
              PopupMenuItem<String>(
                value: 'signOut',
                child: Text(l10n.signOut),
              ),
            ],
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Icon(
                  Icons.person,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: AdaptiveScaffold(
        selectedIndex: navigationShell.currentIndex,
        onSelectedIndexChange: _goBranch,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.dashboard_outlined),
            selectedIcon: const Icon(Icons.dashboard),
            label: l10n.dashboard,
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
