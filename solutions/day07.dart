import 'dart:io';

import 'package:collection/collection.dart';

enum GridVal { start, dot, pipe, carrot, at }

typedef Grid = List<GridVal>;
typedef Coord = ({int row, int col});

late final int rowLen;
late final int nRows;

final remainingStarts = <Coord>[];

void main() {
  final grid = File(
    'input/day07_input.txt',
  ).readAsLinesSync().map((line) => line.split('')).toList();

  rowLen = grid[0].length;
  nRows = grid.length;

  // partOne(grid);

  partTwo(grid);
}

void partTwo(List<List<String>> gridIn) {
  final grid = gridIn
      .map(
        (row) => row.map(
          (char) => switch (char) {
            '.' => GridVal.dot,
            '|' => GridVal.pipe,
            '@' => GridVal.at,
            'S' => GridVal.start,
            '^' => GridVal.carrot,
            _ => throw Exception('unexpected symbol'),
          },
        ),
      )
      .flattenedToList;

  final startIdx = grid.indexOf(.start);
  remainingStarts.add((row: 0, col: startIdx));
  // grid[startIdx] = .pipe;

  // grid.print(clearPrevious: false);

  final stopwatch = Stopwatch()..start();
  // traverseGrid(grid, (row: 0, col: startIdx));
  // solution++;
  // stopwatch.stop();
  // print('Initial traversal time: ${stopwatch.elapsedMicroseconds}');
  // stopwatch.reset();
  // stopwatch.start();

  var iterCount = 0;
  while (remainingStarts.isNotEmpty) {
    // Set new initial | based on bottom left most @ and reset @ to ^
    // final nextCoord = setNewStart(grid);
    // if (nextCoord.row == -1) break;
    // grid.print();
    // sleep(Duration(milliseconds: 100));

    traverseGrid(grid, remainingStarts.removeLast());

    if (iterCount % 10000000 == 0) grid.print();
    // if (iterCount > 1000000) break;

    iterCount++;
  }
  print('Loop time: ${stopwatch.elapsedMilliseconds}');
  print('Part Two solution: $iterCount');
}

/// Returns coord of next @ or -1 if no more @
Coord setNewStart(Grid grid) {
  for (var row = nRows - 1; row >= 0; --row) {
    for (var col = 0; col < rowLen; ++col) {
      if (grid.getSymbol(row: row, col: col) == .at) {
        grid.setSymbol(.carrot, row: row, col: col);
        // grid.setSymbol(.pipe, row: row, col: col + 1);
        return (row: row, col: col + 1);
      }
    }
  }
  return (row: -1, col: -1);
}

void traverseGrid(Grid grid, Coord coord) {
  while (coord.row < nRows - 1) {
    // Check char underneith
    final symbolUnder = grid.getSymbol(row: coord.row + 1, col: coord.col);
    if (symbolUnder == .carrot || symbolUnder == .at) {
      grid.setSymbol(.at, row: coord.row + 1, col: coord.col);
      remainingStarts.add((row: coord.row + 1, col: coord.col + 1));
      coord = (row: coord.row + 1, col: coord.col - 1);
    } else {
      coord = (row: coord.row + 1, col: coord.col);
    }
  }
}

void partOne(Grid grid) {
  // grid.print(clearPrevious: false);
  //
  // var nSplits = 0;
  //
  // for (final (rowIdx, row) in grid.indexed) {
  //   if (rowIdx >= grid.length - 1) continue; // Skip last row
  //
  //   for (final (colIdx, char) in row.indexed) {
  //     if (char == '|' || char == 'S') {
  //       // Current char on current row is a beam
  //       // Check char underneith
  //       if (grid[rowIdx + 1][colIdx] == '^') {
  //         grid[rowIdx + 1][colIdx - 1] = '|';
  //         grid[rowIdx + 1][colIdx + 1] = '|';
  //         nSplits++;
  //       } else {
  //         grid[rowIdx + 1][colIdx] = '|';
  //       }
  //     }
  //   }
  //   grid.print();
  // }
  //
  // print('Part One solution: $nSplits');
}

extension on Grid {
  void print() {
    // Hide cursor
    stdout.write('\x1B[?25l');

    // Move cursor to top left
    stdout.write('\x1B[H');
    for (final (i, val) in this.indexed) {
      final char = switch (val) {
        .dot => '.',
        .start => 'S',
        .pipe => '|',
        .carrot => '^',
        .at => '@',
      };
      stdout.write(char);

      if (i % rowLen == 0) stdout.write('\n');
    }
    stdout.write('\n');
    // sleep(Duration(milliseconds: 30));

    // Show cursor
    stdout.write('\x1B[?25h');
  }

  GridVal getSymbol({required int row, required int col}) =>
      this[row * rowLen + col];

  void setSymbol(GridVal val, {required int row, required int col}) =>
      this[row * rowLen + col] = val;
}
