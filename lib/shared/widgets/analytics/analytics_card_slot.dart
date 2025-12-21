import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/services/analytics_service.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/analytics/chart_card.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/analytics/kpi_card.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/analytics/ranked_list_card.dart';

/// {@template analytics_card_slot}
/// A widget that manages a slot containing multiple analytics cards.
///
/// It fetches data using the [AnalyticsService] and displays the appropriate
/// card widget, passing down slot navigation state to the child card.
/// {@endtemplate}
class AnalyticsCardSlot<T extends Enum> extends StatefulWidget {
  /// {@macro analytics_card_slot}
  const AnalyticsCardSlot({
    required this.cardIds,
    super.key,
  }) : assert(cardIds.length > 0, 'Must provide at least one card ID');

  /// The list of card IDs available in this slot.
  final List<T> cardIds;

  @override
  State<AnalyticsCardSlot<T>> createState() => _AnalyticsCardSlotState<T>();
}

class _AnalyticsCardSlotState<T extends Enum>
    extends State<AnalyticsCardSlot<T>> {
  int _currentIndex = 0;

  void _onSlotChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentId = widget.cardIds[_currentIndex];
    return _buildCardContent(currentId);
  }

  Widget _buildCardContent(T id) {
    final analyticsService = context.read<AnalyticsService>();
    final totalSlots = widget.cardIds.length;

    if (id is KpiCardId) {
      return FutureBuilder<KpiCardData>(
        future: analyticsService.getKpi(id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return KpiCard(
              data: snapshot.data!,
              slotIndex: _currentIndex,
              totalSlots: totalSlots,
              onSlotChanged: _onSlotChanged,
            );
          }
          return const SizedBox.shrink();
        },
      );
    } else if (id is ChartCardId) {
      return FutureBuilder<ChartCardData>(
        future: analyticsService.getChart(id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ChartCard(
              data: snapshot.data!,
              slotIndex: _currentIndex,
              totalSlots: totalSlots,
              onSlotChanged: _onSlotChanged,
            );
          }
          return const SizedBox.shrink();
        },
      );
    } else if (id is RankedListCardId) {
      return FutureBuilder<RankedListCardData>(
        future: analyticsService.getRankedList(id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return RankedListCard(
              data: snapshot.data!,
              slotIndex: _currentIndex,
              totalSlots: totalSlots,
              onSlotChanged: _onSlotChanged,
            );
          }
          return const SizedBox.shrink();
        },
      );
    }

    return const Center(child: Text('Unsupported Card Type'));
  }
}
