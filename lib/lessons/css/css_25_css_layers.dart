// lib/lessons/css/css_25_css_layers.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cssLesson25 = Lesson(
  language: 'CSS',
  title: 'CSS Layers (@layer) and the Modern Cascade',
  content: '''
🎯 METAPHOR:
CSS @layer is like a layered cake with rules about which
layer wins fights. The bottom layer (base/reset) has the
least authority. The middle layer (components) overrides it.
The top layer (utilities) overrides everything. When two
rules in the same layer conflict, normal specificity rules
apply. But a LOW-specificity rule in a HIGH-priority layer
beats a HIGH-specificity rule in a LOW-priority layer.
It gives you INTENTIONAL control over the cascade instead
of specificity warfare.

Before @layer, the only way to override a 3rd-party library's
styles was to use higher specificity or !important — both
create technical debt. @layer lets you say "this library
sits in the base layer — ALL my code wins over it,
regardless of specificity."

📖 EXPLANATION:
@layer — CSS Cascade Layers (2022+)

WHY IT EXISTS:
  Managing specificity in large codebases is a constant battle.
  Third-party libraries often have high-specificity selectors.
  @layer gives deterministic control over which styles win.

HOW IT WORKS:
  Declare layer order first (later = higher priority).
  Rules in higher-priority layers win over lower layers
  regardless of specificity.
  Unlayered styles (no @layer) beat ALL layers.

TYPICAL LAYER ORDER:
  @layer reset, base, components, utilities;

💻 CODE:
/* ─── DECLARE LAYER ORDER ─── */
/* Always declare order first — highest priority last */
@layer reset, base, components, utilities;

/* ─── RESET LAYER (lowest priority) ─── */
@layer reset {
  *, *::before, *::after {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
  }

  img, video, svg {
    display: block;
    max-width: 100%;
  }
}

/* ─── BASE LAYER ─── */
@layer base {
  :root {
    --color-primary: #0066cc;
    --font-size-base: 1rem;
    --line-height-base: 1.6;
  }

  body {
    font-size: var(--font-size-base);
    line-height: var(--line-height-base);
    color: #212529;
  }

  h1, h2, h3 { line-height: 1.2; }
  a { color: var(--color-primary); }
}

/* ─── THIRD-PARTY LIBRARY IN LOW LAYER ─── */
/* Bootstrap or any library — put it in a lower layer */
@import url('bootstrap.css') layer(external);

/* Now your component styles ALWAYS win over Bootstrap */
/* Even if Bootstrap uses #id selectors! */

/* ─── COMPONENTS LAYER ─── */
@layer components {
  /* A button component */
  /* Even with just a class selector, it wins over base layer */
  .btn {
    display: inline-flex;
    align-items: center;
    padding: 0.5rem 1rem;
    border-radius: 0.375rem;
    font-weight: 500;
    cursor: pointer;
    transition: background 200ms;
    border: none;
  }

  .btn-primary {
    background: var(--color-primary);
    color: white;
  }

  .btn-primary:hover {
    background: #004d99;
  }

  .card {
    border-radius: 8px;
    box-shadow: 0 1px 3px rgba(0,0,0,0.12);
    padding: 24px;
    background: white;
  }
}

/* ─── UTILITIES LAYER (highest priority) ─── */
@layer utilities {
  /* These override ANYTHING in lower layers */
  .hidden      { display: none; }
  .sr-only     { position: absolute; width: 1px; height: 1px; overflow: hidden; clip: rect(0,0,0,0); }
  .text-center { text-align: center; }
  .text-right  { text-align: right; }
  .mt-auto     { margin-top: auto; }
  .flex        { display: flex; }
  .grid        { display: grid; }

  /* Color utilities */
  .text-primary { color: var(--color-primary); }
  .bg-primary   { background-color: var(--color-primary); }
}

/* ─── UNLAYERED STYLES (beat EVERYTHING) ─── */
/* Styles outside any @layer beat all layers */
/* Use for one-off critical overrides */
.emergency-fix {
  display: none !important;  /* even this is less brittle with layers */
}

/* ─── LAYER SUBLAYERS ─── */
@layer components {
  @layer forms {
    input, select, textarea {
      border: 1px solid #ccc;
      border-radius: 4px;
      padding: 0.5rem;
    }
  }

  @layer buttons { /* ... */ }
  @layer cards   { /* ... */ }
}
/* Reference: components.forms, components.buttons */

/* ─── @LAYER WITH @IMPORT ─── */
/* Import a whole stylesheet into a layer */
/* @import "normalize.css" layer(reset); */

/* ─── CHECKING LAYER SUPPORT ─── */
@supports (animation-timeline: auto) {
  /* Modern browser features... */
}

/* Browser support for @layer: Chrome 99+, FF 97+, Safari 15.4+ */

📝 KEY POINTS:
✅ Declare layer order first — the order matters, not where rules are defined
✅ Higher priority layers beat lower layers regardless of specificity
✅ Put third-party CSS in a low-priority layer so you can easily override it
✅ Unlayered styles (outside @layer) always beat layered styles
✅ @layer solves the !important arms race in large CSS codebases
❌ @layer browser support: 2022+ — check if your target audience uses older browsers
❌ Don't mix @layer and non-layer styles casually — unlayered always wins
''',
  quiz: [
    Quiz(question: 'If you declare "@layer reset, base, utilities;", which layer has highest priority?', options: [
      QuizOption(text: 'utilities — the last declared layer has the highest priority', correct: true),
      QuizOption(text: 'reset — the first declared layer has highest priority', correct: false),
      QuizOption(text: 'base — the middle layer always wins', correct: false),
      QuizOption(text: 'They all have equal priority — specificity decides', correct: false),
    ]),
    Quiz(question: 'What beats ALL CSS layers, including the highest priority one?', options: [
      QuizOption(text: 'Styles written outside of any @layer (unlayered styles)', correct: true),
      QuizOption(text: '!important declarations inside layers', correct: false),
      QuizOption(text: 'Inline styles', correct: false),
      QuizOption(text: 'ID selectors inside a high-priority layer', correct: false),
    ]),
    Quiz(question: 'Why would you put a third-party CSS library inside a @layer?', options: [
      QuizOption(text: 'So your own styles can override the library easily — regardless of the library\'s specificity', correct: true),
      QuizOption(text: 'To make the library load faster', correct: false),
      QuizOption(text: 'To prevent the library from affecting global styles', correct: false),
      QuizOption(text: 'Libraries must be in a layer to work', correct: false),
    ]),
  ],
);
