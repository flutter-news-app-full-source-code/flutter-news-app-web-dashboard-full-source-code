import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ht_dashboard/dashboard/bloc/dashboard_bloc.dart';
import 'package:ht_dashboard/l10n/l10n.dart';
import 'package:ht_dashboard/shared/shared.dart';

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
                // Other dashboard components will go here in future phases
              ],
            );
          }
          return const SizedBox.shrink(); // Fallback for unexpected states
        },
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
