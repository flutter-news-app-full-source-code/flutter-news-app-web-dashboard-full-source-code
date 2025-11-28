import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/app_config_form_fields.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/app_user_role_l10n.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template feed_decorator_form}
/// A form widget for configuring a single feed decorator's settings.
/// {@endtemplate}
class FeedDecoratorForm extends StatefulWidget {
  /// {@macro feed_decorator_form}
  const FeedDecoratorForm({
    required this.decoratorType,
    required this.remoteConfig,
    required this.onConfigChanged,
    super.key,
  });

  /// The specific type of decorator this form is configuring.
  final FeedDecoratorType decoratorType;

  /// The current [RemoteConfig] object.
  final RemoteConfig remoteConfig;

  /// Callback to notify parent of changes to the [RemoteConfig].
  final ValueChanged<RemoteConfig> onConfigChanged;

  @override
  State<FeedDecoratorForm> createState() => _FeedDecoratorFormState();
}

class _FeedDecoratorFormState extends State<FeedDecoratorForm>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late final TextEditingController _itemsToDisplayController;
  late final Map<AppUserRole, TextEditingController> _roleControllers;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: AppUserRole.values.length,
      vsync: this,
    );
    _initializeControllers();
  }

  @override
  void didUpdateWidget(covariant FeedDecoratorForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.remoteConfig.features.feed.decorators[widget.decoratorType] !=
        oldWidget.remoteConfig.features.feed.decorators[widget.decoratorType]) {
      _updateControllers();
    }
  }

  void _initializeControllers() {
    final decoratorConfig =
        widget.remoteConfig.features.feed.decorators[widget.decoratorType]!;
    _itemsToDisplayController =
        TextEditingController(
            text: decoratorConfig.itemsToDisplay?.toString() ?? '',
          )
          ..selection = TextSelection.collapsed(
            offset: decoratorConfig.itemsToDisplay?.toString().length ?? 0,
          );

    _roleControllers = {
      for (final role in AppUserRole.values)
        role:
            TextEditingController(
                text:
                    decoratorConfig.visibleTo[role]?.daysBetweenViews
                        .toString() ??
                    '',
              )
              ..selection = TextSelection.collapsed(
                offset:
                    decoratorConfig.visibleTo[role]?.daysBetweenViews
                        .toString()
                        .length ??
                    0,
              ),
    };
  }

  void _updateControllers() {
    final decoratorConfig =
        widget.remoteConfig.features.feed.decorators[widget.decoratorType]!;
    final newItemsToDisplay = decoratorConfig.itemsToDisplay?.toString() ?? '';
    if (_itemsToDisplayController.text != newItemsToDisplay) {
      _itemsToDisplayController.text = newItemsToDisplay;
      _itemsToDisplayController.selection = TextSelection.collapsed(
        offset: newItemsToDisplay.length,
      );
    }

    for (final role in AppUserRole.values) {
      final newDaysBetweenViews =
          decoratorConfig.visibleTo[role]?.daysBetweenViews.toString() ?? '';
      if (_roleControllers[role]?.text != newDaysBetweenViews) {
        _roleControllers[role]?.text = newDaysBetweenViews;
        _roleControllers[role]?.selection = TextSelection.collapsed(
          offset: newDaysBetweenViews.length,
        );
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _itemsToDisplayController.dispose();
    for (final controller in _roleControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  /// Determines if a given decorator type is logically applicable to a user role.
  ///
  /// This method centralizes the business logic for decorator visibility
  /// to prevent illogical configurations in the dashboard.
  bool _isDecoratorApplicableToRole(
    FeedDecoratorType decoratorType,
    AppUserRole role,
  ) {
    switch (decoratorType) {
      // The 'linkAccount' decorator is only for guest users.
      case FeedDecoratorType.linkAccount:
        return role == AppUserRole.guestUser;
      // The 'upgrade' decorator is only for standard users.
      case FeedDecoratorType.upgrade:
        return role == AppUserRole.standardUser;
      // All other decorators are applicable to any user role.
      case FeedDecoratorType.rateApp:
      case FeedDecoratorType.enableNotifications:
      case FeedDecoratorType.suggestedTopics:
      case FeedDecoratorType.suggestedSources:
        return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    final features = widget.remoteConfig.features;
    final feed = features.feed;
    final decorators = feed.decorators;
    final decoratorConfig = decorators[widget.decoratorType]!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          title: Text(l10n.enabledLabel),
          value: decoratorConfig.enabled,
          onChanged: (value) {
            final newDecoratorConfig = decoratorConfig.copyWith(enabled: value);
            final newDecorators =
                Map<FeedDecoratorType, FeedDecoratorConfig>.from(
                  decorators,
                )..[widget.decoratorType] = newDecoratorConfig;
            widget.onConfigChanged(
              widget.remoteConfig.copyWith(
                features: features.copyWith(
                  feed: feed.copyWith(decorators: newDecorators),
                ),
              ),
            );
          },
        ),
        if (decoratorConfig.category == FeedDecoratorCategory.contentCollection)
          AppConfigIntField(
            label: l10n.itemsToDisplayLabel,
            description: l10n.itemsToDisplayDescription,
            value: decoratorConfig.itemsToDisplay ?? 0,
            onChanged: (value) {
              final newDecoratorConfig = decoratorConfig.copyWith(
                itemsToDisplay: value,
              );
              final newDecorators =
                  Map<FeedDecoratorType, FeedDecoratorConfig>.from(
                    decorators,
                  )..[widget.decoratorType] = newDecoratorConfig;
              widget.onConfigChanged(
                widget.remoteConfig.copyWith(
                  features: features.copyWith(
                    feed: feed.copyWith(decorators: newDecorators),
                  ),
                ),
              );
            },
            controller: _itemsToDisplayController,
          ),
        const SizedBox(height: AppSpacing.lg),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: SizedBox(
            height: kTextTabBarHeight,
            child: TabBar(
              controller: _tabController,
              tabAlignment: TabAlignment.start,
              isScrollable: true,
              tabs: AppUserRole.values
                  .map((role) => Tab(text: role.l10n(context)))
                  .toList(),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        // TabBarView to display role-specific fields
        SizedBox(
          height: 250,
          child: TabBarView(
            controller: _tabController,
            children: AppUserRole.values
                .map(
                  (role) => _buildRoleSpecificFields(
                    context,
                    l10n,
                    role,
                    decoratorConfig,
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildRoleSpecificFields(
    BuildContext context,
    AppLocalizations l10n,
    AppUserRole role,
    FeedDecoratorConfig decoratorConfig,
  ) {
    final roleConfig = decoratorConfig.visibleTo[role];
    final isApplicable = _isDecoratorApplicableToRole(
      widget.decoratorType,
      role,
    );

    return Column(
      children: [
        CheckboxListTile(
          title: Text(l10n.visibleToRoleLabel(role.l10n(context))),
          value: roleConfig != null && isApplicable,
          // Disable the checkbox if the decorator is not applicable to the role.
          onChanged: isApplicable
              ? (value) {
                  final newVisibleTo =
                      Map<AppUserRole, FeedDecoratorRoleConfig>.from(
                        decoratorConfig.visibleTo,
                      );
                  if (value ?? false) {
                    newVisibleTo[role] = const FeedDecoratorRoleConfig(
                      daysBetweenViews: 7,
                    );
                  } else {
                    newVisibleTo.remove(role);
                  }
                  final newDecoratorConfig = decoratorConfig.copyWith(
                    visibleTo: newVisibleTo,
                  );
                  final newDecorators =
                      Map<FeedDecoratorType, FeedDecoratorConfig>.from(
                        widget.remoteConfig.features.feed.decorators,
                      )..[widget.decoratorType] = newDecoratorConfig;
                  widget.onConfigChanged(
                    widget.remoteConfig.copyWith(
                      features: widget.remoteConfig.features.copyWith(
                        feed: widget.remoteConfig.features.feed.copyWith(
                          decorators: newDecorators,
                        ),
                      ),
                    ),
                  );
                }
              : null,
        ),
        if (roleConfig != null)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              child: AppConfigIntField(
                label: l10n.daysBetweenViewsLabel,
                description: l10n.daysBetweenViewsDescription,
                value: roleConfig.daysBetweenViews,
                onChanged: (value) {
                  final newRoleConfig = roleConfig.copyWith(
                    daysBetweenViews: value,
                  );
                  final newVisibleTo =
                      Map<AppUserRole, FeedDecoratorRoleConfig>.from(
                        decoratorConfig.visibleTo,
                      )..[role] = newRoleConfig;
                  final newDecoratorConfig = decoratorConfig.copyWith(
                    visibleTo: newVisibleTo,
                  );
                  final newDecorators =
                      Map<FeedDecoratorType, FeedDecoratorConfig>.from(
                        widget.remoteConfig.features.feed.decorators,
                      )..[widget.decoratorType] = newDecoratorConfig;
                  widget.onConfigChanged(
                    widget.remoteConfig.copyWith(
                      features: widget.remoteConfig.features.copyWith(
                        feed: widget.remoteConfig.features.feed.copyWith(
                          decorators: newDecorators,
                        ),
                      ),
                    ),
                  );
                },
                controller: _roleControllers[role],
              ),
            ),
          ),
      ],
    );
  }
}
