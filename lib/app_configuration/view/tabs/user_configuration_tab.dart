import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/saved_filter_limits_form.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/user_limits_config_form.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template user_configuration_tab}
/// A widget representing the "User" tab in the App Configuration page.
///
/// This tab allows configuration of user-specific limits and settings.
/// {@endtemplate}
class UserConfigurationTab extends StatefulWidget {
  /// {@macro user_configuration_tab}
  const UserConfigurationTab({
    required this.remoteConfig,
    required this.onConfigChanged,
    super.key,
  });

  /// The current [RemoteConfig] object.
  final RemoteConfig remoteConfig;

  /// Callback to notify parent of changes to the [RemoteConfig].
  final ValueChanged<RemoteConfig> onConfigChanged;

  @override
  State<UserConfigurationTab> createState() => _UserConfigurationTabState();
}

class _UserConfigurationTabState extends State<UserConfigurationTab> {
  /// Notifier for the index of the currently expanded top-level ExpansionTile.
  ///
  /// A value of `null` means no tile is expanded.
  final ValueNotifier<int?> _expandedTileIndex = ValueNotifier<int?>(null);

  @override
  void dispose() {
    _expandedTileIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        ValueListenableBuilder<int?>(
          valueListenable: _expandedTileIndex,
          builder: (context, expandedIndex, child) {
            const tileIndex = 0;
            return ExpansionTile(
              leading: Icon(
                Icons.manage_accounts_outlined,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(
                  0.7,
                ),
              ),
              key: ValueKey('userLimitsTile_$expandedIndex'),
              title: Text(l10n.userLimitsTitle),
              subtitle: Text(
                l10n.userLimitsDescription,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              onExpansionChanged: (isExpanded) {
                _expandedTileIndex.value = isExpanded ? tileIndex : null;
              },
              initiallyExpanded: expandedIndex == tileIndex,
              childrenPadding: const EdgeInsetsDirectional.only(
                start: AppSpacing.xxl,
                top: AppSpacing.md,
                bottom: AppSpacing.md,
              ),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ExpansionTile(
                  title: Text(l10n.userContentLimitsTitle),
                  subtitle: Text(
                    l10n.userContentLimitsDescription,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  childrenPadding: const EdgeInsetsDirectional.only(
                    start: AppSpacing.lg,
                    top: AppSpacing.md,
                    bottom: AppSpacing.md,
                  ),
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UserLimitsConfigForm(
                      remoteConfig: widget.remoteConfig,
                      onConfigChanged: widget.onConfigChanged,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                SavedFilterLimitsForm(
                  remoteConfig: widget.remoteConfig,
                  onConfigChanged: widget.onConfigChanged,
                  filterType: SavedFilterType.headline,
                ),
                const SizedBox(height: AppSpacing.lg),
                SavedFilterLimitsForm(
                  remoteConfig: widget.remoteConfig,
                  onConfigChanged: widget.onConfigChanged,
                  filterType: SavedFilterType.source,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
