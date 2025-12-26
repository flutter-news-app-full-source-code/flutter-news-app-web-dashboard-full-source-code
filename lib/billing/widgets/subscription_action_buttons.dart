import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';

class SubscriptionActionButtons extends StatelessWidget {
  const SubscriptionActionButtons({
    required this.subscription,
    required this.l10n,
    super.key,
  });

  final UserSubscription subscription;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.person_search_outlined),
          tooltip: l10n.subscriptionActionCopyUserId,
          onPressed: () {
            Clipboard.setData(ClipboardData(text: subscription.userId));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.idCopiedToClipboard(subscription.userId)),
              ),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.copy),
          tooltip: l10n.subscriptionActionCopySubscriptionId,
          onPressed: () {
            Clipboard.setData(ClipboardData(text: subscription.id));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.idCopiedToClipboard(subscription.id)),
              ),
            );
          },
        ),
      ],
    );
  }
}
