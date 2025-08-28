/// Defines application-wide constants.
abstract final class AppConstants {
  /// The maximum width the application should occupy on large screens.
  static const double kMaxAppWidth = 1000;

  /// The duration for debouncing search input, to prevent excessive API calls.
  static const Duration kSearchDebounceDuration = Duration(milliseconds: 300);

  /// The maximum width for the searchable paginated dropdown's overlay dialog.
  static const double kMaxDropdownOverlayWidth = 600;

  /// The maximum height for the searchable paginated dropdown's overlay dialog.
  static const double kMaxDropdownOverlayHeight = 500;

  /// The default card radius used across the application.
  static const double kCardRadius = 8;
}
