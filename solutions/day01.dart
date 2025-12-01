import 'dart:io';

enum dir { left, right }

void main() {
  final lines = File('input/day01_input.txt').readAsLinesSync();

  partOne(lines);
  partTwo(lines);
}

void partOne(List<String> lines) {
  var dialPos = 50;
  var solution = 0;

  for (final line in lines) {
    final direction = line[0] == 'L' ? dir.left : dir.right;
    final offset = int.parse(line.substring(1));

    dialPos = switch (direction) {
      .left => (dialPos - offset) % 100,
      .right => (dialPos + offset) % 100,
    };

    if (dialPos == 0) solution++;
  }

  print("Day01 Solution: $solution");
}

void partTwo(List<String> lines) {
  var dialPos = 50;
  var solution = 0;

  for (final line in lines) {
    final direction = line[0] == 'L' ? dir.left : dir.right;
    final offset = int.parse(line.substring(1));

    switch (direction) {
      case .left:
        final quotient = offset ~/ 100;
        final remainder = offset % 100;

        solution += quotient;

        final newDialPos = dialPos - remainder;
        if (newDialPos == 0) solution++;
        if (dialPos != 0 && newDialPos < 0) solution++;
        dialPos = newDialPos % 100;

      case .right:
        final quotient = offset ~/ 100;
        final remainder = offset % 100;

        solution += quotient;

        dialPos = dialPos + remainder;
        if (dialPos >= 100) solution++;
        dialPos = dialPos % 100;
    }
  }

  print("Day02 Solution: $solution");
}
