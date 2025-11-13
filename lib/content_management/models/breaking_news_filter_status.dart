/// Defines the status of the breaking news filter.
enum BreakingNewsFilterStatus {
  /// Show all headlines, regardless of their breaking news status.
  all,

  /// Show only headlines marked as breaking news.
  breakingOnly,

  /// Show only headlines not marked as breaking news.
  nonBreakingOnly,
}
