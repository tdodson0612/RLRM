// lib/domain/controls/control_bindings.dart

/// Everything a lesson can tell the player to press. Lesson text never names a
/// button. It writes the action in square brackets, like "Press [Boost]", and
/// [ControlBindings.resolve] swaps in the player's own button.
enum ControlAction {
  jump('Jump', 'X'),
  boost('Boost', 'Circle'),
  powerslide('Powerslide', 'Square'),
  airRollLeft('Air Roll Left', 'L1'),
  airRollRight('Air Roll Right', 'R1'), // assumed default, not in the brief
  ballCam('Ball Cam', 'Triangle'), // assumed default, not in the brief
  gas('Gas', 'R2'),
  brake('Brake', 'L2');

  const ControlAction(this.label, this.defaultButton);

  /// The name authors write inside [brackets] in lesson text.
  final String label;

  /// The PlayStation default.
  final String defaultButton;

  static ControlAction? fromLabel(String text) {
    final wanted = text.trim().toLowerCase();
    for (final action in values) {
      if (action.label.toLowerCase() == wanted) return action;
    }
    return null;
  }
}

/// The player's button for each [ControlAction]: PlayStation defaults plus any
/// changes they make in Settings.
class ControlBindings {
  const ControlBindings([this._changes = const {}]);

  factory ControlBindings.fromJson(Map<String, dynamic> json) {
    final changes = <ControlAction, String>{};
    for (final action in ControlAction.values) {
      final button = json[action.name];
      if (button is String) changes[action] = button;
    }
    return ControlBindings(changes);
  }

  final Map<ControlAction, String> _changes;

  static final _token = RegExp(r'\[([^\[\]]+)\]');

  String buttonFor(ControlAction action) =>
      _changes[action] ?? action.defaultButton;

  ControlBindings rebind(ControlAction action, String button) =>
      ControlBindings({..._changes, action: button});

  ControlBindings reset(ControlAction action) =>
      ControlBindings({..._changes}..remove(action));

  /// Replaces each known action token with the player's button. Other
  /// brackets are left alone.
  String resolve(String text) => text.replaceAllMapped(_token, (match) {
        final action = ControlAction.fromLabel(match.group(1)!);
        return action == null ? match.group(0)! : buttonFor(action);
      });

  Map<String, dynamic> toJson() => {
        for (final entry in _changes.entries) entry.key.name: entry.value,
      };
}