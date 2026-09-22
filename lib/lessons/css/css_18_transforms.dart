// lib/lessons/css/css_18_transforms.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cssLesson18 = Lesson(
  language: 'CSS',
  title: 'Transforms',
  content: '''
🎯 METAPHOR:
CSS transforms are like camera tricks in photography.
You can move the subject (translate), zoom in or out (scale),
spin the camera (rotate), or tilt the camera for a perspective
distortion (skew). Critically — the subject hasn't actually
moved in the room. The chair is still in the same spot in
the studio. Transform changes HOW it appears in the photo
without reorganizing the furniture. Other elements don't
react because nothing "really" moved.
That's what makes transform perfect for animations —
no layout recalculation, just visual changes.

📖 EXPLANATION:
transform applies visual transformations to an element.
The element's space in the layout is NOT affected.
(Unlike left/top/margin which DO affect layout.)

TRANSFORM FUNCTIONS:
  translate(x, y)          move
  translateX(x) / translateY(y) / translateZ(z)
  scale(x, y)              resize
  rotate(angle)            spin
  skew(x, y)               shear/tilt
  perspective(distance)    3D depth

3D TRANSFORMS:
  rotateX / rotateY / rotateZ
  translate3d(x, y, z)
  scale3d(x, y, z)

CONTROL:
  transform-origin   pivot point (default: center center)
  perspective        3D perspective on parent
  transform-style: preserve-3d   enable true 3D

MULTIPLE TRANSFORMS:
  Combine with spaces: transform: rotate(45deg) scale(1.2)
  Order matters! Applied right-to-left.

💻 CODE:
/* ─── TRANSLATE ─── */
.move-right    { transform: translateX(50px); }
.move-down     { transform: translateY(20px); }
.move-both     { transform: translate(50px, 20px); }
.center-trick  { transform: translate(-50%, -50%); } /* center absolute */

/* ─── SCALE ─── */
.bigger  { transform: scale(1.2); }   /* 120% */
.smaller { transform: scale(0.8); }   /* 80% */
.flip-h  { transform: scaleX(-1); }   /* horizontal flip */
.flip-v  { transform: scaleY(-1); }   /* vertical flip */

/* ─── ROTATE ─── */
.rotated-45  { transform: rotate(45deg); }
.rotated-neg { transform: rotate(-10deg); }
.spin        { transform: rotate(360deg); }

/* ─── SKEW ─── */
.italic-box  { transform: skewX(15deg); }
.parallelogram { transform: skewX(-20deg); }

/* ─── COMBINING TRANSFORMS ─── */
/* Applied right-to-left: scale first, then translate, then rotate */
.combined {
  transform: rotate(15deg) translateY(-10px) scale(1.05);
}

/* ─── TRANSFORM ORIGIN ─── */
.rotate-top-left {
  transform-origin: top left;
  transform: rotate(20deg);
}
.rotate-bottom {
  transform-origin: bottom center;
  transform: rotate(5deg);
}
/* Values: keywords or % or px */
.custom-origin { transform-origin: 20% 80%; }

/* ─── 3D TRANSFORMS ─── */
/* Need perspective on the parent */
.scene {
  perspective: 800px;     /* viewing distance — smaller = more extreme */
}

.card-3d {
  transform: rotateY(30deg);
  transform-style: preserve-3d;
}

/* Card flip effect */
.flipper {
  transform-style: preserve-3d;
  transition: transform 600ms ease;
}
.flipper:hover {
  transform: rotateY(180deg);
}
.front, .back {
  backface-visibility: hidden;   /* hide back face */
}
.back {
  transform: rotateY(180deg);   /* pre-rotated to back */
}

/* ─── PRACTICAL PATTERNS ─── */
/* Button press effect */
.btn {
  transition: transform 100ms ease;
}
.btn:active {
  transform: scale(0.96) translateY(1px);
}

/* Hover lift */
.card {
  transition: transform 200ms ease;
}
.card:hover {
  transform: translateY(-4px);
}

/* Chevron/arrow rotation */
.accordion-toggle { transition: transform 300ms ease; }
.accordion-toggle.open { transform: rotate(180deg); }

/* Loading spinner */
@keyframes spin {
  to { transform: rotate(360deg); }
}
.spinner { animation: spin 1s linear infinite; }

/* Shake animation */
@keyframes shake {
  0%, 100% { transform: translateX(0); }
  20%       { transform: translateX(-8px); }
  40%       { transform: translateX(8px); }
  60%       { transform: translateX(-4px); }
  80%       { transform: translateX(4px); }
}
.error { animation: shake 400ms ease; }

📝 KEY POINTS:
✅ transform does NOT affect layout — use it freely for animations
✅ translate(-50%, -50%) is the classic trick for centering absolutely positioned elements
✅ Order of transforms matters — rotate then translate differs from translate then rotate
✅ transform-origin controls the pivot point for rotation and scale
✅ preserve-3d on parent enables true 3D child transforms
❌ Don't mix transforms with top/left/margin for animation — use transform only
❌ backface-visibility: hidden is needed for card-flip effects
''',
  quiz: [
    Quiz(question: 'Why is transform preferred over top/left for animations?', options: [
      QuizOption(text: 'Transform does not cause layout recalculation — it is GPU-accelerated and does not affect other elements', correct: true),
      QuizOption(text: 'Transform is easier to write', correct: false),
      QuizOption(text: 'top/left does not work with transitions', correct: false),
      QuizOption(text: 'Transform works on all elements; top/left only on positioned elements', correct: false),
    ]),
    Quiz(question: 'What does transform: scaleX(-1) do?', options: [
      QuizOption(text: 'Flips the element horizontally — a mirror image', correct: true),
      QuizOption(text: 'Collapses the element to zero width', correct: false),
      QuizOption(text: 'Scales the element to -1px width', correct: false),
      QuizOption(text: 'Inverts the element colors', correct: false),
    ]),
    Quiz(question: 'What does transform-origin control?', options: [
      QuizOption(text: 'The pivot point around which transforms like rotation and scale happen', correct: true),
      QuizOption(text: 'Where the element starts before the transform is applied', correct: false),
      QuizOption(text: 'The direction of the transform', correct: false),
      QuizOption(text: 'Whether the transform affects layout or not', correct: false),
    ]),
  ],
);
