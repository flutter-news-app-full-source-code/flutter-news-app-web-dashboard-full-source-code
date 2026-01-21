import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/rewards_management/bloc/rewards_filter/rewards_filter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/rewards_management/enums/reward_type_filter.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/constants/app_constants.dart';
import 'package:logging/logging.dart';

part 'rewards_management_event.dart';
part 'rewards_management_state.dart';

/// {@template rewards_management_bloc}
/// A BLoC that manages the state for the rewards management feature.
///
/// This BLoC is responsible for fetching user rewards, handling pagination,
/// and applying filters from the [RewardsFilterBloc].
/// {@endtemplate}
class RewardsManagementBloc
    extends Bloc<RewardsManagementEvent, RewardsManagementState> {
  /// {@macro rewards_management_bloc}
  RewardsManagementBloc({
    required DataRepository<UserRewards> rewardsRepository,
    required RewardsFilterBloc rewardsFilterBloc,
    Logger? logger,
  }) : _rewardsRepository = rewardsRepository,
       _rewardsFilterBloc = rewardsFilterBloc,
       _logger = logger ?? Logger('RewardsManagementBloc'),
       super(const RewardsManagementState()) {
    on<LoadRewardsRequested>(_onLoadRewardsRequested);

    // Listen for changes in the filter BLoC to trigger a data reload.
    _filterSubscription = _rewardsFilterBloc.stream.listen((_) {
      add(
        LoadRewardsRequested(
          limit: AppConstants.kDefaultRowsPerPage,
          forceRefresh: true,
          filter: buildRewardsFilterMap(_rewardsFilterBloc.state),
        ),
      );
    });

    // Listen for external updates to the UserRewards entity to trigger a refresh.
    _rewardsUpdateSubscription = _rewardsRepository.entityUpdated
        .where((type) => type == UserRewards)
        .listen((_) {
          add(
            LoadRewardsRequested(
              limit: AppConstants.kDefaultRowsPerPage,
              forceRefresh: true,
              filter: buildRewardsFilterMap(_rewardsFilterBloc.state),
            ),
          );
        });
  }

  final DataRepository<UserRewards> _rewardsRepository;
  final RewardsFilterBloc _rewardsFilterBloc;
  final Logger _logger;

  late final StreamSubscription<RewardsFilterState> _filterSubscription;
  late final StreamSubscription<Type> _rewardsUpdateSubscription;

  @override
  Future<void> close() {
    _filterSubscription.cancel();
    _rewardsUpdateSubscription.cancel();
    return super.close();
  }

  /// Builds a filter map for rewards from the given filter state.
  Map<String, dynamic> buildRewardsFilterMap(RewardsFilterState state) {
    final filter = <String, dynamic>{};

    if (state.searchQuery.isNotEmpty) {
      filter['userId'] = {r'$regex': state.searchQuery, '': 'i'};
    }

    if (state.rewardTypeFilter != RewardTypeFilter.all) {
      final rewardType = state.rewardTypeFilter.toRewardType();
      if (rewardType != null) {
        // Filter for documents where the specific reward type exists in the map
         filter['activeRewards.${rewardType.name}'] = {r'$exists': true};
      }
    }

    return filter;
  }

  /// Handles the request to load a paginated list of rewards.
  Future<void> _onLoadRewardsRequested(
    LoadRewardsRequested event,
    Emitter<RewardsManagementState> emit,
  ) async {
    if (state.status == RewardsManagementStatus.success &&
        state.rewards.isNotEmpty &&
        event.startAfterId == null &&
        !event.forceRefresh &&
        event.filter == null) {
      return;
    }
    _logger.info('Loading rewards. ForceRefresh: ${event.forceRefresh}');

    emit(state.copyWith(status: RewardsManagementStatus.loading));
    try {
      final isPaginating = event.startAfterId != null;
      final previousRewards = isPaginating ? state.rewards : <UserRewards>[];

      final paginatedRewards = await _rewardsRepository.readAll(
        filter: event.filter ?? buildRewardsFilterMap(_rewardsFilterBloc.state),
        // Sort by ID descending as a proxy for creation time if createdAt is missing
        sort: [const SortOption('_id', SortOrder.desc)],
        pagination: PaginationOptions(
          cursor: event.startAfterId,
          limit: event.limit,
        ),
      );
      emit(
        state.copyWith(
          status: RewardsManagementStatus.success,
          rewards: [...previousRewards, ...paginatedRewards.items],
          cursor: paginatedRewards.cursor,
          hasMore: paginatedRewards.hasMore,
        ),
      );
    } on HttpException catch (e) {
      _logger.severe('HttpException loading rewards', e);

      emit(
        state.copyWith(
          status: RewardsManagementStatus.failure,
          exception: e,
        ),
      );
    } catch (e, s) {
      _logger.severe('Unexpected error loading rewards', e, s);

      emit(
        state.copyWith(
          status: RewardsManagementStatus.failure,
          exception: const UnknownException('An unexpected error occurred: '),
        ),
      );
    }
  }
}
