// lib/lessons/css/css_15_units.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cssLesson15 = Lesson(
  language: 'CSS',
  title: 'Units: px, rem, em, vw, vh, %, fr, and More',
  content: '''
🎯 METAPHOR:
CSS units are like measuring systems — and choosing the wrong
one for the job is like measuring a room in miles or a
marathon in inches. Each unit exists for a specific purpose.
px is the absolute inch tape — precise but inflexible.
rem is the ruler calibrated to the reader's preference —
it respects accessibility settings.
% is relative to the parent — like saying "half the width
of this container."
vw and vh are the viewport percentages — "a quarter of
the screen height."
fr is the flexbox/grid-specific fraction of remaining space.
Choosing the right unit is a skill that separates competent
CSS from great CSS.

📖 EXPLANATION:
─────────────────────────────────────
ABSOLUTE UNITS (fixed size):
─────────────────────────────────────
px    pixels — most common absolute unit
pt    points — 1pt = 1.333px (print/font-related)
cm / mm / in  — physical units (mostly for print)

─────────────────────────────────────
RELATIVE UNITS (scale with context):
─────────────────────────────────────
rem   relative to ROOT element font-size (usually 16px)
em    relative to PARENT element font-size
%     relative to parent value (varies by property)
vw    % of viewport WIDTH  (1vw = 1% of screen width)
vh    % of viewport HEIGHT (1vh = 1% of screen height)
vmin  smaller of vw/vh
vmax  larger of vw/vh
svh   small viewport height (excludes mobile browser chrome)
dvh   dynamic viewport height (adjusts as browser UI shows/hides)
ch    width of the "0" character in current font
ex    height of lowercase "x" in current font

─────────────────────────────────────
GRID/FLEX ONLY:
─────────────────────────────────────
fr    fraction of available space in grid/flex

─────────────────────────────────────
CSS FUNCTIONS:
─────────────────────────────────────
calc(a + b)        compute with mixed units
min(a, b)          smaller of two values
max(a, b)          larger of two values
clamp(min, val, max)  constrain a value within range

💻 CODE:
/* ─── PX — precise, not accessibility-friendly for font-size ─── */
.box { width: 300px; border: 1px solid; }

/* ─── REM — best for font sizes and spacing ─── */
:root { font-size: 16px; }   /* 1rem = 16px */

h1   { font-size: 2rem; }    /* 32px */
h2   { font-size: 1.5rem; }  /* 24px */
p    { font-size: 1rem; }    /* 16px */
.sm  { font-size: 0.875rem; } /* 14px */

/* User increases browser font to 20px → everything scales up */

/* ─── EM — relative to parent, good for components ─── */
.button {
  font-size: 1rem;
  padding: 0.75em 1.5em;  /* scales with button's own font-size */
}
.button.large { font-size: 1.2rem; /* padding auto-scales too */ }

/* Nested em warning: compounding! */
.parent { font-size: 1.2em; }    /* 1.2 × 16 = 19.2px */
.child  { font-size: 1.2em; }    /* 1.2 × 19.2 = 23.04px! */
/* Use rem to avoid this */

/* ─── PERCENTAGE ─── */
.half-width  { width: 50%; }   /* 50% of parent width */
.full-height { height: 100%; } /* 100% of parent height */

/* padding/margin % is relative to PARENT WIDTH (even for vertical!) */
.aspect-hack::before {
  content: "";
  display: block;
  padding-top: 56.25%;  /* 9/16 = 56.25% = 16:9 aspect ratio */
}

/* ─── VW / VH — viewport units ─── */
.hero   { height: 100vh; width: 100vw; }  /* full screen */
.half   { height: 50vh; }

/* Text that scales with viewport */
h1 { font-size: 5vw; }  /* but use clamp! */

/* ─── SVH / DVH — better mobile viewport ─── */
/* vh on mobile includes the browser address bar → 100vh is too tall */
.mobile-full {
  height: 100svh;  /* safe: excludes browser chrome */
}
.dynamic-full {
  height: 100dvh;  /* updates as browser bar shows/hides */
}

/* ─── CH — text-based width ─── */
.readable {
  max-width: 65ch;  /* 65 characters wide — optimal reading width */
}

/* ─── CALC ─── */
.sidebar { width: 200px; }
.content { width: calc(100% - 200px); }  /* fill remaining */

.offset { margin-top: calc(50vh - 100px); }

/* Mix units freely */
.complex { width: calc(100% - 2rem - 32px); }

/* ─── MIN AND MAX ─── */
.responsive-img {
  width: min(100%, 800px);   /* never wider than 800px */
}

.minimum-area {
  height: max(300px, 50vh);  /* at least 300px */
}

/* ─── CLAMP — the fluid sizing hero ─── */
h1 {
  font-size: clamp(1.5rem, 4vw, 3rem);
  /* min: 1.5rem, preferred: 4vw, max: 3rem */
}

.container {
  width: clamp(320px, 90%, 1200px);
  margin-inline: auto;
}

/* ─── FR (grid only) ─── */
.grid {
  display: grid;
  grid-template-columns: 200px 1fr 2fr;
  /* fixed | 1 part | 2 parts of remaining space */
}

📝 KEY POINTS:
✅ rem for font-size — respects user browser settings
✅ em for component-internal spacing — scales with the component's font-size
✅ % for fluid widths and responsive layouts
✅ vw/vh for viewport-relative sizing — use svh/dvh on mobile
✅ clamp() is the modern fluid sizing tool — use it everywhere
✅ max-width: 65ch for readable text columns
❌ Don't use px for font-size on body text — breaks accessibility zoom
❌ Beware em compounding — nested em values multiply and get out of hand
''',
  quiz: [
    Quiz(question: 'What is the difference between rem and em?', options: [
      QuizOption(text: 'rem is relative to the root element font-size; em is relative to the parent element font-size', correct: true),
      QuizOption(text: 'rem is relative to the parent; em is relative to the root', correct: false),
      QuizOption(text: 'rem is for spacing; em is for font sizes only', correct: false),
      QuizOption(text: 'They are identical — just historical naming differences', correct: false),
    ]),
    Quiz(question: 'What does clamp(1rem, 4vw, 3rem) do?', options: [
      QuizOption(text: 'Sets the value to 4vw but never smaller than 1rem or larger than 3rem', correct: true),
      QuizOption(text: 'Clamps the value to exactly 1rem, 4vw, or 3rem', correct: false),
      QuizOption(text: 'Creates three responsive breakpoints', correct: false),
      QuizOption(text: 'Averages 1rem, 4vw, and 3rem', correct: false),
    ]),
    Quiz(question: 'Why is dvh preferred over vh on mobile?', options: [
      QuizOption(text: 'dvh updates dynamically as the mobile browser bar shows/hides; vh includes the browser chrome', correct: true),
      QuizOption(text: 'dvh is supported in more browsers', correct: false),
      QuizOption(text: 'dvh is relative to the device screen, vh is relative to the tab', correct: false),
      QuizOption(text: 'dvh uses device pixels; vh uses CSS pixels', correct: false),
    ]),
  ],
);
