// lib/lessons/html/html_01_what_is_html.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final htmlLesson01 = Lesson(
  language: 'HTML',
  title: 'What is HTML?',
  content: '''
🎯 METAPHOR:
HTML is the skeleton of every web page that has ever existed.
CSS is the wardrobe — the silk shirts, the tailored suits,
the neon sneakers. JavaScript is the nervous system —
the reflexes, the movement, the personality.
But none of it works without the skeleton underneath.
HTML says: HERE is a heading. HERE is a paragraph.
HERE is a button. The browser reads those bones and
builds a page from them. You are about to learn
the language every single website on earth speaks.

📖 EXPLANATION:
HTML stands for HyperText Markup Language.

HyperText — text that links to other text (hyperlinks).
Markup Language — a system of tags that annotate content
  to describe its meaning and structure.

HTML is NOT a programming language. It has no logic,
no loops, no conditions. It is purely structural.
It describes WHAT something is — not how it looks
(CSS) or what it does (JavaScript).

A web browser (Chrome, Safari, Firefox) reads your HTML
and builds the DOM (Document Object Model) — a live
tree of objects representing every element on the page.

HTML was invented by Tim Berners-Lee in 1991.
The current version is HTML5, which brought powerful
new semantic elements, native video/audio, canvas,
and many APIs that previously required plugins.

ANATOMY OF AN HTML ELEMENT:
  <tagname attribute="value"> content </tagname>
  ↑ opening tag               ↑ content  ↑ closing tag

VOID ELEMENTS have no closing tag and no content:
  <br>  <hr>  <img>  <input>  <meta>  <link>

ATTRIBUTES live inside the opening tag:
  <a href="https://example.com">Click me</a>
  <img src="photo.jpg" alt="A photo">

THE BASIC PAGE STRUCTURE:
<!DOCTYPE html>
<html lang="en">
  <head>
    <!-- Metadata — not visible on page -->
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Page</title>
    <link rel="stylesheet" href="styles.css">
  </head>
  <body>
    <!-- Everything visible goes here -->
    <h1>Hello, World!</h1>
    <p>Welcome to my first web page.</p>
  </body>
</html>

💻 CODE:
<!DOCTYPE html>
<!-- DOCTYPE tells the browser: use modern HTML5 rules -->

<html lang="en">
<!-- lang="en" helps screen readers and search engines -->

  <head>
    <!-- HEAD = the brain — invisible but essential -->
    <meta charset="UTF-8">
    <!-- charset: support all characters including emoji 🎉 -->

    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- viewport: make the page responsive on mobile devices -->

    <title>My Awesome Page</title>
    <!-- title: appears in browser tab and search results -->

    <link rel="stylesheet" href="styles.css">
    <!-- link: connect an external CSS file -->
  </head>

  <body>
    <!-- BODY = everything the user sees and interacts with -->

    <h1>Welcome! 🌟</h1>
    <!-- h1: the most important heading on the page -->

    <p>This is my very first web page.</p>
    <!-- p: a paragraph of text -->

    <a href="https://developer.mozilla.org">
      Learn more at MDN
    </a>
    <!-- a: a hyperlink — the original "hyper" in HyperText -->

  </body>
</html>

─────────────────────────────────────
QUICK GLOSSARY:
─────────────────────────────────────
Element    the complete unit: tag + content + closing tag
Tag        the angle-bracket label: <p>, <h1>, <div>
Attribute  extra info inside the opening tag: href, src, class
Content    what lives between opening and closing tags
Void elem  self-closing, no content: <br>, <img>, <input>
DOM        Document Object Model — the browser's live tree
─────────────────────────────────────

📝 KEY POINTS:
✅ HTML is the structure — CSS is style, JavaScript is behavior
✅ Every HTML page needs <!DOCTYPE html> as the very first line
✅ <head> holds metadata; <body> holds visible content
✅ lang attribute on <html> helps accessibility and search engines
✅ The viewport meta tag is essential for mobile-responsive pages
❌ HTML is NOT a programming language — it has no logic or conditions
❌ Don't skip <!DOCTYPE html> — without it browsers use "quirks mode"
''',
  quiz: [
    Quiz(question: 'What does HTML stand for?', options: [
      QuizOption(text: 'HyperText Markup Language', correct: true),
      QuizOption(text: 'High-Tech Modern Language', correct: false),
      QuizOption(text: 'HyperText Machine Learning', correct: false),
      QuizOption(text: 'Home Tool Markup Language', correct: false),
    ]),
    Quiz(question: 'What is the purpose of the <head> element?', options: [
      QuizOption(text: 'To contain metadata about the page — not visible to users', correct: true),
      QuizOption(text: 'To display a header at the top of the page', correct: false),
      QuizOption(text: 'To contain the main navigation menu', correct: false),
      QuizOption(text: 'To load JavaScript files only', correct: false),
    ]),
    Quiz(question: 'What is a void element?', options: [
      QuizOption(text: 'An element with no closing tag and no content, like <br> or <img>', correct: true),
      QuizOption(text: 'An element with no attributes', correct: false),
      QuizOption(text: 'An empty <div> with no children', correct: false),
      QuizOption(text: 'An element that has been removed from the page', correct: false),
    ]),
  ],
);
