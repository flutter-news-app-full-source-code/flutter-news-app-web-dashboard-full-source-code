import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/router/routes.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/about_icon.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/user_management/bloc/user_filter/user_filter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/user_management/view/users_page.dart';
import 'package:go_router/go_router.dart';

/// {@template user_management_page}
/// A page for User Management, providing a view of all system users.
///
/// This page serves as the main entry point for the user management feature.
/// It includes an app bar with a title, an information icon, and a filter
/// button to open the user filtering dialog. The body of the page contains
/// the [UsersPage], which displays the user data table.
/// {@endtemplate}
class UserManagementPage extends StatelessWidget {
  /// {@macro user_management_page}
  const UserManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.userManagement),
            const SizedBox(width: AppSpacing.xs),
            AboutIcon(
              dialogTitle: l10n.userManagement,
              dialogDescription: l10n.userManagementPageDescription,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: l10n.filter,
            onPressed: () {
              // Construct arguments map to pass to the filter dialog route.
              // This ensures the dialog is initialized with the current filter
              // state.
              final arguments = <String, dynamic>{
                'userFilterState': context.read<UserFilterBloc>().state,
              };

              // Push the user filter dialog as a new route.
              context.pushNamed(
                Routes.userFilterDialogName,
                extra: arguments,
              );
            },
          ),
        ],
      ),
      // The body of the scaffold is the UsersPage, which contains the
      // paginated data table for displaying users.
      body: const UsersPage(),
    );
  }
}
