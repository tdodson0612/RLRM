// lib/lessons/css/css_12_transitions_animations.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cssLesson12 = Lesson(
  language: 'CSS',
  title: 'Transitions and Animations',
  content: '''
🎯 METAPHOR:
CSS transitions are like dimmer switches.
Without them, a light either snaps ON or OFF instantly.
With a dimmer (transition), the light smoothly fades from
off to on over a moment. CSS transitions are that smooth
fade — instead of properties changing instantly, they
animate smoothly from old value to new value.

CSS animations are like a scripted stage performance.
You write a script (keyframes) that says what happens at
each percentage of the performance. At 0% the actor is
at stage left. At 50% they're center stage. At 100% they've
exited. The animation follows the script automatically,
repeating as many times as you specify.

📖 EXPLANATION:
TRANSITIONS — smooth change between two states:
  trigger (like :hover) causes a value to change
  transition animates that change smoothly

ANIMATIONS — scripted sequences that run automatically:
  @keyframes defines what happens at each point
  animation properties control playback

TIMING FUNCTIONS:
  ease         slow start, fast middle, slow end (default)
  linear       constant speed
  ease-in      slow start
  ease-out     slow end (feels natural for exits)
  ease-in-out  slow start and end (feels natural for movement)
  cubic-bezier(x1,y1,x2,y2) — custom curve

💻 CODE:
/* ─── TRANSITIONS ─── */
/* transition: property duration timing-function delay */
.btn {
  background-color: #0066cc;
  color: white;
  transition: background-color 200ms ease;
}

.btn:hover {
  background-color: #004d99;
}

/* Multiple properties */
.card {
  transform: translateY(0);
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
  transition: transform 250ms ease, box-shadow 250ms ease;
}

.card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 16px rgba(0,0,0,0.2);
}

/* Transition ALL properties (use carefully) */
.element { transition: all 300ms ease; }

/* ─── TRANSFORM (use WITH transitions) ─── */
/* Transform doesn't affect layout — GPU accelerated */
.move    { transform: translateX(100px) translateY(50px); }
.scale   { transform: scale(1.1); }     /* 110% size */
.rotate  { transform: rotate(45deg); }
.flip    { transform: scaleX(-1); }     /* horizontal flip */
.skew    { transform: skewX(15deg); }

/* Combine transforms */
.combined {
  transform: translate(-50%, -50%) scale(1.05) rotate(3deg);
}

/* Transform origin (pivot point) */
.rotate-corner {
  transform-origin: top left;
  transform: rotate(5deg);
}

/* ─── KEYFRAME ANIMATIONS ─── */
/* Define the animation script */
@keyframes fadeIn {
  from { opacity: 0; }
  to   { opacity: 1; }
}

@keyframes slideUp {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes pulse {
  0%   { transform: scale(1); }
  50%  { transform: scale(1.05); }
  100% { transform: scale(1); }
}

@keyframes spin {
  from { transform: rotate(0deg); }
  to   { transform: rotate(360deg); }
}

@keyframes bounce {
  0%, 100% { transform: translateY(0); animation-timing-function: ease-in; }
  50%       { transform: translateY(-20px); animation-timing-function: ease-out; }
}

/* Apply animations */
/* animation: name duration timing-function delay iteration-count direction fill-mode */
.fade-in  { animation: fadeIn 500ms ease forwards; }
.slide-up { animation: slideUp 400ms ease-out both; }
.spinner  { animation: spin 1s linear infinite; }
.loader   { animation: pulse 1.5s ease-in-out infinite; }

/* Multiple animations */
.complex {
  animation: fadeIn 500ms ease, slideUp 500ms ease;
}

/* ─── ANIMATION PROPERTIES ─── */
.animated {
  animation-name: fadeIn;
  animation-duration: 500ms;
  animation-timing-function: ease-out;
  animation-delay: 200ms;
  animation-iteration-count: 1;       /* or 'infinite' */
  animation-direction: normal;        /* or 'reverse', 'alternate' */
  animation-fill-mode: forwards;      /* keep end state */
  animation-play-state: running;      /* or 'paused' */
}

/* ─── PERFORMANCE ─── */
/* GPU-accelerated properties (use these for smooth animation): */
/* transform, opacity */
/* AVOID animating: width, height, margin, padding, top, left */
/* (they trigger expensive layout recalculations) */

.smooth-animation {
  transition: transform 300ms ease, opacity 300ms ease;
  /* NOT: transition: width 300ms, left 300ms — slow! */
}

📝 KEY POINTS:
✅ Only animate transform and opacity for smooth 60fps animations
✅ ease-out feels natural for UI — things decelerate as they settle
✅ animation-fill-mode: forwards keeps the end state visible
✅ animation-fill-mode: both applies initial state immediately (skips pre-animation flicker)
✅ Use prefers-reduced-motion media query to disable animations for accessibility
❌ Animating width, height, top, left causes layout reflow — causes jank
❌ Don't use transition: all — it's wasteful and animates things you don't expect
''',
  quiz: [
    Quiz(question: 'Which CSS properties should you animate for best performance?', options: [
      QuizOption(text: 'transform and opacity — they are GPU-accelerated', correct: true),
      QuizOption(text: 'width and height — most commonly animated', correct: false),
      QuizOption(text: 'margin and padding — for spacing animations', correct: false),
      QuizOption(text: 'top and left — for position animations', correct: false),
    ]),
    Quiz(question: 'What does animation-fill-mode: forwards do?', options: [
      QuizOption(text: 'Keeps the final animation state applied after the animation ends', correct: true),
      QuizOption(text: 'Makes the animation play forward instead of backward', correct: false),
      QuizOption(text: 'Applies the animation to all forward-facing elements', correct: false),
      QuizOption(text: 'Fills the element with the animation color', correct: false),
    ]),
    Quiz(question: 'What is the difference between a transition and a CSS animation?', options: [
      QuizOption(text: 'Transitions animate between two states triggered by events; animations run scripted sequences automatically', correct: true),
      QuizOption(text: 'Animations are smoother than transitions', correct: false),
      QuizOption(text: 'Transitions require JavaScript; animations are pure CSS', correct: false),
      QuizOption(text: 'They are identical — just different syntax', correct: false),
    ]),
  ],
);
