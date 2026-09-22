// lib/lessons/css/css_02_selectors.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cssLesson02 = Lesson(
  language: 'CSS',
  title: 'Selectors',
  content: '''
🎯 METAPHOR:
A CSS selector is like a spotlight operator in a theater.
The spotlight can be aimed at ONE specific actor (ID selector),
at everyone wearing a red costume (class selector), at all the
extras (element selector), or at everyone standing in the
left wing (combinator selector). The selector tells CSS exactly
WHICH elements on the stage should receive the styling you're
about to apply.

📖 EXPLANATION:
Selectors are the "who gets this style" part of a CSS rule.
CSS has many selector types — from simple to very precise.

─────────────────────────────────────
BASIC SELECTORS:
─────────────────────────────────────
*           universal — selects EVERYTHING
p           element — all <p> tags
.box        class — elements with class="box"
#header     id — element with id="header"
p, h1, div  group — applies to all listed

─────────────────────────────────────
COMBINATOR SELECTORS:
─────────────────────────────────────
div p        descendant — all <p> INSIDE a <div> (any depth)
div > p      child — only DIRECT children <p> of <div>
h1 + p       adjacent sibling — <p> immediately after <h1>
h1 ~ p       general sibling — all <p> after <h1> (same parent)

─────────────────────────────────────
ATTRIBUTE SELECTORS:
─────────────────────────────────────
[href]           has href attribute
[href="url"]     href equals exactly "url"
[href^="https"]  href starts with "https"
[href\$=".pdf"]  href ends with ".pdf"
[href*="google"] href contains "google"

─────────────────────────────────────
PSEUDO-CLASS SELECTORS:
─────────────────────────────────────
a:hover       mouse is over the element
a:visited     link has been visited
input:focus   element has keyboard focus
li:first-child  first child element
li:last-child   last child element
li:nth-child(2) specific child by position
p:not(.special) elements that do NOT match
─────────────────────────────────────

💻 CODE:
/* Element selectors */
h1 { color: navy; }
p  { font-size: 16px; }

/* Class selector — can be reused on multiple elements */
.highlight { background-color: yellow; }
.btn { padding: 8px 16px; border-radius: 4px; }

/* ID selector — unique, one per page */
#main-title { font-size: 2rem; text-align: center; }

/* Universal */
* { box-sizing: border-box; }

/* Descendant — any p inside a .card */
.card p { color: #555; }

/* Direct child only */
.nav > li { display: inline-block; }

/* Adjacent sibling */
h2 + p { font-style: italic; }

/* Attribute selectors */
a[href^="https"] { color: green; }
a[href\$=".pdf"]::after { content: " (PDF)"; }
input[type="text"] { border: 1px solid #ccc; }

/* Pseudo-classes */
a:hover { text-decoration: underline; color: blue; }
button:focus { outline: 2px solid orange; }
li:nth-child(odd) { background: #f5f5f5; }
li:nth-child(2n+1) { /* same as odd */ }
li:first-child { font-weight: bold; }
p:not(.intro) { color: gray; }

/* Pseudo-elements */
p::first-line { font-variant: small-caps; }
p::first-letter { font-size: 2em; float: left; }
.item::before { content: "→ "; color: red; }
.item::after  { content: " ←"; color: red; }

📝 KEY POINTS:
✅ Use classes (.name) for reusable styles — apply to many elements
✅ Use IDs (#name) sparingly — one per page, high specificity
✅ Descendant (space) vs child (>) — know the difference
✅ Pseudo-classes (:hover) respond to state; pseudo-elements (::before) add content
✅ Attribute selectors target specific HTML attributes and values
❌ Avoid universal selector * in large stylesheets — can hurt performance
❌ Don't overuse IDs — they create specificity problems
''',
  quiz: [
    Quiz(question: 'What is the difference between "div p" and "div > p"?', options: [
      QuizOption(text: '"div p" selects all p descendants; "div > p" selects only direct children', correct: true),
      QuizOption(text: 'They are identical', correct: false),
      QuizOption(text: '"div > p" selects all p descendants; "div p" selects only direct children', correct: false),
      QuizOption(text: '"div p" only works in modern browsers', correct: false),
    ]),
    Quiz(question: 'Which selector targets elements that do NOT have a specific class?', options: [
      QuizOption(text: ':not(.className)', correct: true),
      QuizOption(text: '!.className', correct: false),
      QuizOption(text: '.className:exclude', correct: false),
      QuizOption(text: '[no-class]', correct: false),
    ]),
    Quiz(question: 'What does the attribute selector [href^="https"] match?', options: [
      QuizOption(text: 'Elements whose href attribute starts with "https"', correct: true),
      QuizOption(text: 'Elements whose href attribute ends with "https"', correct: false),
      QuizOption(text: 'Elements whose href attribute contains "https"', correct: false),
      QuizOption(text: 'Elements whose href attribute equals "https"', correct: false),
    ]),
  ],
);
