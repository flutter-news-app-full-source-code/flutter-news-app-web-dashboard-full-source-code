import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ht_dashboard/dashboard/bloc/dashboard.dart'; // Barrel file
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
          if (state.status == DashboardStatus.success && state.summary != null) {
            final summary = state.summary!;
            final recentHeadlines = state.recentHeadlines;
            return ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _SummaryCard(
                        icon: Icons.article_outlined,
                        title: l10n.totalHeadlines,
                        value: summary.headlineCount.toString(),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: _SummaryCard(
                        icon: Icons.category_outlined,
                        title: l10n.totalCategories,
                        value: summary.categoryCount.toString(),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: _SummaryCard(
                        icon: Icons.source_outlined,
                        title: l10n.totalSources,
                        value: summary.sourceCount.toString(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                _RecentHeadlinesCard(
                  headlines: recentHeadlines,
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
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
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
