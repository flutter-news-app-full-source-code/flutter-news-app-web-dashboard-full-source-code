import 'package:equatable/equatable.dart';

sealed class SubscriptionsEvent extends Equatable {
  const SubscriptionsEvent();

  @override
  List<Object?> get props => [];
}

final class LoadSubscriptionsRequested extends SubscriptionsEvent {
  const LoadSubscriptionsRequested({
    this.startAfterId,
    this.limit,
    this.forceRefresh = false,
    this.filter,
  });

  final String? startAfterId;
  final int? limit;
  final bool forceRefresh;
  final Map<String, dynamic>? filter;

  @override
  List<Object?> get props => [startAfterId, limit, forceRefresh, filter];
}
