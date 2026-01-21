import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';

/// {@template reward_action_buttons}
/// A widget that displays action buttons for a reward item.
///
/// Currently, this only supports copying the user ID, as reward revocation
/// is not supported.
/// {@endtemplate}
class RewardActionButtons extends StatelessWidget {
  /// {@macro reward_action_buttons}
  const RewardActionButtons({
    required this.reward,
    required this.l10n,
    super.key,
  });

  /// The reward item for which to display actions.
  final UserRewards reward;

  /// The localized strings for the application.
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      visualDensity: VisualDensity.compact,
      iconSize: 20,
      icon: const Icon(Icons.copy),
      tooltip: l10n.copyUserId,
      onPressed: () {
        Clipboard.setData(ClipboardData(text: reward.userId));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.idCopiedToClipboard(reward.userId),
            ),
          ),
        );
      },
    );
  }
}
