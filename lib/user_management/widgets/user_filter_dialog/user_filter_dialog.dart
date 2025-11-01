import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/app_user_role_l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/dashboard_user_role_l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/searchable_selection_input.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/user_management/bloc/user_filter/user_filter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/user_management/widgets/user_filter_dialog/bloc/user_filter_dialog_bloc.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template user_filter_dialog}
/// A full-screen dialog for applying filters to the user management list.
///
/// This dialog provides a search text field for user emails and searchable
/// selection inputs for app and dashboard roles. It uses [UserFilterDialogBloc]
/// to manage its temporary state and applies the final filters to the main
/// [UserFilterBloc].
/// {@endtemplate}
class UserFilterDialog extends StatefulWidget {
  /// {@macro user_filter_dialog}
  const UserFilterDialog({super.key});

  @override
  State<UserFilterDialog> createState() => _UserFilterDialogState();
}

class _UserFilterDialogState extends State<UserFilterDialog> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Dispatches the filter applied event to the main [UserFilterBloc].
  void _dispatchFilterApplied(UserFilterDialogState filterDialogState) {
    context.read<UserFilterBloc>().add(
      UserFilterApplied(
        searchQuery: filterDialogState.searchQuery,
        selectedAppRoles: filterDialogState.selectedAppRoles,
        selectedDashboardRoles: filterDialogState.selectedDashboardRoles,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;

    return BlocBuilder<UserFilterDialogBloc, UserFilterDialogState>(
      builder: (context, filterDialogState) {
        // Sync the text controller with the BLoC state.
        if (_searchController.text != filterDialogState.searchQuery) {
          _searchController.text = filterDialogState.searchQuery;
          _searchController.selection = TextSelection.fromPosition(
            TextPosition(offset: _searchController.text.length),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.filterUsers),
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: l10n.resetFiltersButtonText,
                onPressed: () {
                  // Dispatch a reset event to the main filter BLoC and close.
                  context.read<UserFilterBloc>().add(const UserFilterReset());
                  Navigator.of(context).pop();
                },
              ),
              IconButton(
                icon: const Icon(Icons.check),
                tooltip: l10n.applyFilters,
                onPressed: () {
                  // Apply the current temporary filters and close.
                  _dispatchFilterApplied(filterDialogState);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search field for user email.
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: l10n.search,
                      hintText: l10n.searchByUserEmail,
                      prefixIcon: const Icon(Icons.search),
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (query) {
                      context.read<UserFilterDialogBloc>().add(
                        UserFilterDialogSearchQueryChanged(query),
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Filter for AppUserRole.
                  SearchableSelectionInput<AppUserRole>(
                    label: l10n.appRole,
                    hintText: l10n.selectAppRoles,
                    isMultiSelect: true,
                    selectedItems: filterDialogState.selectedAppRoles,
                    itemBuilder: (context, item) => Text(item.l10n(context)),
                    itemToString: (item) => item.l10n(context),
                    onChanged: (items) {
                      context.read<UserFilterDialogBloc>().add(
                        UserFilterDialogAppRolesChanged(items ?? []),
                      );
                    },
                    staticItems: AppUserRole.values,
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Filter for DashboardUserRole.
                  SearchableSelectionInput<DashboardUserRole>(
                    label: l10n.dashboardRole,
                    hintText: l10n.selectDashboardRoles,
                    isMultiSelect: true,
                    selectedItems: filterDialogState.selectedDashboardRoles,
                    itemBuilder: (context, item) => Text(item.l10n(context)),
                    itemToString: (item) => item.l10n(context),
                    onChanged: (items) {
                      context.read<UserFilterDialogBloc>().add(
                        UserFilterDialogDashboardRolesChanged(items ?? []),
                      );
                    },
                    // Exclude 'admin' from the selectable roles in the filter.
                    staticItems: DashboardUserRole.values
                        .where((role) => role != DashboardUserRole.admin)
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
