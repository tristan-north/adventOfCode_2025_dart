// 1) Loop through and find the index of the largest number,
// exclude the final digit. (fold?)

// 2) Starting from that index, loop through again to find the
// largest number for the second digit of the solution for that row.

// 3) Sum each row solution for final solution.

// TODO: FLASHCARDS: indexed()

import 'dart:io';

const nBatteries = 12;

void main() {
  final batteryBanks = File('input/day03_input.txt').readAsLinesSync();

  partOne(batteryBanks);
  partTwo(batteryBanks);
}

void partOne(List<String> batteryBanks) {
  var solution = 0;

  for (final bank in batteryBanks) {
    final chars = bank.split('');

    final largest = chars.take(bank.length - 1).indexed.reduce(largestChar);
    final second = chars.sublist(largest.$1 + 1).indexed.reduce(largestChar);

    final joltage = int.parse('${largest.$2}${second.$2}');
    solution += joltage;
  }

  print('Part One solution: $solution');
}

void partTwo(List<String> batteryBanks) {
  var solution = 0;

  for (final bank in batteryBanks) {
    final chars = bank.split('');

    var bankChars = '';
    var startIdx = 0;

    for (var i = 0; i < nBatteries; ++i) {
      final largest = chars
          .sublist(startIdx, bank.length - (11 - i))
          .indexed
          .reduce(largestChar);

      startIdx += largest.$1 + 1;
      bankChars += largest.$2;
    }

    final joltage = int.parse(bankChars);
    solution += joltage;
  }

  print('Part Two solution: $solution');
}

// Return largest of a or b based on $2 converted to an int.
(int, String) largestChar((int, String) a, (int, String) b) {
  return int.parse(a.$2) >= int.parse(b.$2) ? a : b;
}
