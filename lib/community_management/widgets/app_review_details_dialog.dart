import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:ui_kit/ui_kit.dart';

class AppReviewDetailsDialog extends StatelessWidget {
  const AppReviewDetailsDialog({
    required this.appReview,
    super.key,
  });

  final AppReview appReview;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    final details = appReview.feedbackDetails;

    return AlertDialog(
      title: Text(l10n.feedbackDetails),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.feedbackProvidedAt(
                  DateFormatter.formatRelativeTime(
                    context,
                    appReview.updatedAt,
                  ),
                ),
                style: Theme.of(context).textTheme.labelSmall,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(details ?? l10n.noReasonProvided),
            ],
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
