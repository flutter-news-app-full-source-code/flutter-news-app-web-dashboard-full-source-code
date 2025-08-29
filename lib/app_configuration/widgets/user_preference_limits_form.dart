import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/widgets/app_config_form_fields.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/app_user_role_l10n.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template user_preference_limits_form}
/// A form widget for configuring user content preference limits based on role.
///
/// This widget uses a [SegmentedButton] to allow selection of an [AppUserRole]
/// and then conditionally renders the relevant input fields for that role.
/// {@endtemplate}
class UserPreferenceLimitsForm extends StatefulWidget {
  /// {@macro user_preference_limits_form}
  const UserPreferenceLimitsForm({
    required this.remoteConfig,
    required this.onConfigChanged,
    super.key,
  });

  /// The current [RemoteConfig] object.
  final RemoteConfig remoteConfig;

  /// Callback to notify parent of changes to the [RemoteConfig].
  final ValueChanged<RemoteConfig> onConfigChanged;

  @override
  State<UserPreferenceLimitsForm> createState() =>
      _UserPreferenceLimitsFormState();
}

class _UserPreferenceLimitsFormState extends State<UserPreferenceLimitsForm> {
  AppUserRole _selectedUserRole = AppUserRole.guestUser;
  late final Map<AppUserRole, TextEditingController>
  _followedItemsLimitControllers;
  late final Map<AppUserRole, TextEditingController>
  _savedHeadlinesLimitControllers;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  @override
  void didUpdateWidget(covariant UserPreferenceLimitsForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.remoteConfig.userPreferenceConfig !=
        oldWidget.remoteConfig.userPreferenceConfig) {
      _updateControllers();
    }
  }

  void _initializeControllers() {
    _followedItemsLimitControllers = {
      for (final role in AppUserRole.values)
        role:
            TextEditingController(
                text: _getFollowedItemsLimit(
                  widget.remoteConfig.userPreferenceConfig,
                  role,
                ).toString(),
              )
              ..selection = TextSelection.collapsed(
                offset: _getFollowedItemsLimit(
                  widget.remoteConfig.userPreferenceConfig,
                  role,
                ).toString().length,
              ),
    };
    _savedHeadlinesLimitControllers = {
      for (final role in AppUserRole.values)
        role:
            TextEditingController(
                text: _getSavedHeadlinesLimit(
                  widget.remoteConfig.userPreferenceConfig,
                  role,
                ).toString(),
              )
              ..selection = TextSelection.collapsed(
                offset: _getSavedHeadlinesLimit(
                  widget.remoteConfig.userPreferenceConfig,
                  role,
                ).toString().length,
              ),
    };
  }

  void _updateControllers() {
    for (final role in AppUserRole.values) {
      final newFollowedItemsLimit = _getFollowedItemsLimit(
        widget.remoteConfig.userPreferenceConfig,
        role,
      ).toString();
      if (_followedItemsLimitControllers[role]?.text !=
          newFollowedItemsLimit) {
        _followedItemsLimitControllers[role]?.text = newFollowedItemsLimit;
        _followedItemsLimitControllers[role]?.selection =
            TextSelection.collapsed(
          offset: newFollowedItemsLimit.length,
        );
      }

      final newSavedHeadlinesLimit = _getSavedHeadlinesLimit(
        widget.remoteConfig.userPreferenceConfig,
        role,
      ).toString();
      if (_savedHeadlinesLimitControllers[role]?.text !=
          newSavedHeadlinesLimit) {
        _savedHeadlinesLimitControllers[role]?.text = newSavedHeadlinesLimit;
        _savedHeadlinesLimitControllers[role]?.selection =
            TextSelection.collapsed(
          offset: newSavedHeadlinesLimit.length,
        );
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _followedItemsLimitControllers.values) {
      controller.dispose();
    }
    for (final controller in _savedHeadlinesLimitControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userPreferenceConfig = widget.remoteConfig.userPreferenceConfig;
    final l10n = AppLocalizationsX(context).l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.userContentLimitsDescription,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
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
        // Conditionally render fields based on selected user role
        if (_selectedUserRole == AppUserRole.guestUser)
          _buildRoleSpecificFields(
            context,
            l10n,
            AppUserRole.guestUser,
            userPreferenceConfig,
          ),
        if (_selectedUserRole == AppUserRole.standardUser)
          _buildRoleSpecificFields(
            context,
            l10n,
            AppUserRole.standardUser,
            userPreferenceConfig,
          ),
        if (_selectedUserRole == AppUserRole.premiumUser)
          _buildRoleSpecificFields(
            context,
            l10n,
            AppUserRole.premiumUser,
            userPreferenceConfig,
          ),
      ],
    );
  }

  Widget _buildRoleSpecificFields(
    BuildContext context,
    AppLocalizations l10n,
    AppUserRole role,
    UserPreferenceConfig config,
  ) {
    return Column(
      children: [
        AppConfigIntField(
          label: _getFollowedItemsLimitLabel(l10n, role),
          description: _getFollowedItemsLimitDescription(l10n, role),
          value: _getFollowedItemsLimit(config, role),
          onChanged: (value) {
            widget.onConfigChanged(
              widget.remoteConfig.copyWith(
                userPreferenceConfig: _updateFollowedItemsLimit(
                  config,
                  value,
                  role,
                ),
              ),
            );
          },
          controller: _followedItemsLimitControllers[role],
        ),
        AppConfigIntField(
          label: _getSavedHeadlinesLimitLabel(l10n, role),
          description: _getSavedHeadlinesLimitDescription(l10n, role),
          value: _getSavedHeadlinesLimit(config, role),
          onChanged: (value) {
            widget.onConfigChanged(
              widget.remoteConfig.copyWith(
                userPreferenceConfig: _updateSavedHeadlinesLimit(
                  config,
                  value,
                  role,
                ),
              ),
            );
          },
          controller: _savedHeadlinesLimitControllers[role],
        ),
      ],
    );
  }

  String _getFollowedItemsLimitLabel(AppLocalizations l10n, AppUserRole role) {
    switch (role) {
      case AppUserRole.guestUser:
        return l10n.guestFollowedItemsLimitLabel;
      case AppUserRole.standardUser:
        return l10n.standardUserFollowedItemsLimitLabel;
      case AppUserRole.premiumUser:
        return l10n.premiumFollowedItemsLimitLabel;
    }
  }

  String _getFollowedItemsLimitDescription(
    AppLocalizations l10n,
    AppUserRole role,
  ) {
    switch (role) {
      case AppUserRole.guestUser:
        return l10n.guestFollowedItemsLimitDescription;
      case AppUserRole.standardUser:
        return l10n.standardUserFollowedItemsLimitDescription;
      case AppUserRole.premiumUser:
        return l10n.premiumFollowedItemsLimitDescription;
    }
  }

  String _getSavedHeadlinesLimitLabel(AppLocalizations l10n, AppUserRole role) {
    switch (role) {
      case AppUserRole.guestUser:
        return l10n.guestSavedHeadlinesLimitLabel;
      case AppUserRole.standardUser:
        return l10n.standardUserSavedHeadlinesLimitLabel;
      case AppUserRole.premiumUser:
        return l10n.premiumSavedHeadlinesLimitLabel;
    }
  }

  String _getSavedHeadlinesLimitDescription(
    AppLocalizations l10n,
    AppUserRole role,
  ) {
    switch (role) {
      case AppUserRole.guestUser:
        return l10n.guestSavedHeadlinesLimitDescription;
      case AppUserRole.standardUser:
        return l10n.standardUserSavedHeadlinesLimitDescription;
      case AppUserRole.premiumUser:
        return l10n.premiumSavedHeadlinesLimitDescription;
    }
  }

  int _getFollowedItemsLimit(UserPreferenceConfig config, AppUserRole role) {
    switch (role) {
      case AppUserRole.guestUser:
        return config.guestFollowedItemsLimit;
      case AppUserRole.standardUser:
        return config.authenticatedFollowedItemsLimit;
      case AppUserRole.premiumUser:
        return config.premiumFollowedItemsLimit;
    }
  }

  int _getSavedHeadlinesLimit(UserPreferenceConfig config, AppUserRole role) {
    switch (role) {
      case AppUserRole.guestUser:
        return config.guestSavedHeadlinesLimit;
      case AppUserRole.standardUser:
        return config.authenticatedSavedHeadlinesLimit;
      case AppUserRole.premiumUser:
        return config.premiumSavedHeadlinesLimit;
    }
  }

  UserPreferenceConfig _updateFollowedItemsLimit(
    UserPreferenceConfig config,
    int value,
    AppUserRole role,
  ) {
    switch (role) {
      case AppUserRole.guestUser:
        return config.copyWith(guestFollowedItemsLimit: value);
      case AppUserRole.standardUser:
        return config.copyWith(authenticatedFollowedItemsLimit: value);
      case AppUserRole.premiumUser:
        return config.copyWith(premiumFollowedItemsLimit: value);
    }
  }

  UserPreferenceConfig _updateSavedHeadlinesLimit(
    UserPreferenceConfig config,
    int value,
    AppUserRole role,
  ) {
    switch (role) {
      case AppUserRole.guestUser:
        return config.copyWith(guestSavedHeadlinesLimit: value);
      case AppUserRole.standardUser:
        return config.copyWith(authenticatedSavedHeadlinesLimit: value);
      case AppUserRole.premiumUser:
        return config.copyWith(premiumSavedHeadlinesLimit: value);
    }
  }
}
