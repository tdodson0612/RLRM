// lib/lessons/css/css_21_reading_documentation.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cssLesson21 = Lesson(
  language: 'CSS',
  title: 'Reading the CSS Documentation',
  content: '''
🎯 METAPHOR:
Learning CSS from tutorials teaches you the most popular
roads on the map. The documentation IS the map — every road,
every path, every dead end. When a tutorial says "here is
how to do X," the documentation tells you every variation
of X, what it accepts, what it doesn't, which browsers
support it, and what happens in edge cases.
A developer who can read the docs is never stuck —
they can always look up the answer themselves.

📖 EXPLANATION:
The two essential CSS documentation sources are:

1. MDN Web Docs (developer.mozilla.org)
   The gold standard for web documentation.
   Comprehensive, accurate, community-maintained.
   Always check MDN first.

2. CSS-Tricks (css-tricks.com)
   Practical guides, visual examples, almanac.
   Great for "how do I DO this" questions.

HOW TO READ AN MDN CSS PAGE:

Every CSS property page has the same structure:
  ① Syntax block  — the formal definition
  ② Values section — every accepted value explained
  ③ Formal definition — initial value, applies to, inherited?
  ④ Browser compatibility table — what works where
  ⑤ Examples — live code demos
  ⑥ Specifications — the official W3C spec link

READING THE SYNTAX BLOCK:
  Items in [ ] are optional
  Items separated by | are choices (pick one)
  Items with ? appear zero or one time
  Items with * appear zero or more times
  Items with + appear one or more times

─────────────────────────────────────
WHERE TO LOOK:
─────────────────────────────────────
MDN CSS Reference:
  developer.mozilla.org/en-US/docs/Web/CSS/Reference

MDN search:  mdn <property name>
             (e.g., "mdn grid-template-columns")

Can I Use:   caniuse.com
             Browser support tables for any feature

CSS Tricks Almanac:
  css-tricks.com/almanac/properties/

W3C specs:   w3.org/TR/css-*
             Official specs — exhaustive but dense
─────────────────────────────────────

💻 CODE:
/* ─── EXAMPLE: READING MDN FOR grid-template-columns ─── */

/* MDN Formal Syntax for grid-template-columns: */
/* grid-template-columns: none | <track-list> | <auto-track-list> */
/* <track-list> = [ <line-names>? [ <track-size> | <track-repeat> ] ]+ <line-names>? */

/* What this tells you: */
/* - Can be 'none' (keyword) */
/* - Can be a list of track sizes */
/* - Can use named lines like [sidebar-start] 200px [sidebar-end] */

/* Values explained in the MDN page: */
.grid-examples {
  /* 'none' value — no explicit tracks */
  grid-template-columns: none;

  /* Fixed values */
  grid-template-columns: 100px 200px 100px;

  /* Fractional */
  grid-template-columns: 1fr 2fr;

  /* Mixed */
  grid-template-columns: 200px 1fr auto;

  /* repeat() function */
  grid-template-columns: repeat(3, 1fr);

  /* minmax() function */
  grid-template-columns: repeat(3, minmax(100px, 1fr));

  /* auto-fill */
  grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));

  /* Named lines */
  grid-template-columns: [nav-start] 200px [nav-end main-start] 1fr [main-end];
}

/* ─── HOW TO FIND WHAT YOU NEED ─── */

/* WORKFLOW: */
/* 1. Know what you want visually */
/* 2. Search: "css [describe what you want]" */
/* 3. Click the MDN result */
/* 4. Read the Values section */
/* 5. Check Browser Compatibility table */
/* 6. Copy the example, adapt to your code */

/* EXAMPLE SEARCHES: */
/* "css make text not wrap"          → white-space: nowrap */
/* "css center vertically"           → flexbox align-items */
/* "css rounded corners"             → border-radius */
/* "css element behind another"      → z-index + position */
/* "css hide element but keep space" → visibility: hidden */
/* "css show element on hover"       → :hover + display/opacity */

/* ─── READING THE BROWSER COMPAT TABLE ─── */
/*
Green = supported
Yellow/partial = partial support (check notes)
Red = not supported
Number = version it was added
"--" = never supported

Example reading:
  Chrome 57+  ✅ grid layout works
  IE 11       ⚠️ partial — old syntax (-ms-grid)
  Safari 10.1 ✅ with -webkit- prefix
*/

/* ─── UNDERSTANDING THE FORMAL DEFINITION ─── */
/* Every MDN CSS property page has a "Formal definition" section: */

/* Example for 'color' property: */
/* Initial value:    canvastext (browser default text color) */
/* Applies to:       all elements */
/* Inherited:        yes ← this tells you children inherit color */
/* Computed value:   computed color ← what the browser actually uses */
/* Animation type:   by color ← can be transitioned/animated */

/* Example for 'padding' property: */
/* Initial value:    0 */
/* Applies to:       all elements except table-row-group, etc. */
/* Inherited:        no ← children don't inherit padding */
/* Percentages:      refer to the width of the containing block */
/*                   ← important! vertical padding % = parent WIDTH */

/* ─── @SUPPORTS — FEATURE DETECTION ─── */
/* Check if browser supports a feature before using it */
@supports (backdrop-filter: blur(10px)) {
  .glass {
    backdrop-filter: blur(10px);
    background: rgba(255,255,255,0.2);
  }
}

@supports not (display: grid) {
  .grid-container { display: flex; flex-wrap: wrap; }
}

/* ─── USEFUL MDN PAGES TO BOOKMARK ─── */
/*
  MDN CSS Reference (full property list):
  developer.mozilla.org/en-US/docs/Web/CSS/Reference

  CSS Selectors:
  developer.mozilla.org/en-US/docs/Web/CSS/CSS_selectors

  CSS Flexbox:
  developer.mozilla.org/en-US/docs/Learn/CSS/CSS_layout/Flexbox

  CSS Grid:
  developer.mozilla.org/en-US/docs/Web/CSS/CSS_grid_layout

  CSS Custom Properties:
  developer.mozilla.org/en-US/docs/Web/CSS/Using_CSS_custom_properties

  Pseudo-classes:
  developer.mozilla.org/en-US/docs/Web/CSS/Pseudo-classes

  Pseudo-elements:
  developer.mozilla.org/en-US/docs/Web/CSS/Pseudo-elements

  CSS Functions:
  developer.mozilla.org/en-US/docs/Web/CSS/CSS_Functions

  Can I Use (browser support):
  caniuse.com
*/

📝 KEY POINTS:
✅ MDN is the authoritative CSS reference — use it as your first stop
✅ The Formal Definition section tells you initial value, inheritance, and animation type
✅ The Browser Compatibility table tells you what's safe to ship
✅ @supports lets you provide fallbacks for unsupported features
✅ Search "mdn [property]" to go straight to the right MDN page
✅ Reading the formal syntax block tells you EVERY valid value for a property
❌ Don't rely only on tutorials — they often omit edge cases and browser notes
❌ W3C specs are the source of truth but are very dense — MDN summarizes them well
''',
  quiz: [
    Quiz(question: 'What does the MDN "Formal Definition" section tell you about a CSS property?', options: [
      QuizOption(text: 'Initial value, which elements it applies to, whether it is inherited, and animation type', correct: true),
      QuizOption(text: 'The JavaScript API for the property', correct: false),
      QuizOption(text: 'The history and browser that invented the property', correct: false),
      QuizOption(text: 'Performance benchmarks for the property', correct: false),
    ]),
    Quiz(question: 'What does @supports do in CSS?', options: [
      QuizOption(text: 'Applies styles only if the browser supports the specified feature', correct: true),
      QuizOption(text: 'Imports external support libraries', correct: false),
      QuizOption(text: 'Checks if the HTML element exists before styling', correct: false),
      QuizOption(text: 'Adds browser prefixes automatically', correct: false),
    ]),
    Quiz(question: 'Which website provides comprehensive browser support tables for CSS features?', options: [
      QuizOption(text: 'caniuse.com', correct: true),
      QuizOption(text: 'w3schools.com', correct: false),
      QuizOption(text: 'css-tricks.com', correct: false),
      QuizOption(text: 'github.com', correct: false),
    ]),
  ],
);
