// lib/lessons/css/css_06_display_positioning.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cssLesson06 = Lesson(
  language: 'CSS',
  title: 'Display and Positioning',
  content: '''
🎯 METAPHOR:
CSS display is like deciding what KIND of furniture a piece is.
"Block" is like a sofa — it takes up the whole width of the
room, you can't put anything beside it without rearranging.
"Inline" is like a picture frame hung on the wall — it sits
next to other frames on the same line, as wide as needed.
"Inline-block" is a small side table — it sits inline BUT
you can set its width and height like block furniture.

CSS positioning is like deciding WHERE in the room furniture
goes and HOW it relates to the room.
"Static" is default — furniture placed in normal flow.
"Relative" is pushing the sofa a few inches from where it
naturally sits without removing it from the flow.
"Absolute" is floating the sofa in mid-air at exact coordinates.
"Fixed" is nailing a TV to the wall — it stays there as you
scroll through the room.

📖 EXPLANATION:
DISPLAY PROPERTY:
  block        — full width, new line, can have width/height
  inline       — flows with text, no width/height control
  inline-block — flows with text, CAN have width/height
  none         — removed from page completely
  flex         — flexbox container (next lesson)
  grid         — grid container (later lesson)

POSITION PROPERTY:
  static    — default, normal document flow
  relative  — offset FROM its normal position (stays in flow)
  absolute  — positioned relative to nearest positioned ancestor
  fixed     — positioned relative to viewport (stays on scroll)
  sticky    — relative until threshold, then fixed

💻 CODE:
/* ─── DISPLAY ─── */
span { display: block; }      /* make span act like div */
div  { display: inline; }     /* make div act like span */
li   { display: inline-block; }  /* inline but with dimensions */

/* Hide element but keep space */
.invisible { visibility: hidden; }

/* Remove element completely */
.hidden { display: none; }

/* ─── POSITION: RELATIVE ─── */
/* Moves FROM its normal position, KEEPS its space */
.nudged {
  position: relative;
  top: 10px;     /* move down 10px */
  left: 20px;    /* move right 20px */
}

/* ─── POSITION: ABSOLUTE ─── */
/* Positioned relative to nearest positioned ancestor */
/* (ancestor must have position: relative/absolute/fixed) */
.parent {
  position: relative;  /* establishes positioning context */
  width: 300px;
  height: 200px;
}

.child {
  position: absolute;
  top: 0;       /* top of parent */
  right: 0;     /* right of parent */
  /* Now child is in top-right corner of parent */
}

/* Center with absolute */
.centered {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
}

/* ─── POSITION: FIXED ─── */
/* Stays in place as user scrolls */
.sticky-nav {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  z-index: 1000;  /* appears above other content */
  background: white;
}

/* ─── POSITION: STICKY ─── */
/* Acts relative until it hits the threshold, then sticks */
.sticky-header {
  position: sticky;
  top: 0;          /* sticks when it reaches the top */
  background: white;
  z-index: 100;
}

/* ─── Z-INDEX ─── */
/* Controls stacking order — higher = on top */
.modal    { z-index: 1000; }
.overlay  { z-index: 999; }
.dropdown { z-index: 100; }
.content  { z-index: 1; }

/* z-index only works on positioned elements (not static) */

/* ─── COMMON PATTERNS ─── */
/* Badge/notification dot */
.button-wrapper {
  position: relative;
  display: inline-block;
}
.badge {
  position: absolute;
  top: -8px;
  right: -8px;
  background: red;
  color: white;
  border-radius: 50%;
  width: 20px;
  height: 20px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 12px;
}

📝 KEY POINTS:
✅ position: relative on parent is needed for absolute children to position correctly
✅ fixed elements are removed from normal flow — other content doesn't know they exist
✅ z-index only works on positioned elements (not position: static)
✅ The "transform: translate(-50%, -50%)" trick centers absolutely positioned elements
✅ sticky is like fixed but within its parent container
❌ Overusing absolute positioning leads to brittle, hard-to-maintain layouts
❌ z-index wars happen when everyone uses high z-index numbers — establish a scale
''',
  quiz: [
    Quiz(question: 'What makes "inline-block" different from "inline"?', options: [
      QuizOption(text: 'inline-block flows like inline but allows setting width and height', correct: true),
      QuizOption(text: 'inline-block takes up the full width like block', correct: false),
      QuizOption(text: 'inline-block only works on <span> elements', correct: false),
      QuizOption(text: 'inline-block removes the element from document flow', correct: false),
    ]),
    Quiz(question: 'For position: absolute to work relative to a parent, what must the parent have?', options: [
      QuizOption(text: 'A position other than static (relative, absolute, or fixed)', correct: true),
      QuizOption(text: 'A defined width and height', correct: false),
      QuizOption(text: 'display: block', correct: false),
      QuizOption(text: 'overflow: hidden', correct: false),
    ]),
    Quiz(question: 'What is the difference between position: fixed and position: sticky?', options: [
      QuizOption(text: 'fixed always stays at viewport coordinates; sticky is relative until it reaches its threshold', correct: true),
      QuizOption(text: 'sticky always stays at viewport coordinates; fixed is relative until threshold', correct: false),
      QuizOption(text: 'They are identical — just different names', correct: false),
      QuizOption(text: 'fixed stays within its parent; sticky is viewport-relative', correct: false),
    ]),
  ],
);
