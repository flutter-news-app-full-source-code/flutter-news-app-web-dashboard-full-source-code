import 'package:core/core.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/constants/app_constants.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/subscriptions/bloc/subscriptions_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/subscriptions/bloc/subscriptions_event.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/subscriptions/bloc/subscriptions_filter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/subscriptions/bloc/subscriptions_filter_event.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/subscriptions/bloc/subscriptions_state.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/subscriptions/widgets/subscriptions_action_buttons.dart';
import 'package:intl/intl.dart';
import 'package:ui_kit/ui_kit.dart';

class SubscriptionsListView extends StatefulWidget {
  const SubscriptionsListView({super.key});

  @override
  State<SubscriptionsListView> createState() => _SubscriptionsListViewState();
}

class _SubscriptionsListViewState extends State<SubscriptionsListView> {
  @override
  void initState() {
    super.initState();
    context.read<SubscriptionsBloc>().add(
      LoadSubscriptionsRequested(
        limit: AppConstants.kDefaultRowsPerPage,
        filter: context.read<SubscriptionsBloc>().buildFilterMap(
          context.read<SubscriptionsFilterBloc>().state,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
        final l10n = AppLocalizationsX(context).l10n;

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: BlocBuilder<SubscriptionsBloc, SubscriptionsState>(
        builder: (context, state) {
          if (state.status == SubscriptionsStatus.loading &&
              state.subscriptions.isEmpty) {
            return LoadingStateWidget(
              icon: Icons.receipt_long_outlined,
              headline: l10n.loadingSubscriptions,
              subheadline: l10n.pleaseWait,
            );
          }

          if (state.status == SubscriptionsStatus.failure) {
            return FailureStateWidget(
              exception: state.exception!,
              onRetry: () => context.read<SubscriptionsBloc>().add(
                LoadSubscriptionsRequested(
                  limit: AppConstants.kDefaultRowsPerPage,
                  forceRefresh: true,
                  filter: context.read<SubscriptionsBloc>().buildFilterMap(
                    context.read<SubscriptionsFilterBloc>().state,
                  ),
                ),
              ),
            );
          }

          if (state.subscriptions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.noSubscriptionsFound,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  ElevatedButton(
                    onPressed: () {
                      context.read<SubscriptionsFilterBloc>().add(
                        const SubscriptionsFilterReset(),
                      );
                    },
                    child: Text(l10n.resetFiltersButtonText),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              if (state.status == SubscriptionsStatus.loading &&
                  state.subscriptions.isNotEmpty)
                const LinearProgressIndicator(),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isMobile = constraints.maxWidth < 600;
                    return PaginatedDataTable2(
                      columns: [
                        DataColumn2(
                          label: Text(l10n.status),
                          size: ColumnSize.S,
                        ),
                        if (!isMobile)
                          DataColumn2(
                            label: Text(l10n.subscriptionProvider),
                            size: ColumnSize.S,
                          ),
                        DataColumn2(
                          label: Text(l10n.expiryDate),
                          size: ColumnSize.M,
                        ),
                        if (!isMobile)
                          DataColumn2(
                            label: Text(l10n.willAutoRenew),
                            size: ColumnSize.S,
                          ),
                        DataColumn2(
                          label: Text(l10n.actions),
                          size: ColumnSize.S,
                        ),
                      ],
                      source: _SubscriptionsDataSource(
                        context: context,
                        subscriptions: state.subscriptions,
                        hasMore: state.hasMore,
                        l10n: l10n,
                        isMobile: isMobile,
                      ),
                      rowsPerPage: AppConstants.kDefaultRowsPerPage,
                      availableRowsPerPage: const [
                        AppConstants.kDefaultRowsPerPage,
                      ],
                      onPageChanged: (pageIndex) {
                        final newOffset =
                            pageIndex * AppConstants.kDefaultRowsPerPage;
                        if (newOffset >= state.subscriptions.length &&
                            state.hasMore &&
                            state.status != SubscriptionsStatus.loading) {
                          context.read<SubscriptionsBloc>().add(
                            LoadSubscriptionsRequested(
                              startAfterId: state.cursor,
                              limit: AppConstants.kDefaultRowsPerPage,
                              filter: context
                                  .read<SubscriptionsBloc>()
                                  .buildFilterMap(
                                    context
                                        .read<SubscriptionsFilterBloc>()
                                        .state,
                                  ),
                            ),
                          );
                        }
                      },
                      empty: Center(child: Text(l10n.noSubscriptionsFound)),
                      showCheckboxColumn: false,
                      showFirstLastButtons: true,
                      fit: FlexFit.tight,
                      headingRowHeight: 56,
                      dataRowHeight: 56,
                      columnSpacing: AppSpacing.sm,
                      horizontalMargin: AppSpacing.sm,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SubscriptionsDataSource extends DataTableSource {
  _SubscriptionsDataSource({
    required this.context,
    required this.subscriptions,
    required this.hasMore,
    required this.l10n,
    required this.isMobile,
  });

  final BuildContext context;
  final List<UserSubscription> subscriptions;
  final bool hasMore;
  final AppLocalizations l10n;
  final bool isMobile;

  Color? _getStatusColor(BuildContext context, SubscriptionStatus status) {
    final colorScheme = Theme.of(context).colorScheme;
    return switch (status) {
      SubscriptionStatus.active => colorScheme.primaryContainer,
      SubscriptionStatus.gracePeriod => colorScheme.tertiaryContainer,
      SubscriptionStatus.billingIssue => colorScheme.errorContainer,
      SubscriptionStatus.canceled => colorScheme.surfaceContainerHighest,
      SubscriptionStatus.expired => colorScheme.surfaceContainerHighest,
    };
  }

  Color? _getProviderColor(BuildContext context, StoreProvider provider) {
    final colorScheme = Theme.of(context).colorScheme;
    return switch (provider) {
      StoreProvider.apple => colorScheme.secondaryContainer,
      StoreProvider.google => colorScheme.errorContainer,
    };
  }

  @override
  DataRow? getRow(int index) {
    if (index >= subscriptions.length) return null;
    final subscription = subscriptions[index];

    return DataRow2(
      cells: [
        DataCell(
          Chip(
            label: Text(
              switch (subscription.status) {
                SubscriptionStatus.active => l10n.subscriptionStatusActive,
                SubscriptionStatus.gracePeriod =>
                  l10n.subscriptionStatusGracePeriod,
                SubscriptionStatus.billingIssue =>
                  l10n.subscriptionStatusBillingIssue,
                SubscriptionStatus.canceled => l10n.subscriptionStatusCanceled,
                SubscriptionStatus.expired => l10n.subscriptionStatusExpired,
              },
            ),
            backgroundColor: _getStatusColor(context, subscription.status),
            side: BorderSide.none,
            visualDensity: VisualDensity.compact,
          ),
        ),
        if (!isMobile)
          DataCell(
            Chip(
              label: Text(
                switch (subscription.provider) {
                  StoreProvider.apple => l10n.storeProviderApple,
                  StoreProvider.google => l10n.storeProviderGoogle,
                },
              ),
              backgroundColor: _getProviderColor(
                context,
                subscription.provider,
              ),
              side: BorderSide.none,
              visualDensity: VisualDensity.compact,
            ),
          ),
        DataCell(
          Text(
            DateFormat('yyyy-MM-dd').format(subscription.validUntil.toLocal()),
          ),
        ),
        if (!isMobile)
          DataCell(
            Icon(
              subscription.willAutoRenew ? Icons.check_circle : Icons.cancel,
              color: subscription.willAutoRenew
                  ? Colors.green
                  : Theme.of(context).colorScheme.error,
              size: 20,
            ),
          ),
        DataCell(
          SubscriptionsActionButtons(
            subscription: subscription,
            l10n: l10n,
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => hasMore;

  @override
  int get rowCount => subscriptions.length;

  @override
  int get selectedRowCount => 0;
}
