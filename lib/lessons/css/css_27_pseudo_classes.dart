// lib/lessons/css/css_27_pseudo_classes.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cssLesson27 = Lesson(
  language: 'CSS',
  title: 'Pseudo-Classes In Depth',
  content: '''
🎯 METAPHOR:
Pseudo-classes are like conditional name tags.
"If you are the FIRST child at this table, wear a gold tag.
If you are being HOVERED over, wear a blue tag.
If you've been VISITED before, wear a purple tag."
The element is always the same HTML element — but its state
or position changes what CSS applies to it. No JavaScript,
no class toggling needed for most interactive states.

📖 EXPLANATION:
Pseudo-classes select elements based on STATE or POSITION.
Single colon syntax: :pseudo-class

─────────────────────────────────────
STATE PSEUDO-CLASSES:
─────────────────────────────────────
:hover          mouse is over element
:focus          element has keyboard/click focus
:focus-visible  focused via keyboard only (not mouse)
:focus-within   element or any descendant has focus
:active         currently being clicked
:visited        link has been visited
:link           link not yet visited
:checked        checkbox/radio is checked
:disabled       form element is disabled
:enabled        form element is enabled
:required       form field has required attribute
:optional       form field has no required attribute
:valid          form field passes validation
:invalid        form field fails validation
:placeholder-shown  input is showing placeholder
:read-only      element is read-only
:read-write     element is editable

─────────────────────────────────────
STRUCTURAL PSEUDO-CLASSES:
─────────────────────────────────────
:first-child    first child of its parent
:last-child     last child of its parent
:nth-child(n)   nth child (1-based)
:nth-last-child(n)  nth from end
:only-child     only child of its parent
:first-of-type  first of this type in parent
:last-of-type   last of this type
:nth-of-type(n) nth of this type
:only-of-type   only of this type in parent
:empty          element has no children

─────────────────────────────────────
LOGICAL PSEUDO-CLASSES:
─────────────────────────────────────
:is(a, b, c)    matches any in the list (forgiving)
:where(a, b, c) same but zero specificity
:not(selector)  does NOT match selector
:has(selector)  has a matching descendant (parent selector!)

💻 CODE:
/* ─── STATE ─── */
a:link    { color: blue; }
a:visited { color: purple; }
a:hover   { color: red; text-decoration: underline; }
a:active  { color: darkred; }
/* Order matters! Always LVHA: Link Visited Hover Active */

button:hover    { background: #eee; }
button:active   { transform: scale(0.98); }
button:focus-visible {
  outline: 3px solid #6c63ff;
  outline-offset: 2px;
}

/* Remove focus ring for mouse users but keep for keyboard */
:focus:not(:focus-visible) { outline: none; }

/* Highlight form when any field inside is focused */
form:focus-within { box-shadow: 0 0 0 2px #6c63ff; }

/* ─── FORM STATES ─── */
input:valid   { border-color: green; }
input:invalid { border-color: red; }

/* Only show invalid after interaction, not immediately */
input:not(:placeholder-shown):invalid {
  border-color: red;
  background: #fff0f0;
}

input:disabled { opacity: 0.5; cursor: not-allowed; }
input:required { border-left: 3px solid orange; }

/* ─── NTH-CHILD FORMULAS ─── */
/* odd / even */
tr:nth-child(odd)  { background: #f9f9f9; }
tr:nth-child(even) { background: #fff; }

/* every 3rd */
li:nth-child(3n) { font-weight: bold; }

/* first 3 */
li:nth-child(-n+3) { color: #6c63ff; }

/* from 4th onward */
li:nth-child(n+4) { opacity: 0.6; }

/* 2nd to 5th */
li:nth-child(n+2):nth-child(-n+5) { background: yellow; }

/* ─── :IS() AND :WHERE() ─── */
/* Long way */
header h1, header h2, header h3,
nav h1, nav h2, nav h3 {
  color: #333;
}

/* Short way with :is() */
:is(header, nav) :is(h1, h2, h3) {
  color: #333;
}

/* :where() is identical but adds ZERO specificity */
:where(header, nav, footer) a {
  text-decoration: none;
}

/* ─── :NOT() ─── */
/* All buttons except disabled */
button:not(:disabled) { cursor: pointer; }

/* All list items except first */
li:not(:first-child) { border-top: 1px solid #eee; }

/* All inputs except checkboxes and radios */
input:not([type="checkbox"]):not([type="radio"]) {
  border: 1px solid #ccc;
  padding: 8px;
}

/* ─── :HAS() — the parent selector! ─── */
/* Card that contains an image */
.card:has(img) { padding: 0; }

/* Form with invalid field */
form:has(input:invalid) .submit-btn {
  opacity: 0.5;
  pointer-events: none;
}

/* Figure with caption */
figure:has(figcaption) { margin-bottom: 2rem; }

/* Table row when checkbox is checked */
tr:has(input[type="checkbox"]:checked) {
  background: #e8f4fd;
}

/* Navigation with open dropdown */
.nav-item:has(.dropdown:hover) > a {
  color: #6c63ff;
}

/* ─── :EMPTY ─── */
p:empty { display: none; }
td:empty::before { content: "—"; color: #999; }

📝 KEY POINTS:
✅ Always write link states in LVHA order: :link :visited :hover :active
✅ :focus-visible targets keyboard focus only — keeps mouse UX clean
✅ :has() is the long-awaited "parent selector" — widely supported since 2023
✅ :where() is identical to :is() but contributes zero specificity
✅ :nth-child(n+2):nth-child(-n+5) selects a range of children
✅ :focus-within styles a parent when any child has focus
❌ :has() is not supported in Firefox before version 121
❌ :visited only allows a limited set of CSS properties for privacy reasons
''',
  quiz: [
    Quiz(question: 'What is the correct order for link pseudo-classes?', options: [
      QuizOption(text: ':link :visited :hover :active (LVHA)', correct: true),
      QuizOption(text: ':hover :link :visited :active', correct: false),
      QuizOption(text: ':active :hover :visited :link', correct: false),
      QuizOption(text: 'Order does not matter for link pseudo-classes', correct: false),
    ]),
    Quiz(question: 'What makes :where() different from :is()?', options: [
      QuizOption(text: ':where() has zero specificity — it never increases selector weight', correct: true),
      QuizOption(text: ':where() only works inside media queries', correct: false),
      QuizOption(text: ':where() matches only one selector at a time', correct: false),
      QuizOption(text: ':where() requires JavaScript to activate', correct: false),
    ]),
    Quiz(question: 'What does form:has(input:invalid) select?', options: [
      QuizOption(text: 'Any form element that contains at least one invalid input', correct: true),
      QuizOption(text: 'Any invalid form element', correct: false),
      QuizOption(text: 'Inputs inside invalid forms', correct: false),
      QuizOption(text: 'Forms with no inputs', correct: false),
    ]),
  ],
);
