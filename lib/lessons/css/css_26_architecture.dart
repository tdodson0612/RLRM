// lib/lessons/css/css_26_architecture.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cssLesson26 = Lesson(
  language: 'CSS',
  title: 'CSS Architecture and Best Practices',
  content: '''
🎯 METAPHOR:
CSS without architecture is like a city that grew without
a plan — roads that don't connect, buildings that block
each other, no logical districts. It works for a while,
then becomes unnavigable. CSS Architecture is urban planning
for your stylesheet: intentional zones (reset, base,
components, utilities), consistent naming conventions
(BEM, atomic), and rules that keep things predictable
as the codebase grows to hundreds of files.

📖 EXPLANATION:
CSS AT SCALE:
As projects grow, unarchitected CSS causes:
  - Specificity wars (needing !important everywhere)
  - Unintended side effects (changing one thing breaks another)
  - Dead code accumulation
  - Inconsistent visual design

POPULAR APPROACHES:
  BEM     — Block, Element, Modifier naming convention
  ITCSS   — Inverted Triangle CSS (layered specificity)
  SMACSS  — Scalable and Modular Architecture
  Atomic  — Single-purpose utility classes (Tailwind's approach)
  CSS-in-JS — Style in components (React world)

THE MODERN RECOMMENDED STACK:
  1. @layer for cascade control
  2. Custom properties for design tokens
  3. BEM or component-scoped naming
  4. Utility classes for one-off overrides

💻 CODE:
/* ─── BEM NAMING CONVENTION ─── */
/* Block: standalone component */
/* Element: part of a block — double underscore __ */
/* Modifier: variation — double hyphen -- */

/* Block */
.card { }

/* Elements of the card block */
.card__image { }
.card__body { }
.card__title { }
.card__description { }
.card__footer { }
.card__button { }

/* Modifiers */
.card--featured { }
.card--horizontal { }
.card--dark { }

/* Element with modifier */
.card__button--primary { }
.card__button--outline { }

/* BEM in practice */
.card {
  background: white;
  border-radius: 8px;
  overflow: hidden;
}

.card__image {
  width: 100%;
  aspect-ratio: 16 / 9;
  object-fit: cover;
}

.card__body {
  padding: 20px;
}

.card__title {
  font-size: 1.25rem;
  font-weight: 600;
  margin-bottom: 8px;
}

.card--featured .card__title {
  color: var(--color-primary);
}

.card--featured {
  border: 2px solid var(--color-primary);
}

/* ─── DESIGN TOKENS (Custom Properties system) ─── */
:root {
  /* Primitive tokens */
  --blue-50:  #eff6ff;
  --blue-500: #3b82f6;
  --blue-700: #1d4ed8;
  --gray-100: #f3f4f6;
  --gray-900: #111827;

  /* Semantic tokens (reference primitives) */
  --color-background: white;
  --color-surface: var(--gray-100);
  --color-text: var(--gray-900);
  --color-primary: var(--blue-500);
  --color-primary-hover: var(--blue-700);

  /* Component tokens */
  --button-padding-y: 0.5rem;
  --button-padding-x: 1rem;
  --button-radius: 0.375rem;
  --card-radius: 0.5rem;
  --card-shadow: 0 1px 3px 0 rgb(0 0 0 / 0.1);
}

/* ─── FILE STRUCTURE ─── */
/*
styles/
  01-settings/
    _variables.css      (custom properties / design tokens)
    _breakpoints.css
  02-tools/
    _mixins.css         (if using preprocessor)
  03-generic/
    _reset.css
    _normalize.css
  04-elements/
    _base.css           (h1-h6, p, a, img defaults)
    _forms.css
  05-objects/
    _grid.css           (layout patterns)
    _container.css
  06-components/
    _button.css
    _card.css
    _nav.css
    _modal.css
  07-utilities/
    _spacing.css
    _text.css
    _display.css
  main.css              (imports all of the above)
*/

/* ─── UTILITY CLASSES ─── */
/* Small, single-purpose classes */
.flex          { display: flex; }
.flex-col      { flex-direction: column; }
.items-center  { align-items: center; }
.justify-between { justify-content: space-between; }
.gap-4         { gap: 1rem; }
.mt-4          { margin-top: 1rem; }
.mb-4          { margin-bottom: 1rem; }
.p-4           { padding: 1rem; }
.px-4          { padding-inline: 1rem; }
.py-2          { padding-block: 0.5rem; }
.text-sm       { font-size: 0.875rem; }
.font-bold     { font-weight: 700; }
.rounded       { border-radius: 0.375rem; }
.rounded-full  { border-radius: 9999px; }
.shadow        { box-shadow: var(--shadow-md); }
.truncate      { overflow: hidden; white-space: nowrap; text-overflow: ellipsis; }
.sr-only       { position: absolute; width: 1px; height: 1px; clip: rect(0,0,0,0); overflow: hidden; }
.pointer-events-none { pointer-events: none; }

/* ─── CSS PERFORMANCE RULES ─── */
/*
  ✅ DO:
  - Use class selectors (.btn) — fast
  - Keep selectors short — .nav-link not nav ul li a
  - Use will-change: transform for animated elements (hint to GPU)
  - Animate only transform and opacity (GPU-composited)
  - Use contain: layout to limit reflow scope

  ❌ AVOID:
  - Universal selector * in hot paths
  - Deeply nested selectors (a div span p em)
  - Animating width, height, top, left (triggers layout)
  - Overusing box-shadow animations (paint intensive)
  - @import inside CSS files (sequential, not parallel)
*/

/* will-change hints to browser before animation */
.will-animate {
  will-change: transform;   /* promote to its own GPU layer */
}
/* Remove after animation — too many layers wastes memory */

/* contain — limit style recalculation scope */
.isolated-widget {
  contain: layout style;   /* changes don't affect outside */
}

📝 KEY POINTS:
✅ BEM naming prevents accidental style collisions across components
✅ Design tokens (custom properties) ensure consistent visual design
✅ Organize CSS from generic to specific — lowest specificity first
✅ Utility classes fill the gaps that components leave
✅ Animate only transform and opacity — they don't trigger layout
✅ @layer makes the cascade predictable at scale
❌ Don't use IDs (#id) for styling — they cause specificity problems
❌ Don't nest selectors more than 3 levels deep
❌ Avoid !important except in utility classes where it's intentional
''',
  quiz: [
    Quiz(question: 'In BEM naming, what does double underscore (__) indicate?', options: [
      QuizOption(text: 'An element — a child part of a block (.card__title)', correct: true),
      QuizOption(text: 'A modifier — a variation of a block', correct: false),
      QuizOption(text: 'A private property not to be used externally', correct: false),
      QuizOption(text: 'A CSS comment marker', correct: false),
    ]),
    Quiz(question: 'What are design tokens in CSS?', options: [
      QuizOption(text: 'Named CSS custom properties representing design decisions — colors, spacing, typography', correct: true),
      QuizOption(text: 'JavaScript objects that define the design system', correct: false),
      QuizOption(text: 'Special HTML attributes for styling', correct: false),
      QuizOption(text: 'Build tool configuration for design systems', correct: false),
    ]),
    Quiz(question: 'Why should you only animate transform and opacity?', options: [
      QuizOption(text: 'They are GPU-composited and don\'t trigger layout recalculation — smooth 60fps', correct: true),
      QuizOption(text: 'They are the only properties that support CSS transitions', correct: false),
      QuizOption(text: 'Other properties cannot be animated', correct: false),
      QuizOption(text: 'They use less memory than other animated properties', correct: false),
    ]),
  ],
);
