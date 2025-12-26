import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';

class SubscriptionsActionButtons extends StatelessWidget {
  const SubscriptionsActionButtons({
    required this.subscription,
    required this.l10n,
    super.key,
  });

  final UserSubscription subscription;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final visibleActions = <Widget>[];
    final overflowMenuItems = <PopupMenuEntry<String>>[];

    // Primary Action: Copy User ID
    visibleActions.add(
      IconButton(
        visualDensity: VisualDensity.compact,
        iconSize: 20,
        icon: const Icon(Icons.copy),
        tooltip: l10n.subscriptionActionCopyUserId,
        onPressed: () => _copyToClipboard(context, subscription.userId),
      ),
    );

    // Secondary Action: Copy Subscription ID (in menu)
    overflowMenuItems.add(
      PopupMenuItem<String>(
        value: 'copySubscriptionId',
        child: Text(l10n.subscriptionActionCopySubscriptionId),
      ),
    );

    if (overflowMenuItems.isNotEmpty) {
      visibleActions.add(
        SizedBox(
          width: 32,
          child: PopupMenuButton<String>(
            iconSize: 20,
            icon: const Icon(Icons.more_vert),
            tooltip: l10n.moreActions,
            onSelected: (value) {
              if (value == 'copySubscriptionId') {
                _copyToClipboard(context, subscription.id);
              }
            },
            itemBuilder: (context) => overflowMenuItems,
          ),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: visibleActions,
    );
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(l10n.idCopiedToClipboard(text)),
        ),
      );
  }
}
