import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/constants/app_constants.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/subscriptions/bloc/subscriptions_event.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/subscriptions/bloc/subscriptions_filter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/subscriptions/bloc/subscriptions_filter_state.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/subscriptions/bloc/subscriptions_state.dart';
import 'package:logging/logging.dart';

class SubscriptionsBloc extends Bloc<SubscriptionsEvent, SubscriptionsState> {
  SubscriptionsBloc({
    required DataRepository<UserSubscription> subscriptionsRepository,
    required SubscriptionsFilterBloc subscriptionsFilterBloc,
    Logger? logger,
  }) : _subscriptionsRepository = subscriptionsRepository,
       _subscriptionsFilterBloc = subscriptionsFilterBloc,
       _logger = logger ?? Logger('SubscriptionsBloc'),
       super(const SubscriptionsState()) {
    on<LoadSubscriptionsRequested>(_onLoadSubscriptionsRequested);

    _filterSubscription = _subscriptionsFilterBloc.stream.listen((_) {
      add(
        LoadSubscriptionsRequested(
          limit: AppConstants.kDefaultRowsPerPage,
          forceRefresh: true,
          filter: buildFilterMap(_subscriptionsFilterBloc.state),
        ),
      );
    });
  }

  final DataRepository<UserSubscription> _subscriptionsRepository;
  final SubscriptionsFilterBloc _subscriptionsFilterBloc;
  final Logger _logger;
  late final StreamSubscription<SubscriptionsFilterState> _filterSubscription;

  @override
  Future<void> close() {
    _filterSubscription.cancel();
    return super.close();
  }

  Map<String, dynamic> buildFilterMap(SubscriptionsFilterState state) {
    final filter = <String, dynamic>{};

    if (state.searchQuery.isNotEmpty) {
      // Assuming we can search by userId or subscriptionId
      filter[r'$or'] = [
        {'userId': state.searchQuery},
        {'_id': state.searchQuery},
      ];
    }

    if (state.status != null) {
      filter['status'] = state.status!.name;
    }

    if (state.provider != null) {
      filter['provider'] = state.provider!.name;
    }

    return filter;
  }

  Future<void> _onLoadSubscriptionsRequested(
    LoadSubscriptionsRequested event,
    Emitter<SubscriptionsState> emit,
  ) async {
    if (state.status == SubscriptionsStatus.success &&
        state.subscriptions.isNotEmpty &&
        event.startAfterId == null &&
        !event.forceRefresh &&
        event.filter == null) {
      return;
    }

    emit(state.copyWith(status: SubscriptionsStatus.loading));

    try {
      final isPaginating = event.startAfterId != null;
      final previousItems = isPaginating
          ? state.subscriptions
          : <UserSubscription>[];

      final paginatedResponse = await _subscriptionsRepository.readAll(
        filter: event.filter ?? buildFilterMap(_subscriptionsFilterBloc.state),
        sort: [const SortOption('validUntil', SortOrder.desc)],
        pagination: PaginationOptions(
          cursor: event.startAfterId,
          limit: event.limit,
        ),
      );

      emit(
        state.copyWith(
          status: SubscriptionsStatus.success,
          subscriptions: [...previousItems, ...paginatedResponse.items],
          cursor: paginatedResponse.cursor,
          hasMore: paginatedResponse.hasMore,
        ),
      );
    } on HttpException catch (e) {
      emit(state.copyWith(status: SubscriptionsStatus.failure, exception: e));
    } catch (e) {
      _logger.severe('Unexpected error loading subscriptions', e);
      emit(
        state.copyWith(
          status: SubscriptionsStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }
}
