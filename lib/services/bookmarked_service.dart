class BookmarkService {
  static final List<Map<String, String>> _bookmarkedFoods = [];

  static void addBookmark(Map<String, String> food) {
    if (!_bookmarkedFoods.contains(food)) {
      _bookmarkedFoods.add(food);
    }
  }

  static void removeBookmark(Map<String, String> food) {
    _bookmarkedFoods.remove(food);
  }

  static List<Map<String, String>> getBookmarks() {
    return _bookmarkedFoods;
  }
}
