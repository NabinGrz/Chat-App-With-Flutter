extension GroupByExtension<T> on List<T> {
  Map<K, List<T>> groupBy<K>(K Function(T) keySelector) {
    Map<K, List<T>> groupedMap = {};

    for (var element in this) {
      var key = keySelector(element);
      groupedMap.putIfAbsent(key, () => []).add(element);
    }

    return groupedMap;
  }
}
