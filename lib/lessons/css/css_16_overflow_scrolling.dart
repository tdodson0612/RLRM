// lib/lessons/css/css_16_overflow_scrolling.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cssLesson16 = Lesson(
  language: 'CSS',
  title: 'Overflow and Scrolling',
  content: '''
🎯 METAPHOR:
Overflow is like water in a glass. If you pour in too much,
it overflows the rim — that's overflow: visible (the default).
overflow: hidden is a sealed lid — water that doesn't fit
simply disappears. overflow: scroll adds a tap at the bottom
of the glass — the extra water flows into a hidden reservoir
you can reach with a scroll wheel. overflow: auto is a smart
glass that only adds the tap when the water actually reaches
the rim.

📖 EXPLANATION:
Overflow controls what happens when content is larger
than its container.

OVERFLOW VALUES:
  visible   — content spills out (default)
  hidden    — clips content at the box edge
  scroll    — always shows scrollbars
  auto      — shows scrollbars only when needed (preferred)
  clip      — clips like hidden but disables all scrolling

AXES:
  overflow-x  — horizontal overflow only
  overflow-y  — vertical overflow only

MODERN SCROLL CONTROL:
  scroll-behavior: smooth   — animated scroll
  scroll-snap-type          — snap scrolling (carousels)
  scroll-snap-align         — where items snap to
  overscroll-behavior       — prevent scroll chaining
  scrollbar-gutter          — reserve space for scrollbar

💻 CODE:
/* ─── BASIC OVERFLOW ─── */
.container {
  width: 300px;
  height: 200px;
  overflow: auto;        /* scrollbars when needed */
}

.clip   { overflow: hidden; }  /* clip, no scroll */
.scroll { overflow: scroll; }  /* always show scrollbars */

/* Axis control */
.horizontal-scroll {
  overflow-x: auto;
  overflow-y: hidden;
  white-space: nowrap;  /* prevent wrapping */
}

/* ─── TEXT TRUNCATION ─── */
.truncate-single {
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  max-width: 200px;
}

/* Multi-line truncation (modern) */
.truncate-multi {
  display: -webkit-box;
  -webkit-line-clamp: 3;    /* show 3 lines */
  -webkit-box-orient: vertical;
  overflow: hidden;
}

/* ─── SMOOTH SCROLLING ─── */
html {
  scroll-behavior: smooth;
}
/* Now anchor links (#section) animate smoothly */

/* But respect user preferences */
@media (prefers-reduced-motion: no-preference) {
  html { scroll-behavior: smooth; }
}

/* ─── SCROLL SNAP (carousels, slideshows) ─── */
.slider {
  display: flex;
  overflow-x: scroll;
  scroll-snap-type: x mandatory;   /* snap on x axis, always */
  gap: 16px;
  scrollbar-width: none;           /* hide scrollbar (Firefox) */
  -ms-overflow-style: none;        /* hide scrollbar (IE) */
}
.slider::-webkit-scrollbar { display: none; } /* hide scrollbar (Chrome) */

.slide {
  flex: 0 0 100%;           /* each slide is full width */
  scroll-snap-align: start; /* snap to start of slide */
  min-height: 300px;
}

/* Proximity snap (snaps when close) */
.gallery {
  scroll-snap-type: x proximity;
}

/* ─── OVERSCROLL BEHAVIOR ─── */
/* Prevent scrolling parent when child hits its boundary */
.modal-scroll {
  overflow-y: auto;
  overscroll-behavior: contain;   /* no scroll chaining */
}

/* Disable pull-to-refresh on mobile */
body {
  overscroll-behavior-y: none;
}

/* ─── SCROLLBAR STYLING ─── */
/* Custom scrollbar (Chrome/Edge/Safari) */
.custom-scroll::-webkit-scrollbar {
  width: 8px;
}
.custom-scroll::-webkit-scrollbar-track {
  background: #f1f1f1;
  border-radius: 4px;
}
.custom-scroll::-webkit-scrollbar-thumb {
  background: #888;
  border-radius: 4px;
}
.custom-scroll::-webkit-scrollbar-thumb:hover {
  background: #555;
}

/* Standard (Firefox) */
.custom-scroll {
  scrollbar-width: thin;
  scrollbar-color: #888 #f1f1f1;
}

/* ─── SCROLLBAR GUTTER (prevent layout shift) ─── */
/* Reserve space for scrollbar even when content doesn't overflow */
body {
  scrollbar-gutter: stable;
}

/* ─── SCROLL-MARGIN / SCROLL-PADDING ─── */
/* Account for sticky header when jumping to anchors */
:target {
  scroll-margin-top: 80px;   /* offset from top of viewport */
}

/* Or on the scroll container: */
html {
  scroll-padding-top: 80px;
}

📝 KEY POINTS:
✅ Use overflow: auto instead of scroll — only shows scrollbars when needed
✅ white-space: nowrap is needed to make horizontal scrolling work
✅ scroll-snap creates smooth carousels without JavaScript
✅ overscroll-behavior: contain prevents scroll chaining in modals
✅ scroll-padding-top fixes the sticky header / anchor link problem
❌ overflow: hidden on a parent clips position: absolute children too
❌ Styling scrollbars with ::-webkit-scrollbar is not standardized — use scrollbar-color for Firefox
''',
  quiz: [
    Quiz(question: 'What is the difference between overflow: hidden and overflow: clip?', options: [
      QuizOption(text: 'Both clip content but overflow: clip also disables scrolling programmatically', correct: true),
      QuizOption(text: 'overflow: clip shows a scrollbar; hidden does not', correct: false),
      QuizOption(text: 'They are identical', correct: false),
      QuizOption(text: 'overflow: hidden clips only text; clip affects all content', correct: false),
    ]),
    Quiz(question: 'What does scroll-snap-type: x mandatory do?', options: [
      QuizOption(text: 'Makes scrolling always snap to a snap point on the horizontal axis', correct: true),
      QuizOption(text: 'Requires all items to be the same size', correct: false),
      QuizOption(text: 'Prevents scrolling in the x direction', correct: false),
      QuizOption(text: 'Forces the scroll container to be mandatory width', correct: false),
    ]),
    Quiz(question: 'Why use overscroll-behavior: contain on a modal?', options: [
      QuizOption(text: 'Prevents the page behind the modal from scrolling when the modal content hits its boundary', correct: true),
      QuizOption(text: 'Makes the modal content wrap instead of scroll', correct: false),
      QuizOption(text: 'Keeps the modal within the viewport', correct: false),
      QuizOption(text: 'Prevents the modal from being scrolled at all', correct: false),
    ]),
  ],
);
