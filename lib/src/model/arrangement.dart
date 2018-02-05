part of model;

class Arrangement {
  final List<int> whiteIndices;
  final List<int> blackIndices;

  Arrangement(this.whiteIndices, this.blackIndices);
  Arrangement.start()
      : whiteIndices = _whiteInitial(),
        blackIndices = _blackInitial() {}
  static List<int> _blackInitial() {
    return const [1, 3, 5, 7, 8, 10, 12, 14, 17, 19, 21, 23];
  }

  static List<int> _whiteInitial() {
    return _blackInitial().map((i) => 63 - i).toList(growable: false);
  }
}
