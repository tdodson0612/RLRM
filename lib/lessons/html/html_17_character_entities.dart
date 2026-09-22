// lib/lessons/html/html_17_character_entities.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final htmlLesson17 = Lesson(
  language: 'HTML',
  title: 'Character Entities, Special Characters, and Encoding',
  content: '''
🎯 METAPHOR:
HTML uses < and > for its own tags. So what happens when
you want to DISPLAY a less-than sign or a greater-than sign?
If you type <3 in HTML, the browser thinks you started
a tag called "3". Character entities are the escape hatch —
a coded way to say "display this special character as text,
not as HTML syntax." &lt; means "show a literal <".
It is like putting quotation marks around a word in a
sentence to show you mean the word itself, not its action.
"I used the word 'delete' — I did not delete anything."

📖 EXPLANATION:
CHARACTER ENTITIES convert special characters to safe HTML:

SYNTAX:  &name;    or    &#number;    or    &#xHex;

ESSENTIAL ENTITIES:
  &lt;        <    less than
  &gt;        >    greater than
  &amp;       &    ampersand
  &quot;      "    double quote
  &apos;      \'    single quote / apostrophe
  &nbsp;           non-breaking space
  &copy;      ©    copyright
  &reg;       ®    registered trademark
  &trade;     ™    trademark
  &mdash;     —    em dash (long dash)
  &ndash;     –    en dash (medium dash)
  &laquo;     «    left double angle quotes
  &raquo;     »    right double angle quotes
  &hellip;    …    ellipsis (three dots)
  &middot;    ·    middle dot
  &bull;      •    bullet
  &euro;      €    Euro
  &pound;     £    Pound sterling
  &yen;       ¥    Yen
  &deg;       °    degree
  &plusmn;    ±    plus-minus
  &frac12;    ½    one half
  &frac14;    ¼    one quarter
  &frac34;    ¾    three quarters
  &times;     ×    multiplication
  &divide;    ÷    division
  &rarr;      →    right arrow
  &larr;      ←    left arrow
  &uarr;      ↑    up arrow
  &darr;      ↓    down arrow
  &harr;      ↔    left-right arrow
  &hearts;    ♥    heart
  &spades;    ♠    spade
  &clubs;     ♣    club
  &diams;     ♦    diamond

UTF-8 NOTE:
  With <meta charset="UTF-8">, you can usually type
  special characters DIRECTLY in your HTML file.
  Entities are mainly needed for < > & in content,
  or in situations where the character can't be typed.

💻 CODE:
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Special Characters &amp; Entities</title>
  <!-- Note &amp; in the title! -->
</head>
<body>

  <!-- ─── REQUIRED ESCAPES ─── -->
  <!-- These MUST be escaped when used as content -->

  <p>HTML tags use &lt;angle brackets&gt; like this.</p>
  <!-- Without escaping: <p>HTML tags use <angle brackets> like this.</p>
       Browser would try to parse <angle as a tag! -->

  <p>Use &amp;amp; to show a literal &amp; sign.</p>
  <!-- Displays: Use &amp; to show a literal & sign -->

  <p>The price is "only" &quot;free&quot; in quotes.</p>

  <!-- Attributes also need escaping -->
  <a href="/search?q=coffee&amp;sort=price">
    Search for Coffee
  </a>
  <!-- & in URLs inside href must be &amp; in HTML -->

  <!-- ─── TYPOGRAPHY ENTITIES ─── -->
  <p>The em dash&mdash;like this&mdash;is used for interruptions.</p>
  <p>The range is 2010&ndash;2024.</p>
  <p>Loading&hellip;</p>
  <p>5&deg;C &middot; Partly Cloudy</p>

  <!-- ─── MATH ENTITIES ─── -->
  <p>Area = &pi;r&sup2;</p>
  <p>Temperature: 37&deg;C &plusmn; 0.5&deg;</p>
  <p>&frac12; cup of flour + &frac14; cup of sugar</p>
  <p>2 &times; 3 = 6, and 6 &divide; 2 = 3</p>

  <!-- ─── CURRENCIES ─── -->
  <p>USD: \$14.99 &middot; EUR: &euro;13.50 &middot; GBP: &pound;11.99</p>

  <!-- ─── ARROWS AND SYMBOLS ─── -->
  <p>Next &rarr; | &larr; Back | &uarr; Top | &darr; Bottom</p>
  <p>I &hearts; HTML &amp; CSS</p>

  <!-- ─── COPYRIGHT AND LEGAL ─── -->
  <p>&copy; 2024 BeanCo Coffee Company&trade; All rights reserved.</p>
  <p>The BeanCo logo is a registered trademark&reg; in 40 countries.</p>

  <!-- ─── NON-BREAKING SPACE ─── -->
  <!-- &nbsp; prevents line break between two words -->
  <p>
    Dr.&nbsp;Alice Johnson was awarded the prize.
    <!-- "Dr." and "Alice" will never be on separate lines -->
  </p>
  <p>
    The package weighs 5&nbsp;kg.
    <!-- Number and unit stay together -->
  </p>

  <!-- ─── NUMERIC ENTITIES ─── -->
  <!-- &#169; = © (decimal) -->
  <p>&#169; 2024 — same as &copy;</p>

  <!-- &#x00A9; = © (hexadecimal) -->
  <p>&#x00A9; 2024 — same as &copy;</p>

  <!-- Emoji via entity -->
  <p>Star: &#x2B50; Coffee: &#x2615;</p>

  <!-- ─── DISPLAYING CODE ─── -->
  <p>
    To write a heading, use: <code>&lt;h1&gt;Title&lt;/h1&gt;</code>
  </p>

  <pre>
&lt;!DOCTYPE html&gt;
&lt;html lang="en"&gt;
  &lt;head&gt;
    &lt;title&gt;Hello World&lt;/title&gt;
  &lt;/head&gt;
  &lt;body&gt;
    &lt;p&gt;Hello, World!&lt;/p&gt;
  &lt;/body&gt;
&lt;/html&gt;
  </pre>

  <!-- ─── MODERN APPROACH: DIRECT UTF-8 ─── -->
  <!-- With UTF-8 charset, you can often type directly: -->
  <p>Copyright © 2024 · Price: €14.99 · 37°C ± 0.5°</p>
  <!-- Much cleaner than using entities for everything! -->
  <!-- But < > & in content STILL need entities -->

</body>
</html>

─────────────────────────────────────
MUST-ESCAPE IN HTML CONTENT:
─────────────────────────────────────
<    →  &lt;    (less than)
>    →  &gt;    (greater than)
&    →  &amp;   (ampersand)
"    →  &quot;  (in attribute values with double quotes)
'    →  &apos;  (in attribute values with single quotes)
─────────────────────────────────────

📝 KEY POINTS:
✅ Always escape < > & when they appear as text content
✅ Escape & in URLs inside href attributes (&amp;)
✅ &nbsp; prevents line breaks between words — use for numbers and units
✅ With UTF-8 charset, you can type © € ° etc. directly
✅ &mdash; — em dash and &ndash; – en dash are essential for good typography
❌ Don't use &nbsp; for spacing — use CSS margin/padding
❌ Don't forget to escape & in attribute values and query strings
''',
  quiz: [
    Quiz(question: 'Why do you need &amp; instead of & in an href like href="/search?q=coffee&sort=price"?', options: [
      QuizOption(text: 'The & in HTML attributes must be encoded as &amp; — bare & is invalid in HTML', correct: true),
      QuizOption(text: 'URLs don\'t support the & character', correct: false),
      QuizOption(text: 'It prevents XSS attacks', correct: false),
      QuizOption(text: 'It is optional — browsers handle both', correct: false),
    ]),
    Quiz(question: 'What does &nbsp; do that a regular space cannot?', options: [
      QuizOption(text: 'Prevents a line break between the words it connects', correct: true),
      QuizOption(text: 'Creates a wider space than a regular space', correct: false),
      QuizOption(text: 'Works in all HTML attributes including alt text', correct: false),
      QuizOption(text: 'It is the same as a regular space', correct: false),
    ]),
    Quiz(question: 'With <meta charset="UTF-8">, which characters still require HTML entities?', options: [
      QuizOption(text: 'The < > and & characters when used as content (not tag syntax)', correct: true),
      QuizOption(text: 'All special characters — UTF-8 does not eliminate the need for entities', correct: false),
      QuizOption(text: 'Only currency symbols like € and £', correct: false),
      QuizOption(text: 'No characters — UTF-8 makes all entities unnecessary', correct: false),
    ]),
  ],
);
