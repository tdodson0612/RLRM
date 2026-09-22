// lib/lessons/html/html_18_reading_docs.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final htmlLesson18 = Lesson(
  language: 'HTML',
  title: 'Reading the HTML Documentation',
  content: '''
🎯 METAPHOR:
Learning HTML from tutorials is like learning to cook
from YouTube videos — you pick up recipes and techniques.
But the HTML specification is the professional chef's
reference encyclopedia: every ingredient (element),
every technique (attribute), every edge case (browser
quirk), every historical note. When a tutorial says
"use this element for this," the spec tells you ALL
the ways it can be used, every attribute it accepts,
which browsers support it, what happens in edge cases,
and what the official W3C committee intended.
A developer who can read the docs never stays stuck.
Every question has an answer — you just need to know
where to look.

📖 EXPLANATION:
THE THREE ESSENTIAL SOURCES:

1. MDN Web Docs (developer.mozilla.org) ⭐ — START HERE
   The absolute best HTML reference.
   Written for developers, not spec lawyers.
   Has live examples, browser support tables, guides.
   URL pattern: developer.mozilla.org/en-US/docs/Web/HTML/Element/[element]

2. HTML Living Standard (html.spec.whatwg.org)
   The official specification maintained by WHATWG.
   Exhaustive but very dense.
   Use when you need the authoritative answer.

3. Can I Use (caniuse.com)
   Browser compatibility tables for every feature.
   Know before you ship whether a feature works everywhere.

HOW TO READ AN MDN ELEMENT PAGE:

The "input" element page structure:
  ① Description           — what it does
  ② Try it                — live editable example
  ③ Attributes            — every attribute explained
  ④ Usage notes           — important gotchas
  ⑤ Technical summary     — content model, allowed parents
  ⑥ Accessibility concerns — WCAG implications
  ⑦ Specifications        — link to official spec
  ⑧ Browser compatibility  — which browsers support what
  ⑨ See also              — related elements/topics

THE CONTENT MODEL TABLE:
  Tells you WHAT can go inside an element.
  "Flow content"   — most block-level stuff
  "Phrasing content" — inline stuff (what goes in paragraphs)
  "Metadata content" — stuff for <head>
  If <div> can only contain "flow content" and you try to put
  it inside a <p>, the browser will correct the error by
  moving the div out (silent HTML correction).

READING BROWSER COMPATIBILITY:
  Green = supported
  Red/grey = not supported
  The version number = when support was added
  "Partial" or ⚠️ = supported with limitations
  Footnotes = important quirks

💻 CODE:
<!-- ─── HOW TO RESEARCH AN HTML ELEMENT ─── -->

<!-- SCENARIO: You want to use <dialog> but aren't sure -->
<!-- what attributes it supports. Here's the workflow: -->

<!-- Step 1: Search "mdn dialog element" -->
<!-- Step 2: Read the description -->
<!-- Step 3: Check the "Attributes" section -->
<!-- Step 4: Check "Browser compatibility" -->
<!-- Step 5: Read "Accessibility concerns" -->
<!-- Step 6: Try the live example -->

<!-- RESULT: You learn: -->
<!-- - open attribute: makes dialog visible without JS -->
<!-- - showModal() method traps focus + adds backdrop -->
<!-- - close(returnValue) closes and stores result -->
<!-- - ::backdrop pseudo-element for styling the overlay -->
<!-- - Supported in all modern browsers since ~2022 -->
<!-- - Safari added support in 15.4 (2022) -->

<!-- ─── LIVE EXERCISE: LOOK UP THESE ELEMENTS ─── -->

<!-- 1. Look up <meter> on MDN:
     What are the low, high, and optimum attributes for? -->
<meter value="65" min="0" max="100" low="30" high="70" optimum="30">
  65%
</meter>

<!-- 2. Look up <input type="range"> on MDN:
     How do you make the slider show only even numbers? -->
<input type="range" min="0" max="100" step="2">
<!-- step="2" restricts to even numbers -->

<!-- 3. Look up <details> on MDN:
     How do you make it start open? -->
<details open>
  <summary>This starts expanded</summary>
  <p>Because of the 'open' attribute on details.</p>
</details>

<!-- 4. Look up <abbr> on MDN:
     What should the title attribute contain? -->
<abbr title="HyperText Markup Language">HTML</abbr>
<!-- title = the full expanded form of the abbreviation -->

<!-- ─── UNDERSTANDING "CONTENT MODEL" ─── -->
<!-- From MDN on <p>: "Permitted content: Phrasing content" -->
<!-- This means: <p> can only contain INLINE elements -->

<!-- VALID: inline content in paragraph -->
<p>Text with <strong>bold</strong> and <em>italic</em> parts.</p>
<p>A <a href="#">link</a> and a <span>span</span>.</p>

<!-- INVALID: block content in paragraph (browser will "fix" it) -->
<!-- <p>Text <div>Block inside paragraph</div> more text</p> -->
<!-- Browser fixes this by closing the <p> before the <div> -->

<!-- ─── READING THE WHATWG SPEC ─── -->
<!-- The spec at html.spec.whatwg.org uses this format: -->
<!--
  4.11.2 The meter element
  
  Categories: Flow content. Phrasing content. Labelable element.
  Contexts in which this element can be used: Where phrasing content is expected.
  Content model: Phrasing content, but there must be no meter element descendants.
  
  Attributes:
    value (required) — The gauge's current value
    min — The gauge's minimum value
    max — The gauge's maximum value
    low — The low limit of the gauge's "low" part
    high — The upper limit of the gauge's "middle" part
    optimum — The gauge's optimum value
-->

<!-- ─── CAN I USE WORKFLOW ─── -->
<!-- Example: checking CSS container queries support -->
<!-- 1. Go to caniuse.com -->
<!-- 2. Search "CSS container queries" -->
<!-- 3. Read the support table -->
<!-- 4. Check the percentage of users covered -->
<!-- 5. Read any footnotes for partial support notes -->

<!-- ─── HTML VALIDATOR ─── -->
<!-- Always validate your HTML! -->
<!-- validator.w3.org — paste HTML or enter URL -->
<!-- It catches: -->
<!--   Missing required attributes (alt on img) -->
<!--   Invalid nesting (div inside p) -->
<!--   Duplicate ids -->
<!--   Missing lang attribute -->
<!--   Deprecated elements and attributes -->

<!-- ─── KEY URLS TO BOOKMARK ─── -->
<!--
  MDN HTML Reference:
    developer.mozilla.org/en-US/docs/Web/HTML/Element

  MDN HTML Attributes:
    developer.mozilla.org/en-US/docs/Web/HTML/Attributes

  HTML Living Standard:
    html.spec.whatwg.org/multipage/

  Can I Use:
    caniuse.com

  W3C Validator:
    validator.w3.org

  WebAIM Accessibility:
    webaim.org/resources/contrastchecker/

  Accessibility Tree:
    chrome://accessibility (in Chrome DevTools)
-->

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Reading HTML Docs</title>
</head>
<body>

  <h1>Your Documentation Bookmarks</h1>

  <nav aria-label="HTML Documentation Resources">
    <ul>
      <li>
        <a
          href="https://developer.mozilla.org/en-US/docs/Web/HTML/Element"
          target="_blank"
          rel="noopener noreferrer"
        >
          MDN HTML Element Reference
        </a>
        — best starting point
      </li>
      <li>
        <a
          href="https://html.spec.whatwg.org/multipage/"
          target="_blank"
          rel="noopener noreferrer"
        >
          HTML Living Standard
        </a>
        — official authoritative spec
      </li>
      <li>
        <a
          href="https://caniuse.com"
          target="_blank"
          rel="noopener noreferrer"
        >
          Can I Use
        </a>
        — browser support tables
      </li>
      <li>
        <a
          href="https://validator.w3.org"
          target="_blank"
          rel="noopener noreferrer"
        >
          W3C HTML Validator
        </a>
        — validate your markup
      </li>
    </ul>
  </nav>

</body>
</html>

📝 KEY POINTS:
✅ MDN Web Docs is your primary HTML reference — bookmark it
✅ The "content model" on MDN tells you what can go inside each element
✅ Browser compatibility tables tell you whether a feature is safe to use
✅ Validate your HTML with validator.w3.org — it catches silent errors
✅ Search "mdn [element name]" in any search engine for instant access
✅ The WHATWG spec is authoritative but dense — use MDN first
❌ Don't guess — if you're unsure about an element, look it up in 30 seconds
❌ Don't rely solely on tutorials — they can be outdated or incomplete
''',
  quiz: [
    Quiz(question: 'What is the best starting resource when learning about an HTML element you haven\'t used before?', options: [
      QuizOption(text: 'MDN Web Docs — it has descriptions, attributes, examples, and browser support in one place', correct: true),
      QuizOption(text: 'The WHATWG HTML Living Standard — always use the authoritative source', correct: false),
      QuizOption(text: 'Stack Overflow — community answers are most practical', correct: false),
      QuizOption(text: 'W3Schools — it is the most popular HTML reference', correct: false),
    ]),
    Quiz(question: 'What does the "content model" section on an MDN element page tell you?', options: [
      QuizOption(text: 'What types of elements are allowed as children of this element', correct: true),
      QuizOption(text: 'How the element\'s content is displayed visually', correct: false),
      QuizOption(text: 'What CSS properties can be applied to the element', correct: false),
      QuizOption(text: 'The maximum amount of text the element can contain', correct: false),
    ]),
    Quiz(question: 'What is caniuse.com used for?', options: [
      QuizOption(text: 'Checking browser support for HTML, CSS, and JavaScript features', correct: true),
      QuizOption(text: 'Validating HTML markup for errors', correct: false),
      QuizOption(text: 'Looking up HTML element descriptions', correct: false),
      QuizOption(text: 'Testing websites on different devices', correct: false),
    ]),
  ],
);
