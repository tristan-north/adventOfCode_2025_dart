import 'dart:io';

typedef Coord = ({int row, int col});

void main() {
  // Create 2D Array List<List<String>>
  final input2d = File(
    'input/day04_input.txt',
  ).readAsLinesSync().map((line) => line.split('')).toList();

  var solutionPartOne = 0;
  var solutionPartTwo = 0;

  while (true) {
    final nRollsRemoved = removeRolls(input2d);
    if (nRollsRemoved == 0) break;

    if (solutionPartOne == 0) solutionPartOne = nRollsRemoved;
    solutionPartTwo += nRollsRemoved;
  }

  print('Part One solution: $solutionPartOne');
  print('Part Two solution: $solutionPartTwo');
}

int removeRolls(List<List<String>> grid) {
  final gridOut = [
    for (final row in grid) [...row],
  ];
  final rowLen = grid.first.length;
  var nRollsRemoved = 0;

  for (final (rowIdx, row) in grid.indexed) {
    for (final (colIdx, val) in row.indexed) {
      if (val != '@') continue;

      final adjacentIndices = getAdjacentIndices2d((
        row: rowIdx,
        col: colIdx,
      ), rowLen);

      final numAdjacent = adjacentIndices
          .where((coord) => grid[coord.row][coord.col] == '@')
          .length;

      if (numAdjacent < 4) {
        gridOut[rowIdx][colIdx] = 'x';
        ++nRollsRemoved;
      }
    }
  }

  grid.clear();
  grid.addAll(gridOut);
  return nRollsRemoved;
}

List<Coord> getAdjacentIndices2d(Coord idx, int rowLen) {
  return [
        (col: idx.col - 1, row: idx.row - 1),
        (col: idx.col - 0, row: idx.row - 1),
        (col: idx.col + 1, row: idx.row - 1),

        (col: idx.col - 1, row: idx.row - 0),
        (col: idx.col + 1, row: idx.row - 0),

        (col: idx.col - 1, row: idx.row + 1),
        (col: idx.col - 0, row: idx.row + 1),
        (col: idx.col + 1, row: idx.row + 1),
      ]
      .where(
        (coord) =>
            coord.row >= 0 &&
            coord.col >= 0 &&
            coord.row < rowLen &&
            coord.col < rowLen,
      )
      .toList();
}

void printGrid(List<List<String>> grid) {
  for (final row in grid) {
    stdout.write(row.join());
    print('');
  }
  print('');
}
