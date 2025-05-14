const _protsNumberMap = {
  0: [0, 1, 2, 3, 4, 5, 6],
  1: [0, 1, 2, 3, 4, 5, 6],
};

class ProtsUtils {
  static List<String> getRandomProts(int amountProts) {
    final allPairs = <(int, int)>[];

    for (final entry in _protsNumberMap.entries) {
      for (final value in entry.value) {
        allPairs.add((entry.key, value));
      }
    }

    allPairs.shuffle();

    return List.from(
      allPairs
          .take(amountProts)
          .map(
            (protsRecord) =>
                'assets/images/prots/${protsRecord.$1}-${protsRecord.$2}.png',
          ),
    );
  }
}
