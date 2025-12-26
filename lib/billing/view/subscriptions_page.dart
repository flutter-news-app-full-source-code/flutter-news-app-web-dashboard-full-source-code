import 'package:core/core.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/billing/bloc/billing_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/billing/bloc/billing_event.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/billing/bloc/billing_filter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/billing/bloc/billing_filter_event.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/billing/bloc/billing_state.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/billing/widgets/subscription_action_buttons.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/constants/app_constants.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/access_tier_l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/access_tier_ui_l10n.dart';
import 'package:intl/intl.dart';
import 'package:ui_kit/ui_kit.dart';

class SubscriptionsPage extends StatefulWidget {
  const SubscriptionsPage({super.key});

  @override
  State<SubscriptionsPage> createState() => _SubscriptionsPageState();
}

class _SubscriptionsPageState extends State<SubscriptionsPage> {
  @override
  void initState() {
    super.initState();
    context.read<BillingBloc>().add(
      LoadSubscriptionsRequested(
        limit: AppConstants.kDefaultRowsPerPage,
        filter: context.read<BillingBloc>().buildFilterMap(
          context.read<BillingFilterBloc>().state,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: BlocBuilder<BillingBloc, BillingState>(
        builder: (context, state) {
          if (state.status == BillingStatus.loading &&
              state.subscriptions.isEmpty) {
            return LoadingStateWidget(
              icon: Icons.receipt_long_outlined,
              headline: l10n.loadingSubscriptions,
              subheadline: l10n.pleaseWait,
            );
          }

          if (state.status == BillingStatus.failure) {
            return FailureStateWidget(
              exception: state.exception!,
              onRetry: () => context.read<BillingBloc>().add(
                LoadSubscriptionsRequested(
                  limit: AppConstants.kDefaultRowsPerPage,
                  forceRefresh: true,
                  filter: context.read<BillingBloc>().buildFilterMap(
                    context.read<BillingFilterBloc>().state,
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
                      context.read<BillingFilterBloc>().add(
                        const BillingFilterReset(),
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
              if (state.status == BillingStatus.loading &&
                  state.subscriptions.isNotEmpty)
                const LinearProgressIndicator(),
              Expanded(
                child: PaginatedDataTable2(
                  columns: [
                    DataColumn2(
                      label: Text(l10n.accessTier),
                      size: ColumnSize.S,
                    ),
                    DataColumn2(
                      label: Text(l10n.status),
                      size: ColumnSize.S,
                    ),
                    DataColumn2(
                      label: Text(l10n.subscriptionProvider),
                      size: ColumnSize.S,
                    ),
                    DataColumn2(
                      label: Text(l10n.expiryDate),
                      size: ColumnSize.M,
                    ),
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
                        state.status != BillingStatus.loading) {
                      context.read<BillingBloc>().add(
                        LoadSubscriptionsRequested(
                          startAfterId: state.cursor,
                          limit: AppConstants.kDefaultRowsPerPage,
                          filter: context.read<BillingBloc>().buildFilterMap(
                            context.read<BillingFilterBloc>().state,
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
  });

  final BuildContext context;
  final List<UserSubscription> subscriptions;
  final bool hasMore;
  final AppLocalizations l10n;

  @override
  DataRow? getRow(int index) {
    if (index >= subscriptions.length) return null;
    final subscription = subscriptions[index];

    return DataRow2(
      cells: [
        DataCell(
          Row(
            children: [
              if (subscription.tier.getPremiumIcon(l10n) case final icon?) ...[
                icon,
                const SizedBox(width: AppSpacing.sm),
              ],
              Text(subscription.tier.l10n(context)),
            ],
          ),
        ),
        DataCell(Text(subscription.status.name.toUpperCase())),
        DataCell(Text(subscription.provider.name.toUpperCase())),
        DataCell(
          Text(
            DateFormat('yyyy-MM-dd').format(subscription.validUntil.toLocal()),
          ),
        ),
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
          SubscriptionActionButtons(
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
