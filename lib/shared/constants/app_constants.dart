/// Defines application-wide constants.
abstract final class AppConstants {
  /// The maximum width the application should occupy on large screens.
  static const double kMaxAppWidth = 1000;

  /// The breakpoint width to switch between mobile (column) and desktop (row) layouts.
  ///
  /// Set to 600 to ensure the row layout triggers even when the navigation rail
  /// consumes space within the kMaxAppWidth constraint.
  static const double kDesktopBreakpoint = 600;

  /// The fixed width for the KPI sidebar in the analytics dashboard strip on large screens.
  static const double kAnalyticsKpiSidebarWidth = 300;

  /// The maximum width for the authentication pages.
  static const double kMaxAuthWidth = 400;

  /// The duration for debouncing search input, to prevent excessive API calls.
  static const Duration kSearchDebounceDuration = Duration(milliseconds: 300);

  /// The maximum width for the searchable paginated dropdown's overlay dialog.
  static const double kMaxDropdownOverlayWidth = 600;

  /// The maximum height for the searchable paginated dropdown's overlay dialog.
  static const double kMaxDropdownOverlayHeight = 500;

  /// The default card radius used across the application.
  static const double kCardRadius = 8;

  /// The default number of rows per page for paginated tables.
  static const int kDefaultRowsPerPage = 10;

  /// The maximum number of items to fetch in a single API request for filter options.
  static const int kMaxItemsPerRequest = 25;

  /// The duration for which a snackbar message is displayed,
  /// also used as the undo duration for pending deletions.
  static const Duration kSnackbarDuration = Duration(seconds: 5);

  /// Validates the configuration constants to ensure UI consistency.
  ///
  /// Throws an [AssertionError] if the configuration is invalid.
  static void validate() {
    assert(
      kDesktopBreakpoint < kMaxAppWidth,
      'The desktop breakpoint ($kDesktopBreakpoint) must be less than the '
      'maximum app width ($kMaxAppWidth) to ensure responsive layouts '
      'function correctly.',
    );
  }
}

/// A dummy [DateTime] used for placeholder models in UI.
final dummyDate = DateTime.fromMillisecondsSinceEpoch(0);
