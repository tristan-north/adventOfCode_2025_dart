import 'dart:io';

typedef coord = ({int row, int col});

void main() {
  final input = File('input/day04_input.txt').readAsLinesSync();

  // Create a 2d array List<List<String>>
  final input2d = [for (final line in input) line.split('')];

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
  final rowLen = grid.first.first.length;
  var nRollsRemoved = 0;

  for (final (rowIdx, row) in grid.indexed) {
    for (final (colIdx, val) in row.indexed) {
      if (val != '@') continue;

      final adjacentIndices = getAdjacentIndices2d((
        row: rowIdx,
        col: colIdx,
      ), rowLen);

      final numAdjacent = adjacentIndices.fold(0, (count, testIdx) {
        if (testIdx.row >= 0 &&
            testIdx.col >= 0 &&
            grid.elementAtOrNull(testIdx.row)?.elementAtOrNull(testIdx.col) ==
                '@')
          return ++count;
        else
          return count;
      });

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

List<coord> getAdjacentIndices2d(coord idx, int rowLen) {
  return [
    (col: idx.col - 1, row: idx.row - 1),
    (col: idx.col - 0, row: idx.row - 1),
    (col: idx.col + 1, row: idx.row - 1),

    (col: idx.col - 1, row: idx.row - 0),
    (col: idx.col + 1, row: idx.row - 0),

    (col: idx.col - 1, row: idx.row + 1),
    (col: idx.col - 0, row: idx.row + 1),
    (col: idx.col + 1, row: idx.row + 1),
  ];
}

void printGrid(List<List<String>> grid) {
  for (final row in grid) {
    for (final val in row) {
      stdout.write(val);
    }
    print('');
  }
  print('');
}
