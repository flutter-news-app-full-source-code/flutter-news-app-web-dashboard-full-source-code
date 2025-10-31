import 'package:core/core.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/app_user_role_l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/dashboard_user_role_l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/user_management/bloc/user_filter/user_filter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/user_management/bloc/user_management_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/user_management/widgets/user_action_buttons.dart';
import 'package:intl/intl.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template users_page}
/// A page for displaying and managing Users in a tabular format.
///
/// This widget listens to the [UserManagementBloc] and displays a paginated
/// data table of users. It handles loading, success, failure, and empty states.
/// {@endtemplate}
class UsersPage extends StatefulWidget {
  /// {@macro users_page}
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  void initState() {
    super.initState();
    // Initial load of users, applying the default filter from UserFilterBloc.
    context.read<UserManagementBloc>().add(
      LoadUsersRequested(
        limit: kDefaultRowsPerPage,
        filter: context.read<UserManagementBloc>().buildUsersFilterMap(
          context.read<UserFilterBloc>().state,
        ),
      ),
    );
  }

  /// Checks if any filters are currently active in the UserFilterBloc.
  bool _areFiltersActive(UserFilterState state) {
    return state.searchQuery.isNotEmpty || state.selectedAppRoles.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: BlocBuilder<UserManagementBloc, UserManagementState>(
        builder: (context, state) {
          final userFilterState = context.watch<UserFilterBloc>().state;
          final filtersActive = _areFiltersActive(userFilterState);

          // Show loading indicator when fetching for the first time.
          if (state.status == UserManagementStatus.loading &&
              state.users.isEmpty) {
            return LoadingStateWidget(
              icon: Icons.people_outline,
              headline: l10n.loadingUsers,
              subheadline: l10n.pleaseWait,
            );
          }

          // Show failure widget if an error occurs.
          if (state.status == UserManagementStatus.failure) {
            return FailureStateWidget(
              exception: state.exception!,
              onRetry: () => context.read<UserManagementBloc>().add(
                LoadUsersRequested(
                  limit: kDefaultRowsPerPage,
                  forceRefresh: true,
                  filter: context
                      .read<UserManagementBloc>()
                      .buildUsersFilterMap(
                        context.read<UserFilterBloc>().state,
                      ),
                ),
              ),
            );
          }

          // Handle empty states.
          if (state.users.isEmpty) {
            if (filtersActive) {
              // If filters are active, show a message to reset them.
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.noResultsWithCurrentFilters,
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    ElevatedButton(
                      onPressed: () {
                        context.read<UserFilterBloc>().add(
                          const UserFilterReset(),
                        );
                      },
                      child: Text(l10n.resetFiltersButtonText),
                    ),
                  ],
                ),
              );
            }
            // If no filters are active, show a generic "no users" message.
            return Center(child: Text(l10n.noUsersFound));
          }

          // Display the data table with users.
          return Column(
            children: [
              // Show a linear progress indicator during subsequent loads/pagination.
              if (state.status == UserManagementStatus.loading &&
                  state.users.isNotEmpty)
                const LinearProgressIndicator(),
              Expanded(
                child: PaginatedDataTable2(
                  columns: [
                    DataColumn2(
                      label: Text(l10n.email),
                      size: ColumnSize.L,
                    ),
                    DataColumn2(
                      label: Text(l10n.authentication),
                      size: ColumnSize.S,
                    ),
                    DataColumn2(
                      label: Text(l10n.subscription),
                      size: ColumnSize.S,
                    ),
                    DataColumn2(
                      label: Text(l10n.createdAt),
                      size: ColumnSize.M,
                    ),
                    DataColumn2(
                      label: Text(l10n.actions),
                      size: ColumnSize.S,
                    ),
                  ],
                  source: _UsersDataSource(
                    context: context,
                    users: state.users,
                    hasMore: state.hasMore,
                    l10n: l10n,
                  ),
                  rowsPerPage: kDefaultRowsPerPage,
                  availableRowsPerPage: const [kDefaultRowsPerPage],
                  onPageChanged: (pageIndex) {
                    // Handle pagination: fetch next page if needed.
                    final newOffset = pageIndex * kDefaultRowsPerPage;
                    if (newOffset >= state.users.length &&
                        state.hasMore &&
                        state.status != UserManagementStatus.loading) {
                      context.read<UserManagementBloc>().add(
                        LoadUsersRequested(
                          startAfterId: state.cursor,
                          limit: kDefaultRowsPerPage,
                          filter: context
                              .read<UserManagementBloc>()
                              .buildUsersFilterMap(
                                context.read<UserFilterBloc>().state,
                              ),
                        ),
                      );
                    }
                  },
                  empty: Center(child: Text(l10n.noUsersFound)),
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

/// Data source for the paginated user table.
class _UsersDataSource extends DataTableSource {
  _UsersDataSource({
    required this.context,
    required this.users,
    required this.hasMore,
    required this.l10n,
  });

  final BuildContext context;
  final List<User> users;
  final bool hasMore;
  final AppLocalizations l10n;

  @override
  DataRow? getRow(int index) {
    if (index >= users.length) {
      return null;
    }
    final user = users[index];
    return DataRow2(
      // We don't implement onSelectChanged because user edits are handled
      // via the action buttons, not by navigating to a dedicated edit page.
      // The email cell is wrapped in an Expanded widget to allow truncation.
      cells: [
        DataCell(
          Row(
            children: [
              Expanded(
                child: Text(
                  user.email,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
        DataCell(Text(user.appRole.authenticationStatusL10n(context))),
        DataCell(Text(user.appRole.subscriptionStatusL10n(context))),
        DataCell(
          Text(
            DateFormat('dd-MM-yyyy').format(user.createdAt.toLocal()),
          ),
        ),
        DataCell(
          UserActionButtons(
            user: user,
            l10n: l10n,
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => hasMore;

  @override
  int get rowCount => users.length;

  @override
  int get selectedRowCount => 0;
}

/// An extension to get the localized string for the authentication status
/// derived from [AppUserRole].
extension AuthenticationStatusL10n on AppUserRole {
  /// Returns the localized authentication status string.
  String authenticationStatusL10n(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    switch (this) {
      case AppUserRole.guestUser:
        return l10n.authenticationAnonymous;
      case AppUserRole.standardUser:
      case AppUserRole.premiumUser:
        return l10n.authenticationAuthenticated;
    }
  }
}

/// An extension to get the localized string for the subscription status
/// derived from [AppUserRole].
extension SubscriptionStatusL10n on AppUserRole {
  /// Returns the localized subscription status string.
  String subscriptionStatusL10n(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    switch (this) {
      case AppUserRole.guestUser:
      case AppUserRole.standardUser:
        return l10n.subscriptionFree;
      case AppUserRole.premiumUser:
        return l10n.subscriptionPremium;
    }
  }
}
