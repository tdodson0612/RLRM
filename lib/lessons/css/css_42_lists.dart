// lib/lessons/css/css_42_lists.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cssLesson42 = Lesson(
  language: 'CSS',
  title: 'Styling Lists',
  content: '''
🎯 METAPHOR:
Lists are the workhorses of the web — navigation menus,
feature lists, breadcrumbs, step-by-step guides, icon lists.
Almost every set of related items starts as an HTML list.
The problem is the default bullet points are ugly and the
default indentation rarely matches your design. CSS list
styling is how you take that raw list and turn it into
anything: a horizontal navigation bar, a custom bulleted
feature list with checkmarks, a numbered steps guide with
big circular numbers, or a clean unstyled menu.

📖 EXPLANATION:
LIST PROPERTIES:
  list-style-type     — bullet/number style
  list-style-image    — image as bullet
  list-style-position — inside | outside
  list-style          — shorthand

list-style-type values:
  none          — no marker
  disc          — filled circle (default ul)
  circle        — hollow circle
  square        — filled square
  decimal       — 1, 2, 3 (default ol)
  lower-alpha   — a, b, c
  upper-alpha   — A, B, C
  lower-roman   — i, ii, iii
  upper-roman   — I, II, III
  decimal-leading-zero — 01, 02, 03

list-style-position:
  outside — marker is outside the content box (default)
  inside  — marker is inside — text wraps under marker

::marker pseudo-element — style the bullet/number directly

@counter-style — define custom markers

💻 CODE:
/* ─── RESET (most common starting point) ─── */
ul, ol {
  list-style: none;
  padding: 0;
  margin: 0;
}

/* ─── BASIC STYLING ─── */
ul {
  list-style-type: disc;
  padding-left: 1.5rem;
  line-height: 1.8;
}

ol {
  list-style-type: decimal;
  padding-left: 1.5rem;
  line-height: 1.8;
}

/* ─── CUSTOM ::MARKER ─── */
ul li::marker {
  color: #6c63ff;
  font-size: 1.2em;
}

ol li::marker {
  color: #e91e8c;
  font-weight: bold;
}

/* Custom marker content */
ul.check-list li::marker {
  content: "✅ ";
}

ul.arrow-list li::marker {
  content: "→ ";
  color: #6c63ff;
}

/* ─── CUSTOM BULLET WITH ::BEFORE ─── */
/* More cross-browser compatible than ::marker */
ul.custom {
  list-style: none;
  padding: 0;
}

ul.custom li {
  padding-left: 1.75rem;
  position: relative;
  margin-bottom: 0.5rem;
}

ul.custom li::before {
  content: "▸";
  position: absolute;
  left: 0;
  color: #6c63ff;
  font-weight: bold;
}

/* ─── ICON LIST ─── */
.icon-list {
  list-style: none;
  padding: 0;
}

.icon-list li {
  display: flex;
  align-items: flex-start;
  gap: 0.75rem;
  margin-bottom: 1rem;
}

.icon-list li::before {
  content: "";
  flex-shrink: 0;
  width: 1.5rem;
  height: 1.5rem;
  background: url('/icons/check.svg') no-repeat center/contain;
  margin-top: 0.1em;
}

/* ─── NUMBERED STEPS (custom design) ─── */
ol.steps {
  list-style: none;
  counter-reset: step;
  padding: 0;
}

ol.steps li {
  counter-increment: step;
  display: flex;
  align-items: flex-start;
  gap: 1rem;
  margin-bottom: 1.5rem;
}

ol.steps li::before {
  content: counter(step);
  flex-shrink: 0;
  width: 2rem;
  height: 2rem;
  border-radius: 50%;
  background: #6c63ff;
  color: white;
  font-weight: bold;
  font-size: 0.875rem;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-top: 0.1em;
}

/* ─── HORIZONTAL NAVIGATION LIST ─── */
.nav-list {
  list-style: none;
  padding: 0;
  margin: 0;
  display: flex;
  gap: 0;
}

.nav-list li a {
  display: block;
  padding: 0.75rem 1rem;
  color: #333;
  text-decoration: none;
  transition: background 0.2s, color 0.2s;
}

.nav-list li a:hover,
.nav-list li a.active {
  background: #6c63ff;
  color: white;
}

/* ─── BREADCRUMB ─── */
.breadcrumb {
  list-style: none;
  padding: 0;
  display: flex;
  align-items: center;
  gap: 0;
  flex-wrap: wrap;
}

.breadcrumb li + li::before {
  content: "/";
  padding: 0 0.5rem;
  color: #ccc;
}

.breadcrumb a {
  color: #6c63ff;
  text-decoration: none;
}

.breadcrumb li:last-child {
  color: #666;
}

/* ─── DEFINITION LIST ─── */
dl {
  display: grid;
  grid-template-columns: auto 1fr;
  gap: 0.5rem 1.5rem;
  align-items: baseline;
}

dt {
  font-weight: bold;
  color: #333;
}

dd {
  margin: 0;
  color: #666;
}

/* ─── LIST-STYLE-IMAGE ─── */
ul.image-bullets {
  list-style-image: url('/icons/bullet.svg');
  /* Use ::before with background-image for better control */
}

/* ─── @COUNTER-STYLE (custom markers) ─── */
@counter-style thumbs {
  system: cyclic;
  symbols: "👍";
  suffix: " ";
}

ol.thumbs-list {
  list-style: thumbs;
}

@counter-style emoji-cycle {
  system: cyclic;
  symbols: "🔵" "🟢" "🟡" "🔴";
  suffix: " ";
}

ul.emoji-list {
  list-style: emoji-cycle;
}

📝 KEY POINTS:
✅ list-style: none; padding: 0; margin: 0 is the standard reset for navigation lists
✅ ::marker is the modern way to style bullets/numbers — better than ::before for simple cases
✅ Use ::before with position: absolute for complex custom bullets (more control)
✅ display: flex on ul/li items is the standard way to build horizontal nav menus
✅ @counter-style lets you define fully custom marker systems
✅ font-variant-numeric: tabular-nums keeps numbered list numbers aligned
❌ list-style-image gives little control over size/position — use ::before with background-image instead
❌ Don't remove list semantics (list-style: none) without preserving ARIA role for screen readers
''',
  quiz: [
    Quiz(question: 'What is the most reliable way to use a custom image as a list bullet?', options: [
      QuizOption(text: 'li::before with background-image — gives full control over size and position', correct: true),
      QuizOption(text: 'list-style-image: url() — the dedicated property', correct: false),
      QuizOption(text: 'li { background: url() no-repeat left; }', correct: false),
      QuizOption(text: 'content: url() in ::marker', correct: false),
    ]),
    Quiz(question: 'What does list-style-position: inside do?', options: [
      QuizOption(text: 'Moves the marker inside the content box so wrapped text aligns under the marker', correct: true),
      QuizOption(text: 'Centers the list inside its parent', correct: false),
      QuizOption(text: 'Places the list inside a flex container', correct: false),
      QuizOption(text: 'Moves the list items closer together', correct: false),
    ]),
    Quiz(question: 'What is the simplest way to turn a vertical list into a horizontal navigation bar?', options: [
      QuizOption(text: 'Add display: flex to the ul element', correct: true),
      QuizOption(text: 'Add float: left to each li element', correct: false),
      QuizOption(text: 'Add display: inline to the ul element', correct: false),
      QuizOption(text: 'Add list-style: horizontal to the ul element', correct: false),
    ]),
  ],
);
