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
    this.data,
    super.key,
  }) : assert(cardIds.length > 0, 'Must provide at least one card ID');

  /// The list of card IDs available in this slot.
  final List<T> cardIds;

  /// An optional list of pre-fetched data objects. If provided, the widget
  /// will not fetch data itself. The list must match the order of [cardIds].
  final List<dynamic>? data;

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

    // If data is pre-fetched, build the card directly.
    if (widget.data != null) {
      // Ensure the data list has an entry for the current index.
      if (_currentIndex < widget.data!.length) {
        final cardData = widget.data![_currentIndex];
        return _buildCardFromData(cardData);
      }
      // If data is missing for the index, return an empty box.
      return const SizedBox.shrink();
    }

    // Otherwise, fall back to fetching data with a FutureBuilder.
    return _buildCardWithFuture(currentId);
  }

  /// Builds the appropriate card widget directly from a [data] object.
  Widget _buildCardFromData(dynamic data) {
    final totalSlots = widget.cardIds.length;

    if (data is KpiCardData) {
      return KpiCard(
        data: data,
        slotIndex: _currentIndex,
        totalSlots: totalSlots,
        onSlotChanged: _onSlotChanged,
      );
    } else if (data is ChartCardData) {
      return ChartCard(
        data: data,
        slotIndex: _currentIndex,
        totalSlots: totalSlots,
        onSlotChanged: _onSlotChanged,
      );
    } else if (data is RankedListCardData) {
      return RankedListCard(
        data: data,
        slotIndex: _currentIndex,
        totalSlots: totalSlots,
        onSlotChanged: _onSlotChanged,
      );
    }

    return const Center(child: Text('Unsupported Card Type'));
  }

  /// Builds the card by fetching its data using a [FutureBuilder].
  Widget _buildCardWithFuture(T id) {
    final analyticsService = context.read<AnalyticsService>();

    if (id is KpiCardId) {
      return FutureBuilder<KpiCardData>(
        future: analyticsService.getKpi(id),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? _buildCardFromData(snapshot.data!)
              : const SizedBox.shrink();
        },
      );
    } else if (id is ChartCardId) {
      return FutureBuilder<ChartCardData>(
        future: analyticsService.getChart(id),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? _buildCardFromData(snapshot.data!)
              : const SizedBox.shrink();
        },
      );
    } else if (id is RankedListCardId) {
      return FutureBuilder<RankedListCardData>(
        future: analyticsService.getRankedList(id),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? _buildCardFromData(snapshot.data!)
              : const SizedBox.shrink();
        },
      );
    }

    return const Center(child: Text('Unsupported Card Type'));
  }
}
