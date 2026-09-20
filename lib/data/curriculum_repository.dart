// lib/data/curriculum_repository.dart

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/curriculum_model.dart';

const curriculumAsset = 'assets/curriculum/curriculum.json';

/// Reads the curriculum bundled inside the app, so it works fully offline.
class CurriculumRepository {
  const CurriculumRepository(this._bundle);

  final AssetBundle _bundle;

  Future<CurriculumModel> load() async {
    final raw = await _bundle.loadString(curriculumAsset);
    return CurriculumModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }
}

final curriculumProvider = FutureProvider<CurriculumModel>(
  (ref) => CurriculumRepository(rootBundle).load(),
);