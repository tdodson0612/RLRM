// lib/features/search/search_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/app_card.dart';
import '../../data/curriculum_repository.dart';
import '../../domain/models/curriculum_model.dart';
import '../../domain/models/skill_model.dart';
import '../../domain/search.dart';
import '../skills/skill_detail_screen.dart';
import '../training/pack_card.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final curriculum = ref.watch(curriculumProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: curriculum.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Padding(
          padding: const EdgeInsets.all(16),
          child: Text('Could not search: $error'),
        ),
        data: _results,
      ),
    );
  }

  Widget _results(CurriculumModel curriculum) {
    final theme = Theme.of(context);
    final results = Search.run(curriculum, _query);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextField(
          autofocus: true,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: 'Search skills, packs and terms',
          ),
          onChanged: (value) => setState(() => _query = value),
        ),
        const SizedBox(height: 16),
        if (_query.trim().isEmpty)
          Text(
            'Try: flick, shadow, air roll, kickoff, boost, defense, gold',
            style: theme.textTheme.bodyMedium,
          )
        else if (results.isEmpty)
          Text('Nothing found. Try a shorter word.',
              style: theme.textTheme.bodyMedium)
        else ...[
          if (results.skills.isNotEmpty) ...[
            _heading('Skills'),
            _skillList(results.skills.take(20).toList()),
          ],
          if (results.packs.isNotEmpty) ...[
            _heading('Training packs'),
            for (final pack in results.packs.take(10))
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: PackCard(pack: pack, curriculum: curriculum),
              ),
          ],
          if (results.related.isNotEmpty) ...[
            _heading('Learn these first'),
            _skillList(results.related),
          ],
        ],
      ],
    );
  }

  Widget _heading(String text) => Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 8),
        child: Text(text, style: Theme.of(context).textTheme.titleMedium),
      );

  Widget _skillList(List<SkillModel> skills) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppCard(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            for (final skill in skills)
              ListTile(
                title: Text(skill.name),
                subtitle: Text('${skill.stage.label} · ${skill.category.label}'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => SkillDetailScreen(skill: skill),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}