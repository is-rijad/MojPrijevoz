class SearchResult<T> {
  List<T> items;
  int count;
  bool hasMore;

  SearchResult({
    required this.items,
    required this.count,
    required this.hasMore,
  });

  void copyTo(SearchResult<T> searchResult) {
    searchResult.items.addAll(items);
    searchResult.count = count;
    searchResult.hasMore = hasMore;
  }
}
