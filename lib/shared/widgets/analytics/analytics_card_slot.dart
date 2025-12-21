import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/services/analytics_service.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/analytics/chart_card.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/analytics/kpi_card.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template analytics_card_slot}
/// A widget that manages a slot containing multiple analytics cards, allowing
/// users to switch between them.
///
/// This widget is generic and can handle either [KpiCardId] or [ChartCardId].
/// It fetches data using the [AnalyticsService] and displays the appropriate
/// card widget.
/// {@endtemplate}
class AnalyticsCardSlot<T extends Enum> extends StatefulWidget {
  /// {@macro analytics_card_slot}
  const AnalyticsCardSlot({
    required this.cardIds,
    super.key,
  }) : assert(cardIds.length > 0, 'Must provide at least one card ID');

  /// The list of card IDs available in this slot.
  /// Must be a list of [KpiCardId] or [ChartCardId].
  final List<T> cardIds;

  @override
  State<AnalyticsCardSlot<T>> createState() => _AnalyticsCardSlotState<T>();
}

class _AnalyticsCardSlotState<T extends Enum>
    extends State<AnalyticsCardSlot<T>> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final currentId = widget.cardIds[_currentIndex];
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Card Content
        Expanded(
          child: _buildCardContent(currentId),
        ),
        const SizedBox(height: AppSpacing.sm),
        // Navigation Dots (only if multiple cards)
        if (widget.cardIds.length > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.cardIds.length, (index) {
              final isSelected = index == _currentIndex;
              return GestureDetector(
                onTap: () => setState(() => _currentIndex = index),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.surfaceContainerHighest,
                  ),
                ),
              );
            }),
          ),
      ],
    );
  }

  Widget _buildCardContent(T id) {
    final analyticsService = context.read<AnalyticsService>();

    if (id is KpiCardId) {
      return FutureBuilder<KpiCardData>(
        future: analyticsService.getKpi(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.hasData) {
            return KpiCard(data: snapshot.data!);
          }
          return const SizedBox.shrink();
        },
      );
    } else if (id is ChartCardId) {
      return FutureBuilder<ChartCardData>(
        future: analyticsService.getChart(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.hasData) {
            return ChartCard(data: snapshot.data!);
          }
          return const SizedBox.shrink();
        },
      );
    }

    return const Center(child: Text('Unsupported Card Type'));
  }
}
