// lib/lessons/css/css_41_tables.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cssLesson41 = Lesson(
  language: 'CSS',
  title: 'Styling Tables',
  content: '''
🎯 METAPHOR:
A table without CSS is like a spreadsheet with no formatting —
all the data is there but it is hard to read and visually
overwhelming. CSS for tables is the equivalent of giving
that spreadsheet a professional makeover: alternating row
colors so your eye stays on the right row, clear borders
between cells, sticky headers so column names stay visible
as you scroll, and consistent column widths that don't
jump around when the data changes. A well-styled table
communicates data clearly instead of just dumping it.

📖 EXPLANATION:
Tables have their own display values and layout rules.
Key CSS properties for tables:

border-collapse: collapse | separate
  collapse: cell borders merge into one (most common)
  separate: cells have independent borders with gaps

border-spacing: width height
  Gap between cells when border-collapse: separate

table-layout: auto | fixed
  auto: columns size to content (default, can be slow)
  fixed: columns split evenly or by first-row widths (faster)

caption-side: top | bottom
  Position of the <caption> element

empty-cells: show | hide
  Whether to show borders on empty cells

vertical-align on td/th
  top | middle | bottom — aligns cell content vertically

💻 CODE:
/* ─── BASIC RESET ─── */
table {
  border-collapse: collapse;
  width: 100%;
  table-layout: fixed;       /* prevents jumping columns */
  font-size: 0.9rem;
}

/* ─── HEADERS ─── */
th {
  background: #f0f0f5;
  color: #333;
  font-weight: 600;
  text-align: left;
  padding: 0.75rem 1rem;
  border-bottom: 2px solid #6c63ff;
  white-space: nowrap;       /* prevent header text wrapping */
}

/* ─── CELLS ─── */
td {
  padding: 0.75rem 1rem;
  border-bottom: 1px solid #e0e0e0;
  vertical-align: middle;
  color: #555;
}

/* ─── ZEBRA STRIPING ─── */
tbody tr:nth-child(even) {
  background: #f9f9fb;
}

/* ─── HOVER ROW HIGHLIGHT ─── */
tbody tr:hover {
  background: #eef0ff;
  cursor: pointer;
}

/* ─── RESPONSIVE TABLE ─── */
/* Wrap table in a div for horizontal scroll on small screens */
.table-wrapper {
  overflow-x: auto;
  -webkit-overflow-scrolling: touch;    /* smooth scroll on iOS */
  border-radius: 8px;
  box-shadow: 0 1px 4px rgba(0,0,0,0.1);
}

/* ─── STICKY HEADER ─── */
/* Scrollable table body with fixed header */
.scrollable-table {
  max-height: 400px;
  overflow-y: auto;
  display: block;             /* needed for sticky to work */
}

.scrollable-table thead th {
  position: sticky;
  top: 0;
  z-index: 1;
  background: #f0f0f5;
  box-shadow: 0 1px 0 #e0e0e0;
}

/* ─── COLUMN WIDTHS ─── */
/* With table-layout: fixed, set widths on first row or <col> */
.data-table col:nth-child(1) { width: 40%; }
.data-table col:nth-child(2) { width: 20%; }
.data-table col:nth-child(3) { width: 20%; }
.data-table col:nth-child(4) { width: 20%; }

/* Or on th directly */
.data-table th:first-child  { width: 40%; }
.data-table th:nth-child(2) { width: 20%; }

/* ─── STATUS BADGES IN CELLS ─── */
td .badge {
  display: inline-block;
  padding: 0.2rem 0.6rem;
  border-radius: 999px;
  font-size: 0.75rem;
  font-weight: 600;
}

td .badge.success { background: #e8f5e9; color: #2e7d32; }
td .badge.warning { background: #fff8e1; color: #f57f17; }
td .badge.error   { background: #ffebee; color: #c62828; }

/* ─── SORTED COLUMN INDICATOR ─── */
th.sorted-asc::after  { content: " ↑"; color: #6c63ff; }
th.sorted-desc::after { content: " ↓"; color: #6c63ff; }
th.sortable { cursor: pointer; user-select: none; }
th.sortable:hover { background: #e8e8f0; }

/* ─── CAPTION ─── */
caption {
  caption-side: bottom;
  padding: 0.5rem;
  font-size: 0.8rem;
  color: #999;
  text-align: left;
}

/* ─── BORDERED TABLE VARIANT ─── */
.bordered-table td,
.bordered-table th {
  border: 1px solid #e0e0e0;
}

/* ─── COMPACT TABLE VARIANT ─── */
.compact-table td,
.compact-table th {
  padding: 0.4rem 0.6rem;
  font-size: 0.8rem;
}

/* ─── TRUNCATE LONG CELL CONTENT ─── */
.truncate-table td {
  max-width: 0;               /* required for text-overflow to work */
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

/* ─── NUMERIC COLUMN ─── */
.num {
  text-align: right;
  font-variant-numeric: tabular-nums;  /* fixed-width digits for alignment */
  font-feature-settings: 'tnum';
}

/* ─── EMPTY STATE ─── */
.empty-row td {
  text-align: center;
  padding: 3rem;
  color: #999;
  font-style: italic;
}

/* ─── PRINT-FRIENDLY TABLE ─── */
@media print {
  table { border-collapse: collapse; }
  th    { background: none; border-bottom: 2pt solid #000; }
  td    { border-bottom: 0.5pt solid #ccc; }
  thead { display: table-header-group; } /* repeat on each page */
  tr    { break-inside: avoid; }
}

📝 KEY POINTS:
✅ Always use border-collapse: collapse — separate borders look dated
✅ table-layout: fixed prevents columns from jumping when data loads
✅ Wrap the table in overflow-x: auto for responsive mobile behavior
✅ Use position: sticky on th for scrollable tables with fixed headers
✅ font-variant-numeric: tabular-nums keeps number columns aligned
✅ text-overflow: ellipsis on td requires max-width: 0 and overflow: hidden
❌ Don't use tables for layout — they are for tabular data only
❌ border-spacing only works when border-collapse: separate is set
''',
  quiz: [
    Quiz(question: 'What does border-collapse: collapse do?', options: [
      QuizOption(text: 'Merges adjacent cell borders into a single shared border', correct: true),
      QuizOption(text: 'Removes all borders from the table', correct: false),
      QuizOption(text: 'Collapses empty rows to zero height', correct: false),
      QuizOption(text: 'Merges cells with the same content', correct: false),
    ]),
    Quiz(question: 'What does table-layout: fixed do?', options: [
      QuizOption(text: 'Columns use widths set in CSS/HTML instead of sizing to content — faster and more predictable', correct: true),
      QuizOption(text: 'Prevents the table from scrolling horizontally', correct: false),
      QuizOption(text: 'Makes all columns equal width automatically', correct: false),
      QuizOption(text: 'Fixes the table position on the screen', correct: false),
    ]),
    Quiz(question: 'How do you make a table scroll horizontally on mobile without breaking desktop layout?', options: [
      QuizOption(text: 'Wrap the table in a div with overflow-x: auto', correct: true),
      QuizOption(text: 'Set the table width to 100vw', correct: false),
      QuizOption(text: 'Use display: block on the table element', correct: false),
      QuizOption(text: 'Add overflow: scroll to the body', correct: false),
    ]),
  ],
);
