// lib/lessons/css/css_08_grid.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cssLesson08 = Lesson(
  language: 'CSS',
  title: 'CSS Grid',
  content: '''
🎯 METAPHOR:
CSS Grid is like graph paper for your webpage.
You draw the grid lines first — "I want 3 columns and 4 rows"
— then you place items wherever they fit on the grid.
A newspaper layout editor does exactly this: draw the grid,
then decide which article goes in column 1-2, which photo
spans the full width, which sidebar occupies column 3.
Grid is TWO-dimensional — rows AND columns at the same time.
Flexbox handles one dimension. Grid handles both.

📖 EXPLANATION:
Grid is the most powerful layout system in CSS.
Use it for page layouts, card grids, dashboard layouts —
anything with both rows and columns.

─────────────────────────────────────
CONTAINER PROPERTIES:
─────────────────────────────────────
display: grid               activate grid
grid-template-columns       define column sizes
grid-template-rows          define row sizes
grid-template-areas         named areas (visual layout)
gap / column-gap / row-gap  spacing between cells
justify-items               align items in columns
align-items                 align items in rows
place-items                 shorthand both

─────────────────────────────────────
ITEM PROPERTIES:
─────────────────────────────────────
grid-column        which columns to span
grid-row           which rows to span
grid-area          named area or row/column shorthand
justify-self       align item in its cell (horizontal)
align-self         align item in its cell (vertical)
─────────────────────────────────────

SPECIAL VALUES:
  fr    — fractional unit (share of available space)
  auto  — size based on content
  minmax(min, max) — flexible range
  repeat(n, size)  — repeat column/row definition
  auto-fill / auto-fit — automatic columns based on size

💻 CODE:
/* ─── BASIC 3-COLUMN GRID ─── */
.grid {
  display: grid;
  grid-template-columns: 1fr 1fr 1fr;  /* 3 equal columns */
  /* Same as: repeat(3, 1fr) */
  gap: 16px;
}

/* ─── DIFFERENT COLUMN SIZES ─── */
.layout {
  display: grid;
  grid-template-columns: 200px 1fr 300px;
  /* Fixed sidebar, flexible content, fixed sidebar */
}

/* ─── RESPONSIVE AUTO-FILL GRID ─── */
.card-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
  /* Creates as many columns as fit, each min 250px */
  gap: 24px;
}

/* ─── EXPLICIT ROWS ─── */
.page {
  display: grid;
  grid-template-rows: auto 1fr auto;
  /* header: auto height, main: fills remaining, footer: auto */
  min-height: 100vh;
}

/* ─── NAMED TEMPLATE AREAS ─── */
.app-layout {
  display: grid;
  grid-template-areas:
    "header header header"
    "sidebar content content"
    "footer footer footer";
  grid-template-columns: 200px 1fr;
  grid-template-rows: 64px 1fr 48px;
  min-height: 100vh;
}

.header  { grid-area: header; }
.sidebar { grid-area: sidebar; }
.content { grid-area: content; }
.footer  { grid-area: footer; }

/* ─── ITEM SPANNING ─── */
.item {
  /* span from column line 1 to line 3 (spans 2 columns) */
  grid-column: 1 / 3;
  grid-row: 1 / 2;
}

/* Span using 'span' keyword */
.wide   { grid-column: span 2; }  /* spans 2 columns */
.tall   { grid-row: span 3; }     /* spans 3 rows */
.banner { grid-column: 1 / -1; } /* spans ALL columns */

/* ─── CENTERING IN GRID ─── */
.center-child {
  display: grid;
  place-items: center;  /* both axes */
}

/* ─── PRACTICAL CARD GRID ─── */
.cards {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 24px;
  padding: 24px;
}

@media (max-width: 768px) {
  .cards {
    grid-template-columns: 1fr;  /* single column on mobile */
  }
}

/* ─── DENSE PACKING (fill gaps) ─── */
.masonry {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  grid-auto-flow: dense;  /* fill in holes from spanning items */
}

📝 KEY POINTS:
✅ fr units share available space — 1fr 2fr = ⅓ and ⅔
✅ repeat(auto-fill, minmax(250px, 1fr)) is the magic responsive grid pattern
✅ grid-template-areas gives you a visual ASCII representation of your layout
✅ grid-column: 1 / -1 spans the entire row regardless of column count
✅ place-items: center is the easiest way to center in a grid cell
❌ Grid is 2D (rows AND columns); flexbox is 1D — use the right tool
❌ Grid lines are numbered starting at 1 (not 0) and can be negative from the end
''',
  quiz: [
    Quiz(question: 'What does "1fr" mean in grid-template-columns?', options: [
      QuizOption(text: 'One fractional unit — a proportional share of available space', correct: true),
      QuizOption(text: '1 frame per row', correct: false),
      QuizOption(text: '1 pixel of flexible space', correct: false),
      QuizOption(text: 'The first column is free', correct: false),
    ]),
    Quiz(question: 'What does "grid-column: 1 / -1" do?', options: [
      QuizOption(text: 'Spans the item across ALL columns from first to last', correct: true),
      QuizOption(text: 'Places the item in the first and last columns only', correct: false),
      QuizOption(text: 'Creates a negative margin on the first column', correct: false),
      QuizOption(text: 'Removes the item from the first column', correct: false),
    ]),
    Quiz(question: 'What is the "magic" responsive grid pattern using repeat and minmax?', options: [
      QuizOption(text: 'repeat(auto-fill, minmax(250px, 1fr)) — creates columns that fill the space', correct: true),
      QuizOption(text: 'repeat(auto, min(250px, 1fr))', correct: false),
      QuizOption(text: 'grid-template: auto-fill 250px', correct: false),
      QuizOption(text: 'grid-columns: responsive(250px)', correct: false),
    ]),
  ],
);
