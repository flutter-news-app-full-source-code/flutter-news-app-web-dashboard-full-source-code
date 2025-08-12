import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/dashboard/bloc/dashboard_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/router/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

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
    context.read<DashboardBloc>().add(DashboardSummaryRequested());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
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
              exception: state.exception!,
              onRetry: () {
                context.read<DashboardBloc>().add(DashboardSummaryRequested());
              },
            );
          }
          if (state.status == DashboardStatus.success &&
              state.summary != null) {
            final summary = state.summary!;
            final recentHeadlines = state.recentHeadlines;
            return ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    final summaryCards = [
                      _SummaryCard(
                        icon: Icons.newspaper_outlined,
                        title: l10n.totalHeadlines,
                        value: summary.headlineCount.toString(),
                      ),
                      _SummaryCard(
                        icon: Icons.category_outlined,
                        title: l10n.totalTopics,
                        value: summary.topicCount.toString(),
                      ),
                      _SummaryCard(
                        icon: Icons.source_outlined,
                        title: l10n.totalSources,
                        value: summary.sourceCount.toString(),
                      ),
                    ];

                    // Calculate item width for responsive wrapping
                    // Aim for 3 cards per row on wider screens, 2 on medium, 1 on narrow
                    final double totalWidth = constraints.maxWidth;
                    const double minCardWidth =
                        280; // Minimum readable width for a card
                    const double spacing = AppSpacing.lg;

                    // Calculate how many cards can fit in a row
                    int crossAxisCount = (totalWidth / (minCardWidth + spacing))
                        .floor();
                    if (crossAxisCount == 0)
                      crossAxisCount = 1; // Ensure at least one card
                    if (crossAxisCount > summaryCards.length) {
                      crossAxisCount =
                          summaryCards.length; // Don't exceed number of cards
                    }

                    final double itemWidth =
                        (totalWidth - (spacing * (crossAxisCount - 1))) /
                        crossAxisCount;

                    return Wrap(
                      spacing: spacing, // Horizontal space between cards
                      runSpacing: spacing, // Vertical space between rows
                      alignment: WrapAlignment.start,
                      children: summaryCards
                          .map(
                            (card) => SizedBox(
                              width: itemWidth,
                              child: card,
                            ),
                          )
                          .toList(),
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
                      const _QuickActionsCard(),
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

/// A card providing quick navigation to common administrative tasks.
class _QuickActionsCard extends StatelessWidget {
  const _QuickActionsCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
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
            OutlinedButton.icon(
              icon: const Icon(Icons.create_new_folder_outlined),
              label: Text(l10n.createTopic),
              onPressed: () => context.goNamed(Routes.createTopicName),
            ),
            const SizedBox(height: AppSpacing.sm),
            OutlinedButton.icon(
              icon: const Icon(Icons.add_to_photos_outlined),
              label: Text(l10n.createSource),
              onPressed: () => context.goNamed(Routes.createSourceName),
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
    final l10n = AppLocalizationsX(context).l10n;
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
