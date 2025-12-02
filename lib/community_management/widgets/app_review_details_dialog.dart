import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';

class AppReviewDetailsDialog extends StatelessWidget {
  const AppReviewDetailsDialog({
    required this.appReview,
    super.key,
  });

  final AppReview appReview;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final details = appReview.feedbackDetails;

    return AlertDialog(
      title: Text(l10n.feedbackDetails),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 300),
        child: SingleChildScrollView(
          child: Text(
            details ?? l10n.noReasonProvided,
            style: (details == null)
                ? theme.textTheme.bodyLarge?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  )
                : theme.textTheme.bodyLarge,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.closeButtonText),
        ),
      ],
    );
  }
}
