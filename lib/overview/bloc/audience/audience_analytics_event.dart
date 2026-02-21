part of 'audience_analytics_bloc.dart';

sealed class AudienceAnalyticsEvent extends Equatable {
  const AudienceAnalyticsEvent();

  @override
  List<Object> get props => [];
}

final class AudienceAnalyticsSubscriptionRequested
    extends AudienceAnalyticsEvent {
  const AudienceAnalyticsSubscriptionRequested();
}
