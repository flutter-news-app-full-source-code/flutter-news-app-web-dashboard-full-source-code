/// Defines the possible states for the breaking news filter.
///
/// This enum provides a clear, type-safe way to represent the three
/// distinct filtering options for breaking news, avoiding the ambiguity
/// of using a nullable boolean.
enum BreakingNewsFilterStatus {
  /// Show all headlines, regardless of their breaking status.
  all,

  /// Show only headlines marked as breaking news.
  breakingOnly,

  /// Show only headlines that are not marked as breaking news.
  nonBreakingOnly,
}
