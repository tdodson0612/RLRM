// lib/data/exercise_library.dart

import '../models/exercise.dart';

/// Every exercise in the app. All of them need NO equipment: just your body
/// and some floor or wall space.
///
/// Honest limits of equipment-free training are written into each exercise's
/// `note`. Pulling (lats) and direct biceps work are the hardest to train
/// without a bar or weights, and the notes say so.
const List<Exercise> exerciseLibrary = [
  // ---------------------------------------------------------------- CHEST
  Exercise(
    id: 'push_up',
    name: 'Push-Up',
    region: BodyRegion.chest,
    targetMuscles:
        'Chest, triceps, front of the shoulders. Your core keeps your body straight.',
    instructions:
        'Start in a high plank with your hands just wider than your shoulders. '
        'Keep your body in one straight line from head to heels. '
        'Lower your chest toward the floor with your elbows about 45 degrees from your sides, then press back up. '
        'Too hard? Do them from your knees, or with your hands on a wall or counter.',
  ),
  Exercise(
    id: 'wide_push_up',
    name: 'Wide Push-Up',
    region: BodyRegion.chest,
    targetMuscles:
        'Chest (more emphasis than a regular push-up), front shoulders, triceps',
    instructions:
        'Same as a push-up, but place your hands about one and a half times shoulder width apart. '
        'Lower until your chest is just above the floor while keeping your hips level, then press up. '
        'Your elbows flare out more here, so go slowly.',
  ),

  // ------------------------------------------------------------- TRICEPS
  Exercise(
    id: 'diamond_push_up',
    name: 'Diamond Push-Up',
    region: BodyRegion.triceps,
    difficulty: Difficulty.intermediate,
    targetMuscles: 'Triceps, inner chest, front shoulders',
    instructions:
        'Start in a high plank with your hands close together under your chest, '
        'thumbs and index fingers almost touching. '
        'Lower your chest toward your hands with your elbows close to your body, then press up. '
        'Too hard? Do them from your knees.',
  ),
  Exercise(
    id: 'close_grip_push_up',
    name: 'Close-Grip Push-Up',
    region: BodyRegion.triceps,
    targetMuscles: 'Triceps, chest, front shoulders',
    instructions:
        'Place your hands directly under your shoulders, or a little narrower. '
        'Keep your elbows brushing your sides as you lower your chest, then press up. '
        'This is an easier triceps option than the diamond push-up.',
  ),

  // ----------------------------------------------------------- SHOULDERS
  Exercise(
    id: 'pike_push_up',
    name: 'Pike Push-Up',
    region: BodyRegion.shoulders,
    difficulty: Difficulty.intermediate,
    targetMuscles: 'Front and side shoulders, triceps, upper chest',
    instructions:
        'Start with your hands and feet on the floor and your hips high, so your body makes an upside-down V. '
        'Bend your elbows to lower the top of your head toward the floor between your hands, then press back up. '
        'Keep your hips high the whole time.',
  ),
  Exercise(
    id: 'shoulder_tap_plank',
    name: 'Shoulder Taps',
    region: BodyRegion.shoulders,
    targetMuscles:
        'Shoulder stabilizers, core (it resists twisting), chest',
    instructions:
        'Start in a high plank with your feet a little wider than hip width. '
        'Without letting your hips rock side to side, tap your left shoulder with your right hand, '
        'then your right shoulder with your left hand. That is one rep.',
  ),

  // ---------------------------------------------------------------- BACK
  Exercise(
    id: 'prone_iyt_raise',
    name: 'Floor I-Y-T Raise',
    region: BodyRegion.back,
    targetMuscles:
        'Middle and lower traps, rear shoulders, the muscles between your shoulder blades',
    instructions:
        'Lie face down with your arms straight out in front of you and your forehead just off the floor. '
        'Lift your arms into an I (overhead), lower them, lift into a Y, lower, then lift into a T (out to the sides). '
        'Squeeze your shoulder blades down and back each time. All three positions count as one rep. Use no weight.',
    note:
        'Floor-only back exercises are limited. This trains the upper-back muscles that control your shoulder blades. '
        'It puts very little load on your lats.',
  ),
  Exercise(
    id: 'superman_pull',
    name: 'Superman Pull',
    region: BodyRegion.back,
    targetMuscles:
        'Lower back, glutes, rear shoulders. Your lats get only light, indirect work.',
    instructions:
        'Lie face down with your arms straight overhead. '
        'Lift your chest, arms, and legs slightly off the floor. '
        'Bend your elbows and pull them back toward your ribs like a lat pull-down, then straighten your arms again. '
        'That is one rep. Keep your neck long and look at the floor.',
    note:
        'Pulling strength is the hardest thing to train without a bar. '
        'This is one of the better floor-only options, but the load on your lats is small.',
  ),
  Exercise(
    id: 'reverse_snow_angel',
    name: 'Reverse Snow Angel',
    region: BodyRegion.back,
    targetMuscles: 'Rear shoulders, middle and lower traps, lower back',
    instructions:
        'Lie face down with your arms at your sides, palms down. '
        'Lift your chest and arms slightly off the floor. '
        'Sweep your arms out and up overhead in a wide arc, keeping them off the floor, then sweep back to your sides. '
        'That is one rep.',
    note:
        'This builds upper-back endurance and shoulder control. The load is low, '
        'so it will not build a big back on its own.',
  ),
  Exercise(
    id: 'superman_hold',
    name: 'Superman Hold',
    region: BodyRegion.back,
    type: ExerciseType.time,
    startingGoal: 15,
    targetMuscles: 'Lower back (spinal erectors), glutes, hamstrings',
    instructions:
        'Lie face down with your arms overhead. '
        'Lift your arms, chest, and legs a few inches off the floor and hold, breathing normally. '
        'Look at the floor to keep your neck neutral. '
        'Lower down right away if your lower back pinches.',
  ),

  // -------------------------------------------------------------- BICEPS
  Exercise(
    id: 'self_resisted_curl',
    name: 'Self-Resisted Curl',
    region: BodyRegion.biceps,
    perSide: true,
    targetMuscles: 'Biceps and the muscle underneath it (brachialis)',
    instructions:
        'Stand or sit tall. Make a fist with your left hand and curl it slowly toward your shoulder (about 3 seconds up). '
        'At the same time, press down on your left wrist with your right hand so your left arm works against resistance. '
        'Lower slowly, keeping that pressure on. Do all reps, then switch arms. '
        'Use moderate pressure and stop if your elbow hurts.',
    note:
        'Direct biceps work without equipment is limited. The resistance comes from your other hand, '
        'so it will not match weighted curls. It is here so your biceps get some direct work.',
  ),

  // ---------------------------------------------------------------- CORE
  Exercise(
    id: 'plank',
    name: 'Plank',
    region: BodyRegion.core,
    type: ExerciseType.time,
    startingGoal: 20,
    targetMuscles:
        'Deep core (transverse abdominis), abs, obliques, shoulders, glutes',
    instructions:
        'Rest on your forearms and toes with your elbows under your shoulders. '
        'Keep your body in a straight line from head to heels. '
        'Squeeze your abs and glutes and breathe normally. '
        'Stop when your hips sag or your lower back hurts.',
  ),
  Exercise(
    id: 'crunch',
    name: 'Crunch',
    region: BodyRegion.core,
    targetMuscles: 'Abs (rectus abdominis)',
    instructions:
        'Lie on your back with your knees bent and feet flat, hands beside your head. '
        'Do not pull on your neck. Curl your ribs toward your hips so your shoulder blades lift off the floor. '
        'Pause, then lower slowly. The movement is small.',
  ),
  Exercise(
    id: 'mountain_climber',
    name: 'Mountain Climber',
    region: BodyRegion.core,
    targetMuscles: 'Abs, hip flexors, shoulders',
    instructions:
        'Start in a high plank. Drive one knee toward your chest, then switch legs, like running in place while holding a plank. '
        'Keep your hips level. One rep is a knee drive on each side.',
  ),
  Exercise(
    id: 'bicycle_crunch',
    name: 'Bicycle Crunch',
    region: BodyRegion.core,
    targetMuscles: 'Obliques and abs',
    instructions:
        'Lie on your back with your hands beside your head. '
        'Lift your shoulders, bring one knee in, and turn the opposite elbow toward it. '
        'Switch sides in a slow pedaling motion. One rep is one knee on each side.',
  ),
  Exercise(
    id: 'lying_leg_raise',
    name: 'Lying Leg Raise',
    region: BodyRegion.core,
    targetMuscles: 'Abs and hip flexors',
    instructions:
        'Lie on your back with your legs straight and your hands by your sides or under your hips. '
        'Keep your lower back pressed toward the floor as you lift both legs to point at the ceiling, '
        'then lower them slowly without letting your back arch. '
        'Bend your knees to make it easier.',
  ),
  Exercise(
    id: 'side_plank',
    name: 'Side Plank',
    region: BodyRegion.core,
    type: ExerciseType.time,
    startingGoal: 15,
    perSide: true,
    targetMuscles: 'Obliques, deep core, and the hip and glute muscles on your side',
    instructions:
        'Lie on your side with your forearm under your shoulder and your legs stacked. '
        'Lift your hips so your body forms a straight line from head to feet. Hold, then switch sides. '
        'Bend your knees and rest them on the floor to make it easier.',
  ),
  Exercise(
    id: 'hollow_hold',
    name: 'Hollow Hold',
    region: BodyRegion.core,
    type: ExerciseType.time,
    startingGoal: 10,
    difficulty: Difficulty.intermediate,
    targetMuscles: 'Abs, hip flexors, deep core',
    instructions:
        'Lie on your back. Press your lower back into the floor and lift your shoulders and straight legs a few inches off the floor, '
        'with your arms by your sides. Hold. '
        'If your back arches off the floor, bend your knees or raise your legs higher.',
  ),
  Exercise(
    id: 'bird_dog',
    name: 'Bird Dog',
    region: BodyRegion.core,
    perSide: true,
    targetMuscles: 'Deep core, lower back muscles, glutes',
    instructions:
        'Start on your hands and knees. Reach your right arm forward and your left leg back at the same time, '
        'keeping your hips and shoulders level. Pause, return, then switch sides. Move slowly.',
  ),

  // -------------------------------------------------------------- GLUTES
  Exercise(
    id: 'glute_bridge',
    name: 'Glute Bridge',
    region: BodyRegion.glutes,
    targetMuscles: 'Glutes, with help from the hamstrings and core',
    instructions:
        'Lie on your back with your knees bent and feet flat, hip width apart. '
        'Press through your heels to lift your hips until your body makes a straight line from shoulders to knees. '
        'Squeeze your glutes at the top, then lower with control.',
  ),
  Exercise(
    id: 'single_leg_glute_bridge',
    name: 'Single-Leg Glute Bridge',
    region: BodyRegion.glutes,
    perSide: true,
    targetMuscles: 'Glutes, hamstrings, core',
    instructions:
        'Lie on your back with one knee bent and that foot flat, and the other leg straight in the air. '
        'Press through your heel to lift your hips until your body is level. Lower with control. '
        'Do all reps on one side, then switch.',
  ),

  // --------------------------------------------------------------- QUADS
  Exercise(
    id: 'bodyweight_squat',
    name: 'Bodyweight Squat',
    region: BodyRegion.quads,
    targetMuscles: 'Quads, glutes, inner thighs. Hamstrings help.',
    instructions:
        'Stand with your feet shoulder width apart. '
        'Push your hips back and bend your knees as if sitting down onto an invisible seat, keeping your chest up and heels flat. '
        'Go down as far as you comfortably can, then stand up.',
  ),
  Exercise(
    id: 'reverse_lunge',
    name: 'Reverse Lunge',
    region: BodyRegion.quads,
    perSide: true,
    targetMuscles: 'Quads, glutes, hamstrings',
    instructions:
        'Stand tall. Step one foot back and lower until both knees are bent about 90 degrees, with your back knee just above the floor. '
        'Push through your front heel to stand. Count the reps for each leg. '
        'Rest a hand on a wall for balance if you need to.',
  ),
  Exercise(
    id: 'split_squat',
    name: 'Split Squat',
    region: BodyRegion.quads,
    perSide: true,
    targetMuscles: 'Quads, glutes',
    instructions:
        'Stand in a long staggered stance with one foot forward and one back. '
        'Lower your back knee toward the floor, keeping your front heel down and your torso upright, then push back up. '
        'Do all reps on one side, then switch. Rest a hand on a wall for balance if you need to.',
  ),
  Exercise(
    id: 'wall_sit',
    name: 'Wall Sit',
    region: BodyRegion.quads,
    type: ExerciseType.time,
    startingGoal: 20,
    targetMuscles: 'Quads, glutes',
    instructions:
        'Lean your back against a wall and slide down until your knees are bent about 90 degrees, '
        'with your knees over your ankles. Keep your back flat on the wall and breathe. '
        'Rest your hands on your thighs, not on your knees.',
  ),

  // ---------------------------------------------------------- HAMSTRINGS
  Exercise(
    id: 'single_leg_rdl',
    name: 'Single-Leg Hip Hinge',
    region: BodyRegion.hamstrings,
    perSide: true,
    targetMuscles: 'Hamstrings, glutes, and the small muscles that keep you balanced',
    instructions:
        'Stand on one leg with a soft knee. Hinge at your hips, sending your other leg straight back behind you '
        'while your chest lowers toward the floor and your back stays flat. '
        'Go until you feel a stretch in the hamstring of your standing leg, then squeeze your glute to stand up. '
        'Touch a wall for balance if you need to.',
    note:
        'Hamstrings are hard to load with body weight alone. Single-leg hinges and bridge walkouts '
        'are the best equipment-free options.',
  ),
  Exercise(
    id: 'bridge_walkout',
    name: 'Bridge Walkout',
    region: BodyRegion.hamstrings,
    difficulty: Difficulty.intermediate,
    targetMuscles: 'Hamstrings, glutes',
    instructions:
        'Get into a glute bridge. Keeping your hips up, walk your feet away from your body in small steps '
        'until your legs are nearly straight, then walk them back in. That is one rep. '
        'If your hamstrings cramp, use smaller steps.',
  ),

  // -------------------------------------------------------------- CALVES
  Exercise(
    id: 'calf_raise',
    name: 'Calf Raise',
    region: BodyRegion.calves,
    targetMuscles: 'Calf muscles (gastrocnemius and soleus)',
    instructions:
        'Stand with your feet hip width apart and one hand lightly on a wall for balance. '
        'Rise onto the balls of your feet as high as you can, pause, then lower slowly.',
  ),
  Exercise(
    id: 'single_leg_calf_raise',
    name: 'Single-Leg Calf Raise',
    region: BodyRegion.calves,
    perSide: true,
    targetMuscles: 'Calf muscles',
    instructions:
        'Stand on one foot, holding a wall for balance. '
        'Rise onto the ball of your foot as high as you can, pause, then lower slowly. '
        'Do all reps on one leg, then switch.',
  ),

  // --------------------------------------------------------------- SHINS
  Exercise(
    id: 'tibialis_wall_raise',
    name: 'Shin Raise (Wall)',
    region: BodyRegion.shins,
    targetMuscles: 'Tibialis anterior (the muscle on the front of your shin)',
    instructions:
        'Stand with your back against a wall and your heels about a foot and a half away from it, legs straight. '
        'Keeping your heels on the floor, pull your toes up toward your shins as high as you can, then lower slowly.',
    note:
        'This muscle is small, so move slowly. Stop if you feel sharp shin pain.',
  ),

  // ----------------------------------------------------------- FULL BODY
  Exercise(
    id: 'burpee',
    name: 'Burpee',
    region: BodyRegion.fullBody,
    difficulty: Difficulty.intermediate,
    targetMuscles: 'Legs, chest, shoulders, core (whole body)',
    instructions:
        'Stand tall. Squat down and put your hands on the floor. '
        'Step or jump your feet back into a plank, then step or jump them back in. '
        'Stand up and reach overhead, jumping if you like. '
        'Step instead of jumping if you are new to it.',
  ),
];

final Map<String, Exercise> _byId = {
  for (final exercise in exerciseLibrary) exercise.id: exercise,
};

/// Returns the exercise with this id, or null if it no longer exists.
Exercise? findExercise(String id) => _byId[id];

/// Returns the exercise with this id. Throws if the id is unknown,
/// which means there is a typo in the weekly plan.
Exercise exerciseById(String id) =>
    findExercise(id) ?? (throw StateError('Unknown exercise id: $id'));

List<Exercise> exercisesForRegion(BodyRegion region) =>
    exerciseLibrary.where((e) => e.region == region).toList();
