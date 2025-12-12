import 'dart:io';

typedef Grid = List<List<String>>;

void main() {
  final grid = File(
    'input/day07_input.txt',
  ).readAsLinesSync().map((line) => line.split('')).toList();

  // partOne(grid);

  partTwo(grid);
}

void partTwo(List<List<String>> grid) {
  final startIdx = grid[0].indexOf('S');
  grid[1][startIdx] = '|';
  // grid.print(clearPrevious: false);

  var solution = 0;

  final stopwatch = Stopwatch()..start();
  traverseGrid(grid);
  stopwatch.stop();
  print('Initial traversal time: ${stopwatch.elapsedMicroseconds}');
  stopwatch.reset();
  stopwatch.start();

  var iterCount = 0;
  var rowOfNextIter = 0;
  while (rowOfNextIter != -1) {
    clearPipes(grid);

    // Set new initial | based on bottom left most @ and reset @ to ^
    rowOfNextIter = setNewStart(grid);
    // if (iterCount % 10000 == 0) grid.print();

    traverseGrid(grid);
    solution++;

    if (iterCount > 1000) break;
    iterCount++;
  }
  print('Loop time: ${stopwatch.elapsedMilliseconds}');
  print('Part Two solution: $solution');
}

/// Return -1 if no more @
int setNewStart(Grid grid) {
  for (var row = grid.length - 1; row >= 0; --row) {
    for (var col = 0; col < grid[row].length; ++col) {
      if (grid[row][col] == '@') {
        grid[row][col] = '^';
        grid[row][col + 1] = '|';
        return row;
      }
    }
  }
  return -1;
}

void clearPipes(Grid grid) {
  final rowLen = grid[0].length;
  for (var row = 0; row < grid.length; ++row) {
    for (var col = 0; col < rowLen; ++col) {
      if (grid[row][col] == '|') grid[row][col] = '.';
    }
  }
}

void traverseGrid(Grid grid) {
  final rowLen = grid[0].length;
  for (var rowIdx = 0; rowIdx < grid.length - 1; ++rowIdx) {
    // var madeGridChange = false;
    for (var colIdx = 0; colIdx < rowLen; ++colIdx) {
      if (grid[rowIdx][colIdx] == '|') {
        final nextRow = grid[rowIdx + 1];
        // madeGridChange = true;
        // Current char on current row is a beam
        // Check char underneith
        if (nextRow[colIdx] == '^') {
          nextRow[colIdx - 1] = '|';
          nextRow[colIdx] = '@';
        } else {
          nextRow[colIdx] = '|';
        }
      }
    }
    // if (madeGridChange) grid.print();
  }
}

void partOne(Grid grid) {
  grid.print(clearPrevious: false);

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
    grid.print();
  }

  print('Part One solution: $nSplits');
}

extension on Grid {
  void print({bool clearPrevious = true}) {
    // Hide cursor
    stdout.write('\x1B[?25l');

    // Move cursor to top left
    stdout.write('\x1B[H');
    // if (clearPrevious) stdout.write('\x1B[${linesToClear}A\x1B[0J');
    for (final line in this) {
      line.forEach(stdout.write);
      stdout.write('\n');
    }
    stdout.write('\n');
    // sleep(Duration(milliseconds: 30));

    // Show cursor
    stdout.write('\x1B[?25h');
  }
}
