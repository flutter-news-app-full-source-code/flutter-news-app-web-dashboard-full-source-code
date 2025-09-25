import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';

/// {@template about_icon}
/// A widget that displays an information icon which, when pressed, shows
/// a dialog with a title and a descriptive message.
/// {@endtemplate}
class AboutIcon extends StatelessWidget {
  /// {@macro about_icon}
  const AboutIcon({
    required this.dialogTitle,
    required this.dialogDescription,
    super.key,
  });

  /// The title to display in the dialog.
  final String dialogTitle;

  /// The descriptive message to display in the dialog.
  final String dialogDescription;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    final theme = Theme.of(context);
    return IconButton(
      icon: Icon(
        Icons.info_outline,
        color: theme.colorScheme.onSurfaceVariant,
      ),
      iconSize: 20,
      tooltip: l10n.aboutIconTooltip,
      onPressed: () {
        showDialog<void>(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: Text(
                dialogTitle,
                style: Theme.of(dialogContext).textTheme.titleLarge,
              ),
              content: Text(
                dialogDescription,
                style: Theme.of(dialogContext).textTheme.bodyMedium,
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text(l10n.closeButtonText),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
