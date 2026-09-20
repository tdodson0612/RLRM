// test/domain/models_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:roadmap_for_rl/domain/enums.dart';
import 'package:roadmap_for_rl/domain/models/curriculum_model.dart';
import 'package:roadmap_for_rl/domain/models/progress_model.dart';
import 'package:roadmap_for_rl/domain/models/skill_model.dart';
import 'package:roadmap_for_rl/domain/models/training_pack_model.dart';

Map<String, dynamic> skillJson(String id, {List<String> needs = const []}) => {
      'id': id,
      'name': 'Skill $id',
      'stage': 'silver',
      'category': 'ballControl',
      'description': 'Keep the ball near your car.',
      'whyItMatters': 'Control leads to shots.',
      'whatItUnlocks': 'Leads to: Catching.',
      'instructions': ['Press [Jump].'],
      'drills': [
        {'id': '$id.drill1', 'title': 'Basic', 'text': 'Do it 5 times.'},
      ],
      'masteryRequirements': [
        {'id': '$id.mastery1', 'text': 'Do it 10 times.'},
      ],
      'matchApplicationRequirements': [
        {'id': '$id.match1', 'text': 'Use it in a match.'},
      ],
      'prerequisites': needs,
      'trainingPackIds': ['pack_a'],
      'applicableModes': ['oneVsOne', 'twoVsTwo'],
      'optional': false,
      'estimatedMinutes': 10,
      'maintenanceIntervalDays': 45,
      'trainingMethod': 'customTraining',
      'commonMistakes': ['Too much boost.'],
      'easierDrill': 'Go slower.',
      'statChecks': [
        {
          'screen': 'postMatch',
          'metric': 'saves',
          'minimum': 1.0,
          'label': 'Save once a match',
          'matches': 1,
        },
      ],
    };

Map<String, dynamic> packJson() => {
      'id': 'pack_a',
      'name': 'Sample Pack',
      'code': 'AAAA-BBBB-CCCC-DDDD',
      'description': 'Sample.',
      'categories': ['shooting'],
      'skills': ['a'],
      'applicableModes': ['all'],
      'difficulty': 'gold',
      'source': 'Test data',
      'status': 'active',
      'creator': 'Someone',
      'sourceUrl': 'https://example.com',
      'verifiedDate': '2026-09-20',
      'lastChecked': '2026-09-20',
      'verificationNotes': 'Test.',
    };

void main() {
  test('SkillModel reads and writes the same JSON', () {
    final skill = SkillModel.fromJson(skillJson('a'));
    expect(skill.stage, Stage.silver);
    expect(skill.maintenanceInterval, const Duration(days: 45));
    expect(skill.drills.single.id, 'a.drill1');
    expect(skill.toJson(), skillJson('a'));
  });

  test('appliesTo respects the chosen mode', () {
    final skill = SkillModel.fromJson(skillJson('a'));
    expect(skill.appliesTo(GameMode.oneVsOne), isTrue);
    expect(skill.appliesTo(GameMode.threeVsThree), isFalse);
    expect(skill.appliesTo(GameMode.all), isTrue);
  });

  test('TrainingPackModel round trips and defaults to needing verification', () {
    final pack = TrainingPackModel.fromJson(packJson());
    expect(pack.isActive, isTrue);
    expect(pack.toJson(), packJson());
    final unchecked = TrainingPackModel.fromJson(packJson()..remove('status'));
    expect(unchecked.status, PackStatus.needsVerification);
  });

  test('ProgressModel round trips and copyWith keeps the rest', () {
    const start = ProgressModel(skillId: 'a');
    final now = DateTime.utc(2026, 9, 20, 12);
    final next = start.copyWith(
      status: SkillStatus.practicing,
      completedDrills: {'a.drill1'},
      lastPracticed: now,
      favorite: true,
    );
    expect(next.skillId, 'a');
    expect(next.notes, '');
    final restored = ProgressModel.fromJson(next.toJson());
    expect(restored.status, SkillStatus.practicing);
    expect(restored.completedDrills, {'a.drill1'});
    expect(restored.lastPracticed, now);
    expect(restored.favorite, isTrue);
  });

  test('CurriculumModel looks things up and round trips', () {
    final data = <String, dynamic>{
      'version': '1.0.0',
      'packDataVersion': '1.0.0',
      'releaseDate': '2026-09-20',
      'lastUpdated': '2026-09-20',
      'skills': [
        skillJson('a'),
        skillJson('b', needs: ['a']),
      ],
      'trainingPacks': [packJson()],
    };
    final curriculum = CurriculumModel.fromJson(data);
    expect(curriculum.skillById('b')?.prerequisites, ['a']);
    expect(curriculum.packById('pack_a')?.name, 'Sample Pack');
    expect(curriculum.skillsIn(Stage.silver), hasLength(2));
    expect(curriculum.unlockedBy('a').single.id, 'b');
    expect(curriculum.toJson(), data);
  });

  test('unknown stage names fail loudly', () {
    expect(
      () => SkillModel.fromJson({...skillJson('a'), 'stage': 'bogus'}),
      throwsFormatException,
    );
  });
}