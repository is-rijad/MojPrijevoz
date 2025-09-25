class SearchResult<T> {
  List<T> items;
  int count;
  bool hasMore;

  SearchResult({List<T>? items, this.count = 0, this.hasMore = true})
    : items = items ?? List.empty(growable: true);

  void copyTo(SearchResult<T> searchResult) {
    searchResult.items.addAll(items);
    searchResult.count = count;
    searchResult.hasMore = hasMore;
  }
}
