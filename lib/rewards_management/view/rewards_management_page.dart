import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/rewards_management/bloc/rewards_filter/rewards_filter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/rewards_management/bloc/rewards_management_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/rewards_management/view/rewards_page.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/router/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template rewards_management_page}
/// The top-level page for the Rewards Management feature.
///
/// This page sets up the necessary BLoC providers ([RewardsManagementBloc],
/// [RewardsFilterBloc]) and displays the main [RewardsPage] within a scaffold.
/// It also handles navigation to the filter dialog.
/// {@endtemplate}
class RewardsManagementPage extends StatelessWidget {
  /// {@macro rewards_management_page}
  const RewardsManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RewardsFilterBloc(),
        ),
        BlocProvider(
          create: (context) => RewardsManagementBloc(
            rewardsRepository: context.read<DataRepository<UserRewards>>(),
            rewardsFilterBloc: context.read<RewardsFilterBloc>(),
          ),
        ),
      ],
      child: const _RewardsManagementView(),
    );
  }
}

class _RewardsManagementView extends StatelessWidget {
  const _RewardsManagementView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.rewardsManagement),
        actions: [
          // Filter Button
          BlocBuilder<RewardsFilterBloc, RewardsFilterState>(
            builder: (context, state) {
              return IconButton(
                icon: const Icon(Icons.filter_list),
                tooltip: l10n.filterRewards,
                onPressed: () {
                  context.goNamed(
                    Routes.rewardsFilterDialogName,
                    extra: {'rewardsFilterState': state},
                  );
                },
              );
            },
          ),
          const SizedBox(width: AppSpacing.md),
          // Info Button
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: l10n.aboutIconTooltip,
            onPressed: () {
              showDialog<void>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(l10n.rewardsManagement),
                    content: Text(l10n.rewardsManagementPageDescription),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(l10n.closeButtonText),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          const SizedBox(width: AppSpacing.md),
        ],
      ),
      body: const RewardsPage(),
    );
  }
}
