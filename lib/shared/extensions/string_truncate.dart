extension StringTruncate on String {
  String truncate(int maxLength) {
    if (length <= maxLength) {
      return this;
    }
    return '${substring(0, maxLength)}...';
  }
}
