// lib/domain/enums.dart

/// Progression categories. They describe training complexity, not competitive
/// rank, and a player can skip any of them.
enum Stage {
  beginner('Beginner'),
  bronze('Bronze'),
  silver('Silver'),
  gold('Gold'),
  platinum('Platinum'),
  diamond('Diamond'),
  champion('Champion'),
  grandChampion('Grand Champion'),
  ssl('SSL');

  const Stage(this.label);
  final String label;
}

enum SkillCategory {
  mechanics('Mechanics'),
  shooting('Shooting'),
  defense('Defense'),
  aerials('Aerials'),
  ballControl('Ball Control'),
  wallPlay('Wall Play'),
  recoveries('Recoveries'),
  gameSense('Game Sense'),
  positioning('Positioning'),
  boostManagement('Boost Management'),
  kickoffs('Kickoffs');

  const SkillCategory(this.label);
  final String label;
}

enum GameMode {
  oneVsOne('1v1'),
  twoVsTwo('2v2'),
  threeVsThree('3v3'),
  all('All');

  const GameMode(this.label);
  final String label;
}

/// `locked` and `maintenanceRecommended` are display states worked out from
/// prerequisites and dates. Only the other four are ever saved.
enum SkillStatus {
  locked('Locked'),
  notStarted('Not Started'),
  practicing('Practicing'),
  consistent('Consistent'),
  mastered('Mastered'),
  maintenanceRecommended('Maintenance Recommended');

  const SkillStatus(this.label);
  final String label;
}

enum PackStatus {
  active('Active'),
  needsVerification('Needs Verification'),
  retired('Retired');

  const PackStatus(this.label);
  final String label;
}

/// The in-game screens a Stat Check can read numbers from.
enum StatScreen {
  postMatch('Post-match scoreboard'),
  matchHistory('Match History'),
  trainingPackResult('Training pack results');

  const StatScreen(this.label);
  final String label;
}

/// `shotAccuracy` is goals divided by shots and `packScore` is shots made
/// divided by shots in the pack. Both are percentages.
enum StatMetric {
  goals('Goals'),
  assists('Assists'),
  saves('Saves'),
  shots('Shots'),
  score('Score'),
  shotAccuracy('Shot accuracy (%)'),
  packScore('Pack score (%)');

  const StatMetric(this.label);
  final String label;
}

/// Where a skill is normally practiced.
enum TrainingMethod {
  freeplay('Freeplay'),
  customTraining('Custom Training pack'),
  match('Match play');

  const TrainingMethod(this.label);
  final String label;
}

/// Finds an enum value by its `name` when reading JSON. Bad data raises a
/// clear error instead of quietly becoming a default.
T enumByName<T extends Enum>(List<T> values, Object? raw, String field) {
  for (final value in values) {
    if (value.name == raw) return value;
  }
  throw FormatException('Unknown $field "$raw"');
}