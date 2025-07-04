import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ht_dashboard/dashboard/bloc/dashboard_bloc.dart';
import 'package:ht_dashboard/l10n/app_localizations.dart';
import 'package:ht_dashboard/l10n/l10n.dart';
import 'package:ht_dashboard/router/routes.dart';
import 'package:ht_dashboard/shared/shared.dart';
import 'package:ht_shared/ht_shared.dart';

/// {@template dashboard_page}
/// The main dashboard page, displaying key statistics and quick actions.
/// {@endtemplate}
class DashboardPage extends StatefulWidget {
  /// {@macro dashboard_page}
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    // Dispatch the event to load dashboard data when the page is initialized.
    context.read<DashboardBloc>().add(DashboardSummaryLoaded());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state.status == DashboardStatus.loading ||
              state.status == DashboardStatus.initial) {
            return LoadingStateWidget(
              icon: Icons.dashboard_outlined,
              headline: l10n.loadingDashboard,
              subheadline: l10n.loadingDashboardSubheadline,
            );
          }
          if (state.status == DashboardStatus.failure) {
            return FailureStateWidget(
              message: state.errorMessage ?? l10n.dashboardLoadFailure,
              onRetry: () {
                context.read<DashboardBloc>().add(DashboardSummaryLoaded());
              },
            );
          }
          if (state.status == DashboardStatus.success &&
              state.summary != null &&
              state.appConfig != null) {
            final summary = state.summary!;
            final appConfig = state.appConfig!;
            final recentHeadlines = state.recentHeadlines;
            return ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    const tabletBreakpoint = 800;
                    final isNarrow = constraints.maxWidth < tabletBreakpoint;

                    final summaryCards = [
                      _SummaryCard(
                        icon: Icons.article_outlined,
                        title: l10n.totalHeadlines,
                        value: summary.headlineCount.toString(),
                      ),
                      _SummaryCard(
                        icon: Icons.category_outlined,
                        title: l10n.totalCategories,
                        value: summary.categoryCount.toString(),
                      ),
                      _SummaryCard(
                        icon: Icons.source_outlined,
                        title: l10n.totalSources,
                        value: summary.sourceCount.toString(),
                      ),
                    ];

                    if (isNarrow) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          summaryCards[0],
                          const SizedBox(height: AppSpacing.lg),
                          summaryCards[1],
                          const SizedBox(height: AppSpacing.lg),
                          summaryCards[2],
                        ],
                      );
                    }
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: summaryCards[0]),
                        const SizedBox(width: AppSpacing.lg),
                        Expanded(child: summaryCards[1]),
                        const SizedBox(width: AppSpacing.lg),
                        Expanded(child: summaryCards[2]),
                      ],
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                LayoutBuilder(
                  builder: (context, constraints) {
                    const wideBreakpoint = 1200;
                    final isWide = constraints.maxWidth > wideBreakpoint;

                    final mainContent = [
                      _RecentHeadlinesCard(headlines: recentHeadlines),
                      Column(
                        children: [
                          _SystemStatusCard(
                            status: appConfig.appOperationalStatus,
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          const _QuickActionsCard(),
                        ],
                      ),
                    ];

                    if (isWide) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 2, child: mainContent[0]),
                          const SizedBox(width: AppSpacing.lg),
                          Expanded(flex: 1, child: mainContent[1]),
                        ],
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        mainContent[0],
                        const SizedBox(height: AppSpacing.lg),
                        mainContent[1],
                      ],
                    );
                  },
                ),
              ],
            );
          }
          return const SizedBox.shrink(); // Fallback for unexpected states
        },
      ),
    );
  }
}

/// A card to display the current operational status of the application.
class _SystemStatusCard extends StatelessWidget {
  const _SystemStatusCard({required this.status});

  final RemoteAppStatus status;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    final (icon, color, text) = _getStatusDetails(status, l10n, theme);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.systemStatus, style: theme.textTheme.titleLarge),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  text,
                  style: theme.textTheme.titleMedium?.copyWith(color: color),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Returns the appropriate icon, color, and text for a given status.
  (IconData, Color, String) _getStatusDetails(
    RemoteAppStatus status,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    switch (status) {
      case RemoteAppStatus.active:
        return (
          Icons.check_circle_outline,
          theme.colorScheme.primary,
          l10n.appStatusActive,
        );
      case RemoteAppStatus.maintenance:
        return (
          Icons.warning_amber_outlined,
          theme.colorScheme.tertiary,
          l10n.appStatusMaintenance,
        );
      case RemoteAppStatus.disabled:
        return (
          Icons.cancel_outlined,
          theme.colorScheme.error,
          l10n.appStatusDisabled,
        );
    }
  }
}

/// A card providing quick navigation to common administrative tasks.
class _QuickActionsCard extends StatelessWidget {
  const _QuickActionsCard();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.quickActions, style: theme.textTheme.titleLarge),
            const SizedBox(height: AppSpacing.md),
            ElevatedButton.icon(
              icon: const Icon(Icons.add_circle_outline),
              label: Text(l10n.createHeadlineAction),
              onPressed: () => context.goNamed(Routes.createHeadlineName),
            ),
            const SizedBox(height: AppSpacing.sm),
            ElevatedButton.icon(
              icon: const Icon(Icons.create_new_folder_outlined),
              label: Text(l10n.createCategory),
              onPressed: () => context.goNamed(Routes.createCategoryName),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.secondaryContainer,
                foregroundColor: theme.colorScheme.onSecondaryContainer,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            ElevatedButton.icon(
              icon: const Icon(Icons.add_to_photos_outlined),
              label: Text(l10n.createSource),
              onPressed: () => context.goNamed(Routes.createSourceName),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.secondaryContainer,
                foregroundColor: theme.colorScheme.onSecondaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A card to display a list of recently created headlines.
class _RecentHeadlinesCard extends StatelessWidget {
  const _RecentHeadlinesCard({required this.headlines});

  final List<Headline> headlines;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.recentHeadlines, style: theme.textTheme.titleLarge),
                TextButton(
                  onPressed: () =>
                      context.goNamed(Routes.contentManagementName),
                  child: Text(l10n.viewAll),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            if (headlines.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                child: Center(
                  child: Text(
                    l10n.noRecentHeadlines,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              )
            else
              ...headlines.map(
                (headline) => ListTile(
                  leading: const Icon(Icons.article_outlined),
                  title: Text(headline.title, maxLines: 1),
                  subtitle: Text(
                    DateFormatter.formatRelativeTime(
                      context,
                      headline.createdAt,
                    ),
                  ),
                  onTap: () => context.goNamed(
                    Routes.editHeadlineName,
                    pathParameters: {'id': headline.id},
                  ),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// A private widget to display a single summary statistic on the dashboard.
class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 28, color: theme.colorScheme.primary),
            const SizedBox(height: AppSpacing.sm),
            Text(value, style: theme.textTheme.headlineMedium),
            const SizedBox(height: AppSpacing.xs),
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
