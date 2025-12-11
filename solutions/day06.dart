import 'dart:io';

void main() {
  final input = File('input/day06_input.txt').readAsLinesSync();

  print('Day06 Part One solution: ${partOne(input)}');
  print('Day06 Part Two solution: ${partTwo(input)}');
}

int partTwo(List<String> input) {
  final rows = [...input];
  final opRow = rows.removeLast();

  var solution = 0;

  var opFunc = opSum;
  final valuesBuffer = <int>[];
  for (var colIdx = 0; colIdx < opRow.length; ++colIdx) {
    opFunc = switch (opRow[colIdx]) {
      '+' => opSum,
      '*' => opProduct,
      _ => opFunc,
    };

    switch (getIntFromColumn(colIdx, rows)) {
      case null:
        solution += valuesBuffer.reduce(opFunc);
        valuesBuffer.clear();
        continue;

      case int val:
        valuesBuffer.add(val);
    }
  }
  solution += valuesBuffer.reduce(opFunc); // For the last group of columns

  return solution;
}

int? getIntFromColumn(colIdx, List<String> rows) {
  final intStr =
      '${rows[0][colIdx]}${rows[1][colIdx]}${rows[2][colIdx]}${rows[3][colIdx]}';
  return int.tryParse(intStr.trim());
}

int opSum(int a, int b) => a + b;
int opProduct(int a, int b) => a * b;

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

    final opFunc = op == '+' ? opSum : opProduct;

    solution += rows.map((x) => int.parse(x[colIdx])).reduce(opFunc);
  }

  return solution;
}
