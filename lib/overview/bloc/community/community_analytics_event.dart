part of 'community_analytics_bloc.dart';

sealed class CommunityAnalyticsEvent extends Equatable {
  const CommunityAnalyticsEvent();

  @override
  List<Object> get props => [];
}

final class CommunityAnalyticsSubscriptionRequested
    extends CommunityAnalyticsEvent {
  const CommunityAnalyticsSubscriptionRequested();
}
