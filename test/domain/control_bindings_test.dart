// test/domain/control_bindings_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:roadmap_for_rl/domain/controls/control_bindings.dart';

void main() {
  const defaults = ControlBindings();

  test('default bindings match the PlayStation scheme in the brief', () {
    expect(defaults.resolve('[Jump] [Boost] [Powerslide]'), 'X Circle Square');
    expect(defaults.resolve('[Air Roll Left] [Gas] [Brake]'), 'L1 R2 L2');
  });

  test("lesson text uses the player's own buttons", () {
    final mine = defaults.rebind(ControlAction.boost, 'R1');
    expect(
      mine.resolve('Hold [Boost], then press [Jump].'),
      'Hold R1, then press X.',
    );
    expect(mine.reset(ControlAction.boost).buttonFor(ControlAction.boost),
        'Circle');
  });

  test('tokens ignore case and unknown brackets are left alone', () {
    expect(defaults.resolve('[boost] then [air roll left]'), 'Circle then L1');
    expect(defaults.resolve('Steer with [Left Stick]'),
        'Steer with [Left Stick]');
    expect(defaults.resolve('No tokens here'), 'No tokens here');
  });

  test('custom bindings survive a JSON round trip', () {
    final restored = ControlBindings.fromJson(
      defaults.rebind(ControlAction.jump, 'Cross').toJson(),
    );
    expect(restored.resolve('[Jump] and [Boost]'), 'Cross and Circle');
  });
}