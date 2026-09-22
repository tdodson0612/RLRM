// lib/lessons/css/css_05_typography.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cssLesson05 = Lesson(
  language: 'CSS',
  title: 'Typography and Text',
  content: '''
🎯 METAPHOR:
Typography in CSS is like being a typesetter at a printing
press. You choose the typeface (font-family), the size of
the type blocks (font-size), how heavy the ink is pressed
(font-weight), whether letters are upright or slanted
(font-style), how much space between lines (line-height),
and how the text is arranged on the page (text-align).
Good typography is invisible — bad typography is painful.
These properties are your entire type-setting toolkit.

📖 EXPLANATION:
Text is the most important content on the web. CSS gives
you comprehensive control over how text looks and behaves.

─────────────────────────────────────
FONT PROPERTIES:
─────────────────────────────────────
font-family       which typeface to use
font-size         size of text
font-weight       thickness (100-900, bold, normal)
font-style        italic, oblique, normal
font-variant      small-caps
line-height       space between lines
font              shorthand for all font properties

─────────────────────────────────────
TEXT PROPERTIES:
─────────────────────────────────────
color             text color
text-align        left, right, center, justify
text-decoration   underline, line-through, none
text-transform    uppercase, lowercase, capitalize
text-indent       first line indent
letter-spacing    space between letters
word-spacing      space between words
text-shadow       drop shadow behind text
white-space       how whitespace is handled
text-overflow     what happens when text overflows
─────────────────────────────────────

💻 CODE:
/* ─── FONT FAMILY ─── */
body {
  /* Font stack: try each, use first available */
  font-family: 'Inter', 'Segoe UI', Arial, sans-serif;
}

/* System font stack (fast, no download needed) */
.system-font {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI',
               Roboto, Oxygen, Ubuntu, sans-serif;
}

/* ─── GOOGLE FONTS (add to HTML head) ─── */
/* <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet"> */
.google-font { font-family: 'Roboto', sans-serif; }

/* ─── FONT SIZE ─── */
/* px: absolute, predictable */
h1 { font-size: 32px; }

/* rem: relative to root element (best for accessibility) */
body { font-size: 16px; }   /* base */
h1   { font-size: 2rem; }   /* 32px */
h2   { font-size: 1.5rem; } /* 24px */
p    { font-size: 1rem; }   /* 16px */
small { font-size: 0.875rem; } /* 14px */

/* em: relative to parent element */
.parent { font-size: 20px; }
.child  { font-size: 0.8em; } /* 16px (0.8 × 20) */

/* ─── FONT WEIGHT ─── */
.thin    { font-weight: 100; }
.regular { font-weight: 400; } /* same as 'normal' */
.medium  { font-weight: 500; }
.bold    { font-weight: 700; } /* same as 'bold' */
.black   { font-weight: 900; }

/* ─── LINE HEIGHT ─── */
/* Unitless is recommended — scales with font size */
p { line-height: 1.6; }  /* 160% of font size */
h1 { line-height: 1.2; } /* tighter for headings */

/* ─── TEXT PROPERTIES ─── */
h1 { text-align: center; }
.justify { text-align: justify; }

/* Removing underline from links */
a { text-decoration: none; }
a:hover { text-decoration: underline; }

/* Transform */
.uppercase { text-transform: uppercase; }
.caps      { text-transform: capitalize; } /* First Letter Each Word */

/* Truncate overflowing text with ellipsis */
.truncate {
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  max-width: 200px;
}

/* ─── TEXT SHADOW ─── */
/* text-shadow: x-offset y-offset blur color */
h1 {
  text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
}
.glow {
  text-shadow: 0 0 10px #0066ff, 0 0 20px #0066ff;
}

/* ─── FONT SHORTHAND ─── */
/* font: style variant weight size/line-height family */
.shorthand {
  font: italic bold 1.2rem/1.6 'Georgia', serif;
}

📝 KEY POINTS:
✅ Use rem for font sizes — respects user's browser accessibility settings
✅ Always provide a font stack — fallbacks if the first font isn't available
✅ Line-height: 1.4-1.6 is ideal for body text readability
✅ font-weight numbers (100-900) require the font to have those weights available
✅ The truncation pattern (white-space + overflow + text-overflow) is commonly needed
❌ Don't use px for font-size on body text — breaks browser zoom accessibility
❌ text-align: justify can create uneven word spacing — use carefully
''',
  quiz: [
    Quiz(question: 'Why is "rem" preferred over "px" for font sizes?', options: [
      QuizOption(text: 'rem respects the user\'s browser base font size setting — better accessibility', correct: true),
      QuizOption(text: 'rem is more precise than px', correct: false),
      QuizOption(text: 'rem works in more browsers', correct: false),
      QuizOption(text: 'rem automatically adjusts for screen size', correct: false),
    ]),
    Quiz(question: 'What three properties are needed to show "..." when text overflows?', options: [
      QuizOption(text: 'white-space: nowrap, overflow: hidden, text-overflow: ellipsis', correct: true),
      QuizOption(text: 'overflow: hidden, clip: ellipsis, max-width', correct: false),
      QuizOption(text: 'text-overflow: ellipsis alone is sufficient', correct: false),
      QuizOption(text: 'overflow: scroll, text-clip: ellipsis, width', correct: false),
    ]),
    Quiz(question: 'What does line-height: 1.6 mean?', options: [
      QuizOption(text: 'Line height is 160% of the current font size', correct: true),
      QuizOption(text: 'Line height is 1.6 pixels', correct: false),
      QuizOption(text: 'Line height is 1.6 rem', correct: false),
      QuizOption(text: 'Lines are spaced 1.6 inches apart', correct: false),
    ]),
  ],
);
