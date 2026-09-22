// lib/lessons/html/html_02_headings_paragraphs.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final htmlLesson02 = Lesson(
  language: 'HTML',
  title: 'Headings, Paragraphs, and Text',
  content: '''
🎯 METAPHOR:
Headings are like the table of contents in a spectacular
coffee-table book. h1 is the title on the cover — bold,
unmissable, one per book. h2 are the chapter titles.
h3 are the section headers within chapters. All the way
down to h6, which is a tiny footnote heading that almost
nobody uses. The hierarchy creates the OUTLINE of your page.
Search engines read it. Screen readers navigate by it.
It is the most important structural decision you make.

📖 EXPLANATION:
HEADINGS — six levels of importance:
  <h1> Most important — page title, use ONCE per page
  <h2> Section headings
  <h3> Sub-section headings
  <h4> Sub-sub-section headings
  <h5> Rarely used
  <h6> Almost never used

Do NOT choose headings based on size — use CSS for that.
Choose headings based on HIERARCHY and MEANING.

TEXT ELEMENTS:
  <p>         paragraph — block of text, auto spacing
  <br>        line break — void element
  <hr>        horizontal rule / thematic break — void element
  <strong>    important text (bold by default)
  <em>        emphasized text (italic by default)
  <b>         bold — stylistic, not semantic
  <i>         italic — stylistic, not semantic
  <u>         underline — avoid (confused with links)
  <s>         strikethrough
  <mark>      highlighted text
  <small>     smaller text / fine print
  <sub>       subscript (H₂O)
  <sup>       superscript (E=mc²)
  <code>      inline code
  <pre>       preformatted text (preserves whitespace)
  <kbd>       keyboard input
  <samp>      sample output
  <var>       variable in code/math
  <abbr>      abbreviation with title
  <cite>      citation of creative work
  <q>         inline quotation
  <blockquote> block quotation
  <time>      machine-readable date/time
  <address>   contact information

💻 CODE:
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Text Elements</title>
</head>
<body>

  <!-- HEADINGS — hierarchy, not size -->
  <h1>The History of Coffee ☕</h1>
  <h2>Chapter 1: Origins in Ethiopia</h2>
  <h3>The Legend of Kaldi</h3>
  <h4>Archaeological Evidence</h4>

  <!-- PARAGRAPHS -->
  <p>
    Coffee was first discovered in the highlands of Ethiopia,
    where goats were observed dancing after eating berries
    from a certain tree. Their herder, Kaldi, reported this
    to the local monastery.
  </p>

  <p>
    The monks made a drink from the berries and found that
    it kept them alert during long evening prayers.
    <!-- br: line break within a paragraph -->
    Word spread east, and coffee reached the Arabian Peninsula.
  </p>

  <!-- HR: thematic break between sections -->
  <hr>

  <!-- INLINE TEXT ELEMENTS -->
  <p>
    Coffee contains <strong>caffeine</strong>, which is
    <em>extremely important</em> for morning productivity.
  </p>

  <p>
    The chemical formula for caffeine is C₈H₁₀N₄O₂.
    Written with markup: C<sub>8</sub>H<sub>10</sub>N<sub>4</sub>O<sub>2</sub>
  </p>

  <p>
    Einstein's famous equation: E=mc<sup>2</sup>
  </p>

  <p>
    <mark>This text is highlighted</mark> like a neon marker.
  </p>

  <p>
    <s>Original price: \$20</s> — Now only \$12!
  </p>

  <p>
    Press <kbd>Ctrl</kbd> + <kbd>C</kbd> to copy.
  </p>

  <p>
    The function returns <samp>true</samp> on success.
  </p>

  <p>
    The variable <var>x</var> represents the unknown value.
  </p>

  <!-- ABBREVIATIONS -->
  <p>
    The <abbr title="World Wide Web Consortium">W3C</abbr>
    sets the standards for HTML.
  </p>

  <!-- QUOTES -->
  <p>
    As Einstein said: <q>Imagination is more important than knowledge.</q>
  </p>

  <blockquote cite="https://example.com/speech">
    <p>We choose to go to the Moon in this decade and do the
    other things, not because they are easy, but because
    they are hard.</p>
    <cite>— John F. Kennedy, 1962</cite>
  </blockquote>

  <!-- TIME -->
  <p>
    The event is on
    <time datetime="2024-07-04">July 4th, 2024</time>.
  </p>

  <!-- CODE -->
  <p>Use <code>console.log()</code> to debug.</p>

  <!-- PRE: preserves all whitespace and line breaks -->
  <pre>
    function greet(name) {
      return "Hello, " + name + "!";
    }
  </pre>

  <!-- ADDRESS -->
  <address>
    Written by <a href="mailto:author@example.com">The Author</a>.<br>
    123 Web Street, Internet City
  </address>

</body>
</html>

📝 KEY POINTS:
✅ Use ONE <h1> per page — it tells search engines what the page is about
✅ Never skip heading levels (h1 → h3) — maintain logical hierarchy
✅ <strong> means importance; <b> means bold — prefer semantic elements
✅ <em> means emphasis; <i> means italic — prefer semantic elements
✅ <time datetime="..."> makes dates machine-readable for SEO and assistive tech
✅ <blockquote> is for long quotes; <q> for inline quotes
❌ Don't use headings to make text bigger — use CSS font-size
❌ Don't use <br> to create spacing between paragraphs — use CSS margin
''',
  quiz: [
    Quiz(question: 'How many <h1> elements should a page typically have?', options: [
      QuizOption(text: 'One — it represents the main topic of the entire page', correct: true),
      QuizOption(text: 'As many as needed for large pages', correct: false),
      QuizOption(text: 'Two — one for the header and one for the main content', correct: false),
      QuizOption(text: 'None — use CSS to style h2 to look like h1 instead', correct: false),
    ]),
    Quiz(question: 'What is the semantic difference between <strong> and <b>?', options: [
      QuizOption(text: '<strong> marks text as important; <b> is purely visual bold styling', correct: true),
      QuizOption(text: 'They are identical — just different names', correct: false),
      QuizOption(text: '<b> marks text as important; <strong> is purely visual', correct: false),
      QuizOption(text: '<strong> is block-level; <b> is inline', correct: false),
    ]),
    Quiz(question: 'What does the datetime attribute on <time> do?', options: [
      QuizOption(text: 'Provides a machine-readable date format for search engines and assistive tech', correct: true),
      QuizOption(text: 'Displays a formatted date automatically', correct: false),
      QuizOption(text: 'Sets a countdown timer on the element', correct: false),
      QuizOption(text: 'Validates that the text content is a valid date', correct: false),
    ]),
  ],
);
