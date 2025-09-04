/// Extension on [String] to provide truncation and capitalization utilities.
extension StringX on String {
  /// Truncates the string to a specified [maxLength].
  ///
  /// If the string's length exceeds [maxLength], it is truncated and
  /// '...' is appended.
  String truncate(int maxLength) {
    if (length <= maxLength) {
      return this;
    }
    return '${substring(0, maxLength)}...';
  }

  /// Capitalizes the first letter of the string.
  ///
  /// Returns the original string if it is empty.
  String capitalize() {
    if (isEmpty) {
      return this;
    }
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
