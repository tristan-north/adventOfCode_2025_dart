import 'dart:io';

enum dir { left, right }

void main() {
  final lines = File('input/day01_input.txt').readAsLinesSync();

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
