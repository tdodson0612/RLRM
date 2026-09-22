// lib/lessons/css/css_39_grid_flexbox_advanced.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cssLesson39 = Lesson(
  language: 'CSS',
  title: 'Grid and Flexbox Advanced Patterns',
  content: '''
🎯 METAPHOR:
Grid is the architect's floor plan — columns, rows, named
zones, precise placement. Flexbox is the interior decorator —
given a room (row or column), it arranges the furniture
beautifully regardless of how many pieces there are.
The two are not rivals. Use both. Grid handles the big picture
layout; Flexbox handles the details inside each grid area.
Subgrid is the breakthrough: child elements align to the
PARENT grid's tracks — finally, perfect column alignment
across nested card components.

📖 EXPLANATION:
SUBGRID:
  grid-template-columns: subgrid
  Child grid uses PARENT'S column tracks, not its own.
  Perfect for aligning card contents across cards.

AUTO-FIT vs AUTO-FILL:
  auto-fill: creates as many columns as fit (even empty)
  auto-fit: collapses empty columns (items stretch to fill)

NAMED GRID LINES:
  [main-start] 1fr [main-end]  — name lines, reference them

GRID PLACEMENT:
  grid-column: span 2            — span 2 columns
  grid-column: 2 / 4            — from line 2 to line 4
  grid-column: main-start / main-end  — named lines

FLEXBOX ADVANCED:
  flex: 1 1 300px  — grow, shrink, basis
  align-self       — override parent's align-items
  order            — reorder without changing HTML
  gap              — gutters between flex items

💻 CODE:
/* ─── SUBGRID ─── */
.card-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  grid-template-rows: auto;
  gap: 1rem;
}

.card {
  display: grid;
  /* Use parent grid's column tracks */
  grid-template-rows: subgrid;
  /* Card rows align across all cards in the grid */
  grid-row: span 4;  /* span 4 rows: image, title, body, button */
}

.card-image   { }  /* row 1: aligned across all cards */
.card-title   { }  /* row 2: all titles at same height */
.card-body    { }  /* row 3: all bodies same height */
.card-button  { }  /* row 4: all buttons at bottom */

/* ─── AUTO-FIT vs AUTO-FILL ─── */
/* auto-fill: creates columns even if empty */
.auto-fill-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
  /* On wide screen: 6 columns, some empty if < 6 items */
}

/* auto-fit: stretches items to fill available space */
.auto-fit-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  /* On wide screen: 3 items → 3 equally-wide columns */
}

/* ─── RESPONSIVE MASONRY-LIKE GRID ─── */
.masonry {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
  grid-auto-rows: 10px;  /* small row unit for masonry */
  gap: 1rem;
}

.masonry-item {
  /* JS sets grid-row-end based on content height */
  /* grid-row: span 20; */  /* spans 20 units = 200px */
}

/* ─── NAMED GRID LINES ─── */
.page-layout {
  display: grid;
  grid-template-columns:
    [full-start] 1fr
    [main-start] minmax(0, 65ch)
    [main-end] 1fr
    [full-end];
}

/* Main content stays in main-start to main-end */
.main-content {
  grid-column: main-start / main-end;
}

/* Full-bleed images span the full width */
.full-bleed {
  grid-column: full-start / full-end;
}

/* ─── HOLY GRAIL LAYOUT ─── */
.holy-grail {
  display: grid;
  grid-template:
    "header  header  header" auto
    "sidebar content aside"  1fr
    "footer  footer  footer" auto
    / 200px  1fr     200px;
  min-height: 100vh;
  gap: 1rem;
}

.holy-grail > header  { grid-area: header;  }
.holy-grail > .sidebar{ grid-area: sidebar; }
.holy-grail > main    { grid-area: content; }
.holy-grail > aside   { grid-area: aside;   }
.holy-grail > footer  { grid-area: footer;  }

/* ─── FLEXBOX ADVANCED ─── */
/* flex shorthand: grow shrink basis */
.flex-item {
  flex: 1 1 300px;   /* can grow, can shrink, starts at 300px */
}

.fixed-item {
  flex: 0 0 200px;   /* never grow, never shrink, always 200px */
}

.grow-only {
  flex: 1 0 0;       /* grows to fill, won't shrink below 0 */
}

/* ─── FLEXBOX ALIGNMENT PATTERNS ─── */
/* Space between header items */
.navbar {
  display: flex;
  align-items: center;
}

.navbar .logo { margin-right: auto; }  /* pushes rest to right */
.navbar .nav-links { display: flex; gap: 1rem; }
.navbar .cta { margin-left: auto; }    /* pushes to far right */

/* ─── FLEXBOX REORDERING ─── */
/* Mobile: image first */
.card { display: flex; flex-direction: column; }
.card-image { order: -1; }  /* always first */
.card-button { order: 1; }  /* always last */

/* Desktop: reorder via media query */
@media (min-width: 768px) {
  .feature-card { flex-direction: row; }
  .feature-card:nth-child(even) .image { order: 1; }
  /* Even cards have image on the right */
}

/* ─── RESPONSIVE WITHOUT MEDIA QUERIES ─── */
/* Flex wrapping approach */
.flex-responsive {
  display: flex;
  flex-wrap: wrap;
  gap: 1rem;
}

.flex-responsive > * {
  flex: 1 1 300px;
  /* Items grow to fill row, wrap at 300px minimum */
}

/* Grid approach */
.grid-responsive {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(min(300px, 100%), 1fr));
  gap: 1rem;
  /* min() prevents overflow on small screens */
}

📝 KEY POINTS:
✅ Subgrid aligns nested card contents to the parent grid's tracks
✅ auto-fit collapses empty columns; auto-fill keeps them
✅ Named grid lines make placement declarations self-documenting
✅ margin-right: auto in flex pushes everything after it to the right
✅ flex: 0 0 200px is a fixed-size item that never grows or shrinks
✅ grid-template shorthand combines rows, columns, and areas in one declaration
❌ Don't use order to change logical reading order — it confuses screen readers
❌ Subgrid requires explicit grid-row: span N on the child — it doesn't auto-span
''',
  quiz: [
    Quiz(question: 'What does subgrid do for a child grid element?', options: [
      QuizOption(text: 'Uses the parent grid\'s tracks instead of creating its own — enabling cross-card alignment', correct: true),
      QuizOption(text: 'Creates an identical copy of the parent grid inside the child', correct: false),
      QuizOption(text: 'Allows the child to span multiple parent grid cells', correct: false),
      QuizOption(text: 'Enables nested grid areas with the same names', correct: false),
    ]),
    Quiz(question: 'What is the difference between auto-fit and auto-fill?', options: [
      QuizOption(text: 'auto-fit collapses empty columns so items stretch; auto-fill keeps empty columns', correct: true),
      QuizOption(text: 'auto-fill collapses empty columns; auto-fit keeps them', correct: false),
      QuizOption(text: 'They are identical — just different browser implementations', correct: false),
      QuizOption(text: 'auto-fit only works with fixed column widths', correct: false),
    ]),
    Quiz(question: 'What does "margin-right: auto" do on a flex item?', options: [
      QuizOption(text: 'Pushes all subsequent flex items to the right by consuming available space', correct: true),
      QuizOption(text: 'Centers the item within the flex container', correct: false),
      QuizOption(text: 'Sets the item\'s right margin to the same as its left margin', correct: false),
      QuizOption(text: 'Removes the right margin from the item', correct: false),
    ]),
  ],
);
