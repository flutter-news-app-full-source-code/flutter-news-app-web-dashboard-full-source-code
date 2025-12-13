import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';

/// {@template confirmation_dialog}
/// A reusable dialog to confirm a user action.
///
/// This dialog displays a title, content, and two buttons: a cancel button
/// and a confirm button. The text for these buttons and the action to be
/// performed on confirmation are customizable.
/// {@endtemplate}
class ConfirmationDialog extends StatelessWidget {
  /// {@macro confirmation_dialog}
  const ConfirmationDialog({
    required this.title,
    required this.content,
    required this.onConfirm,
    this.confirmText,
    super.key,
  });

  /// The title of the dialog.
  final String title;

  /// The main content or question of the dialog.
  final String content;

  /// The callback to be executed when the user confirms the action.
  final VoidCallback onConfirm;

  /// The text for the confirmation button. Defaults to 'Confirm'.
  final String? confirmText;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;

    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancelButton),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm();
          },
          child: Text(confirmText ?? l10n.confirmSaveButton),
        ),
      ],
    );
  }
}
