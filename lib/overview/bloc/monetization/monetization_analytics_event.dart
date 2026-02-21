part of 'monetization_analytics_bloc.dart';

sealed class MonetizationAnalyticsEvent extends Equatable {
  const MonetizationAnalyticsEvent();

  @override
  List<Object> get props => [];
}

final class MonetizationAnalyticsSubscriptionRequested
    extends MonetizationAnalyticsEvent {
  const MonetizationAnalyticsSubscriptionRequested();
}
