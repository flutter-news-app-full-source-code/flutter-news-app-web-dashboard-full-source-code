import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/local_ads_management/bloc/filter_local_ads/filter_local_ads_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/local_ads_management/widgets/local_ads_filter_dialog/bloc/local_ads_filter_dialog_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/ad_type_l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/content_status_l10n.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template local_ads_filter_dialog}
/// A full-screen dialog for applying filters to local ads lists.
///
/// This dialog provides a search text field and filter chips for content status
/// and ad type.
/// {@endtemplate}
class LocalAdsFilterDialog extends StatefulWidget {
  /// {@macro local_ads_filter_dialog}
  const LocalAdsFilterDialog({
    required this.filterLocalAdsBloc,
    super.key,
  });

  /// The [FilterLocalAdsBloc] instance to interact with.
  final FilterLocalAdsBloc filterLocalAdsBloc;

  @override
  State<LocalAdsFilterDialog> createState() => _LocalAdsFilterDialogState();
}

class _LocalAdsFilterDialogState extends State<LocalAdsFilterDialog> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    // Initialize the LocalAdsFilterDialogBloc with current filter states.
    context.read<LocalAdsFilterDialogBloc>().add(
      LocalAdsFilterDialogInitialized(
        filterLocalAdsState: widget.filterLocalAdsBloc.state,
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    final theme = Theme.of(context);

    return BlocBuilder<LocalAdsFilterDialogBloc, LocalAdsFilterDialogState>(
      builder: (context, filterDialogState) {
        _searchController.text = filterDialogState.searchQuery;
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.filterLocalAds),
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: l10n.resetFiltersButtonText,
                onPressed: () {
                  // Dispatch reset event
                  context.read<LocalAdsFilterDialogBloc>().add(
                    const LocalAdsFilterDialogReset(),
                  );
                  // After reset, get the new state and apply filters
                  const resetState = FilterLocalAdsState();
                  widget.filterLocalAdsBloc.add(
                    FilterLocalAdsApplied(
                      searchQuery: resetState.searchQuery,
                      selectedStatus: resetState.selectedStatus,
                      selectedAdType: resetState.selectedAdType,
                    ),
                  );
                  Navigator.of(context).pop();
                },
              ),
              IconButton(
                icon: const Icon(Icons.check),
                tooltip: l10n.applyFilters,
                onPressed: () {
                  widget.filterLocalAdsBloc.add(
                    FilterLocalAdsApplied(
                      searchQuery: filterDialogState.searchQuery,
                      selectedStatus: filterDialogState.selectedStatus,
                      selectedAdType: filterDialogState.selectedAdType,
                    ),
                  );
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: l10n.search,
                      hintText: l10n.searchByAdTitleOrUrl,
                      prefixIcon: const Icon(Icons.search),
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (query) {
                      context.read<LocalAdsFilterDialogBloc>().add(
                        LocalAdsFilterDialogSearchQueryChanged(query),
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    l10n.status,
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _buildStatusFilterChips(l10n, theme, filterDialogState),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    l10n.adType,
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _buildAdTypeFilterChips(l10n, theme, filterDialogState),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Builds the status filter chips.
  Widget _buildStatusFilterChips(
    AppLocalizations l10n,
    ThemeData theme,
    LocalAdsFilterDialogState filterDialogState,
  ) {
    return Wrap(
      spacing: AppSpacing.sm,
      children: ContentStatus.values.map((status) {
        return ChoiceChip(
          label: Text(status.l10n(context)),
          selected: filterDialogState.selectedStatus == status,
          onSelected: (isSelected) {
            if (isSelected) {
              context.read<LocalAdsFilterDialogBloc>().add(
                LocalAdsFilterDialogStatusChanged(status),
              );
            }
          },
          selectedColor: theme.colorScheme.primaryContainer,
          labelStyle: TextStyle(
            color: filterDialogState.selectedStatus == status
                ? theme.colorScheme.onPrimaryContainer
                : theme.colorScheme.onSurface,
          ),
        );
      }).toList(),
    );
  }

  /// Builds the ad type filter chips.
  Widget _buildAdTypeFilterChips(
    AppLocalizations l10n,
    ThemeData theme,
    LocalAdsFilterDialogState filterDialogState,
  ) {
    return Wrap(
      spacing: AppSpacing.sm,
      children: AdType.values.map((adType) {
        return ChoiceChip(
          avatar: Icon(_getAdTypeIcon(adType)),
          label: Text(adType.l10n(context)),
          selected: filterDialogState.selectedAdType == adType,
          onSelected: (isSelected) {
            if (isSelected) {
              context.read<LocalAdsFilterDialogBloc>().add(
                LocalAdsFilterDialogAdTypeChanged(adType),
              );
            }
          },
          selectedColor: theme.colorScheme.primaryContainer,
          labelStyle: TextStyle(
            color: filterDialogState.selectedAdType == adType
                ? theme.colorScheme.onPrimaryContainer
                : theme.colorScheme.onSurface,
          ),
        );
      }).toList(),
    );
  }

  /// Returns the appropriate icon for a given AdType.
  IconData _getAdTypeIcon(AdType adType) {
    switch (adType) {
      case AdType.native:
        return Icons.article;
      case AdType.banner:
        return Icons.view_carousel;
      case AdType.interstitial:
        return Icons.fullscreen;
      case AdType.video:
        return Icons.videocam;
    }
  }
}
