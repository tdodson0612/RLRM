// lib/lessons/html/html_05_lists.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final htmlLesson05 = Lesson(
  language: 'HTML',
  title: 'Lists',
  content: '''
🎯 METAPHOR:
Lists are the great organizers of the web. Imagine trying to
read a recipe where every ingredient and every step was
crammed into one giant paragraph. Chaos. Lists impose order.
They say: "These items belong together. They are related.
Here is one, and here is the next." Every navigation menu
you have ever clicked? A list. Every set of features on
a pricing page? A list. Every breadcrumb trail? A list.
HTML lists are not just bullet points — they are the
structural backbone of organized web content.

📖 EXPLANATION:
THREE TYPES OF LISTS:

<ul> — Unordered List
  Items where order doesn't matter.
  Default: bullet points.
  Use for: navigation menus, feature lists, ingredients.

<ol> — Ordered List
  Items where order DOES matter.
  Default: numbers 1, 2, 3...
  Use for: steps, rankings, instructions.
  Attributes: start, reversed, type

<dl> — Description List
  Key-value pairs. Term + its definition.
  <dt> — description term
  <dd> — description definition
  Use for: glossaries, metadata, FAQ.

NESTING:
  Lists can be nested inside other lists.
  Navigation menus often use nested <ul>.

OL ATTRIBUTES:
  start="5"       — start numbering at 5
  reversed        — count down instead of up
  type="A"        — A B C D
  type="a"        — a b c d
  type="I"        — I II III IV
  type="i"        — i ii iii iv
  type="1"        — 1 2 3 (default)

<li value="3"> — override number for specific item

💻 CODE:
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Lists Demo</title>
</head>
<body>

  <!-- ─── UNORDERED LIST ─── -->
  <h2>Ingredients</h2>
  <ul>
    <li>2 cups of flour</li>
    <li>1 cup of sugar</li>
    <li>3 eggs</li>
    <li>1/2 cup of butter</li>
  </ul>

  <!-- ─── ORDERED LIST ─── -->
  <h2>Instructions</h2>
  <ol>
    <li>Preheat oven to 350°F</li>
    <li>Mix dry ingredients</li>
    <li>Add wet ingredients and combine</li>
    <li>Pour into pan and bake for 30 minutes</li>
    <li>Let cool before serving</li>
  </ol>

  <!-- ─── OL ATTRIBUTES ─── -->
  <!-- Start at 5 -->
  <ol start="5">
    <li>Step five</li>
    <li>Step six</li>
    <li>Step seven</li>
  </ol>

  <!-- Count down -->
  <ol reversed>
    <li>Third place: Bronze</li>
    <li>Second place: Silver</li>
    <li>First place: Gold</li>
  </ol>

  <!-- Alphabetical -->
  <ol type="A">
    <li>Option Alpha</li>
    <li>Option Beta</li>
    <li>Option Gamma</li>
  </ol>

  <!-- Roman numerals -->
  <ol type="I">
    <li>Introduction</li>
    <li>Methods</li>
    <li>Results</li>
    <li>Conclusion</li>
  </ol>

  <!-- ─── DESCRIPTION LIST ─── -->
  <h2>Glossary</h2>
  <dl>
    <dt>HTML</dt>
    <dd>HyperText Markup Language — the structure of web pages.</dd>

    <dt>CSS</dt>
    <dd>Cascading Style Sheets — the visual styling of web pages.</dd>

    <dt>JavaScript</dt>
    <dd>A programming language that adds interactivity to web pages.</dd>

    <!-- One term, multiple definitions -->
    <dt>Bank</dt>
    <dd>A financial institution that holds money.</dd>
    <dd>The side of a river or lake.</dd>
  </dl>

  <!-- ─── NESTED LISTS ─── -->
  <h2>Table of Contents</h2>
  <ol>
    <li>
      Introduction
      <ul>
        <li>Background</li>
        <li>Goals</li>
      </ul>
    </li>
    <li>
      Methods
      <ul>
        <li>Data Collection</li>
        <li>Analysis</li>
        <li>Tools Used</li>
      </ul>
    </li>
    <li>
      Results
      <ul>
        <li>Primary Findings</li>
        <li>Secondary Findings</li>
      </ul>
    </li>
    <li>Conclusion</li>
  </ol>

  <!-- ─── NAVIGATION (SEMANTIC USE OF UL) ─── -->
  <nav aria-label="Main Navigation">
    <ul>
      <li><a href="/">Home</a></li>
      <li>
        <a href="/products">Products</a>
        <!-- Nested dropdown -->
        <ul>
          <li><a href="/products/software">Software</a></li>
          <li><a href="/products/hardware">Hardware</a></li>
          <li><a href="/products/services">Services</a></li>
        </ul>
      </li>
      <li><a href="/about">About</a></li>
      <li><a href="/contact">Contact</a></li>
    </ul>
  </nav>

</body>
</html>

📝 KEY POINTS:
✅ Use <ul> when order doesn't matter (ingredients, features, navigation)
✅ Use <ol> when order matters (steps, rankings, instructions)
✅ Use <dl> for term-definition pairs (glossary, FAQ, metadata)
✅ Navigation menus are almost always <ul> with <li><a> inside
✅ Lists can be nested — great for table of contents and dropdown menus
✅ OL supports start, reversed, and type attributes for custom numbering
❌ Don't use lists just for indentation — use CSS padding/margin instead
❌ <li> can only be a direct child of <ul> or <ol> — not standalone
''',
  quiz: [
    Quiz(question: 'Which list type should you use for a set of cooking steps?', options: [
      QuizOption(text: '<ol> — ordered list, because the sequence matters', correct: true),
      QuizOption(text: '<ul> — unordered list, because bullets look cleaner', correct: false),
      QuizOption(text: '<dl> — description list, because each step has a name', correct: false),
      QuizOption(text: 'Any list type — they are interchangeable', correct: false),
    ]),
    Quiz(question: 'What is a <dl> element used for?', options: [
      QuizOption(text: 'Description lists — pairing terms with their definitions or values', correct: true),
      QuizOption(text: 'Downloadable lists that users can save', correct: false),
      QuizOption(text: 'Dynamic lists that update with JavaScript', correct: false),
      QuizOption(text: 'Deeply nested list structures', correct: false),
    ]),
    Quiz(question: 'What does the "reversed" attribute do on an <ol>?', options: [
      QuizOption(text: 'Makes the list count down from the total number of items to 1', correct: true),
      QuizOption(text: 'Reverses the visual order of list items', correct: false),
      QuizOption(text: 'Displays items from right to left', correct: false),
      QuizOption(text: 'Makes the list use reverse alphabetical order', correct: false),
    ]),
  ],
);
