// lib/lessons/css/css_23_css_shapes_clip_path.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cssLesson23 = Lesson(
  language: 'CSS',
  title: 'CSS Shapes and clip-path',
  content: '''
🎯 METAPHOR:
clip-path is like a cookie cutter pressed onto an element.
The element is the dough — it can be any color, any content.
The clip-path is the cutter shape. Whatever falls outside
the cutter shape is invisible — clipped away. The element
is still there (still takes up space), but only the
shape you cut is visible. You can cut circles, polygons,
stars, arbitrary paths — anything.

shape-outside is the complementary concept: it tells
text how to flow AROUND a floated element based on a shape,
not just around a rectangle.

📖 EXPLANATION:
CLIP-PATH:
  clip-path cuts the visible area of an element to a shape.
  The element still occupies its full box in the layout.
  Can be animated for reveal effects.

SHAPE FUNCTIONS:
  inset(top right bottom left round radius)   rectangle with optional rounded corners
  circle(radius at x y)                       circle
  ellipse(rx ry at x y)                       ellipse
  polygon(x1 y1, x2 y2, ...)                  arbitrary polygon
  path("SVG path data")                        SVG path

SHAPE-OUTSIDE:
  Tells text to flow around a non-rectangular float.
  Only works on floated elements.

💻 CODE:
/* ─── BASIC CLIP-PATH ─── */
/* Circle */
.avatar {
  clip-path: circle(50%);         /* perfect circle */
  width: 100px;
  height: 100px;
}

.circle-small {
  clip-path: circle(40px at center);  /* explicit radius */
}

/* Ellipse */
.ellipse {
  clip-path: ellipse(60% 40% at center);
}

/* Rectangle inset */
.inset {
  clip-path: inset(10px 20px 10px 20px);           /* cut 10px from each side */
  clip-path: inset(10px round 16px);               /* with rounded corners */
}

/* ─── POLYGONS ─── */
/* Triangle */
.triangle-up {
  clip-path: polygon(50% 0%, 0% 100%, 100% 100%);
}
.triangle-right {
  clip-path: polygon(0% 0%, 100% 50%, 0% 100%);
}

/* Hexagon */
.hexagon {
  clip-path: polygon(
    50% 0%,
    100% 25%,
    100% 75%,
    50% 100%,
    0% 75%,
    0% 25%
  );
  width: 100px;
  height: 115px;
}

/* Pentagon */
.pentagon {
  clip-path: polygon(50% 0%, 100% 38%, 82% 100%, 18% 100%, 0% 38%);
}

/* Arrow shape */
.arrow {
  clip-path: polygon(0% 20%, 60% 20%, 60% 0%, 100% 50%, 60% 100%, 60% 80%, 0% 80%);
  background: #0066cc;
  width: 200px;
  height: 80px;
}

/* ─── DIAGONAL SECTION CUTS ─── */
.diagonal-top {
  clip-path: polygon(0 0, 100% 8vw, 100% 100%, 0 100%);
  padding-top: 8vw;   /* compensate for the cut */
}

.diagonal-bottom {
  clip-path: polygon(0 0, 100% 0, 100% calc(100% - 8vw), 0 100%);
  padding-bottom: 8vw;
}

.v-shape {
  clip-path: polygon(0 0, 100% 0, 100% 80%, 50% 100%, 0 80%);
}

/* ─── SVG PATH ─── */
.star {
  clip-path: path('M 50,0 L 61,35 L 98,35 L 68,57 L 79,91 L 50,70 L 21,91 L 32,57 L 2,35 L 39,35 Z');
  width: 100px;
  height: 91px;
}

/* ─── ANIMATED CLIP-PATH ─── */
/* Reveal effect */
.reveal {
  clip-path: inset(0 100% 0 0);  /* fully hidden */
  animation: reveal-left 800ms ease forwards;
}

@keyframes reveal-left {
  to { clip-path: inset(0 0% 0 0); } /* fully visible */
}

/* Expanding circle reveal */
.circle-reveal {
  clip-path: circle(0% at center);
  animation: expand-circle 600ms ease forwards;
}

@keyframes expand-circle {
  to { clip-path: circle(150% at center); }
}

/* ─── SHAPE-OUTSIDE (text wrapping) ─── */
/* Image that text wraps around in a circle */
.float-circle {
  float: left;
  width: 200px;
  height: 200px;
  shape-outside: circle(50%);  /* text flows around the circle */
  clip-path: circle(50%);       /* visual matches the shape */
  margin-right: 16px;
}

/* Diagonal text wrap */
.float-diagonal {
  float: left;
  width: 200px;
  height: 300px;
  shape-outside: polygon(0 0, 100% 0, 0 100%);
  /* text fills the area not covered by the triangle */
}

📝 KEY POINTS:
✅ clip-path polygon values are percentages by default — responsive
✅ Diagonal sections with clip-path need extra padding to compensate for the cut
✅ clip-path can be animated — use for elegant reveal effects
✅ shape-outside requires the element to be floated to work
✅ Use the online tool "clippy" (bennettfeely.com/clippy) to generate polygon values
❌ Elements outside clip-path are invisible but still capture mouse events by default
❌ shape-outside only affects text flow when the element is floated
''',
  quiz: [
    Quiz(question: 'What does clip-path do to an element?', options: [
      QuizOption(text: 'Makes only the specified shape visible — clips everything outside the shape', correct: true),
      QuizOption(text: 'Changes the element\'s shape in the layout', correct: false),
      QuizOption(text: 'Clips child elements to the parent shape', correct: false),
      QuizOption(text: 'Creates an SVG shape overlay', correct: false),
    ]),
    Quiz(question: 'What CSS is needed to create a pure circle from a square element?', options: [
      QuizOption(text: 'clip-path: circle(50%) on an element with equal width and height', correct: true),
      QuizOption(text: 'shape: circle(50%)', correct: false),
      QuizOption(text: 'border-radius: circle', correct: false),
      QuizOption(text: 'transform: circle(50%)', correct: false),
    ]),
    Quiz(question: 'What does shape-outside require to work?', options: [
      QuizOption(text: 'The element must be floated', correct: true),
      QuizOption(text: 'The element must have position: absolute', correct: false),
      QuizOption(text: 'The element must have clip-path applied', correct: false),
      QuizOption(text: 'The parent must have display: grid', correct: false),
    ]),
  ],
);
