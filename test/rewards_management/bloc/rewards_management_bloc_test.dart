import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/rewards_management/bloc/rewards_filter/rewards_filter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/rewards_management/bloc/rewards_management_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/rewards_management/enums/reward_type_filter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logging/logging.dart';
import 'package:mocktail/mocktail.dart';

class MockDataRepository extends Mock implements DataRepository<UserRewards> {}

class MockRewardsFilterBloc extends Mock implements RewardsFilterBloc {}

class MockLogger extends Mock implements Logger {}

void main() {
  group('RewardsManagementBloc', () {
    late DataRepository<UserRewards> rewardsRepository;
    late RewardsFilterBloc rewardsFilterBloc;
    late Logger logger;

    setUp(() {
      rewardsRepository = MockDataRepository();
      rewardsFilterBloc = MockRewardsFilterBloc();
      logger = MockLogger();

      when(
        () => rewardsFilterBloc.stream,
      ).thenAnswer((_) => const Stream.empty());
      when(
        () => rewardsFilterBloc.state,
      ).thenReturn(const RewardsFilterState());
      when(
        () => rewardsRepository.entityUpdated,
      ).thenAnswer((_) => const Stream.empty());
    });

    test('initial state is correct', () {
      expect(
        RewardsManagementBloc(
          rewardsRepository: rewardsRepository,
          rewardsFilterBloc: rewardsFilterBloc,
          logger: logger,
        ).state,
        const RewardsManagementState(),
      );
    });

    group('LoadRewardsRequested', () {
      final userRewards = [
        const UserRewards(id: '1', userId: '1', activeRewards: {}),
        const UserRewards(id: '2', userId: '2', activeRewards: {}),
      ];
      final paginatedData = PaginatedResponse(
        items: userRewards,
        cursor: 'cursor',
        hasMore: true,
      );

      blocTest<RewardsManagementBloc, RewardsManagementState>(
        'emits [loading, success] when rewards are fetched successfully',
        setUp: () {
          when(
            () => rewardsRepository.readAll(
              filter: any(named: 'filter'),
              sort: any(named: 'sort'),
              pagination: any(named: 'pagination'),
            ),
          ).thenAnswer((_) async => paginatedData);
        },
        build: () => RewardsManagementBloc(
          rewardsRepository: rewardsRepository,
          rewardsFilterBloc: rewardsFilterBloc,
          logger: logger,
        ),
        act: (bloc) => bloc.add(const LoadRewardsRequested()),
        expect: () => <RewardsManagementState>[
          const RewardsManagementState(status: RewardsManagementStatus.loading),
          RewardsManagementState(
            status: RewardsManagementStatus.success,
            rewards: userRewards,
            cursor: 'cursor',
            hasMore: true,
          ),
        ],
        verify: (_) {
          verify(
            () => rewardsRepository.readAll(
              filter: any(named: 'filter'),
              sort: any(named: 'sort'),
              pagination: any(named: 'pagination'),
            ),
          ).called(1);
        },
      );
      blocTest<RewardsManagementBloc, RewardsManagementState>(
        'emits [loading, success] when rewards are fetched successfully with forceRefresh',
        setUp: () {
          when(
            () => rewardsRepository.readAll(
              filter: any(named: 'filter'),
              sort: any(named: 'sort'),
              pagination: any(named: 'pagination'),
            ),
          ).thenAnswer((_) async => paginatedData);
        },
        build: () => RewardsManagementBloc(
          rewardsRepository: rewardsRepository,
          rewardsFilterBloc: rewardsFilterBloc,
          logger: logger,
        ),
        seed: () => const RewardsManagementState(
          status: RewardsManagementStatus.success,
          rewards: [UserRewards(id: 'old', userId: 'old', activeRewards: {})],
        ),
        act: (bloc) => bloc.add(const LoadRewardsRequested(forceRefresh: true)),
        expect: () => <RewardsManagementState>[
          const RewardsManagementState(
            status: RewardsManagementStatus.loading,
            rewards: [UserRewards(id: 'old', userId: 'old', activeRewards: {})],
          ),
          RewardsManagementState(
            status: RewardsManagementStatus.success,
            rewards: userRewards,
            cursor: 'cursor',
            hasMore: true,
          ),
        ],
      );
      blocTest<RewardsManagementBloc, RewardsManagementState>(
        'emits [loading, success] and appends rewards when paginating',
        setUp: () {
          when(
            () => rewardsRepository.readAll(
              filter: any(named: 'filter'),
              sort: any(named: 'sort'),
              pagination: any(named: 'pagination'),
            ),
          ).thenAnswer((_) async => paginatedData);
        },
        build: () => RewardsManagementBloc(
          rewardsRepository: rewardsRepository,
          rewardsFilterBloc: rewardsFilterBloc,
          logger: logger,
        ),
        seed: () => const RewardsManagementState(
          status: RewardsManagementStatus.success,
          rewards: [
            UserRewards(id: 'initial', userId: 'initial', activeRewards: {}),
          ],
          cursor: 'initial_cursor',
          hasMore: true,
        ),
        act: (bloc) => bloc.add(
          const LoadRewardsRequested(startAfterId: 'initial_cursor'),
        ),
        expect: () => <RewardsManagementState>[
          const RewardsManagementState(
            status: RewardsManagementStatus.loading,
            rewards: [
              UserRewards(id: 'initial', userId: 'initial', activeRewards: {}),
            ],
            cursor: 'initial_cursor',
            hasMore: true,
          ),
          RewardsManagementState(
            status: RewardsManagementStatus.success,
            rewards: [
              const UserRewards(
                id: 'initial',
                userId: 'initial',
                activeRewards: {},
              ),
              ...userRewards,
            ],
            cursor: 'cursor',
            hasMore: true,
          ),
        ],
      );
      blocTest<RewardsManagementBloc, RewardsManagementState>(
        'emits [loading, failure] when fetching rewards fails with HttpException',
        setUp: () {
          when(
            () => rewardsRepository.readAll(
              filter: any(named: 'filter'),
              sort: any(named: 'sort'),
              pagination: any(named: 'pagination'),
            ),
          ).thenThrow(const HttpException('Not found'));
        },
        build: () => RewardsManagementBloc(
          rewardsRepository: rewardsRepository,
          rewardsFilterBloc: rewardsFilterBloc,
          logger: logger,
        ),
        act: (bloc) => bloc.add(const LoadRewardsRequested()),
        expect: () => <RewardsManagementState>[
          const RewardsManagementState(status: RewardsManagementStatus.loading),
          const RewardsManagementState(
            status: RewardsManagementStatus.failure,
            exception: HttpException('Not found'),
          ),
        ],
      );
    });

    group('Stream Subscriptions', () {
      final userRewards = [
        const UserRewards(id: '1', userId: '1', activeRewards: {}),
      ];
      final paginatedData = PaginatedResponse(
        items: userRewards,
        cursor: 'cursor',
        hasMore: true,
      );

      test('loads rewards when filter changes', () async {
        final filterController = StreamController<RewardsFilterState>();
        when(
          () => rewardsFilterBloc.stream,
        ).thenAnswer((_) => filterController.stream);
        when(
          () => rewardsRepository.readAll(
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            pagination: any(named: 'pagination'),
          ),
        ).thenAnswer((_) async => paginatedData);

        final bloc = RewardsManagementBloc(
          rewardsRepository: rewardsRepository,
          rewardsFilterBloc: rewardsFilterBloc,
          logger: logger,
        );

        filterController.add(const RewardsFilterState(searchQuery: 'test'));

        await expectLater(
          bloc.stream,
          emitsInOrder([
            isA<RewardsManagementState>().having(
              (s) => s.status,
              'status',
              RewardsManagementStatus.loading,
            ),
            isA<RewardsManagementState>().having(
              (s) => s.status,
              'status',
              RewardsManagementStatus.success,
            ),
          ]),
        );
      });
      test('loads rewards when entity is updated', () async {
        final entityUpdatedController = StreamController<Type>();
        when(
          () => rewardsRepository.entityUpdated,
        ).thenAnswer((_) => entityUpdatedController.stream);
        when(
          () => rewardsRepository.readAll(
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            pagination: any(named: 'pagination'),
          ),
        ).thenAnswer((_) async => paginatedData);

        final bloc = RewardsManagementBloc(
          rewardsRepository: rewardsRepository,
          rewardsFilterBloc: rewardsFilterBloc,
          logger: logger,
        );

        entityUpdatedController.add(UserRewards);

        await expectLater(
          bloc.stream,
          emitsInOrder([
            isA<RewardsManagementState>().having(
              (s) => s.status,
              'status',
              RewardsManagementStatus.loading,
            ),
            isA<RewardsManagementState>().having(
              (s) => s.status,
              'status',
              RewardsManagementStatus.success,
            ),
          ]),
        );
      });
    });

    group('buildRewardsFilterMap', () {
      test('returns correct filter for search query', () {
        final bloc = RewardsManagementBloc(
          rewardsRepository: rewardsRepository,
          rewardsFilterBloc: rewardsFilterBloc,
        );
        const filterState = RewardsFilterState(searchQuery: 'test');
        final filterMap = bloc.buildRewardsFilterMap(filterState);
        expect(filterMap, {
          'userId': {r'$regex': 'test', '': 'i'},
        });
      });

      test('returns correct filter for reward type', () {
        final bloc = RewardsManagementBloc(
          rewardsRepository: rewardsRepository,
          rewardsFilterBloc: rewardsFilterBloc,
        );
        const filterState = RewardsFilterState(
          rewardTypeFilter: RewardTypeFilter.adFree,
        );
        final filterMap = bloc.buildRewardsFilterMap(filterState);
        expect(filterMap, {
          'activeRewards.adFree': {r'$exists': true},
        });
      });

      test('returns empty map for default filters', () {
        final bloc = RewardsManagementBloc(
          rewardsRepository: rewardsRepository,
          rewardsFilterBloc: rewardsFilterBloc,
        );
        const filterState = RewardsFilterState();
        final filterMap = bloc.buildRewardsFilterMap(filterState);
        expect(filterMap, <String, dynamic>{});
      });
    });
  });
}
