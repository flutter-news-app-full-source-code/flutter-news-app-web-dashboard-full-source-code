import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/rewards_management/bloc/rewards_filter/rewards_filter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/rewards_management/enums/reward_type_filter.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/rewards_management/widgets/rewards_filter_dialog/bloc/rewards_filter_dialog_bloc.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template rewards_filter_dialog}
/// A full-screen dialog for applying filters to the rewards management list.
///
/// This dialog provides a search text field for user IDs and choice chips
/// for filtering by reward type. It uses [RewardsFilterDialogBloc] to manage
/// its temporary state and applies the final filters to the main
/// [RewardsFilterBloc].
/// {@endtemplate}
class RewardsFilterDialog extends StatefulWidget {
  /// {@macro rewards_filter_dialog}
  const RewardsFilterDialog({super.key});

  @override
  State<RewardsFilterDialog> createState() => _RewardsFilterDialogState();
}

class _RewardsFilterDialogState extends State<RewardsFilterDialog> {
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

  /// Dispatches the filter applied event to the main [RewardsFilterBloc].
  void _dispatchFilterApplied(RewardsFilterDialogState filterDialogState) {
    context.read<RewardsFilterBloc>().add(
      RewardsFilterApplied(
        searchQuery: filterDialogState.searchQuery,
        rewardTypeFilter: filterDialogState.rewardTypeFilter,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;

    return BlocBuilder<RewardsFilterDialogBloc, RewardsFilterDialogState>(
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
            title: Text(l10n.filterRewards),
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
                  context.read<RewardsFilterBloc>().add(
                    const RewardsFilterReset(),
                  );
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
                  // Search field for user ID.
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: l10n.search,
                      hintText: l10n.searchByUserId,
                      prefixIcon: const Icon(Icons.search),
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (query) {
                      context.read<RewardsFilterDialogBloc>().add(
                        RewardsFilterDialogSearchQueryChanged(query),
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Reward Type Filter
                  _FilterSection<RewardTypeFilter>(
                    title: l10n.rewardType,
                    selectedValue: filterDialogState.rewardTypeFilter,
                    values: RewardTypeFilter.values,
                    onSelected: (value) =>
                        context.read<RewardsFilterDialogBloc>().add(
                          RewardsFilterDialogRewardTypeChanged(value!),
                        ),
                    chipLabelBuilder: (value) => value.l10n(context),
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
  });

  final String title;
  final T? selectedValue;
  final List<T> values;
  final ValueChanged<T?> onSelected;
  final String Function(T) chipLabelBuilder;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: textTheme.titleMedium),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: values.map((value) {
            final isSelected = selectedValue == value;
            return ChoiceChip(
              label: Text(chipLabelBuilder(value)),
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
