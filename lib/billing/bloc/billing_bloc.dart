import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/billing/bloc/billing_event.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/billing/bloc/billing_filter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/billing/bloc/billing_filter_state.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/billing/bloc/billing_state.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/constants/app_constants.dart';
import 'package:logging/logging.dart';

class BillingBloc extends Bloc<BillingEvent, BillingState> {
  BillingBloc({
    required DataRepository<UserSubscription> subscriptionsRepository,
    required BillingFilterBloc billingFilterBloc,
    Logger? logger,
  }) : _subscriptionsRepository = subscriptionsRepository,
       _billingFilterBloc = billingFilterBloc,
       _logger = logger ?? Logger('BillingBloc'),
       super(const BillingState()) {
    on<LoadSubscriptionsRequested>(_onLoadSubscriptionsRequested);

    _filterSubscription = _billingFilterBloc.stream.listen((_) {
      add(
        LoadSubscriptionsRequested(
          limit: AppConstants.kDefaultRowsPerPage,
          forceRefresh: true,
          filter: buildFilterMap(_billingFilterBloc.state),
        ),
      );
    });
  }

  final DataRepository<UserSubscription> _subscriptionsRepository;
  final BillingFilterBloc _billingFilterBloc;
  final Logger _logger;
  late final StreamSubscription<BillingFilterState> _filterSubscription;

  @override
  Future<void> close() {
    _filterSubscription.cancel();
    return super.close();
  }

  Map<String, dynamic> buildFilterMap(BillingFilterState state) {
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
    Emitter<BillingState> emit,
  ) async {
    if (state.status == BillingStatus.success &&
        state.subscriptions.isNotEmpty &&
        event.startAfterId == null &&
        !event.forceRefresh &&
        event.filter == null) {
      return;
    }

    emit(state.copyWith(status: BillingStatus.loading));

    try {
      final isPaginating = event.startAfterId != null;
      final previousItems = isPaginating
          ? state.subscriptions
          : <UserSubscription>[];

      final paginatedResponse = await _subscriptionsRepository.readAll(
        filter: event.filter ?? buildFilterMap(_billingFilterBloc.state),
        sort: [const SortOption('validUntil', SortOrder.desc)],
        pagination: PaginationOptions(
          cursor: event.startAfterId,
          limit: event.limit,
        ),
      );

      emit(
        state.copyWith(
          status: BillingStatus.success,
          subscriptions: [...previousItems, ...paginatedResponse.items],
          cursor: paginatedResponse.cursor,
          hasMore: paginatedResponse.hasMore,
        ),
      );
    } on HttpException catch (e) {
      emit(state.copyWith(status: BillingStatus.failure, exception: e));
    } catch (e) {
      _logger.severe('Unexpected error loading subscriptions', e);
      emit(
        state.copyWith(
          status: BillingStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }
}
