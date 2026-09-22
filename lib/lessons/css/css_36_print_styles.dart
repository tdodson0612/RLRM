// lib/lessons/css/css_36_print_styles.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cssLesson36 = Lesson(
  language: 'CSS',
  title: 'Print Styles and @media print',
  content: '''
🎯 METAPHOR:
Print styles are like the "clean version" of your page.
Your screen version has navigation, sidebars, ads, dark
backgrounds, hover effects, and interactive elements.
Nobody wants to print the hamburger menu. Print CSS is
where you say: "When this page leaves the screen and
goes to paper, strip everything non-essential, make text
black on white, show full URLs for links, start new pages
where it makes sense, and make sure tables don't split
across pages mid-row."

📖 EXPLANATION:
@media print targets printers and PDF export.

COMMON PRINT CSS GOALS:
  - Remove navigation, footers, ads, interactive elements
  - Set black text on white background (ink saving)
  - Show URLs for links (they become dead on paper)
  - Control page breaks
  - Set appropriate font sizes and margins
  - Use print-friendly font stacks

PAGE BREAK PROPERTIES:
  break-before: page | column | auto | avoid
  break-after:  page | column | auto | avoid
  break-inside: avoid | auto

@page RULE:
  @page { margin: 2cm; }
  @page :first { margin-top: 3cm; }
  @page :left { }
  @page :right { }

SIZE:
  @page { size: A4 portrait; }
  @page { size: letter landscape; }

💻 CODE:
/* ─── PRINT MEDIA QUERY ─── */
@media print {
  /* ─── HIDE NON-ESSENTIAL ELEMENTS ─── */
  nav,
  header,
  footer,
  aside,
  .sidebar,
  .ad,
  .cookie-banner,
  .chat-widget,
  .social-share,
  button,
  .no-print,
  [data-no-print] {
    display: none !important;
  }

  /* ─── RESET COLORS FOR PRINT ─── */
  *,
  *::before,
  *::after {
    background: transparent !important;
    color: #000 !important;
    box-shadow: none !important;
    text-shadow: none !important;
  }

  /* ─── TYPOGRAPHY ─── */
  body {
    font: 12pt/1.5 Georgia, 'Times New Roman', serif;
    /* Serif fonts are more readable in print */
  }

  h1 { font-size: 24pt; }
  h2 { font-size: 18pt; }
  h3 { font-size: 14pt; }

  /* ─── LINKS ─── */
  /* Show URLs so they're useful on paper */
  a[href]::after {
    content: " (" attr(href) ")";
    font-size: 0.8em;
    color: #555 !important;
  }

  /* Exceptions: internal links, no-href links */
  a[href^="#"]::after,
  a[href^="javascript:"]::after {
    content: "";
  }

  /* ─── PAGE BREAKS ─── */
  h1, h2, h3 {
    break-after: avoid;   /* Don't break right after headings */
    page-break-after: avoid;  /* legacy property */
  }

  /* Keep heading with its following content */
  h2, h3 {
    break-after: avoid;
  }

  /* Start chapters on new page */
  .chapter {
    break-before: page;
  }

  /* Never break inside these */
  figure,
  blockquote,
  table,
  pre,
  .keep-together {
    break-inside: avoid;
    page-break-inside: avoid;
  }

  /* ─── TABLES ─── */
  table {
    border-collapse: collapse;
  }

  thead {
    display: table-header-group;  /* repeat header on each page */
  }

  tfoot {
    display: table-footer-group;  /* repeat footer on each page */
  }

  tr {
    break-inside: avoid;  /* don't break rows across pages */
  }

  td, th {
    border: 1px solid #999;
    padding: 4pt 8pt;
  }

  /* ─── IMAGES ─── */
  img {
    max-width: 100% !important;
    break-inside: avoid;
  }

  /* ─── LAYOUT RESET ─── */
  .container,
  .wrapper,
  main,
  article {
    width: 100% !important;
    max-width: none !important;
    margin: 0 !important;
    padding: 0 !important;
  }

  /* Multi-column becomes single column for print */
  .two-column,
  .three-column {
    columns: 1 !important;
  }

  /* ─── CODE BLOCKS ─── */
  pre {
    border: 1px solid #999;
    page-break-inside: avoid;
    white-space: pre-wrap;  /* allow wrapping */
  }

  code {
    font-size: 10pt;
    background: #f5f5f5 !important;
  }
}

/* ─── @PAGE RULE ─── */
@page {
  margin: 2cm;   /* page margins */
  size: A4;      /* page size */
}

@page :first {
  margin-top: 3cm;  /* extra top margin on first page */
}

/* Different margins for left/right pages (duplex printing) */
@page :left  { margin-right: 3cm; }
@page :right { margin-left: 3cm; }

/* ─── PRINT-ONLY CONTENT ─── */
.print-only {
  display: none;  /* hidden normally */
}

@media print {
  .print-only {
    display: block;  /* visible only when printing */
  }
}

/* Show print-only header */
.print-header {
  display: none;
}

@media print {
  .print-header {
    display: block;
    border-bottom: 2pt solid #000;
    margin-bottom: 1cm;
    padding-bottom: 0.5cm;
  }
}

📝 KEY POINTS:
✅ @media print is the standard way to write printer-specific styles
✅ Always show link URLs with a[href]::after in print styles
✅ Use break-inside: avoid on tables, figures, and blockquotes
✅ Repeat table headers on each page with thead { display: table-header-group }
✅ Reset all colors to black on white to save ink
✅ Set font sizes in pt (points) for print — it's the correct unit
❌ Don't include background images or shadows in print — they waste ink
❌ Don't forget to hide interactive elements like buttons, navs, and dropdowns
''',
  quiz: [
    Quiz(question: 'What CSS property shows a link\'s URL when printing?', options: [
      QuizOption(text: 'a[href]::after { content: " (" attr(href) ")"; }', correct: true),
      QuizOption(text: 'a { print-url: visible; }', correct: false),
      QuizOption(text: 'a::print { display-url: true; }', correct: false),
      QuizOption(text: 'a[href] { show-url: print; }', correct: false),
    ]),
    Quiz(question: 'What does "break-inside: avoid" do?', options: [
      QuizOption(text: 'Prevents the element from being split across two printed pages', correct: true),
      QuizOption(text: 'Prevents page breaks from being added inside CSS columns', correct: false),
      QuizOption(text: 'Removes all internal margins', correct: false),
      QuizOption(text: 'Prevents the element from being selected', correct: false),
    ]),
    Quiz(question: 'What does thead { display: table-header-group } do when printing?', options: [
      QuizOption(text: 'Repeats the table header on every printed page the table spans', correct: true),
      QuizOption(text: 'Groups all table headers into one element', correct: false),
      QuizOption(text: 'Makes the table header sticky during scrolling', correct: false),
      QuizOption(text: 'Hides the table header in print view', correct: false),
    ]),
  ],
);
