import 'dart:io';
import 'dart:math';

enum Dir { up, down, left, right, invalid }

enum Offset { extend, shrink, invalid }

typedef Coord = ({int x, int y});

void main() {
  final input = File('input/day09_input.txt').readAsLinesSync();

  final corners = [
    for (final line in input)
      if (line.split(',') case [final x, final y])
        (x: int.parse(x), y: int.parse(y)),
  ];

  partOne(corners);
  partTwo(corners);
}

void partOne(List<Coord> corners) {
  var biggestArea = 0;
  for (final corner in corners) {
    for (final otherCorner in corners) {
      final area = computeArea(corner, otherCorner);

      biggestArea = max(area, biggestArea);
    }
  }

  print('Part One solution: $biggestArea');
}

void partTwo(List<Coord> corners) {
  final cornersExpanded = <Coord>[];

  for (var i = 0; i < corners.length; i++) {
    final currentPt = corners[i];
    final nextPt = corners[(i + 1) % corners.length];
    final prevPt = corners[(i - 1) % corners.length];

    final prevEdgeDir = getDir(prevPt, currentPt);
    final nextEdgeDir = getDir(currentPt, nextPt);

    final offset = getOffsetFromDirs(prevEdgeDir, nextEdgeDir);
    assert(offset != (x: 0, y: 0));

    cornersExpanded.add((x: currentPt.x + offset.x, y: currentPt.y + offset.y));
  }

  var biggestArea = 0;
  for (final corner in corners) {
    for (final otherCorner in corners) {
      if (corner == otherCorner) continue;

      final corner3 = (x: corner.x, y: otherCorner.y);
      final corner4 = (x: otherCorner.x, y: corner.y);

      if (isLineIntersected(corner, corner3, cornersExpanded)) continue;
      if (isLineIntersected(corner, corner4, cornersExpanded)) continue;
      if (isLineIntersected(otherCorner, corner3, cornersExpanded)) continue;
      if (isLineIntersected(otherCorner, corner4, cornersExpanded)) continue;

      final area = computeArea(corner, otherCorner);
      if (area > biggestArea) {
        biggestArea = area;
      }
    }
  }

  print('Part Two solution: $biggestArea');
}

bool isPointInside(Coord p, List<Coord> corners) {
  var nIntersections = 0;
  for (var i = 0; i < corners.length; i += 2) {
    final lineStart = corners[i];
    final lineEnd = corners[i + 1];

    assert(lineStart.x == lineEnd.x);
    // Check for intersection to the left in x
    if (isValWithinRange(p.y, lineStart.y, lineEnd.y, inclusive: false) &&
        p.x > lineStart.x)
      nIntersections++;

    // Check for intersection with horizontal and count as one intersection
    final horizontalStart = lineStart;
    if (i == 0) continue;
    final horizontalEnd = corners[i - 1];
    assert(horizontalStart.y == horizontalEnd.y);
    final horizontal = horizontalStart.x < horizontalEnd.x
        ? horizontalStart
        : horizontalEnd;
    if (horizontal.y == p.y && p.x >= horizontal.x) nIntersections++;
  }

  return nIntersections.isOdd;
}

bool isLineIntersected(Coord p1, Coord p2, List<Coord> cornersIn) {
  final isVerticalLine = p1.x == p2.x;
  final corners = [...cornersIn];

  if (isVerticalLine) {
    // Arrange so that they're in horizontal pairs
    corners.add(corners.removeAt(0));
    // TODO: not considering wrapping of last and first points
  }

  for (var i = 0; i < corners.length; i += 2) {
    final lineStart = corners[i];
    final lineEnd = corners[i + 1];

    if (isVerticalLine) {
      if (isValWithinRange(p1.x, lineStart.x, lineEnd.x, inclusive: true) &&
          isValWithinRange(lineStart.y, p1.y, p2.y, inclusive: true))
        return true;
    } else {
      if (isValWithinRange(p1.y, lineStart.y, lineEnd.y, inclusive: true) &&
          isValWithinRange(lineStart.x, p1.x, p2.x, inclusive: true))
        return true;
    }
  }

  return false;
}

Coord getOffsetFromDirs(Dir prevDir, Dir nextDir) =>
    switch ((prevDir, nextDir)) {
      (.up, .left) => (x: 1, y: 1),
      (.up, .right) => (x: 1, y: -1),
      (.down, .left) => (x: -1, y: 1),
      (.down, .right) => (x: -1, y: -1),

      (.left, .up) => (x: 1, y: 1),
      (.left, .down) => (x: -1, y: 1),
      (.right, .up) => (x: 1, y: -1),
      (.right, .down) => (x: -1, y: -1),

      _ => (x: 0, y: 0),
    };

Dir getDir(Coord start, Coord end) {
  final dx = end.x - start.x;
  final dy = end.y - start.y;
  final Dir dir = switch ((dx.sign, dy.sign)) {
    (0, 1) => .up,
    (0, -1) => .down,
    (1, 0) => .right,
    (-1, 0) => .left,
    _ => Dir.invalid,
  };

  assert(dir != .invalid);

  return dir;
}

bool isValWithinRange(int x, int a, int b, {required bool inclusive}) =>
    inclusive
    ? x >= min(a, b) && x <= max(a, b)
    : x > min(a, b) && x < max(a, b);

bool isPointWithinRect(Coord p, Coord corner, Coord otherCorner) =>
    p.x >= min(corner.x, otherCorner.x) &&
    p.x <= max(corner.x, otherCorner.x) &&
    p.y >= min(corner.y, otherCorner.y) &&
    p.y <= max(corner.y, otherCorner.y);

computeArea(Coord corner, Coord otherCorner) {
  return ((corner.x - otherCorner.x).abs() + 1) *
      ((corner.y - otherCorner.y).abs() + 1);
}
