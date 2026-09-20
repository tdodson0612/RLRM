// lib/domain/json_helpers.dart

import 'enums.dart';

List<String> stringList(Object? raw) =>
    List<String>.from(raw as List<dynamic>? ?? const <dynamic>[]);

List<T> enumList<T extends Enum>(List<T> values, Object? raw, String field) => [
      for (final item in raw as List<dynamic>? ?? const <dynamic>[])
        enumByName(values, item, field),
    ];

/// Reads a JSON list of objects, turning each one into a [T] with [read].
List<T> objectList<T>(Object? raw, T Function(Map<String, dynamic>) read) => [
      for (final item in raw as List<dynamic>? ?? const <dynamic>[])
        read(item as Map<String, dynamic>),
    ];

DateTime? dateOrNull(Object? raw) =>
    raw == null ? null : DateTime.parse(raw as String);

/// Writes a date as `2026-09-20`.
String? dateOnly(DateTime? date) => date?.toIso8601String().substring(0, 10);