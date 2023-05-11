extension WebFeedIterable<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
