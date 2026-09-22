// lib/lessons/css/css_38_motion_masking.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cssLesson38 = Lesson(
  language: 'CSS',
  title: 'Motion Path, Masking, and Cursor',
  content: '''
🎯 METAPHOR:
Motion path is like a train on rails. Without it, you can
only move elements in straight lines (translate X and Y).
With offset-path, you lay down curved tracks and the element
follows them precisely — looping around a circle, tracing
a logo shape, following a bezier curve — all in pure CSS.

Masking is like a stencil. You define a shape or image as
the stencil, place it over your content, and only the parts
visible through the stencil holes show. Use a radial gradient
mask and content fades from center to edge. Use an SVG path
mask and content appears only within that shape.

📖 EXPLANATION:
MOTION PATH:
  offset-path: path("M0,0 C100,0 100,100 0,100")  — SVG path
  offset-path: circle(50%)          — shape function
  offset-path: ray(45deg)           — angle-based
  offset-distance: 0% → 100%        — how far along path
  offset-rotate: auto | angle       — auto aligns to path direction

MASKING:
  mask-image: url(mask.png) | linear-gradient() | radial-gradient()
  mask-size: cover | contain | width height
  mask-repeat: no-repeat | repeat
  mask-position: center
  mask-composite: intersect | subtract | add | exclude

CSS CLIP PATH (see lesson 23):
  clip-path: polygon() | circle() | ellipse() | inset() | path()
  Clips the visible area — no anti-aliasing on some browsers

CURSOR:
  cursor: pointer | crosshair | grab | grabbing | zoom-in | move
  cursor: url('/cursor.cur'), auto  — custom cursor

💻 CODE:
/* ─── MOTION PATH ─── */
.orbit {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  background: #6c63ff;

  /* The path to follow — SVG ellipse path */
  offset-path: path("M 200,100 A 200,100 0 1 1 200,99.9");
  offset-distance: 0%;
  offset-rotate: 0deg;  /* don't rotate with path */

  animation: orbit 4s linear infinite;
}

@keyframes orbit {
  to { offset-distance: 100%; }
}

/* ─── CIRCULAR ORBIT ─── */
.planet {
  offset-path: circle(120px at 50% 50%);
  offset-distance: 0%;
  animation: circle-orbit 3s linear infinite;
}

@keyframes circle-orbit {
  to { offset-distance: 100%; }
}

/* ─── FOLLOWING A BEZIER CURVE ─── */
.particle {
  offset-path: path("M 0,200 C 50,0 150,400 200,200");
  animation: follow-curve 2s ease-in-out infinite alternate;
}

@keyframes follow-curve {
  from { offset-distance: 0%; }
  to   { offset-distance: 100%; }
}

/* offset-rotate: auto makes element face the direction of travel */
.car {
  offset-path: path("M 0,0 Q 200,0 200,200 Q 200,400 0,400");
  offset-rotate: auto;  /* car "turns" as it follows path */
  animation: drive 3s linear infinite;
}

@keyframes drive { to { offset-distance: 100%; } }

/* ─── MASKING ─── */
/* Fade out at edges with gradient mask */
.fade-edges {
  mask-image: radial-gradient(
    ellipse at center,
    black 60%,
    transparent 100%
  );
}

/* Horizontal fade for image carousel */
.carousel-mask {
  mask-image: linear-gradient(
    to right,
    transparent 0%,
    black 10%,
    black 90%,
    transparent 100%
  );
}

/* Image cut into a circle with gradient edge */
.circular-fade {
  mask-image: radial-gradient(circle, black 70%, transparent 100%);
  mask-size: 100% 100%;
}

/* ─── SVG MASK ─── */
.text-reveal {
  mask-image: url('mask-shape.svg');
  mask-size: cover;
  mask-repeat: no-repeat;
  mask-position: center;
}

/* ─── WEBKIT PREFIX (still needed for Safari) ─── */
.masked {
  -webkit-mask-image: radial-gradient(circle, black 60%, transparent 100%);
  mask-image: radial-gradient(circle, black 60%, transparent 100%);
}

/* ─── MASK COMPOSITE ─── */
.complex-mask {
  /* Multiple mask layers */
  mask-image:
    url('highlight.svg'),
    linear-gradient(black, black);
  mask-composite: intersect;
  /* Shows only area where BOTH masks overlap */
}

/* ─── CURSOR ─── */
/* Standard cursors */
.clickable     { cursor: pointer; }
.not-allowed   { cursor: not-allowed; }
.draggable     { cursor: grab; }
.dragging      { cursor: grabbing; }
.resizable     { cursor: ew-resize; }
.text-input    { cursor: text; }
.zoom-in-area  { cursor: zoom-in; }
.move-handle   { cursor: move; }
.crosshair     { cursor: crosshair; }

/* Custom cursor */
.custom-cursor {
  cursor: url('/cursors/wand.cur'), url('/cursors/wand.png'), auto;
  /* Fallback chain: .cur → .png → system default */
}

/* ─── CSS POINTER EVENTS ─── */
.overlay {
  pointer-events: none;  /* clicks pass through */
}

.overlay .interactive {
  pointer-events: auto;  /* re-enable for specific children */
}

/* Disable all interaction */
.disabled-area {
  pointer-events: none;
  opacity: 0.5;
  cursor: not-allowed;
}

📝 KEY POINTS:
✅ offset-path animates elements along SVG paths, shapes, or rays
✅ offset-rotate: auto makes elements face the direction of travel on the path
✅ mask-image with gradients creates smooth edge fades on images or elements
✅ Always include -webkit-mask-image for Safari alongside mask-image
✅ pointer-events: none lets clicks pass through overlay elements
✅ cursor: grab / grabbing provides intuitive drag UX
❌ mask-image support varies — test in Safari (requires -webkit- prefix)
❌ Don't override cursor to a confusing type — pointer means clickable
''',
  quiz: [
    Quiz(question: 'What does offset-distance: 100% do in motion path animation?', options: [
      QuizOption(text: 'Moves the element to the end of the defined offset-path', correct: true),
      QuizOption(text: 'Scales the element to 100% of its path size', correct: false),
      QuizOption(text: 'Repeats the animation 100 times', correct: false),
      QuizOption(text: 'Sets the element\'s travel speed to maximum', correct: false),
    ]),
    Quiz(question: 'What does mask-image: radial-gradient(circle, black 60%, transparent 100%) do?', options: [
      QuizOption(text: 'Shows the center 60% of the element clearly and fades to invisible at the edges', correct: true),
      QuizOption(text: 'Creates a black circle covering 60% of the element', correct: false),
      QuizOption(text: 'Clips the element to a circle shape', correct: false),
      QuizOption(text: 'Makes the element 60% transparent', correct: false),
    ]),
    Quiz(question: 'What does pointer-events: none do?', options: [
      QuizOption(text: 'Makes the element invisible to mouse clicks and hover — events pass through to elements below', correct: true),
      QuizOption(text: 'Disables all CSS transitions on the element', correct: false),
      QuizOption(text: 'Hides the cursor when hovering over the element', correct: false),
      QuizOption(text: 'Removes all event listeners attached via JavaScript', correct: false),
    ]),
  ],
);
