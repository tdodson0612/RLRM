// lib/lessons/css/css_10_specificity_cascade.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cssLesson10 = Lesson(
  language: 'CSS',
  title: 'Specificity and the Cascade',
  content: '''
🎯 METAPHOR:
The CSS cascade is like a chain of command in the military.
A private's order (browser default) is overridden by a
sergeant's order (inherited styles), which is overridden by
a lieutenant's order (element selector), a captain's order
(class selector), a general's order (ID selector), and the
commander-in-chief's order (inline styles or !important).
When two orders conflict, the higher rank wins.
Specificity is how CSS calculates each selector's "rank."

📖 EXPLANATION:
The CASCADE determines which CSS rule wins when multiple
rules target the same element with the same property.

ORDER OF PRIORITY (lowest to highest):
  1. Browser default styles
  2. External stylesheets
  3. Internal <style> tag
  4. Inline style="" attributes
  5. !important declarations

SPECIFICITY CALCULATION:
  Each selector has a specificity score: (a, b, c)
  a = ID selectors (#id)
  b = class (.class), attribute ([attr]), pseudo-class (:hover)
  c = element (p, div), pseudo-element (::before)

  Higher score wins. Compare a first, then b, then c.

─────────────────────────────────────
SPECIFICITY SCORES:
─────────────────────────────────────
*                  0,0,0  (zero specificity)
p                  0,0,1
.class             0,1,0
p.class            0,1,1
#id                1,0,0
#id .class         1,1,0
#id .class p       1,1,1
style=""           1,0,0,0 (inline — always wins over selectors)
!important         beats everything
─────────────────────────────────────

INHERITANCE:
  Some CSS properties are inherited by children automatically.
  Inherited: color, font-*, line-height, text-*
  NOT inherited: margin, padding, border, background, width

💻 CODE:
/* ─── SPECIFICITY EXAMPLES ─── */
/* 0,0,1 — element */
p { color: gray; }

/* 0,1,0 — class (wins over element) */
.highlight { color: yellow; }

/* 0,1,1 — class + element */
p.highlight { color: orange; }

/* 1,0,0 — ID (wins over class) */
#special { color: red; }

/* 1,0,1 — ID + element */
#special p { color: darkred; }

/* Given: <p id="special" class="highlight">text</p> */
/* Result: color: red (#special wins at 1,0,0 vs 0,1,0) */

/* ─── SAME SPECIFICITY: LAST ONE WINS ─── */
.box { color: blue; }
.box { color: red; }   /* this wins — same specificity, later rule */

/* ─── IMPORTANT (use sparingly!) ─── */
p { color: black !important; }  /* beats everything except another !important */

/* ─── THE CASCADE IN ACTION ─── */
/* Three ways something affects an element */

/* 1. Direct style */
.button { background: blue; }

/* 2. Inherited style */
.parent { color: navy; }  /* children inherit color */
/* .child doesn't need color — it inherits navy from .parent */

/* 3. Browser defaults */
h1 { /* browsers give h1 a default font-size of 2em */ }

/* ─── MANAGING SPECIFICITY ─── */
/* PROBLEM: specificity wars */
/* Don't do this — creates an arms race */
.nav #menu .item a:hover { color: blue; }
/* BETTER: use lower specificity */
.nav-link:hover { color: blue; }

/* CSS LAYERS (modern solution to specificity) */
@layer base, components, utilities;

@layer base {
  p { color: gray; font-size: 1rem; }
}

@layer components {
  .card p { color: #333; }
}

@layer utilities {
  .text-red { color: red !important; }
}
/* Later layers win over earlier layers */

/* ─── INHERIT AND INITIAL ─── */
.child {
  color: inherit;   /* force inheritance even if not normally inherited */
  border: initial;  /* reset to browser default */
  all: unset;       /* reset ALL properties */
}

📝 KEY POINTS:
✅ Understanding specificity prevents "why isn't my style working?" frustration
✅ Keep selectors as short as possible — lower specificity = more maintainable
✅ Avoid !important — use it only for utility classes or to override 3rd party CSS
✅ CSS @layer gives you explicit control over cascade order
✅ "all: unset" resets an element completely — useful for custom components
❌ ID selectors in CSS create specificity headaches — prefer classes
❌ Never fight specificity by adding more selectors — refactor instead
''',
  quiz: [
    Quiz(question: 'Which has higher specificity: "#nav a" or ".nav-link"?', options: [
      QuizOption(text: '#nav a (score 1,0,1) beats .nav-link (score 0,1,0)', correct: true),
      QuizOption(text: '.nav-link (class selectors always win)', correct: false),
      QuizOption(text: 'They have equal specificity', correct: false),
      QuizOption(text: '#nav a because it has more selectors', correct: false),
    ]),
    Quiz(question: 'What happens when two rules have identical specificity?', options: [
      QuizOption(text: 'The rule that appears last in the CSS wins', correct: true),
      QuizOption(text: 'The rule that appears first wins', correct: false),
      QuizOption(text: 'Both rules are applied and they merge', correct: false),
      QuizOption(text: 'Neither rule applies — they cancel out', correct: false),
    ]),
    Quiz(question: 'Which CSS properties are inherited by child elements by default?', options: [
      QuizOption(text: 'color and font-family', correct: true),
      QuizOption(text: 'margin and padding', correct: false),
      QuizOption(text: 'width and height', correct: false),
      QuizOption(text: 'border and background', correct: false),
    ]),
  ],
);
