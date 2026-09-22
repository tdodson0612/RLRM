// lib/lessons/css/css_09_responsive_design.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cssLesson09 = Lesson(
  language: 'CSS',
  title: 'Responsive Design and Media Queries',
  content: '''
🎯 METAPHOR:
Responsive design is like a shape-shifting restaurant.
At a big table (desktop), dishes are spread out beautifully
with plenty of space. When guests move to a small booth
(tablet), dishes rearrange to a tighter layout. At a café
counter (mobile), everything stacks vertically and only
the essentials are shown. The food (content) is the same —
only the presentation adapts to the space available.
Media queries are the sensor that detects the table size
and triggers the rearrangement.

📖 EXPLANATION:
Responsive design means your site looks great on ALL screen
sizes — from a 320px phone to a 2560px monitor.

THREE PILLARS:
  1. Fluid grids — use % or fr instead of fixed px
  2. Flexible images — max-width: 100%
  3. Media queries — apply different styles at breakpoints

MOBILE-FIRST vs DESKTOP-FIRST:
  Mobile-first: start with mobile styles, add complexity for larger screens
    → Use min-width media queries (preferred)
  Desktop-first: start with desktop, override for smaller screens
    → Use max-width media queries

COMMON BREAKPOINTS:
  < 576px    — xs: small phones
  576-768px  — sm: phones
  768-992px  — md: tablets
  992-1200px — lg: laptops
  > 1200px   — xl: desktops

VIEWPORT META TAG (required in HTML):
  <meta name="viewport" content="width=device-width, initial-scale=1">

💻 CODE:
/* ─── VIEWPORT UNITS ─── */
.hero {
  height: 100vh;    /* 100% of viewport height */
  width: 100vw;     /* 100% of viewport width */
}
.sidebar { width: 30vw; min-width: 200px; }

/* ─── FLEXIBLE IMAGES ─── */
img {
  max-width: 100%;  /* never wider than container */
  height: auto;     /* maintain aspect ratio */
}

/* ─── MEDIA QUERIES ─── */
/* Mobile-first approach */
/* Base styles (mobile): single column */
.card-grid {
  display: grid;
  grid-template-columns: 1fr;
  gap: 16px;
}

/* Tablet: 2 columns */
@media (min-width: 768px) {
  .card-grid {
    grid-template-columns: 1fr 1fr;
  }
}

/* Desktop: 3 columns */
@media (min-width: 1024px) {
  .card-grid {
    grid-template-columns: repeat(3, 1fr);
    gap: 24px;
  }
}

/* ─── MULTIPLE CONDITIONS ─── */
@media (min-width: 768px) and (max-width: 1024px) {
  /* tablet only */
}

/* ─── ORIENTATION ─── */
@media (orientation: landscape) { /* ... */ }
@media (orientation: portrait)  { /* ... */ }

/* ─── DARK MODE ─── */
@media (prefers-color-scheme: dark) {
  body {
    background-color: #1a1a1a;
    color: #f0f0f0;
  }
}

/* ─── REDUCED MOTION (accessibility) ─── */
@media (prefers-reduced-motion: reduce) {
  * { animation: none !important; transition: none !important; }
}

/* ─── PRINT ─── */
@media print {
  .no-print { display: none; }
  body { font-size: 12pt; color: black; }
}

/* ─── RESPONSIVE TYPOGRAPHY ─── */
/* clamp(min, preferred, max) */
h1 {
  font-size: clamp(1.5rem, 4vw, 3rem);
  /* minimum 1.5rem, scales with viewport, max 3rem */
}

/* ─── CONTAINER QUERIES (modern CSS) ─── */
/* Style based on CONTAINER size, not viewport */
.card-container {
  container-type: inline-size;
  container-name: card;
}

@container card (min-width: 400px) {
  .card { flex-direction: row; }
}

/* ─── PRACTICAL RESPONSIVE NAV ─── */
.nav {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

@media (min-width: 768px) {
  .nav {
    flex-direction: row;
    align-items: center;
    justify-content: space-between;
  }
}

.hamburger { display: block; }

@media (min-width: 768px) {
  .hamburger { display: none; }
  .nav-links  { display: flex !important; }
}

📝 KEY POINTS:
✅ Always include the viewport meta tag in HTML
✅ Mobile-first (min-width) is preferred — progressive enhancement
✅ Use clamp() for fluid typography that scales smoothly
✅ max-width: 100% on images prevents overflow on small screens
✅ Container queries (@container) are the modern alternative to media queries
✅ prefers-color-scheme and prefers-reduced-motion are important accessibility features
❌ Don't use fixed px widths for layout — use %, fr, or max-width
❌ Don't just hide content on mobile — redesign the layout
''',
  quiz: [
    Quiz(question: 'What is "mobile-first" CSS development?', options: [
      QuizOption(text: 'Writing base styles for mobile, then using min-width media queries to add desktop styles', correct: true),
      QuizOption(text: 'Building only mobile apps, not desktop', correct: false),
      QuizOption(text: 'Using max-width media queries to override desktop styles', correct: false),
      QuizOption(text: 'Hiding desktop content on mobile', correct: false),
    ]),
    Quiz(question: 'What does clamp(1rem, 4vw, 3rem) do for font-size?', options: [
      QuizOption(text: 'Sets font-size to 4vw, but never smaller than 1rem or larger than 3rem', correct: true),
      QuizOption(text: 'Clamps the font between 1px and 3px', correct: false),
      QuizOption(text: 'Sets three different font sizes for three breakpoints', correct: false),
      QuizOption(text: 'Restricts font scaling to the viewport width only', correct: false),
    ]),
    Quiz(question: 'What is the required HTML tag for responsive design to work on mobile?', options: [
      QuizOption(text: '<meta name="viewport" content="width=device-width, initial-scale=1">', correct: true),
      QuizOption(text: '<meta name="responsive" content="true">', correct: false),
      QuizOption(text: '<link rel="responsive" href="mobile.css">', correct: false),
      QuizOption(text: '<style media="mobile">...</style>', correct: false),
    ]),
  ],
);
