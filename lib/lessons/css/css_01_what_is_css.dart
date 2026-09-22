// lib/lessons/css/css_01_what_is_css.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cssLesson01 = Lesson(
  language: 'CSS',
  title: 'What is CSS?',
  content: '''
🎯 METAPHOR:
HTML is the skeleton of a webpage — the bones and structure.
CSS is the skin, clothes, and makeup on top of that skeleton.
The skeleton tells you WHAT is there (a heading, a paragraph,
a button). CSS tells you HOW it looks: the color, the size,
the font, the spacing, the layout. Without CSS, every webpage
looks like a plain text document from 1993. With CSS, it can
look like anything you can imagine.

📖 EXPLANATION:
CSS stands for Cascading Style Sheets.
Created by Håkon Wium Lie and Bert Bos in 1994, first
released as CSS1 in 1996. We now use CSS3 and beyond.

The "Cascading" part means styles flow DOWN — from parent
elements to children, and from multiple stylesheets that
combine in a specific order (the cascade).

THREE WAYS TO ADD CSS:
  1. Inline    — style="" attribute on an HTML element
  2. Internal  — <style> tag in the <head>
  3. External  — separate .css file linked with <link>

External is always preferred for real projects.

💻 CODE:
<!-- 1. Inline CSS (avoid — hard to maintain) -->
<p style="color: red; font-size: 18px;">Red text</p>

<!-- 2. Internal CSS -->
<head>
  <style>
    p {
      color: blue;
      font-size: 16px;
    }
  </style>
</head>

<!-- 3. External CSS (best practice) -->
<head>
  <link rel="stylesheet" href="styles.css">
</head>

/* styles.css */
p {
  color: green;
  font-size: 16px;
}

─────────────────────────────────────
CSS RULE ANATOMY:
─────────────────────────────────────
selector {
  property: value;
  property: value;
}

p {           ← selector (targets all <p> elements)
  color: red; ← declaration (property: value)
  font-size: 16px;
}             ← closing brace
─────────────────────────────────────

CSS COMMENTS:
/* This is a CSS comment */
/* Comments can span
   multiple lines */

📝 KEY POINTS:
✅ CSS controls the visual presentation of HTML
✅ External stylesheets keep HTML and CSS separate (best practice)
✅ A CSS rule = selector + declarations inside {}
✅ Declarations are property: value pairs ending with semicolons
✅ CSS is case-insensitive but by convention use lowercase
❌ Don't use inline styles for anything beyond quick tests
❌ CSS does NOT use // for comments — only /* */
''',
  quiz: [
    Quiz(question: 'What does CSS stand for?', options: [
      QuizOption(text: 'Cascading Style Sheets', correct: true),
      QuizOption(text: 'Creative Style System', correct: false),
      QuizOption(text: 'Computer Style Sheets', correct: false),
      QuizOption(text: 'Colorful Style Syntax', correct: false),
    ]),
    Quiz(question: 'Which method of adding CSS is considered best practice for real projects?', options: [
      QuizOption(text: 'External stylesheet linked with <link>', correct: true),
      QuizOption(text: 'Inline style="" attributes', correct: false),
      QuizOption(text: 'Internal <style> tag in <head>', correct: false),
      QuizOption(text: 'JavaScript-generated styles', correct: false),
    ]),
    Quiz(question: 'What is the correct comment syntax in CSS?', options: [
      QuizOption(text: '/* comment */', correct: true),
      QuizOption(text: '// comment', correct: false),
      QuizOption(text: '<!-- comment -->', correct: false),
      QuizOption(text: '# comment', correct: false),
    ]),
  ],
);
