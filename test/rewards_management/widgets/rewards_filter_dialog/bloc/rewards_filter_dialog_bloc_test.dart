// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/rewards_management/bloc/rewards_filter/rewards_filter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/rewards_management/enums/reward_type_filter.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/rewards_management/widgets/rewards_filter_dialog/bloc/rewards_filter_dialog_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RewardsFilterDialogBloc', () {
    test('initial state is correct', () {
      expect(
        RewardsFilterDialogBloc().state,
        const RewardsFilterDialogState(),
      );
    });

    group('RewardsFilterDialogInitialized', () {
      blocTest<RewardsFilterDialogBloc, RewardsFilterDialogState>(
        'emits state with updated filters',
        build: RewardsFilterDialogBloc.new,
        act: (bloc) => bloc.add(
          RewardsFilterDialogInitialized(
            rewardsFilterState: RewardsFilterState(
              searchQuery: 'test',
              rewardTypeFilter: RewardTypeFilter.adFree,
            ),
          ),
        ),
        expect: () => <RewardsFilterDialogState>[
          RewardsFilterDialogState(
            searchQuery: 'test',
            rewardTypeFilter: RewardTypeFilter.adFree,
          ),
        ],
      );
    });

    group('RewardsFilterDialogSearchQueryChanged', () {
      blocTest<RewardsFilterDialogBloc, RewardsFilterDialogState>(
        'emits state with updated search query',
        build: RewardsFilterDialogBloc.new,
        act: (bloc) => bloc.add(
          RewardsFilterDialogSearchQueryChanged('test'),
        ),
        expect: () => <RewardsFilterDialogState>[
          RewardsFilterDialogState(searchQuery: 'test'),
        ],
      );
    });

    group('RewardsFilterDialogRewardTypeChanged', () {
      blocTest<RewardsFilterDialogBloc, RewardsFilterDialogState>(
        'emits state with updated reward type filter',
        build: RewardsFilterDialogBloc.new,
        act: (bloc) => bloc.add(
          RewardsFilterDialogRewardTypeChanged(RewardTypeFilter.adFree),
        ),
        expect: () => <RewardsFilterDialogState>[
          RewardsFilterDialogState(rewardTypeFilter: RewardTypeFilter.adFree),
        ],
      );
    });

    group('RewardsFilterDialogReset', () {
      blocTest<RewardsFilterDialogBloc, RewardsFilterDialogState>(
        'emits initial state',
        build: RewardsFilterDialogBloc.new,
        seed: () => RewardsFilterDialogState(
          searchQuery: 'test',
          rewardTypeFilter: RewardTypeFilter.adFree,
        ),
        act: (bloc) => bloc.add(RewardsFilterDialogReset()),
        expect: () => <RewardsFilterDialogState>[
          RewardsFilterDialogState(),
        ],
      );
    });
  });
}
