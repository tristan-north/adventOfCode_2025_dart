import 'dart:io';
import 'dart:math';

typedef Position = (int, int, int);

void main() {
  // Create List of (int, int, int)
  final input = File('input/day08_input.txt').readAsLinesSync().map((line) {
    final asList = line.split(',').map((intStr) => int.parse(intStr)).toList();
    return (asList[0], asList[1], asList[2]);
  }).toList();

  // Create List of sorted connection distances largest to shortest.
  final distances = <(double, int, int)>[];
  for (var i = 0; i < input.length - 1; ++i) {
    for (var j = i + 1; j < input.length; ++j) {
      final dist = distanceBetween(input[i], input[j]);
      distances.add((dist, i, j));
    }
  }
  distances.sort((a, b) => -a.$1.compareTo(b.$1));

  final circuits = <List<int>>[];
  for (var i = 0; i < 1000; i++) {
    final (_, posAIdx, posBIdx) = distances.removeLast();

    final posACircuit = getCircuitContaining(posAIdx, circuits);
    final posBCircuit = getCircuitContaining(posBIdx, circuits);

    switch ((posACircuit, posBCircuit)) {
      // Neither pos is in a circuit
      case (null, null):
        circuits.add([posAIdx, posBIdx]); // Create a new circuit

      // They're in the same circuit
      case (int a, int b) when a == b:
        break;

      // They're in different circuits
      case (int a, int b):
        circuits[a].addAll(circuits[b]); // Add from one circuit to the other
        circuits.removeAt(b); // Remove other circuit

      // One is in a circuit but the other isn't
      case (int a, null):
        circuits[a].add(posBIdx);
      case (null, int b):
        circuits[b].add(posAIdx);
    }
  }

  circuits.sort((a, b) => a.length.compareTo(b.length));

  for (final circuit in circuits) {
    for (final posIdx in circuit) stdout.write('${input[posIdx].$1} ');
    print('');
  }

  final solution = circuits
      .getRange(circuits.length - 3, circuits.length)
      .map((c) => c.length)
      .fold(1, (carry, curr) => carry * curr);
  print('Part One solution: $solution');
}

int? getCircuitContaining(int posIdxA, List<List<int>> circuits) {
  for (final (idx, containedPositions) in circuits.indexed) {
    if (containedPositions.contains(posIdxA)) return idx;
  }

  return null;
}

double distanceBetween(Position a, Position b) =>
    sqrt(pow(a.$1 - b.$1, 2) + pow(a.$2 - b.$2, 2) + pow(a.$3 - b.$3, 2));
