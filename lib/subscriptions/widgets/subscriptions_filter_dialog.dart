import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/subscriptions/bloc/subscriptions_filter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/subscriptions/bloc/subscriptions_filter_dialog_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/subscriptions/bloc/subscriptions_filter_dialog_event.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/subscriptions/bloc/subscriptions_filter_dialog_state.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/subscriptions/bloc/subscriptions_filter_event.dart';
import 'package:ui_kit/ui_kit.dart';

class SubscriptionsFilterDialog extends StatefulWidget {
  const SubscriptionsFilterDialog({super.key});

  @override
  State<SubscriptionsFilterDialog> createState() =>
      _SubscriptionsFilterDialogState();
}

class _SubscriptionsFilterDialogState extends State<SubscriptionsFilterDialog> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    // Initialize dialog state from the main filter bloc
    final mainFilterState = context.read<SubscriptionsFilterBloc>().state;
    context.read<SubscriptionsFilterDialogBloc>().add(
      SubscriptionsFilterDialogInitialized(mainFilterState),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters(SubscriptionsFilterDialogState state) {
    context.read<SubscriptionsFilterBloc>().add(
      SubscriptionsFilterApplied(
        searchQuery: state.searchQuery,
        status: state.status,
        provider: state.provider,
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
        final l10n = AppLocalizationsX(context).l10n;

    return BlocBuilder<SubscriptionsFilterDialogBloc,
        SubscriptionsFilterDialogState>(
      builder: (context, state) {
        if (_searchController.text != state.searchQuery) {
          _searchController.text = state.searchQuery;
          _searchController.selection = TextSelection.fromPosition(
            TextPosition(offset: _searchController.text.length),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.filterSubscriptions),
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: l10n.resetFiltersButtonText,
                onPressed: () {
                  context.read<SubscriptionsFilterBloc>().add(
                    const SubscriptionsFilterReset(),
                  );
                  Navigator.of(context).pop();
                },
              ),
              IconButton(
                icon: const Icon(Icons.check),
                tooltip: l10n.applyFilters,
                onPressed: () => _applyFilters(state),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: l10n.search,
                      hintText: l10n.searchByUserIdOrSubscriptionId,
                      prefixIcon: const Icon(Icons.search),
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      context.read<SubscriptionsFilterDialogBloc>().add(
                        SubscriptionsFilterDialogSearchQueryChanged(value),
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _FilterSection<SubscriptionStatus>(
                    title: l10n.selectStatus,
                    selectedValue: state.status,
                    values: SubscriptionStatus.values,
                    onSelected: (value) {
                      context.read<SubscriptionsFilterDialogBloc>().add(
                        SubscriptionsFilterDialogStatusChanged(value),
                      );
                    },
                    labelBuilder: (v) => switch (v) {
                      SubscriptionStatus.active =>
                        l10n.subscriptionStatusActive,
                      SubscriptionStatus.gracePeriod =>
                        l10n.subscriptionStatusGracePeriod,
                      SubscriptionStatus.billingIssue =>
                        l10n.subscriptionStatusBillingIssue,
                      SubscriptionStatus.canceled =>
                        l10n.subscriptionStatusCanceled,
                      SubscriptionStatus.expired =>
                        l10n.subscriptionStatusExpired,
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _FilterSection<StoreProvider>(
                    title: l10n.selectProvider,
                    selectedValue: state.provider,
                    values: StoreProvider.values,
                    onSelected: (value) {
                      context.read<SubscriptionsFilterDialogBloc>().add(
                        SubscriptionsFilterDialogProviderChanged(value),
                      );
                    },
                    labelBuilder: (v) => switch (v) {
                      StoreProvider.apple => l10n.storeProviderApple,
                      StoreProvider.google => l10n.storeProviderGoogle,
                    },
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
    required this.labelBuilder,
  });

  final String title;
  final T? selectedValue;
  final List<T> values;
  final ValueChanged<T?> onSelected;
  final String Function(T) labelBuilder;

  @override
  Widget build(BuildContext context) {
        final l10n = AppLocalizationsX(context).l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            ChoiceChip(
              label: Text(l10n.any),
              selected: selectedValue == null,
              onSelected: (selected) {
                if (selected) onSelected(null);
              },
            ),
            ...values.map((value) {
              return ChoiceChip(
                label: Text(labelBuilder(value)),
                selected: selectedValue == value,
                onSelected: (selected) {
                  onSelected(selected ? value : null);
                },
              );
            }),
          ],
        ),
      ],
    );
  }
}
