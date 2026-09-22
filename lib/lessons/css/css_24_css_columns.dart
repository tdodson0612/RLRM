// lib/lessons/css/css_24_css_columns.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cssLesson24 = Lesson(
  language: 'CSS',
  title: 'CSS Columns, Logical Properties, and CSS Nesting',
  content: '''
🎯 METAPHOR:
CSS multi-column layout is like a newspaper printing press.
The typesetter says "flow all this article text into 3 columns
of equal width with a thin line between them." The text
automatically flows from the bottom of one column to the
top of the next. You don't place each paragraph — the
layout engine does it. This is exactly what multi-column
CSS does for text content.

CSS logical properties are like direction-aware labels.
Instead of "left" and "right," you say "start" and "end."
In English (left-to-right), start = left, end = right.
In Arabic (right-to-left), start = right, end = left.
One CSS rule — works in all writing directions.

📖 EXPLANATION:
CSS MULTI-COLUMN:
  column-count      number of columns
  column-width      minimum column width (auto-fills)
  columns           shorthand: count and width
  column-gap        space between columns
  column-rule       divider line between columns
  column-span: all  span across all columns
  break-inside: avoid  prevent element from splitting across columns

CSS LOGICAL PROPERTIES:
  margin-inline-start   = margin-left in LTR
  margin-inline-end     = margin-right in LTR
  margin-block-start    = margin-top
  margin-block-end      = margin-bottom
  padding-inline        = left + right padding (shorthand)
  padding-block         = top + bottom padding (shorthand)
  inset-inline-start    = left in LTR
  border-inline-start   = border-left in LTR
  text-align: start     = left in LTR

CSS NESTING (modern CSS, 2023+):
  Write nested selectors like Sass — no preprocessor needed.

💻 CODE:
/* ─── MULTI-COLUMN ─── */
/* Newspaper-style columns */
.article-body {
  column-count: 3;
  column-gap: 32px;
  column-rule: 1px solid #ddd;
}

/* Responsive: browser decides how many columns fit */
.responsive-cols {
  columns: 200px;           /* min width — browser auto-fills */
  column-gap: 24px;
}

/* Span a heading across all columns */
.column-heading {
  column-span: all;
  text-align: center;
  margin-bottom: 24px;
}

/* Prevent card from splitting across columns */
.column-card {
  break-inside: avoid;
  margin-bottom: 16px;
}

/* ─── BALANCE vs FILL ─── */
.columns-fill {
  column-fill: balance;   /* equal column heights (default) */
  column-fill: auto;      /* fill first column, then next */
}

/* ─── CSS LOGICAL PROPERTIES ─── */
/* Traditional (physical) */
.traditional {
  margin-left: 16px;
  margin-right: 16px;
  padding-top: 8px;
  padding-bottom: 8px;
  border-left: 2px solid blue;
  text-align: left;
}

/* Logical (direction-aware) — EQUIVALENT but works in RTL */
.logical {
  margin-inline: 16px;         /* inline = horizontal axis */
  padding-block: 8px;          /* block = vertical axis */
  border-inline-start: 2px solid blue;  /* start = left in LTR */
  text-align: start;
}

/* More logical properties */
.box-logical {
  margin-inline-start: 16px;   /* left margin in LTR */
  margin-inline-end: 8px;      /* right margin in LTR */
  margin-block-start: 24px;    /* top margin */
  margin-block-end: 24px;      /* bottom margin */

  padding-inline: 16px;        /* horizontal padding */
  padding-block: 12px;         /* vertical padding */

  inset-inline-start: 0;       /* left: 0 in LTR (for positioned elements) */
  inset-block-start: 0;        /* top: 0 */

  width: 300px;                /* still needed */
  inline-size: 300px;          /* logical equivalent (horizontal size) */
  block-size: 200px;           /* logical equivalent (vertical size) */
}

/* ─── CSS NESTING (Native — 2023+) ─── */
/* No preprocessor needed! */

.card {
  background: white;
  border-radius: 8px;
  padding: 24px;

  /* Nested child selector */
  & h2 {
    font-size: 1.25rem;
    margin-bottom: 8px;
  }

  & p {
    color: #666;
    line-height: 1.6;
  }

  /* Nested pseudo-class */
  &:hover {
    box-shadow: 0 8px 24px rgba(0,0,0,0.12);
  }

  /* Nested modifier class */
  &.featured {
    border: 2px solid #0066cc;
  }

  /* Descendant (note: & is the parent) */
  & .card-footer {
    margin-top: 16px;
    padding-top: 16px;
    border-top: 1px solid #eee;
  }

  /* Media query inside rule */
  @media (max-width: 768px) {
    & {
      padding: 16px;
    }
  }
}

/* ─── CSS NESTING: COMBINATORS ─── */
.nav {
  display: flex;

  & > li {          /* direct children */
    list-style: none;

    & > a {
      text-decoration: none;
      color: #333;

      &:hover {
        color: #0066cc;
      }
    }
  }

  & + .breadcrumb { /* adjacent sibling */
    margin-top: 16px;
  }
}

📝 KEY POINTS:
✅ Multi-column is perfect for long text articles — great reading experience
✅ break-inside: avoid prevents cards/quotes from awkwardly splitting
✅ Logical properties make RTL/multilingual sites trivial
✅ CSS nesting works natively in modern browsers — no Sass needed
✅ & in CSS nesting refers to the parent selector
❌ CSS nesting browser support: Chrome 112+, Firefox 117+, Safari 16.5+ — check before using
❌ Multi-column is for reading-flow text — not card/image grid layouts (use grid for those)
''',
  quiz: [
    Quiz(question: 'What does break-inside: avoid do in a multi-column layout?', options: [
      QuizOption(text: 'Prevents the element from being split across two columns', correct: true),
      QuizOption(text: 'Prevents columns from being created inside the element', correct: false),
      QuizOption(text: 'Stops text from flowing into the next column', correct: false),
      QuizOption(text: 'Forces a column break before this element', correct: false),
    ]),
    Quiz(question: 'What does padding-inline: 16px do?', options: [
      QuizOption(text: 'Sets left and right padding to 16px — adapts to the text direction', correct: true),
      QuizOption(text: 'Sets top and bottom padding to 16px', correct: false),
      QuizOption(text: 'Sets padding inside an inline element', correct: false),
      QuizOption(text: 'Sets padding on inline children', correct: false),
    ]),
    Quiz(question: 'In CSS nesting, what does & refer to?', options: [
      QuizOption(text: 'The parent selector that the rule is nested inside', correct: true),
      QuizOption(text: 'All child elements', correct: false),
      QuizOption(text: 'The root element', correct: false),
      QuizOption(text: 'The universal selector *', correct: false),
    ]),
  ],
);
