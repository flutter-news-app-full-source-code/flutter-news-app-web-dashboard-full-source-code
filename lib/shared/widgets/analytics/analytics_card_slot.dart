import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verity_dashboard/shared/services/analytics_service.dart';
import 'package:verity_dashboard/shared/widgets/analytics/analytics_card_shell.dart';
import 'package:verity_dashboard/shared/widgets/analytics/chart_card.dart';
import 'package:verity_dashboard/shared/widgets/analytics/kpi_card.dart';
import 'package:verity_dashboard/shared/widgets/analytics/ranked_list_card.dart';

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
        return _buildCardFromData(currentId, cardData);
      }
      // If data is missing for the index, return an empty box.
      return _buildEmptyCard(currentId);
    }

    // Otherwise, fall back to fetching data with a FutureBuilder.
    return _buildCardWithFuture(currentId);
  }

  Widget _buildCardFromData(T id, dynamic data) {
    if (data == null) {
      return _buildEmptyCard(id);
    }

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

  Widget _buildEmptyCard(T id) {
    return AnalyticsCardShell<dynamic>(
      title: _getTitleForCardId(id),
      timeFrames: const [],
      totalSlots: widget.cardIds.length,
      currentSlot: _currentIndex,
      onSlotChanged: _onSlotChanged,
      child: const Center(
        child: Text('No data available'),
      ),
    );
  }

  /// Builds the card by fetching its data using a [FutureBuilder].
  Widget _buildCardWithFuture(T id) {
    final analyticsService = context.read<AnalyticsService>();

    if (id is KpiCardId) {
      return FutureBuilder<KpiCardData?>(
        future: analyticsService.getKpi(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return _buildEmptyCard(id);
          }
          return _buildCardFromData(id, snapshot.data);
        },
      );
    } else if (id is ChartCardId) {
      return FutureBuilder<ChartCardData?>(
        future: analyticsService.getChart(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return _buildEmptyCard(id);
          }
          return _buildCardFromData(id, snapshot.data);
        },
      );
    } else if (id is RankedListCardId) {
      return FutureBuilder<RankedListCardData?>(
        future: analyticsService.getRankedList(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return _buildEmptyCard(id);
          }
          return _buildCardFromData(id, snapshot.data);
        },
      );
    }

    return const Center(child: Text('Unsupported Card Type'));
  }
}

/// Generates a human-readable title from an analytics card enum ID.
///
/// This provides a fallback title when the analytics data (which includes the
/// backend-provided title) cannot be fetched. It works by converting camelCase
/// enum names into Title Case strings.
///
/// Example: `KpiCardId.usersTotalRegistered` -> `"Users Total Registered"`
String _getTitleForCardId(Enum id) {
  final enumName = id.name;

  if (enumName.isEmpty) {
    return '';
  }

  // Split the enum name by capital letters to separate words.
  final parts = enumName.split(RegExp('(?=[A-Z])'));

  if (parts.isEmpty) {
    return '';
  }

  // Capitalize the first letter of the first word.
  final firstWord = parts[0];
  parts[0] = '${firstWord[0].toUpperCase()}${firstWord.substring(1)}';

  return parts.join(' ');
}
