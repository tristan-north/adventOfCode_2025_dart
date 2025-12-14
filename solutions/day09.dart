import 'dart:io';

typedef Coord = ({int x, int y});

void main() {
  final input = File('input/day09_input.txt').readAsLinesSync();

  final corners = [
    for (final line in input)
      if (line.split(',') case [final x, final y])
        (x: int.parse(x), y: int.parse(y)),
  ];

  var biggestArea = 0;
  for (final corner in corners) {
    for (final otherCorner in corners) {
      if (corner == otherCorner) continue;

      final area = computeArea(corner, otherCorner);

      if (area > biggestArea) biggestArea = area;
    }
  }

  print('Part One solution: $biggestArea');
}

computeArea(Coord corner, Coord otherCorner) {
  return ((corner.x - otherCorner.x).abs() + 1) *
      ((corner.y - otherCorner.y).abs() + 1);
}
