import 'dart:io';

typedef Grid = List<List<String>>;

void main() {
  final grid = File(
    'input/day07_input.txt',
  ).readAsLinesSync().map((line) => line.split('')).toList();

  // grid.print();

  var nSplits = 0;

  for (final (rowIdx, row) in grid.indexed) {
    if (rowIdx >= grid.length - 1) continue; // Skip last row

    for (final (colIdx, char) in row.indexed) {
      if (char == '|' || char == 'S') {
        // Current char on current row is a beam
        // Check char underneith
        if (grid[rowIdx + 1][colIdx] == '^') {
          grid[rowIdx + 1][colIdx - 1] = '|';
          grid[rowIdx + 1][colIdx + 1] = '|';
          nSplits++;
        } else {
          grid[rowIdx + 1][colIdx] = '|';
        }
      }
    }
    // grid.print();
  }

  print('Part One solution: $nSplits');
}

extension on Grid {
  void print() {
    for (final line in this) {
      line.forEach(stdout.write);
      stdout.write('\n');
    }
    stdout.write('\n');
  }
}
