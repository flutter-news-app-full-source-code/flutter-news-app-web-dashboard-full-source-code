part of 'community_management_bloc.dart';

abstract class CommunityManagementEvent extends Equatable {
  const CommunityManagementEvent();

  @override
  List<Object?> get props => [];
}

class CommunityManagementTabChanged extends CommunityManagementEvent {
  const CommunityManagementTabChanged(this.tab);

  final CommunityManagementTab tab;

  @override
  List<Object> get props => [tab];
}

class LoadEngagementsRequested extends CommunityManagementEvent {
  const LoadEngagementsRequested({
    this.startAfterId,
    this.limit,
    this.filter,
    this.forceRefresh = false,
  });

  final String? startAfterId;
  final int? limit;
  final Map<String, dynamic>? filter;
  final bool forceRefresh;

  @override
  List<Object?> get props => [startAfterId, limit, filter, forceRefresh];
}

class LoadReportsRequested extends CommunityManagementEvent {
  const LoadReportsRequested({
    this.startAfterId,
    this.limit,
    this.filter,
    this.forceRefresh = false,
  });

  final String? startAfterId;
  final int? limit;
  final Map<String, dynamic>? filter;
  final bool forceRefresh;

  @override
  List<Object?> get props => [startAfterId, limit, filter, forceRefresh];
}

class LoadAppReviewsRequested extends CommunityManagementEvent {
  const LoadAppReviewsRequested({
    this.startAfterId,
    this.limit,
    this.filter,
    this.forceRefresh = false,
  });

  final String? startAfterId;
  final int? limit;
  final Map<String, dynamic>? filter;
  final bool forceRefresh;

  @override
  List<Object?> get props => [startAfterId, limit, filter, forceRefresh];
}

final class ApproveCommentRequested extends CommunityManagementEvent {
  const ApproveCommentRequested(this.engagementId);

  final String engagementId;

  @override
  List<Object> get props => [engagementId];
}

final class RejectCommentRequested extends CommunityManagementEvent {
  const RejectCommentRequested(this.engagementId);

  final String engagementId;

  @override
  List<Object> get props => [engagementId];
}

final class ResolveReportRequested extends CommunityManagementEvent {
  const ResolveReportRequested(this.reportId);

  final String reportId;

  @override
  List<Object> get props => [reportId];
}

final class UndoUpdateRequested extends CommunityManagementEvent {
  const UndoUpdateRequested(this.id);

  final String id;

  @override
  List<Object> get props => [id];
}

final class UpdateEventReceived extends CommunityManagementEvent {
  const UpdateEventReceived(this.event);

  final UpdateEvent<dynamic> event;

  @override
  List<Object> get props => [event];
}
