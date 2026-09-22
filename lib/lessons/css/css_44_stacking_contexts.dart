// lib/lessons/css/css_44_stacking_contexts.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cssLesson44 = Lesson(
  language: 'CSS',
  title: 'Stacking Contexts and z-index',
  content: '''
🎯 METAPHOR:
Imagine a desk covered in stacks of paper. Each stack is
a stacking context. Within a single stack, papers at the
top cover papers at the bottom — that is z-index. But here
is the key: no matter how high you number a paper INSIDE
stack A, it can NEVER cover the entire stack B if stack B
is on top of stack A. The z-index hierarchy respects the
stack order first. This is why z-index: 9999 sometimes
does nothing — you are rearranging papers inside your
stack, but your whole stack is underneath someone else's.

📖 EXPLANATION:
Z-INDEX:
  Controls which element appears on top when they overlap.
  Higher z-index = closer to viewer.
  Only works on positioned elements (position not static)
  or flex/grid items.
  z-index: auto — no stacking context created
  z-index: 0    — creates stacking context, same level as auto
  z-index: -1   — below normal flow
  z-index: 1+   — above normal flow

STACKING CONTEXT:
  A self-contained z-index universe.
  Elements inside can only be ordered relative to each other.
  z-index values only compete within the same stacking context.

WHAT CREATES A STACKING CONTEXT:
  ✅ position + z-index (not auto)
  ✅ opacity < 1
  ✅ transform (any value except none)
  ✅ filter (any value)
  ✅ will-change (any value)
  ✅ isolation: isolate
  ✅ mix-blend-mode (not normal)
  ✅ contain: layout | paint | strict | content
  ✅ Flex/grid items with z-index not auto

STACKING ORDER (bottom to top):
  1. Background and borders of stacking context element
  2. Negative z-index elements
  3. Block elements in normal flow
  4. Float elements
  5. Inline elements in normal flow
  6. z-index: auto positioned elements
  7. Positive z-index elements (ascending)

💻 CODE:
/* ─── BASIC Z-INDEX ─── */
.dropdown {
  position: relative;
  z-index: 100;
}

.modal-overlay {
  position: fixed;
  inset: 0;
  z-index: 1000;
}

.modal {
  position: fixed;
  z-index: 1001;  /* above overlay */
}

.tooltip {
  position: absolute;
  z-index: 500;
}

/* ─── Z-INDEX SCALE (design system approach) ─── */
:root {
  --z-below:    -1;
  --z-base:      0;
  --z-raised:   10;
  --z-dropdown: 100;
  --z-sticky:   200;
  --z-overlay:  300;
  --z-modal:    400;
  --z-toast:    500;
  --z-tooltip:  600;
}

/* ─── STACKING CONTEXT PROBLEM ─── */
/* This is the classic "z-index isn't working" bug */

.card {
  position: relative;
  transform: translateY(0);
  /* ⚠️ transform creates a NEW stacking context!
     Any z-index inside .card is now isolated.
     .card's dropdown can never appear above .other-card */
}

.card .dropdown {
  position: absolute;
  z-index: 999;  /* 999 inside .card's context — still below .other-card */
}

.other-card {
  position: relative;
  z-index: 1;   /* this whole card is above card's context */
}

/* ─── FIX: isolation: isolate ─── */
/* Create an intentional stacking context without side effects */
.stacking-root {
  isolation: isolate;
  /* Creates a stacking context WITHOUT transform/opacity side effects
     Useful to contain z-index battles inside a component */
}

/* ─── PRACTICAL EXAMPLE: MODAL PORTAL ─── */
/* Move modal to body level to escape nested stacking contexts */

/* JavaScript: document.body.appendChild(modalElement) */
/* Then style at body level where z-index is unrestricted */

.modal-portal {
  position: fixed;
  inset: 0;
  z-index: var(--z-modal);
  display: flex;
  align-items: center;
  justify-content: center;
}

/* ─── NEGATIVE Z-INDEX ─── */
.card {
  position: relative;
  background: white;
}

.card::before {
  content: "";
  position: absolute;
  inset: 0;
  z-index: -1;               /* behind the card itself */
  background: linear-gradient(135deg, #6c63ff, #e91e8c);
  border-radius: inherit;
  transform: translate(4px, 4px);  /* offset shadow effect */
  filter: blur(12px);
  opacity: 0.6;
}

/* ─── DEBUGGING STACKING ISSUES ─── */
/* Outline every stacking context to visualize them */
/* (dev tool — remove in production) */
*[style*="transform"],
*[style*="opacity"],
*[style*="z-index"],
.stacking-context {
  outline: 2px dashed rgba(255, 0, 0, 0.3);
}

/* ─── COMMON Z-INDEX PITFALLS ─── */

/* PROBLEM: header with dropdown under content */
.sticky-header {
  position: sticky;
  top: 0;
  /* Missing z-index — content scrolls over header */
}
/* FIX: */
.sticky-header {
  position: sticky;
  top: 0;
  z-index: var(--z-sticky);  /* stays above scroll content */
  background: white;          /* don't forget background! */
}

/* PROBLEM: modal behind sticky header */
/* FIX: ensure modal z-index > sticky header z-index */

/* PROBLEM: tooltip clipped by overflow: hidden parent */
/* FIX: move tooltip to a portal (append to body via JS)
   OR restructure HTML so tooltip isn't inside the clipping container */

/* ─── PAINT-ORDER WITH FLEX/GRID ─── */
/* Flex and grid items can use z-index without position */
.flex-container {
  display: flex;
}

.flex-item:hover {
  z-index: 1;    /* works on flex items — raises above siblings */
  transform: scale(1.05);
}

📝 KEY POINTS:
✅ z-index only works on positioned elements (not position: static) or flex/grid items
✅ Use a named z-index scale (CSS variables) to avoid magic numbers
✅ transform, opacity < 1, filter, and will-change all create new stacking contexts
✅ isolation: isolate creates a stacking context with no visual side effects
✅ "z-index not working" is almost always a stacking context issue — check ancestors
✅ Sticky headers need an explicit z-index or content will scroll over them
❌ Don't use z-index: 9999 — use a scale; 9999 means "I don't understand the context"
❌ overflow: hidden on a parent clips absolutely positioned children — can't be fixed with z-index
''',
  quiz: [
    Quiz(question: 'Why does z-index sometimes have no effect?', options: [
      QuizOption(text: 'The element is position: static — z-index only works on positioned elements', correct: true),
      QuizOption(text: 'z-index values above 100 are ignored', correct: false),
      QuizOption(text: 'z-index requires display: block', correct: false),
      QuizOption(text: 'z-index does not work inside flex containers', correct: false),
    ]),
    Quiz(question: 'What does isolation: isolate do?', options: [
      QuizOption(text: 'Creates a new stacking context without any visual side effects like transform or opacity', correct: true),
      QuizOption(text: 'Prevents the element from inheriting z-index from its parent', correct: false),
      QuizOption(text: 'Makes the element invisible to z-index layering', correct: false),
      QuizOption(text: 'Isolates the element from CSS cascade inheritance', correct: false),
    ]),
    Quiz(question: 'A dropdown inside a card is hidden behind another card despite z-index: 999. What is the most likely cause?', options: [
      QuizOption(text: 'The card has transform or opacity which created a new stacking context', correct: true),
      QuizOption(text: '999 is not high enough — try z-index: 9999', correct: false),
      QuizOption(text: 'Dropdowns cannot use z-index', correct: false),
      QuizOption(text: 'The card needs position: relative', correct: false),
    ]),
  ],
);
