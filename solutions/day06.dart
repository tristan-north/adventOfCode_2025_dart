import 'dart:io';

void main() {
  final input = File('input/day06_input.txt').readAsLinesSync();

  print('Day06 Part One solution: ${partOne(input)}');
}

int partOne(List<String> input) {
  final seperatorRe = RegExp(' +');

  final rows = [
    for (final line in input)
      line.split(seperatorRe).where((x) => x.isNotEmpty).toList(),
  ];

  var solution = 0;
  for (var colIdx = 0; colIdx < rows.first.length; ++colIdx) {
    final op = rows[4][colIdx];

    final opFunc = op == '+'
        ? ((int sum, int b) => sum + b)
        : ((int product, int b) => product * b);

    solution += rows
        .map((x) => int.tryParse(x[colIdx]))
        .whereType<int>()
        .reduce(opFunc);
  }

  return solution;
}
