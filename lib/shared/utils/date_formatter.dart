import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

/// A utility class for formatting dates and times.
abstract final class DateFormatter {
  /// Formats the given [dateTime] into a relative time string
  /// (e.g., "5m ago", "Yesterday", "now").
  ///
  /// Uses the current locale from [context] to format appropriately.
  /// Returns an empty string if [dateTime] is null.
  static String formatRelativeTime(BuildContext context, DateTime? dateTime) {
    if (dateTime == null) {
      return '';
    }
    final locale = Localizations.localeOf(context).languageCode;
    return timeago.format(dateTime, locale: locale);
  }

  /// Formats the given [dateTime] into a short date string (e.g., "Jul 1, 2025").
  ///
  /// Returns an empty string if [dateTime] is null.
  static String formatDate(DateTime? dateTime) {
    if (dateTime == null) {
      return '';
    }
    return DateFormat.yMMMd().format(dateTime);
  }
}
