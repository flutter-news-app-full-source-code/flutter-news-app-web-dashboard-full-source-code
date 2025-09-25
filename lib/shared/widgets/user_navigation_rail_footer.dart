import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app/bloc/app_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/router/routes.dart';
import 'package:go_router/go_router.dart';

/// {@template user_navigation_rail_footer}
/// A widget designed to be placed at the bottom of a [NavigationRail]
/// to display user-specific actions like settings and sign-out.
/// {@endtemplate}
class UserNavigationRailFooter extends StatelessWidget {
  /// {@macro user_navigation_rail_footer}
  const UserNavigationRailFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Settings Tile
        ListTile(
          leading: Icon(
            Icons.settings,
            color: theme.colorScheme.onSurface,
            size: 24, // Explicitly set icon size
          ),
          title: Text(
            l10n.settings,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          onTap: () {
            context.goNamed(Routes.settingsName);
          },
        ),
        // Sign Out Tile
        ListTile(
          leading: Icon(
            Icons.logout,
            color: theme.colorScheme.error,
            size: 24, // Explicitly set icon size
          ),
          title: Text(
            l10n.signOut,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
          onTap: () {
            context.read<AppBloc>().add(const AppLogoutRequested());
          },
        ),
      ],
    );
  }
}
