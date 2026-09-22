// lib/lessons/css/css_03_colors.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cssLesson03 = Lesson(
  language: 'CSS',
  title: 'Colors',
  content: '''
🎯 METAPHOR:
Colors in CSS are like paint — but you can specify any color
in four completely different ways depending on what's most
convenient. You can ask for "red" by name (like saying
"fire engine red"), by its RGB recipe (like a paint formula),
by its hex code (like a manufacturer's code), or by its
HSL recipe (hue, saturation, lightness — the artist's way).
All four ways describe the same color — you choose whichever
is most useful for your situation.

📖 EXPLANATION:
CSS supports several color formats:

─────────────────────────────────────
COLOR FORMATS:
─────────────────────────────────────
Named       color: red;
            color: cornflowerblue;
            (148 named colors)

Hex         color: #ff0000;    (red)
            color: #f00;       (shorthand — same as #ff0000)
            color: #ff000080;  (with alpha — 50% transparent)

RGB         color: rgb(255, 0, 0);
            color: rgb(255 0 0);   (modern, no commas)

RGBA        color: rgba(255, 0, 0, 0.5);  (50% transparent)

HSL         color: hsl(0, 100%, 50%);     (red)
            Hue: 0-360° on color wheel
            Saturation: 0% grey → 100% vivid
            Lightness: 0% black → 50% normal → 100% white

HSLA        color: hsla(0, 100%, 50%, 0.5);

Modern (CSS Color Level 4):
            color: rgb(255 0 0 / 0.5);    (slash for alpha)
            color: hsl(0 100% 50% / 50%); (all in one)

─────────────────────────────────────
SPECIAL VALUES:
─────────────────────────────────────
transparent     fully transparent (rgba(0,0,0,0))
currentColor    inherits color from the element itself
inherit         inherits from parent
─────────────────────────────────────

💻 CODE:
/* Named colors */
h1 { color: navy; }
p  { color: dimgray; }

/* Hex colors */
.primary   { color: #0066cc; }
.secondary { color: #6c757d; }
.danger    { color: #dc3545; }
.light     { color: #f8f9fa; }

/* Hex shorthand — #rgb where each digit is doubled */
.red   { color: #f00; }  /* same as #ff0000 */
.white { color: #fff; }  /* same as #ffffff */
.black { color: #000; }  /* same as #000000 */

/* RGB */
.custom { color: rgb(100, 149, 237); }  /* cornflower blue */

/* RGBA — transparency */
.overlay { background-color: rgba(0, 0, 0, 0.5); } /* 50% black */
.glass   { background-color: rgba(255, 255, 255, 0.2); }

/* HSL — great for creating color variations */
:root {
  --brand-hue: 220;
}
.brand          { color: hsl(220, 80%, 50%); }
.brand-light    { color: hsl(220, 80%, 70%); }
.brand-dark     { color: hsl(220, 80%, 30%); }
.brand-muted    { color: hsl(220, 20%, 50%); }

/* currentColor — border uses same color as text */
.icon {
  color: #0066cc;
  border: 2px solid currentColor; /* also #0066cc */
}

/* Modern syntax */
.modern { color: rgb(100 149 237 / 0.8); }

📝 KEY POINTS:
✅ Hex is most common — use it for specific brand colors
✅ HSL is best for creating color variations — just change the L value
✅ rgba/hsla for transparency — use when you need see-through elements
✅ currentColor is a powerful shortcut — border and icon match text color
✅ CSS Custom Properties (variables) make color systems manageable
❌ Opacity (opacity: 0.5) affects the whole element AND its children — rgba is more precise
❌ Avoid color names for important colors — they're browser-interpreted
''',
  quiz: [
    Quiz(question: 'What does the "L" in HSL control?', options: [
      QuizOption(text: 'Lightness — 0% is black, 50% is the pure color, 100% is white', correct: true),
      QuizOption(text: 'Length of the color range', correct: false),
      QuizOption(text: 'Luminosity — the total brightness of the screen', correct: false),
      QuizOption(text: 'Level of saturation', correct: false),
    ]),
    Quiz(question: 'What is the shorthand hex equivalent of #336699?', options: [
      QuizOption(text: '#369', correct: true),
      QuizOption(text: '#369699', correct: false),
      QuizOption(text: '#336', correct: false),
      QuizOption(text: 'There is no shorthand for this color', correct: false),
    ]),
    Quiz(question: 'What does "currentColor" do in CSS?', options: [
      QuizOption(text: 'Uses the element\'s computed color value for the property', correct: true),
      QuizOption(text: 'Inherits color from the browser default', correct: false),
      QuizOption(text: 'Sets the color to whatever was last defined', correct: false),
      QuizOption(text: 'Matches the background color', correct: false),
    ]),
  ],
);
