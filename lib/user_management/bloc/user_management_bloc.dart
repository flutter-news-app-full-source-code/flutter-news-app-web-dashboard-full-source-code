import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/constants/app_constants.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/user_management/bloc/user_filter/user_filter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/user_management/enums/authentication_filter.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/user_management/enums/subscription_filter.dart';
import 'package:logging/logging.dart';
import 'package:ui_kit/ui_kit.dart';

part 'user_management_event.dart';
part 'user_management_state.dart';

/// {@template user_management_bloc}
/// A BLoC that manages the state for the user management feature.
///
/// This BLoC is responsible for fetching users, handling pagination,
/// applying filters from the [UserFilterBloc], and processing user
/// role updates.
/// {@endtemplate}
class UserManagementBloc
    extends Bloc<UserManagementEvent, UserManagementState> {
  /// {@macro user_management_bloc}
  UserManagementBloc({
    required DataRepository<User> usersRepository,
    required UserFilterBloc userFilterBloc,
    Logger? logger,
  }) : _usersRepository = usersRepository,
       _userFilterBloc = userFilterBloc,
       _logger = logger ?? Logger('UserManagementBloc'),
       super(const UserManagementState()) {
    on<LoadUsersRequested>(_onLoadUsersRequested);
    on<UserRoleChanged>(_onUserRoleChanged);
    on<UserAccessTierChanged>(_onUserAccessTierChanged);

    // Listen for changes in the filter BLoC to trigger a data reload.
    _filterSubscription = _userFilterBloc.stream.listen((_) {
      add(
        LoadUsersRequested(
          limit: AppConstants.kDefaultRowsPerPage,
          forceRefresh: true,
          filter: buildUsersFilterMap(_userFilterBloc.state),
        ),
      );
    });

    // Listen for external updates to the User entity to trigger a refresh.
    _userUpdateSubscription = _usersRepository.entityUpdated
        .where((type) => type == User)
        .listen((_) {
          add(
            LoadUsersRequested(
              limit: kDefaultRowsPerPage,
              forceRefresh: true,
              filter: buildUsersFilterMap(_userFilterBloc.state),
            ),
          );
        });
  }

  final DataRepository<User> _usersRepository;
  final UserFilterBloc _userFilterBloc;
  final Logger _logger;

  late final StreamSubscription<UserFilterState> _filterSubscription;
  late final StreamSubscription<Type> _userUpdateSubscription;

  @override
  Future<void> close() {
    _filterSubscription.cancel();
    _userUpdateSubscription.cancel();
    return super.close();
  }

  /// Builds a filter map for users from the given filter state.
  Map<String, dynamic> buildUsersFilterMap(UserFilterState state) {
    final filter = <String, dynamic>{};

    final orConditions = <Map<String, dynamic>>[];

    if (state.searchQuery.isNotEmpty) {
      orConditions
        ..add({
          'email': {r'$regex': state.searchQuery, r'$options': 'i'},
        })
        ..add({'_id': state.searchQuery});
    }

    if (orConditions.isNotEmpty) {
      filter[r'$or'] = orConditions;
    }

    if (state.authenticationFilter != AuthenticationFilter.all) {
      filter['isAnonymous'] =
          state.authenticationFilter == AuthenticationFilter.anonymous;
    }

    if (state.subscriptionFilter != SubscriptionFilter.all) {
      if (state.subscriptionFilter == SubscriptionFilter.premium) {
        filter['tier'] = AccessTier.premium.name;
      } else {
        filter['tier'] = {
          r'$in': [AccessTier.guest.name, AccessTier.standard.name],
        };
      }
    }

    if (state.userRole != null) {
      filter['role'] = state.userRole!.name;
    }

    return filter;
  }

  /// Handles the request to load a paginated list of users.
  Future<void> _onLoadUsersRequested(
    LoadUsersRequested event,
    Emitter<UserManagementState> emit,
  ) async {
    // Avoid re-fetching if data is already loaded and not a pagination or
    // forced refresh request.
    if (state.status == UserManagementStatus.success &&
        state.users.isNotEmpty &&
        event.startAfterId == null &&
        !event.forceRefresh &&
        event.filter == null) {
      return;
    }

    emit(state.copyWith(status: UserManagementStatus.loading));
    try {
      final isPaginating = event.startAfterId != null;
      final previousUsers = isPaginating ? state.users : <User>[];

      final paginatedUsers = await _usersRepository.readAll(
        filter: event.filter ?? buildUsersFilterMap(_userFilterBloc.state),
        sort: [const SortOption('createdAt', SortOrder.desc)],
        pagination: PaginationOptions(
          cursor: event.startAfterId,
          limit: event.limit,
        ),
      );
      emit(
        state.copyWith(
          status: UserManagementStatus.success,
          users: [...previousUsers, ...paginatedUsers.items],
          cursor: paginatedUsers.cursor,
          hasMore: paginatedUsers.hasMore,
        ),
      );
    } on HttpException catch (e) {
      emit(state.copyWith(status: UserManagementStatus.failure, exception: e));
    } catch (e) {
      emit(
        state.copyWith(
          status: UserManagementStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }

  /// Handles the request to change a user's role.
  Future<void> _onUserRoleChanged(
    UserRoleChanged event,
    Emitter<UserManagementState> emit,
  ) async {
    _logger.info(
      'Attempting to change role for user: ${event.userId} '
      'to ${event.role.name}',
    );
    try {
      final userToUpdate = state.users.firstWhere((u) => u.id == event.userId);
      _logger.info('Found user in state: $userToUpdate');

      final updatedItem = userToUpdate.copyWith(
        role: event.role,
      );
      _logger.info('Sending updated user object to repository: $updatedItem');

      await _usersRepository.update(
        id: event.userId,
        item: updatedItem,
      );
    } catch (error, stackTrace) {
      _logger.severe(
        'Error changing user role for ${event.userId}.',
        error,
        stackTrace,
      );
      addError(error, stackTrace);
    }
  }

  /// Handles the request to change a user's access tier.
  Future<void> _onUserAccessTierChanged(
    UserAccessTierChanged event,
    Emitter<UserManagementState> emit,
  ) async {
    _logger.info(
      'Attempting to change access tier for user: ${event.userId} '
      'to ${event.tier.name}',
    );
    try {
      final userToUpdate = state.users.firstWhere((u) => u.id == event.userId);
      _logger.info('Found user in state: $userToUpdate');

      final updatedItem = userToUpdate.copyWith(tier: event.tier);
      _logger.info('Sending updated user object to repository: $updatedItem');

      await _usersRepository.update(
        id: event.userId,
        item: updatedItem,
      );
    } catch (error, stackTrace) {
      _logger.severe(
        'Error changing user access tier for ${event.userId}.',
        error,
        stackTrace,
      );
      addError(error, stackTrace);
    }
  }
}
