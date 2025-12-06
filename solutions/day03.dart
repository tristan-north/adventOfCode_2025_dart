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

    final (idx1, val1) = chars
        .take(bank.length - 1)
        .indexed
        .reduce(largestChar);

    final (_, val2) = chars.skip(idx1 + 1).indexed.reduce(largestChar);

    final joltage = int.parse('$val1$val2');
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
      final (idx, val) = chars
          .sublist(startIdx, bank.length - (11 - i))
          .indexed
          .reduce(largestChar);

      startIdx += idx + 1;
      bankChars += val;
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
