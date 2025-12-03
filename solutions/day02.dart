import 'dart:io';

typedef Range = ({String start, String end});

void main() {
  final input = File('input/day02_input.txt').readAsStringSync();

  final rangeStrings = input.split(',');

  // Convert input into a list of records containing start and end
  final ranges = [
    for (final s in rangeStrings)
      if (s.split('-') case [final first, final second, ...])
        (start: first, end: second),
  ];

  partOne(ranges);
  partTwo(ranges);
}

void partOne(List<Range> ranges) {
  var solution = 0;

  for (final range in ranges) {
    final startInt = int.parse(range.start);
    final endInt = int.parse(range.end);

    for (var n = startInt; n <= endInt; n++) {
      final nStr = n.toString();

      if (nStr.length.isOdd) continue;

      final first = nStr.substring(0, nStr.length ~/ 2);
      final second = nStr.substring(nStr.length ~/ 2, nStr.length);

      if (first == second) solution += n;
    }
  }

  print('Part One solution: $solution');
}

void partTwo(List<Range> ranges) {
  var solution = 0;

  for (final range in ranges) {
    final startInt = int.parse(range.start);
    final endInt = int.parse(range.end);

    for (var n = startInt; n <= endInt; n++) {
      final testStr = n.toString();
      print('testNum: $testStr');

      final nPatterns = testStr.length ~/ 2;
      for (int i = 0; i < nPatterns; ++i) {
        var pattern = testStr.substring(0, i + 1);
        pattern = pattern * (testStr.length ~/ pattern.length);
        if (testStr == pattern) {
          print(n);
          solution += n;
          break;
        }
      }
    }
  }

  print('Part Two solution: $solution');
}
