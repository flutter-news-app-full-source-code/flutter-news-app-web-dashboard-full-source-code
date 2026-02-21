part of 'content_analytics_bloc.dart';

sealed class ContentAnalyticsEvent extends Equatable {
  const ContentAnalyticsEvent();

  @override
  List<Object> get props => [];
}

final class ContentAnalyticsSubscriptionRequested
    extends ContentAnalyticsEvent {
  const ContentAnalyticsSubscriptionRequested();
}
