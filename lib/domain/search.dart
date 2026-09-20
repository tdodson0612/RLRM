// lib/domain/search.dart

import 'models/curriculum_model.dart';
import 'models/skill_model.dart';
import 'models/training_pack_model.dart';

class SearchResults {
  const SearchResults({
    this.skills = const [],
    this.packs = const [],
    this.related = const [],
  });

  final List<SkillModel> skills;
  final List<TrainingPackModel> packs;

  /// Prerequisites of the best matches, worth learning first.
  final List<SkillModel> related;

  bool get isEmpty => skills.isEmpty && packs.isEmpty;
}

/// Finds skills and packs by name, category, stage and lesson wording. Every
/// word in the query has to match somewhere, and name matches rank highest.
abstract final class Search {
  static SearchResults run(CurriculumModel curriculum, String query) {
    final terms = query
        .toLowerCase()
        .split(RegExp(r'\s+'))
        .where((t) => t.isNotEmpty)
        .map(_stem)
        .toList();
    if (terms.isEmpty) return const SearchResults();

    final scored = <(SkillModel, int, int)>[];
    for (var i = 0; i < curriculum.skills.length; i++) {
      final skill = curriculum.skills[i];
      final total = _scoreSkill(skill, terms);
      if (total > 0) scored.add((skill, total, i));
    }
    scored.sort((a, b) {
      final byScore = b.$2.compareTo(a.$2);
      return byScore != 0 ? byScore : a.$3.compareTo(b.$3);
    });
    final skills = [for (final r in scored) r.$1];
    final skillIds = {for (final s in skills) s.id};
    final topIds = {for (final s in skills.take(5)) s.id};

    final packs = <(TrainingPackModel, int)>[];
    for (final pack in curriculum.trainingPacks) {
      var total = _scorePack(pack, curriculum, terms);
      if (total == 0 && pack.skills.any(topIds.contains)) total = 1;
      if (total > 0) packs.add((pack, total));
    }
    packs.sort((a, b) => b.$2.compareTo(a.$2));

    final related = <SkillModel>[];
    for (final skill in skills.take(3)) {
      for (final id in skill.prerequisites) {
        final need = curriculum.skillById(id);
        if (need != null &&
            !skillIds.contains(id) &&
            !related.any((s) => s.id == id)) {
          related.add(need);
        }
      }
    }

    return SearchResults(
      skills: skills,
      packs: [for (final r in packs) r.$1],
      related: related,
    );
  }

  /// "flicks" should find "flick". Only a trailing plural s is removed.
  static String _stem(String term) =>
      term.length > 3 && term.endsWith('s')
          ? term.substring(0, term.length - 1)
          : term;

  /// 0 means at least one word did not match anywhere.
  static int _scoreSkill(SkillModel skill, List<String> terms) {
    final name = skill.name.toLowerCase();
    final labels = '${skill.category.label} ${skill.stage.label}'.toLowerCase();
    final body = [
      skill.description,
      skill.whyItMatters,
      ...skill.instructions,
      ...skill.commonMistakes,
      ...skill.drills.map((d) => d.text),
    ].join(' ').toLowerCase();
    var total = 0;
    for (final term in terms) {
      var score = 0;
      if (name.contains(term)) {
        score += name.startsWith(term) || name.contains(' $term') ? 12 : 8;
      }
      if (labels.contains(term)) score += 6;
      if (body.contains(term)) score += 2;
      if (score == 0) return 0;
      total += score;
    }
    return total;
  }

  static int _scorePack(
    TrainingPackModel pack,
    CurriculumModel curriculum,
    List<String> terms,
  ) {
    final name = pack.name.toLowerCase();
    final details = [
      pack.creator ?? '',
      pack.description,
      pack.difficulty.label,
      ...pack.categories.map((c) => c.label),
    ].join(' ').toLowerCase();
    final skillNames = pack.skills
        .map((id) => curriculum.skillById(id)?.name ?? '')
        .join(' ')
        .toLowerCase();
    var total = 0;
    for (final term in terms) {
      var score = 0;
      if (name.contains(term)) score += 12;
      if (details.contains(term)) score += 4;
      if (skillNames.contains(term)) score += 3;
      if (score == 0) return 0;
      total += score;
    }
    return total;
  }
}