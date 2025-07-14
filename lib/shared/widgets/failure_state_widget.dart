import 'package:flutter/material.dart';
import 'package:ht_shared/ht_shared.dart';
import 'package:ht_ui_kit/ht_ui_kit.dart';
import 'package:ht_dashboard/l10n/l10n.dart'; // Import l10n

/// A widget to display an error message and an optional retry button.
class FailureStateWidget extends StatelessWidget {
  /// Creates a [FailureStateWidget].
  ///
  /// This widget accepts an [exception] of type [HtHttpException]
  /// and uses the `toFriendlyMessage` extension from `ht_ui_kit`
  /// to display a localized, user-friendly error message.
  ///
  /// The [onRetry] is an optional callback to be called
  /// when the retry button is pressed.
  const FailureStateWidget({
    required this.exception,
    super.key,
    this.onRetry,
    this.retryButtonText,
  });

  /// The error exception to display.
  /// This exception will be converted to a friendly, localized message.
  final HtHttpException exception;

  /// An optional callback to be called when the retry button is pressed.
  final VoidCallback? onRetry;

  /// Optional custom text for the retry button. Defaults to "Retry".
  final String? retryButtonText;

  @override
  Widget build(BuildContext context) {
    final friendlyMessage = exception.toFriendlyMessage(context);
    final l10n = context.l10n; // Get l10n instance
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            friendlyMessage,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          // Show the retry button only if onRetry is provided
          if (onRetry != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: ElevatedButton(
                onPressed: onRetry,
                child: Text(retryButtonText ?? l10n.retryButtonText),
              ),
            ),
        ],
      ),
    );
  }
}
