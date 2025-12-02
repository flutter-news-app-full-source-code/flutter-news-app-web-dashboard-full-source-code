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
    final details = appReview.feedbackDetails;

    return AlertDialog(
      title: Text(l10n.feedbackDetails),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Text(details ?? l10n.noReasonProvided),
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
