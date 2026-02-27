import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/extensions.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/user_management/bloc/user_filter/user_filter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/user_management/enums/authentication_filter.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/user_management/widgets/user_filter_dialog/bloc/user_filter_dialog_bloc.dart';
import 'package:core_ui/core_ui.dart';

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
        authenticationFilter: filterDialogState.authenticationFilter,
        userRole: filterDialogState.userRole,
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

                  // Authentication Filter
                  _FilterSection<AuthenticationFilter>(
                    title: l10n.authentication,
                    selectedValue: filterDialogState.authenticationFilter,
                    values: AuthenticationFilter.values,
                    onSelected: (value) =>
                        context.read<UserFilterDialogBloc>().add(
                          UserFilterDialogAuthenticationChanged(
                            value!,
                          ),
                        ),
                    chipLabelBuilder: (value) => value.l10n(context),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Dashboard Role Filter
                  _FilterSection<UserRole>(
                    title: l10n.dashboardRole,
                    selectedValue: filterDialogState.userRole,
                    values: const [
                      UserRole.admin,
                      UserRole.publisher,
                    ],
                    onSelected: (value) =>
                        context.read<UserFilterDialogBloc>().add(
                          UserFilterDialogUserRoleChanged(
                            value,
                          ),
                        ),
                    chipLabelBuilder: (value) => value.l10n(context),
                    includeAllOption: true,
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

class _FilterSection<T> extends StatelessWidget {
  const _FilterSection({
    required this.title,
    required this.selectedValue,
    required this.values,
    required this.onSelected,
    required this.chipLabelBuilder,
    this.includeAllOption = false,
  });

  final String title;
  final T? selectedValue;
  final List<T> values;
  final ValueChanged<T?> onSelected;
  final String Function(T) chipLabelBuilder;
  final bool includeAllOption;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    final textTheme = Theme.of(context).textTheme;

    final allValues = includeAllOption
        ? [null, ...values.where((v) => v != null)]
        : values;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: textTheme.titleMedium),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: allValues.map((value) {
            final isSelected = selectedValue == value;
            final label = value == null
                ? l10n.any
                : chipLabelBuilder(value as T);
            return ChoiceChip(
              label: Text(label),
              selected: isSelected,
              onSelected: (_) {
                onSelected(value);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
