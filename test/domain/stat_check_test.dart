// test/domain/stat_check_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:roadmap_for_rl/domain/enums.dart';
import 'package:roadmap_for_rl/domain/models/stat_check.dart';

void main() {
  const json = <String, Object>{
    'screen': 'matchHistory',
    'metric': 'saves',
    'minimum': 2,
    'matches': 3,
    'label': 'Average 2 or more saves over 3 matches',
  };

  test('reads a StatCheck from JSON and writes the same data back', () {
    final check = StatCheck.fromJson(json);
    expect(check.screen, StatScreen.matchHistory);
    expect(check.metric, StatMetric.saves);
    expect(check.minimum, 2.0);
    expect(check.matches, 3);
    expect(StatCheck.fromJson(check.toJson()).toJson(), check.toJson());
  });

  test('below the minimum does not pass, at or above does', () {
    final check = StatCheck.fromJson(json);
    expect(check.isMetBy(1.9), isFalse);
    expect(check.isMetBy(2), isTrue);
  });

  test('matches defaults to 1 and unknown names fail loudly', () {
    expect(StatCheck.fromJson({...json}..remove('matches')).matches, 1);
    expect(
      () => StatCheck.fromJson({...json, 'metric': 'notAMetric'}),
      throwsFormatException,
    );
  });
}