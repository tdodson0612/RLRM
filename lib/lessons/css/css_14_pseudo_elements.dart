// lib/lessons/css/css_14_pseudo_elements.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cssLesson14 = Lesson(
  language: 'CSS',
  title: 'Pseudo-Elements',
  content: '''
🎯 METAPHOR:
Pseudo-elements are like invisible assistants that add
extra content or styling to an element without touching
the HTML. Imagine you have a paragraph. Before the paragraph,
your assistant can hold up a decorative sign (::before).
After it, they hold up another (::after). The HTML never
changes — the assistants just add visual flourishes.
You can also give special treatment to just the first line
of a book (::first-line) or the very first letter (::first-letter)
like illuminated manuscripts from the Middle Ages.

📖 EXPLANATION:
Pseudo-elements style a SPECIFIC PART of an element.
They use double colon :: (CSS3) though single colon : still works.

CORE PSEUDO-ELEMENTS:
  ::before       — insert content before the element's content
  ::after        — insert content after the element's content
  ::first-line   — style the first line of a text block
  ::first-letter — style the first letter (drop caps)
  ::selection    — style text when user selects/highlights it
  ::placeholder  — style placeholder text in inputs
  ::marker       — style list item bullets/numbers
  ::backdrop     — style behind a modal/dialog

KEY RULE: ::before and ::after REQUIRE content: ""
to exist, even if that content is empty.

💻 CODE:
/* ─── ::BEFORE AND ::AFTER ─── */
/* Add decorative quotes */
blockquote::before {
  content: '"';
  font-size: 4rem;
  color: #0066cc;
  line-height: 0;
  vertical-align: -0.5em;
}

/* Add an icon after external links */
a[href^="http"]::after {
  content: " ↗";
  font-size: 0.75em;
}

/* Clear floats (classic clearfix) */
.clearfix::after {
  content: "";
  display: block;
  clear: both;
}

/* Decorative divider */
.section-title::after {
  content: "";
  display: block;
  width: 60px;
  height: 3px;
  background: #0066cc;
  margin-top: 8px;
}

/* Tooltip using ::before */
[data-tooltip] {
  position: relative;
}
[data-tooltip]::before {
  content: attr(data-tooltip);   /* reads the data attribute! */
  position: absolute;
  bottom: calc(100% + 8px);
  left: 50%;
  transform: translateX(-50%);
  background: #333;
  color: white;
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 0.75rem;
  white-space: nowrap;
  opacity: 0;
  pointer-events: none;
  transition: opacity 200ms;
}
[data-tooltip]:hover::before {
  opacity: 1;
}

/* Counter badges */
.nav-item {
  counter-increment: nav-items;
  position: relative;
}
.nav-item::before {
  content: counter(nav-items);
}

/* ─── DECORATIVE PATTERNS ─── */
/* Underline effect */
.fancy-link {
  position: relative;
  text-decoration: none;
}
.fancy-link::after {
  content: "";
  position: absolute;
  bottom: -2px;
  left: 0;
  width: 0;
  height: 2px;
  background: #0066cc;
  transition: width 300ms ease;
}
.fancy-link:hover::after {
  width: 100%;
}

/* ─── ::FIRST-LINE AND ::FIRST-LETTER ─── */
p::first-line {
  font-weight: bold;
  color: #333;
}

/* Drop cap */
article p:first-of-type::first-letter {
  font-size: 3.5rem;
  font-weight: bold;
  float: left;
  line-height: 0.8;
  margin-right: 8px;
  color: #0066cc;
}

/* ─── ::SELECTION ─── */
::selection {
  background-color: #0066cc;
  color: white;
}

/* Per-element selection */
.code-block::selection {
  background-color: #ff6b6b;
  color: white;
}

/* ─── ::PLACEHOLDER ─── */
input::placeholder {
  color: #aaa;
  font-style: italic;
}

input:focus::placeholder {
  opacity: 0.5;  /* fade placeholder on focus */
}

/* ─── ::MARKER ─── */
li::marker {
  color: #0066cc;
  font-weight: bold;
  content: "▸ ";
}

/* ─── ::BACKDROP (dialog/fullscreen) ─── */
dialog::backdrop {
  background: rgba(0, 0, 0, 0.5);
  backdrop-filter: blur(4px);
}

📝 KEY POINTS:
✅ ::before and ::after must have content: "" to render — even for pure visual elements
✅ content: attr(data-x) reads the element's HTML attribute into content
✅ Pseudo-elements are great for decorative effects without cluttering HTML
✅ ::selection lets you brand the text highlight color
✅ Position the parent relative when using absolute ::before / ::after
❌ You cannot add pseudo-elements to replaced elements like <img> or <input>
❌ Double colon :: is the correct modern syntax — but single : still works for legacy
''',
  quiz: [
    Quiz(question: 'What is required for ::before and ::after to be visible?', options: [
      QuizOption(text: 'The content property must be set — even to an empty string ""', correct: true),
      QuizOption(text: 'The parent element must have position: relative', correct: false),
      QuizOption(text: 'The element must have a defined width', correct: false),
      QuizOption(text: 'display: block must be set on the pseudo-element', correct: false),
    ]),
    Quiz(question: 'What does content: attr(data-tooltip) do?', options: [
      QuizOption(text: 'Reads the data-tooltip HTML attribute value and inserts it as content', correct: true),
      QuizOption(text: 'Creates a tooltip element automatically', correct: false),
      QuizOption(text: 'Links to the data-tooltip CSS variable', correct: false),
      QuizOption(text: 'Displays the attribute name as text', correct: false),
    ]),
    Quiz(question: 'Which pseudo-element styles text when the user highlights it?', options: [
      QuizOption(text: '::selection', correct: true),
      QuizOption(text: '::highlight', correct: false),
      QuizOption(text: '::focus', correct: false),
      QuizOption(text: '::marked', correct: false),
    ]),
  ],
);
