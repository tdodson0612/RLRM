// lib/data/weekly_plan.dart

import '../models/workout_day.dart';

/// The weekly split: an upper/lower split.
///
/// Why this shape:
/// - Every major area is trained about twice a week (the ACSM minimum),
///   with 72 hours between sessions of the same area.
/// - No two consecutive days train the same big muscle groups.
/// - Two full rest days.
/// - 5 to 7 exercises per day, 2 sets each, so a workout stays short.
const List<WorkoutDay> weeklyPlan = [
  WorkoutDay(
    weekday: 1,
    name: 'Upper A',
    focus: 'Chest, triceps, back',
    exerciseIds: [
      'push_up',
      'wide_push_up',
      'diamond_push_up',
      'prone_iyt_raise',
      'superman_pull',
      'plank',
    ],
  ),
  WorkoutDay(
    weekday: 2,
    name: 'Lower A',
    focus: 'Quads, glutes, calves',
    exerciseIds: [
      'bodyweight_squat',
      'reverse_lunge',
      'glute_bridge',
      'wall_sit',
      'calf_raise',
    ],
  ),
  WorkoutDay(
    weekday: 3,
    name: 'Rest Day',
    focus: 'Recovery',
    exerciseIds: [],
  ),
  WorkoutDay(
    weekday: 4,
    name: 'Upper B',
    focus: 'Shoulders, back, arms',
    exerciseIds: [
      'pike_push_up',
      'close_grip_push_up',
      'shoulder_tap_plank',
      'reverse_snow_angel',
      'superman_hold',
      'self_resisted_curl',
      'crunch',
    ],
  ),
  WorkoutDay(
    weekday: 5,
    name: 'Lower B',
    focus: 'Hamstrings, glutes, shins',
    exerciseIds: [
      'single_leg_rdl',
      'single_leg_glute_bridge',
      'bridge_walkout',
      'split_squat',
      'single_leg_calf_raise',
      'tibialis_wall_raise',
    ],
  ),
  WorkoutDay(
    weekday: 6,
    name: 'Core + Full Body',
    focus: 'Core and whole-body conditioning',
    exerciseIds: [
      'burpee',
      'mountain_climber',
      'bicycle_crunch',
      'lying_leg_raise',
      'side_plank',
      'hollow_hold',
      'bird_dog',
    ],
  ),
  WorkoutDay(
    weekday: 7,
    name: 'Rest Day',
    focus: 'Recovery',
    exerciseIds: [],
  ),
];

const List<String> weekdayNames = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

/// [weekday] uses DateTime.weekday numbers: 1 = Monday ... 7 = Sunday.
WorkoutDay planForWeekday(int weekday) =>
    weeklyPlan.firstWhere((day) => day.weekday == weekday);

String weekdayName(int weekday) => weekdayNames[weekday - 1];
