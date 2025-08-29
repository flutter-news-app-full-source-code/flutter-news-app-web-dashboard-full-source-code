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

class _FeedDecoratorFormState extends State<FeedDecoratorForm> {
  AppUserRole _selectedUserRole = AppUserRole.guestUser;
  late final TextEditingController _itemsToDisplayController;
  late final Map<AppUserRole, TextEditingController> _roleControllers;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  @override
  void didUpdateWidget(covariant FeedDecoratorForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.remoteConfig.feedDecoratorConfig[widget.decoratorType] !=
        oldWidget.remoteConfig.feedDecoratorConfig[widget.decoratorType]) {
      _updateControllers();
    }
  }

  void _initializeControllers() {
    final decoratorConfig =
        widget.remoteConfig.feedDecoratorConfig[widget.decoratorType]!;
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
        widget.remoteConfig.feedDecoratorConfig[widget.decoratorType]!;
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
    _itemsToDisplayController.dispose();
    for (final controller in _roleControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    final decoratorConfig =
        widget.remoteConfig.feedDecoratorConfig[widget.decoratorType]!;

    return Column(
      children: [
        SwitchListTile(
          title: Text(l10n.enabledLabel),
          value: decoratorConfig.enabled,
          onChanged: (value) {
            final newDecoratorConfig = decoratorConfig.copyWith(enabled: value);
            final newFeedDecoratorConfig =
                Map<FeedDecoratorType, FeedDecoratorConfig>.from(
                  widget.remoteConfig.feedDecoratorConfig,
                )..[widget.decoratorType] = newDecoratorConfig;
            widget.onConfigChanged(
              widget.remoteConfig.copyWith(
                feedDecoratorConfig: newFeedDecoratorConfig,
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
              final newFeedDecoratorConfig =
                  Map<FeedDecoratorType, FeedDecoratorConfig>.from(
                    widget.remoteConfig.feedDecoratorConfig,
                  )..[widget.decoratorType] = newDecoratorConfig;
              widget.onConfigChanged(
                widget.remoteConfig.copyWith(
                  feedDecoratorConfig: newFeedDecoratorConfig,
                ),
              );
            },
            controller: _itemsToDisplayController,
          ),
        const SizedBox(height: AppSpacing.lg),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: SegmentedButton<AppUserRole>(
            style: SegmentedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            segments: AppUserRole.values
                .map(
                  (role) => ButtonSegment<AppUserRole>(
                    value: role,
                    label: Text(role.l10n(context)),
                  ),
                )
                .toList(),
            selected: {_selectedUserRole},
            onSelectionChanged: (newSelection) {
              setState(() {
                _selectedUserRole = newSelection.first;
              });
            },
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        _buildRoleSpecificFields(
          context,
          l10n,
          _selectedUserRole,
          decoratorConfig,
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
    final isLinkAccountForStandardOrPremium =
        widget.decoratorType == FeedDecoratorType.linkAccount &&
        (role == AppUserRole.standardUser || role == AppUserRole.premiumUser);

    return Column(
      children: [
        CheckboxListTile(
          title: Text(l10n.visibleToRoleLabel(role.l10n(context))),
          value: roleConfig != null,
          onChanged: isLinkAccountForStandardOrPremium
              ? null // Disable for standard and premium users for linkAccount
              : (value) {
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
                  final newFeedDecoratorConfig =
                      Map<FeedDecoratorType, FeedDecoratorConfig>.from(
                        widget.remoteConfig.feedDecoratorConfig,
                      )..[widget.decoratorType] = newDecoratorConfig;
                  widget.onConfigChanged(
                    widget.remoteConfig.copyWith(
                      feedDecoratorConfig: newFeedDecoratorConfig,
                    ),
                  );
                },
        ),
        if (roleConfig != null)
          Padding(
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
                final newFeedDecoratorConfig =
                    Map<FeedDecoratorType, FeedDecoratorConfig>.from(
                      widget.remoteConfig.feedDecoratorConfig,
                    )..[widget.decoratorType] = newDecoratorConfig;
                widget.onConfigChanged(
                  widget.remoteConfig.copyWith(
                    feedDecoratorConfig: newFeedDecoratorConfig,
                  ),
                );
              },
              controller: _roleControllers[role],
            ),
          ),
      ],
    );
  }
}
