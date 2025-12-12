import 'dart:io';

import 'package:collection/collection.dart';

enum GridVal { start, empty, splitter, beam }

typedef Grid = List<GridVal>;
typedef Coord = ({int row, int col});

late final int rowLen;
late final int nRows;

void main() {
  final input = File(
    'input/day07_input.txt',
  ).readAsLinesSync().map((line) => line.split('')).toList();

  rowLen = input[0].length;
  nRows = input.length;

  final grid = input
      .map(
        (row) => row.map(
          (char) => switch (char) {
            '.' => GridVal.empty,
            'S' => GridVal.start,
            '^' => GridVal.splitter,
            _ => throw Exception('unexpected symbol'),
          },
        ),
      )
      .flattenedToList;

  partOne(grid);

  partTwo(grid);
}

void partTwo(List<GridVal> grid) {
  final pathCache = <Coord, int>{};

  for (var row = nRows - 2; row > 1; --row) {
    for (var col = 0; col < rowLen; ++col) {
      final currentCoord = (row: row, col: col);

      final symbol = grid.getSymbol(currentCoord);
      if (symbol == .splitter) {
        var nPaths = traverseGrid(grid, (
          row: currentCoord.row,
          col: currentCoord.col - 1,
        ), pathCache);

        nPaths += traverseGrid(grid, (
          row: currentCoord.row,
          col: currentCoord.col + 1,
        ), pathCache);

        pathCache[currentCoord] = nPaths;
      }
    }
  }
  // print(pathCache);
  final startCoord = (row: 2, col: grid.indexOf(.start));
  print('Part Two solution: ${pathCache[startCoord]}');
}

/// Return num paths from this grid pos.
int traverseGrid(Grid grid, Coord coord, Map<Coord, int> pathCache) {
  while (coord.row < nRows - 1) {
    coord = (row: coord.row + 1, col: coord.col);

    final symbolUnder = grid.getSymbol(coord);
    if (symbolUnder == .splitter) {
      return pathCache[coord] ?? -1;
    }
  }
  return 1;
}

void partOne(Grid inGrid) {
  final grid = [...inGrid];
  var nSplits = 0;

  for (var rowIdx = 0; rowIdx < nRows - 2; ++rowIdx) {
    for (var colIdx = 0; colIdx < rowLen; ++colIdx) {
      final char = grid.getSymbol((row: rowIdx, col: colIdx));

      if (char == .beam || char == .start) {
        // Current char on current row is a beam
        // Check char underneith
        if (grid.getSymbol((row: rowIdx + 1, col: colIdx)) == .splitter) {
          grid.setSymbol(.beam, row: rowIdx + 1, col: colIdx - 1);
          grid.setSymbol(.beam, row: rowIdx + 1, col: colIdx + 1);
          nSplits++;
        } else {
          grid.setSymbol(.beam, row: rowIdx + 1, col: colIdx);
        }
      }
    }
  }

  print('Part One solution: $nSplits');
}

extension on Grid {
  void print() {
    // Hide cursor
    stdout.write('\x1B[?25l');

    // Move cursor to top left
    stdout.write('\x1B[H');
    for (final (i, val) in this.indexed) {
      final char = switch (val) {
        .empty => '.',
        .start => 'S',
        .splitter => '^',
        _ => '#',
      };
      stdout.write(char);

      if (i % rowLen == 0) stdout.write('\n');
    }
    stdout.write('\n');
    // sleep(Duration(milliseconds: 30));

    // Show cursor
    stdout.write('\x1B[?25h');
  }

  GridVal getSymbol(Coord coord) => this[coord.row * rowLen + coord.col];

  void setSymbol(GridVal val, {required int row, required int col}) =>
      this[row * rowLen + col] = val;
}
