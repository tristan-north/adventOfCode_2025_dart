import 'dart:io';

void main() {
  final [rangesStr, idsStr] = File(
    'input/day05_input.txt',
  ).readAsStringSync().split('\n\n');

  final ranges = rangesStr.split('\n').map((x) {
    final [a, b] = x.split('-');
    return (int.parse(a), int.parse(b));
  }).toList();

  final ids = idsStr.trim().split('\n').map((x) => int.parse(x)).toList();

  // Part One
  final solutionPartOne = ids.where((id) => isFresh(id, ranges)).length;
  print('Part One solution: $solutionPartOne');

  // Part Two
  final remainingRanges = ranges;
  final mergedRanges = [remainingRanges.removeLast()];

  while (remainingRanges.length > 0) {
    var currentRange = remainingRanges.removeLast();

    var discard = false;
    (int, int)? rangeToRemove;

    forloop:
    for (final mergedRange in mergedRanges) {
      switch (currentRange.getOverlap(mergedRange)) {
        case .startOverlaps:
          currentRange = (mergedRange.$2 + 1, currentRange.$2);
        case .endOverlaps:
          currentRange = (currentRange.$1, mergedRange.$1 - 1);
        case .fullyEnclosed:
          discard = true;
          break forloop;
        case .fullyOverlaps:
          rangeToRemove = mergedRange;
        case .noOverlap:
          continue;
      }
    }

    if (rangeToRemove != null) mergedRanges.remove(rangeToRemove);
    if (discard == false) mergedRanges.add(currentRange);
  }

  final solutionPartTwo = mergedRanges.fold(
    0,
    (sum, range) => sum + range.$2 - range.$1 + 1,
  );

  print('Part Two solution: $solutionPartTwo');
}

enum OverlapState {
  noOverlap,
  fullyEnclosed,
  startOverlaps,
  endOverlaps,
  fullyOverlaps,
}

extension on (int, int) {
  OverlapState getOverlap((int, int) b) {
    if (this.$1 >= b.$1 && this.$2 <= b.$2) return .fullyEnclosed;
    if (this.$1 >= b.$1 && this.$1 <= b.$2) return .startOverlaps;
    if (this.$2 <= b.$2 && this.$2 >= b.$1) return .endOverlaps;
    if (this.$1 < b.$1 && this.$2 > b.$2) return .fullyOverlaps;
    return .noOverlap;
  }
}

bool isFresh(id, ranges) {
  return ranges.any((range) => id >= range.$1 && id <= range.$2);
}
