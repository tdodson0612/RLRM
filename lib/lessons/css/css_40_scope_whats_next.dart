// lib/lessons/css/css_40_scope_whats_next.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cssLesson40 = Lesson(
  language: 'CSS',
  title: '@scope, CSS Anchoring, and What\'s Next in CSS',
  content: '''
🎯 METAPHOR:
@scope is like a privacy fence for CSS rules.
Instead of complex .component .child .element selectors
to avoid global contamination, you say "these rules only
apply WITHIN this boundary, and don't apply PAST that fence."
It's built-in component scoping without a framework.

CSS Anchor Positioning is like magnetic snap alignment.
Instead of calculating pixels to position a tooltip near
its button, you declare "this tooltip is anchored to that
button — keep it nearby and flip sides if it would go
off-screen." The browser does the geometry.

CSS is evolving faster than ever. Features that required
JavaScript or frameworks are becoming pure CSS. Understanding
the direction helps you write future-proof code today.

📖 EXPLANATION:
@SCOPE (CSS Scoping):
  Limits rule application to a subtree.
  Can have an upper boundary and a lower boundary (donut scope).
  Rules inside @scope have implicit proximity-based specificity.

CSS ANCHOR POSITIONING:
  anchor-name: --my-anchor     — mark the anchor element
  position-anchor: --my-anchor — connect positioned element to anchor
  anchor() function            — reference anchor dimensions
  inset-area                   — position relative to anchor

CSS VIEW TRANSITIONS:
  view-transition-name         — mark elements for transition
  ::view-transition-*          — style the transition
  Works across page navigations (SPA and MPA)

WHAT ELSE IS COMING:
  CSS Mixins & Functions (custom functions)
  CSS Conditional Rules improvements
  CSS Typed OM (JavaScript API for CSS values)
  Relative Color enhancements

💻 CODE:
/* ─── @SCOPE ─── */
/* Basic scope: rules only apply inside .card */
@scope (.card) {
  img {
    border-radius: 8px;    /* only card images get this */
    width: 100%;
  }

  h2 {
    font-size: 1.25rem;    /* only h2 inside .card */
    color: var(--card-title-color, #333);
  }

  a {
    color: #6c63ff;        /* only links inside .card */
  }
}

/* Donut scope: applies INSIDE .card but NOT inside .card-footer */
@scope (.card) to (.card-footer) {
  a {
    color: #6c63ff;        /* card links, but NOT footer links */
    text-decoration: none;
  }
}

/* Multiple scopes */
@scope (.nav), @scope (.sidebar) {
  a {
    display: block;
    padding: 0.5rem 1rem;
  }
}

/* ─── ANCHOR POSITIONING ─── */
/* Define the anchor */
.trigger-button {
  anchor-name: --tooltip-anchor;
}

/* Position relative to anchor */
.tooltip {
  position: absolute;
  position-anchor: --tooltip-anchor;

  /* Position above the anchor */
  bottom: anchor(top);
  left: anchor(center);
  transform: translateX(-50%);

  /* Fallback: flip to below if off screen */
  position-try-fallbacks: flip-block;
}

/* Grid-based inset-area positioning */
.popover {
  position: absolute;
  position-anchor: --button;
  inset-area: block-start center;
  /* Positions above the anchor, centered horizontally */
}

/* ─── VIEW TRANSITIONS ─── */
/* Opt-in to view transitions */
/* In JavaScript: document.startViewTransition(() => updateDOM()); */

/* Name specific elements for targeted transitions */
.hero-image {
  view-transition-name: hero;
}

.page-title {
  view-transition-name: title;
}

/* Style the transition */
::view-transition-old(hero) {
  animation: slide-out-left 0.3s ease;
}

::view-transition-new(hero) {
  animation: slide-in-right 0.3s ease;
}

/* Default fade for everything else */
::view-transition-old(root),
::view-transition-new(root) {
  animation-duration: 0.2s;
}

/* ─── CSS NESTING RECAP (fully landed) ─── */
.card {
  padding: 1rem;
  background: white;

  /* Direct child nesting — no & needed for descendants */
  h2 {
    color: #333;
    font-size: 1.25rem;
  }

  .badge {
    background: #6c63ff;
    color: white;
  }

  /* & needed for pseudo-classes and modifiers */
  &:hover {
    box-shadow: 0 4px 12px rgba(0,0,0,0.1);
  }

  &.featured {
    border: 2px solid #6c63ff;
  }

  @media (max-width: 600px) {
    padding: 0.75rem;
  }
}

/* ─── CSS FUNCTIONS (coming) ─── */
/* Custom functions — not yet in browsers but proposed */
/* @function --fluid-size(--min, --max) {
     result: clamp(var(--min), 5vw, var(--max));
   }
   
   .heading {
     font-size: --fluid-size(1rem, 2rem);
   } */

/* ─── CSS LAYERS RECAP ─── */
@layer reset, base, components, utilities;

@layer reset {
  * { box-sizing: border-box; margin: 0; }
}

@layer base {
  body { font-family: system-ui, sans-serif; }
}

@layer components {
  .btn { padding: 0.5rem 1rem; border-radius: 4px; }
}

@layer utilities {
  .mt-4 { margin-top: 1rem; }
}

/* ─── WHERE CSS IS GOING ─── */
/* Summary of important modern features to learn:
   ✅ Container queries (@container)
   ✅ CSS Layers (@layer)
   ✅ CSS Nesting
   ✅ :has() selector
   ✅ oklch() and color-mix()
   ✅ @property registered custom properties
   ✅ View Transitions API
   ✅ Anchor Positioning (arriving 2024-2025)
   ✅ @scope (arriving 2024-2025)
   ✅ Scroll-driven animations (coming)
   ✅ CSS Mixins (proposed)
*/

/* ─── SCROLL-DRIVEN ANIMATIONS (landed in Chrome 115+) ─── */
@keyframes fade-in {
  from { opacity: 0; transform: translateY(20px); }
  to   { opacity: 1; transform: translateY(0); }
}

.scroll-reveal {
  animation: fade-in linear both;
  animation-timeline: view();
  /* Plays as element enters the viewport — no JS needed! */
  animation-range: entry 0% entry 100%;
}

/* Progress bar driven by scroll */
.reading-progress {
  position: fixed;
  top: 0;
  left: 0;
  height: 4px;
  background: #6c63ff;
  transform-origin: left;
  animation: progress linear;
  animation-timeline: scroll(root);
}

@keyframes progress {
  from { transform: scaleX(0); }
  to   { transform: scaleX(1); }
}

📝 KEY POINTS:
✅ @scope gives you built-in component-level CSS scoping without BEM or CSS Modules
✅ Donut scope (@scope from to) excludes nested components from style rules
✅ Anchor positioning will replace complex tooltip/popover JavaScript calculations
✅ View Transitions enable smooth cross-page animations with minimal code
✅ Scroll-driven animations (animation-timeline: scroll()) tie animations to scroll position with zero JavaScript
✅ CSS nesting is fully supported in all modern browsers
❌ @scope and anchor positioning are newer — check browser support before using
❌ View transitions require JavaScript to trigger (document.startViewTransition)
''',
  quiz: [
    Quiz(question: 'What does "donut scope" mean in @scope?', options: [
      QuizOption(text: 'Rules apply inside the upper boundary but NOT inside the lower boundary', correct: true),
      QuizOption(text: 'Rules apply in a ring shape around the element', correct: false),
      QuizOption(text: 'Rules apply only to circular elements', correct: false),
      QuizOption(text: 'Rules apply everywhere except inside the scoped element', correct: false),
    ]),
    Quiz(question: 'What does animation-timeline: scroll() enable?', options: [
      QuizOption(text: 'Ties the animation progress to the page scroll position — no JavaScript needed', correct: true),
      QuizOption(text: 'Plays the animation in a loop as the page scrolls', correct: false),
      QuizOption(text: 'Triggers the animation only after scrolling past an element', correct: false),
      QuizOption(text: 'Creates a scroll-linked parallax effect automatically', correct: false),
    ]),
    Quiz(question: 'What does anchor-name and position-anchor enable?', options: [
      QuizOption(text: 'Positions an element relative to a named anchor element — browser handles geometry and overflow', correct: true),
      QuizOption(text: 'Creates hyperlink anchors with CSS positioning', correct: false),
      QuizOption(text: 'Names a grid area for anchor positioning', correct: false),
      QuizOption(text: 'Sticks an element to a named scroll position', correct: false),
    ]),
  ],
);
