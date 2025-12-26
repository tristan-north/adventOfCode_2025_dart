import 'dart:io';
import 'package:collection/collection.dart';

final expBase = RegExp(r'\[(.+)\] (.+) {(.+)}');
final expButtons = RegExp(r'\(([^)]+)\)');

void main() {
  final input = File('input/day10_input.txt').readAsLinesSync();

  var solution = 0;
  for (final (i, line) in input.indexed) {
    print('Computing: ${i + 1}/${input.length}');
    final iterations = calcNumButtonPushes(line);
    solution += iterations;
  }

  print('Part One solution: $solution');
}

int calcNumButtonPushes(String line) {
  final match = expBase.firstMatch(line)!;
  final lightsStr = match.group(1)!;
  final buttonsStr = match.group(2)!;

  final lightsSolution = lightsStr
      .split('')
      .map((x) => x == '.' ? false : true)
      .toList();

  final buttons = expButtons
      .allMatches(buttonsStr)
      .map(
        (match) => match.group(1)!.split(',').map((x) => int.parse(x)).toList(),
      )
      .toList();

  var combinations = buttons.mapIndexed((i, _) => [i]).toList();
  var iteration = 1;
  while (true) {
    print('iteration: $iteration');

    var newCombinations = <List<int>>[];
    for (var i = 0; i < buttons.length; i++) {
      final newList = combinations.map((x) => [...x, i]).toList();
      newCombinations = [...newCombinations, ...newList];
    }

    combinations = newCombinations;

    iteration++;

    // print(combinations);
    for (final combination in combinations) {
      final lightState = computeLightsFromPresses(
        lightsSolution.length,
        combination,
        buttons,
      );
      if (lightState.equals(lightsSolution)) return iteration;
    }
  }

  return -1;
}

List<bool> computeLightsFromPresses(
  int nLights,
  List<int> presses,
  List<List<int>> buttons,
) {
  final lights = List.filled(nLights, false);

  for (final btnIdx in presses) {
    for (final lightIdx in buttons[btnIdx]) {
      lights[lightIdx] = !lights[lightIdx];
    }
  }

  return lights;
}
