// lib/lessons/css/css_04_box_model.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cssLesson04 = Lesson(
  language: 'CSS',
  title: 'The Box Model',
  content: '''
🎯 METAPHOR:
Every HTML element is a box — like a picture frame.
Working from the outside in:
  MARGIN  — the empty space OUTSIDE the frame (between frames)
  BORDER  — the frame itself (can be thick, thin, colored)
  PADDING — the mat inside the frame (space between border and picture)
  CONTENT — the actual picture (text, image, etc.)

Change the margin and the frame moves away from neighbors.
Change the padding and the picture gets more breathing room.
Change the border and the frame itself gets bigger.
Understanding the box model is ESSENTIAL — it controls
all spacing and sizing in CSS.

📖 EXPLANATION:
The CSS Box Model defines how every element is sized and spaced.

─────────────────────────────────────
TOTAL WIDTH (default box-sizing):
─────────────────────────────────────
total width = content width
            + padding-left + padding-right
            + border-left + border-right
            + margin-left + margin-right

So: width: 300px + padding: 20px = 340px total content box!

─────────────────────────────────────
BOX-SIZING: BORDER-BOX (use this always):
─────────────────────────────────────
With box-sizing: border-box:
  width: 300px means 300px TOTAL including padding and border.
  Content shrinks to accommodate padding and border.
  MUCH more predictable — use it everywhere.
─────────────────────────────────────

MARGIN COLLAPSE:
  Top and bottom margins between siblings COLLAPSE.
  Two elements with margin: 20px top/bottom will have 20px
  between them (not 40px). Only vertical margins collapse.
  Horizontal margins DO NOT collapse.

💻 CODE:
/* ─── APPLY BORDER-BOX GLOBALLY (always do this) ─── */
*,
*::before,
*::after {
  box-sizing: border-box;
}

/* ─── BOX MODEL PROPERTIES ─── */
.box {
  /* Content */
  width: 300px;
  height: 200px;

  /* Padding — space inside the border */
  padding: 20px;            /* all sides */
  padding: 10px 20px;       /* top/bottom left/right */
  padding: 10px 20px 15px 5px; /* top right bottom left (clockwise) */
  padding-top: 10px;
  padding-right: 20px;
  padding-bottom: 15px;
  padding-left: 5px;

  /* Border */
  border: 2px solid #333;       /* shorthand */
  border-width: 2px;
  border-style: solid;          /* solid, dashed, dotted, none */
  border-color: #333;
  border-radius: 8px;           /* rounded corners */
  border-radius: 50%;           /* circle (if equal width/height) */

  /* Margin — space outside the border */
  margin: 20px;
  margin: 0 auto;               /* center horizontally */
  margin-top: 10px;

  /* Background */
  background-color: #f0f0f0;
}

/* ─── SHORTHAND REMINDER ─── */
/* padding: top right bottom left (TRBL — "trouble") */
/* margin:  top right bottom left */

/* Two values: top/bottom  left/right */
.compact {
  padding: 8px 16px;   /* 8px top+bottom, 16px left+right */
  margin: 0 auto;      /* 0 top+bottom, auto left+right */
}

/* ─── OUTLINE vs BORDER ─── */
/* outline does NOT take up space, border does */
button:focus {
  outline: 2px solid blue;  /* doesn't affect layout */
  outline-offset: 2px;
}

/* ─── OVERFLOW ─── */
.container {
  width: 200px;
  height: 100px;
  overflow: hidden;    /* clip content */
  overflow: scroll;    /* always show scrollbars */
  overflow: auto;      /* scrollbars only when needed (use this) */
  overflow: visible;   /* default, content spills out */
}

📝 KEY POINTS:
✅ ALWAYS start with * { box-sizing: border-box } in every project
✅ margin: 0 auto centers a block element horizontally
✅ padding adds space INSIDE; margin adds space OUTSIDE the border
✅ border-radius: 50% on equal-width/height elements makes a circle
✅ Use browser DevTools to visualize the box model for any element
❌ Without border-box, padding and border add to the width — confusing!
❌ Margins between siblings collapse vertically — only one of the two margins applies
❌ margin: auto does not work for vertical centering (use flexbox instead)
''',
  quiz: [
    Quiz(question: 'With box-sizing: border-box, what does width: 300px mean?', options: [
      QuizOption(text: 'The element is 300px total including padding and border', correct: true),
      QuizOption(text: 'The content area is 300px, padding and border add on top', correct: false),
      QuizOption(text: 'The element plus its margin is 300px', correct: false),
      QuizOption(text: 'border-box has no effect on width calculation', correct: false),
    ]),
    Quiz(question: 'What does "margin: 0 auto" do on a block element?', options: [
      QuizOption(text: 'Sets top/bottom margin to 0 and centers it horizontally', correct: true),
      QuizOption(text: 'Centers the element both horizontally and vertically', correct: false),
      QuizOption(text: 'Removes all margins and lets the browser decide', correct: false),
      QuizOption(text: 'Automatically adjusts margin based on viewport', correct: false),
    ]),
    Quiz(question: 'What is margin collapse?', options: [
      QuizOption(text: 'When vertical margins between elements merge — only the larger one applies', correct: true),
      QuizOption(text: 'When margins shrink to zero on small screens', correct: false),
      QuizOption(text: 'When a child element\'s margin affects the parent', correct: false),
      QuizOption(text: 'When left and right margins cancel each other out', correct: false),
    ]),
  ],
);
