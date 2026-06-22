class SearchResult<T> {
  List<T> items;
  bool hasMore;

  SearchResult({List<T>? items, this.hasMore = true})
    : items = items ?? List.empty(growable: true);

  void copyTo(SearchResult<T> searchResult) {
    searchResult.items.addAll(items);
    searchResult.hasMore = hasMore;
  }
}
