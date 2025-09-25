import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/bloc/app_configuration_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/view/tabs/advertisements_configuration_tab.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/view/tabs/feed_configuration_tab.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/view/tabs/general_configuration_tab.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/about_icon.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template app_configuration_page}
/// A page for managing the application's remote configuration.
///
/// This page allows administrators to view and modify various application
/// settings that affect the live mobile app. Due to the sensitive nature
/// of these settings, changes require explicit confirmation.
/// {@endtemplate}
class AppConfigurationPage extends StatefulWidget {
  /// {@macro app_configuration_page}
  const AppConfigurationPage({super.key});

  @override
  State<AppConfigurationPage> createState() => _AppConfigurationPageState();
}

class _AppConfigurationPageState extends State<AppConfigurationPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    context.read<AppConfigurationBloc>().add(const AppConfigurationLoaded());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.appConfigurationPageTitle,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        actions: [
          AboutIcon(
            dialogTitle: l10n.appConfigurationPageTitle,
            dialogDescription: l10n.appConfigurationPageDescription,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabAlignment: TabAlignment.start,
          isScrollable: true,
          tabs: [
            Tab(text: l10n.generalTab),
            Tab(text: l10n.feedTab),
            Tab(text: l10n.advertisementsTab),
          ],
        ),
      ),
      body: BlocConsumer<AppConfigurationBloc, AppConfigurationState>(
        listener: (context, state) {
          if (state.status == AppConfigurationStatus.success &&
              state.showSaveSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(
                    l10n.appConfigSaveSuccessMessage,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
              );
            // Clear the showSaveSuccess flag after showing the snackbar
            context.read<AppConfigurationBloc>().add(
              const AppConfigurationFieldChanged(),
            );
          } else if (state.status == AppConfigurationStatus.failure &&
              state.exception != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(
                    state.exception!.toFriendlyMessage(context),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onError,
                    ),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
          }
        },
        builder: (context, state) {
          if (state.status == AppConfigurationStatus.loading ||
              state.status == AppConfigurationStatus.initial) {
            return LoadingStateWidget(
              icon: Icons.settings_applications_outlined,
              headline: l10n.loadingConfigurationHeadline,
              subheadline: l10n.loadingConfigurationSubheadline,
            );
          } else if (state.status == AppConfigurationStatus.failure) {
            return FailureStateWidget(
              exception: state.exception!,
              onRetry: () {
                context.read<AppConfigurationBloc>().add(
                  const AppConfigurationLoaded(),
                );
              },
            );
          } else if (state.status == AppConfigurationStatus.success &&
              state.remoteConfig != null) {
            final remoteConfig = state.remoteConfig!;
            return TabBarView(
              controller: _tabController,
              children: [
                GeneralConfigurationTab(
                  remoteConfig: remoteConfig,
                  onConfigChanged: (newConfig) {
                    context.read<AppConfigurationBloc>().add(
                      AppConfigurationFieldChanged(remoteConfig: newConfig),
                    );
                  },
                ),
                FeedConfigurationTab(
                  remoteConfig: remoteConfig,
                  onConfigChanged: (newConfig) {
                    context.read<AppConfigurationBloc>().add(
                      AppConfigurationFieldChanged(remoteConfig: newConfig),
                    );
                  },
                ),
                AdvertisementsConfigurationTab(
                  remoteConfig: remoteConfig,
                  onConfigChanged: (newConfig) {
                    context.read<AppConfigurationBloc>().add(
                      AppConfigurationFieldChanged(remoteConfig: newConfig),
                    );
                  },
                ),
              ],
            );
          }
          return InitialStateWidget(
            icon: Icons.settings_applications_outlined,
            headline: l10n.appConfigurationPageTitle,
            subheadline: l10n.loadAppSettingsSubheadline,
          );
        },
      ),
      bottomNavigationBar: _buildBottomAppBar(context),
    );
  }

  Widget _buildBottomAppBar(BuildContext context) {
    final isDirty = context.select(
      (AppConfigurationBloc bloc) => bloc.state.isDirty,
    );
    final remoteConfig = context.select(
      (AppConfigurationBloc bloc) => bloc.state.remoteConfig,
    );

    return BottomAppBar(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton(
              onPressed: isDirty
                  ? () {
                      // Discard changes: revert to original config
                      context.read<AppConfigurationBloc>().add(
                        const AppConfigurationDiscarded(),
                      );
                    }
                  : null,
              child: Text(AppLocalizationsX(context).l10n.discardChangesButton),
            ),
            const SizedBox(width: AppSpacing.md),
            ElevatedButton(
              onPressed: isDirty
                  ? () async {
                      final confirmed = await _showConfirmationDialog(context);
                      if (context.mounted &&
                          confirmed &&
                          remoteConfig != null) {
                        context.read<AppConfigurationBloc>().add(
                          AppConfigurationUpdated(remoteConfig),
                        );
                      }
                    }
                  : null,
              child: Text(AppLocalizationsX(context).l10n.saveChangesButton),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _showConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: Text(
                AppLocalizationsX(context).l10n.confirmConfigUpdateDialogTitle,
                style: Theme.of(dialogContext).textTheme.titleLarge,
              ),
              content: Text(
                AppLocalizationsX(
                  context,
                ).l10n.confirmConfigUpdateDialogContent,
                style: Theme.of(dialogContext).textTheme.bodyMedium,
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: Text(AppLocalizationsX(context).l10n.cancelButton),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(dialogContext).colorScheme.error,
                    foregroundColor: Theme.of(
                      dialogContext,
                    ).colorScheme.onError,
                  ),
                  child: Text(
                    AppLocalizationsX(context).l10n.confirmSaveButton,
                  ),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}
