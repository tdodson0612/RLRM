// lib/lessons/html/html_09_attributes.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final htmlLesson09 = Lesson(
  language: 'HTML',
  title: 'Attributes: Global and Essential',
  content: '''
🎯 METAPHOR:
Attributes are like the name badges and extra labels at
a conference. The person (the element) exists without
them, but the badges tell you everything extra:
their name tag (id), their department sticker (class),
their dietary restrictions (data-*), whether they need
wheelchair access (aria-*), and what language they speak
(lang). Without these labels, people exist but the system
can't organize, identify, or understand them properly.
Global attributes are labels that EVERY person at the
conference can wear — regardless of their role.

📖 EXPLANATION:
GLOBAL ATTRIBUTES — valid on every HTML element:

id         — unique identifier on the page
class      — space-separated list of CSS classes
style      — inline CSS (use sparingly)
title      — tooltip text on hover
lang       — language of element content
dir        — text direction: ltr | rtl | auto
tabindex   — keyboard focus order
hidden     — hides element (like display:none)
draggable  — enable HTML drag and drop
contenteditable — makes element editable
spellcheck — enable/disable spell checking
translate  — hint for translation services
inert      — makes subtree non-interactive

DATA ATTRIBUTES — store custom data:
  data-*   — any custom data attribute
  Read in JS: element.dataset.myValue
  Read in CSS: content: attr(data-label)

ARIA ATTRIBUTES — accessibility:
  aria-label       — accessible label
  aria-labelledby  — reference to labeling element
  aria-describedby — reference to description element
  aria-hidden      — hide from screen readers
  aria-expanded    — is this thing expanded?
  aria-controls    — what does this control?
  aria-live        — announce dynamic changes
  role             — ARIA landmark role

FORM-SPECIFIC:
  autocomplete, autofocus, disabled, readonly,
  required, name, value, placeholder, pattern

💻 CODE:
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Attributes Demo</title>
</head>
<body>

  <!-- ─── ID AND CLASS ─── -->
  <!-- id must be unique on the page -->
  <h1 id="page-title">Welcome to HTML</h1>

  <!-- class can be reused on multiple elements -->
  <p class="intro highlight">This paragraph has two classes.</p>
  <p class="intro">This one only has the intro class.</p>

  <!-- ─── TITLE (TOOLTIP) ─── -->
  <abbr title="HyperText Markup Language">HTML</abbr>
  <button title="Save your changes to the database">Save</button>

  <!-- ─── LANG ─── -->
  <!-- Override language for a specific element -->
  <p>
    The French say:
    <span lang="fr">Bonjour tout le monde</span>
  </p>
  <p lang="ja">日本語のテキスト</p>

  <!-- ─── DIR (TEXT DIRECTION) ─── -->
  <p dir="rtl">This text flows right to left</p>
  <p dir="ltr">This flows left to right (default)</p>

  <!-- ─── TABINDEX ─── -->
  <!-- tabindex="0": include in natural tab order -->
  <div tabindex="0" role="button" aria-label="Custom button">
    I'm focusable!
  </div>

  <!-- tabindex="-1": focusable via JS only, skip in tab order -->
  <div tabindex="-1" id="modal-content">Modal content (focus via JS)</div>

  <!-- tabindex="1+": explicit order — generally avoid this -->

  <!-- ─── HIDDEN ─── -->
  <div hidden>
    This content is completely hidden (like display: none)
  </div>

  <!-- ─── CONTENTEDITABLE ─── -->
  <div
    contenteditable="true"
    role="textbox"
    aria-label="Editable bio"
    aria-multiline="true"
  >
    Click here to edit this text directly in the browser!
  </div>

  <!-- ─── DATA ATTRIBUTES ─── -->
  <!-- Store custom data for JavaScript and CSS -->
  <button
    data-action="delete"
    data-item-id="42"
    data-confirm="Are you sure you want to delete this?"
  >
    Delete Item
  </button>

  <!-- Read in JavaScript: -->
  <!-- button.dataset.action    → "delete" -->
  <!-- button.dataset.itemId    → "42" (camelCase!) -->
  <!-- button.dataset.confirm   → "Are you sure..." -->

  <!-- Use in CSS: -->
  <!-- [data-action="delete"] { color: red; } -->

  <div
    class="status-badge"
    data-status="active"
    data-count="7"
  >
    Notifications
  </div>

  <!-- ─── ARIA ATTRIBUTES ─── -->
  <!-- Button with aria-label (no visible text) -->
  <button aria-label="Close dialog">✕</button>

  <!-- Expanded/collapsed state -->
  <button
    aria-expanded="false"
    aria-controls="menu-list"
    id="menu-toggle"
  >
    Menu ▼
  </button>
  <ul id="menu-list" hidden>
    <li><a href="/">Home</a></li>
    <li><a href="/about">About</a></li>
  </ul>

  <!-- Hide decorative element from screen readers -->
  <span aria-hidden="true">⭐</span> Featured

  <!-- Live region — announce changes to screen readers -->
  <div aria-live="polite" aria-atomic="true" id="status-msg">
    <!-- JS updates this: screen readers announce changes -->
  </div>

  <!-- ─── INERT ─── -->
  <!-- Makes entire subtree non-interactive -->
  <div inert>
    <button>This button cannot be clicked</button>
    <a href="/somewhere">This link cannot be followed</a>
    <input type="text" placeholder="This cannot be focused">
  </div>

  <!-- ─── DRAGGABLE ─── -->
  <div draggable="true" id="drag-me">
    Drag me!
  </div>

  <div
    id="drop-zone"
    ondragover="event.preventDefault()"
    ondrop="handleDrop(event)"
  >
    Drop here
  </div>

  <!-- ─── TRANSLATE ─── -->
  <!-- Hint to translation tools: don't translate this -->
  <span translate="no">CompanyName™</span>

</body>
</html>

─────────────────────────────────────
DATA ATTRIBUTE NAMING:
─────────────────────────────────────
HTML:           data-item-id="42"
                data-user-name="alice"

JavaScript:     element.dataset.itemId   ← camelCase
                element.dataset.userName ← camelCase

CSS:            [data-item-id="42"] { }
                content: attr(data-user-name)
─────────────────────────────────────

📝 KEY POINTS:
✅ id must be unique on the page — use it for anchors, JS, and aria references
✅ class is for CSS styling — can be reused across many elements
✅ data-* stores custom data — readable by JS via element.dataset
✅ tabindex="0" adds any element to the keyboard tab order
✅ tabindex="-1" allows programmatic focus without natural tab order
✅ aria-hidden="true" removes decorative elements from screen reader output
❌ Don't use id for CSS styling — use class instead (ids have too-high specificity)
❌ Avoid tabindex values > 0 — they create confusing tab order
''',
  quiz: [
    Quiz(question: 'What does tabindex="-1" do?', options: [
      QuizOption(text: 'Makes the element focusable via JavaScript but skipped in the natural tab order', correct: true),
      QuizOption(text: 'Removes the element from the page entirely', correct: false),
      QuizOption(text: 'Makes the element the first in the tab order', correct: false),
      QuizOption(text: 'Prevents the element from receiving focus at all', correct: false),
    ]),
    Quiz(question: 'How do you read data-item-id="42" in JavaScript?', options: [
      QuizOption(text: 'element.dataset.itemId', correct: true),
      QuizOption(text: 'element.getAttribute("data-item-id")', correct: true),
      QuizOption(text: 'element.dataset["item-id"]', correct: false),
      QuizOption(text: 'element.data.itemId', correct: false),
    ]),
    Quiz(question: 'What does the inert attribute do?', options: [
      QuizOption(text: 'Makes the entire element subtree non-interactive — no focus, no clicks, no screen reader access', correct: true),
      QuizOption(text: 'Makes the element invisible', correct: false),
      QuizOption(text: 'Freezes JavaScript event listeners on the element', correct: false),
      QuizOption(text: 'Prevents CSS from applying to the element', correct: false),
    ]),
  ],
);
