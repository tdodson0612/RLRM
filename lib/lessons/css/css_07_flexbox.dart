// lib/lessons/css/css_07_flexbox.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cssLesson07 = Lesson(
  language: 'CSS',
  title: 'Flexbox',
  content: '''
🎯 METAPHOR:
Flexbox is like a smart waiter distributing dishes along a
table. You tell the waiter: "Put all dishes in a row,
space them evenly, and keep them centered vertically."
The waiter (flexbox) figures out the exact measurements.
You don't measure each dish's position — you declare the
RULES and the waiter handles the math. That's the power of
flexbox: describe the behavior, not the exact pixels.

There are two roles in flexbox:
  The CONTAINER (display: flex) — the table, makes the rules
  The ITEMS (children) — the dishes, follow the rules

📖 EXPLANATION:
Flexbox is a one-dimensional layout system (row OR column).
It is the standard way to:
  - Center things (finally easy!)
  - Distribute space between items
  - Build navigation bars
  - Create card layouts
  - Align elements of different sizes

─────────────────────────────────────
CONTAINER PROPERTIES:
─────────────────────────────────────
display: flex           activate flexbox
flex-direction          row | row-reverse | column | column-reverse
flex-wrap               nowrap | wrap | wrap-reverse
flex-flow               shorthand for direction + wrap
justify-content         alignment on MAIN axis
align-items             alignment on CROSS axis
align-content           multi-line cross axis alignment
gap                     space between items
─────────────────────────────────────

─────────────────────────────────────
ITEM PROPERTIES:
─────────────────────────────────────
flex-grow    how much extra space to take (0 = don't grow)
flex-shrink  how much to shrink when space is tight (1 = shrink)
flex-basis   initial size before growing/shrinking
flex         shorthand: grow shrink basis
align-self   override align-items for this item
order        change visual order (default: 0)
─────────────────────────────────────

💻 CODE:
/* ─── BASIC FLEXBOX ─── */
.container {
  display: flex;
  gap: 16px;  /* space between items */
}

/* ─── FLEX DIRECTION ─── */
.row    { flex-direction: row; }     /* default: left to right */
.column { flex-direction: column; } /* top to bottom */

/* ─── JUSTIFY-CONTENT (main axis) ─── */
.start   { justify-content: flex-start; }   /* default */
.end     { justify-content: flex-end; }
.center  { justify-content: center; }
.between { justify-content: space-between; } /* max space between */
.around  { justify-content: space-around; }  /* space around each */
.evenly  { justify-content: space-evenly; }  /* equal space everywhere */

/* ─── ALIGN-ITEMS (cross axis) ─── */
.top      { align-items: flex-start; }
.bottom   { align-items: flex-end; }
.middle   { align-items: center; }
.stretch  { align-items: stretch; }   /* default */
.baseline { align-items: baseline; }  /* align text baselines */

/* ─── PERFECT CENTERING ─── */
.center-everything {
  display: flex;
  justify-content: center;  /* horizontal */
  align-items: center;      /* vertical */
  min-height: 100vh;        /* full height */
}

/* ─── FLEX WRAP ─── */
.card-container {
  display: flex;
  flex-wrap: wrap;   /* items wrap to next line */
  gap: 16px;
}

/* ─── FLEX ITEM PROPERTIES ─── */
/* flex: grow shrink basis */
.item-equal { flex: 1; }              /* equal share of space */
.item-double { flex: 2; }            /* takes twice as much space */
.item-fixed  { flex: 0 0 200px; }   /* always 200px, no grow/shrink */
.item-grow   { flex: 1 0 auto; }    /* grow but don't shrink */

/* ─── PRACTICAL EXAMPLES ─── */

/* Navigation bar */
.nav {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0 24px;
  height: 64px;
}
.nav-logo { flex: 0 0 auto; }     /* logo doesn't grow/shrink */
.nav-links { display: flex; gap: 24px; }
.nav-actions { flex: 0 0 auto; }

/* Card with content at bottom */
.card {
  display: flex;
  flex-direction: column;
  height: 300px;
}
.card-body { flex: 1; }           /* takes all available space */
.card-footer { flex: 0 0 auto; } /* stays at bottom */

/* Holy grail layout */
.page {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
}
.header, .footer { flex: 0 0 auto; }
.main-area {
  display: flex;
  flex: 1;
}
.sidebar { flex: 0 0 200px; }
.content { flex: 1; }

📝 KEY POINTS:
✅ justify-content controls the MAIN axis (row = horizontal, column = vertical)
✅ align-items controls the CROSS axis (row = vertical, column = horizontal)
✅ flex: 1 on items gives them equal space — the most common usage
✅ gap replaces margin hacks between flex items — use it
✅ flex-direction: column + flex: 1 on content pushes footer to bottom
❌ flex-direction changes which axis is "main" — justify/align swap roles
❌ Don't forget flex-wrap: wrap if you want items to wrap on small screens
''',
  quiz: [
    Quiz(question: 'In a flex row container, what does justify-content control?', options: [
      QuizOption(text: 'Alignment along the horizontal (main) axis', correct: true),
      QuizOption(text: 'Alignment along the vertical (cross) axis', correct: false),
      QuizOption(text: 'The order of flex items', correct: false),
      QuizOption(text: 'How much each item grows', correct: false),
    ]),
    Quiz(question: 'What does flex: 1 do on a flex item?', options: [
      QuizOption(text: 'The item grows to fill available space equally with other flex: 1 items', correct: true),
      QuizOption(text: 'The item is always exactly 1px wide', correct: false),
      QuizOption(text: 'The item has 1 unit of fixed width', correct: false),
      QuizOption(text: 'The item is the first in the layout order', correct: false),
    ]),
    Quiz(question: 'How do you perfectly center an element both horizontally and vertically with flexbox?', options: [
      QuizOption(text: 'display: flex; justify-content: center; align-items: center', correct: true),
      QuizOption(text: 'display: flex; align: center center', correct: false),
      QuizOption(text: 'display: flex; flex-align: center', correct: false),
      QuizOption(text: 'display: flex; margin: auto', correct: false),
    ]),
  ],
);
