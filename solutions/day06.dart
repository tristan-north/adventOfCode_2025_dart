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

  final opRow = rows.removeLast();

  var solution = 0;
  for (var colIdx = 0; colIdx < rows.first.length; ++colIdx) {
    final op = opRow[colIdx];

    final opFunc = op == '+'
        ? ((int sum, int b) => sum + b)
        : ((int product, int b) => product * b);

    solution += rows.map((x) => int.parse(x[colIdx])).reduce(opFunc);
  }

  return solution;
}
