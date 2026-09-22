// lib/lessons/css/css_37_performance.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cssLesson37 = Lesson(
  language: 'CSS',
  title: 'CSS Performance and will-change',
  content: '''
🎯 METAPHOR:
CSS performance is like stage lighting at a concert.
The audience (browser) sees a smooth show because the crew
(compositor thread) pre-positions lights (layers) BEFORE
the number starts. If you surprise the crew with sudden
changes (layout reflows), they scramble and the show
stutters. will-change is a heads-up to the crew:
"get ready, this spotlight is going to move soon."
The crew pre-promotes it to its own rig, ready to go.

The critical insight: some CSS properties are cheap (opacity,
transform — GPU handles them). Others are expensive (width,
height, margin — trigger full layout recalculation).
Choose the cheap path whenever possible.

📖 EXPLANATION:
RENDERING PIPELINE:
  1. Style     — which CSS rules apply
  2. Layout    — how big / where things are (expensive!)
  3. Paint     — drawing pixels (moderately expensive)
  4. Composite — combining layers on GPU (cheap, hardware!)

PROPERTIES BY COST:
  Cheap (composite only):  opacity, transform, filter
  Medium (paint only):     color, background, border-radius, box-shadow
  Expensive (layout):      width, height, margin, padding, top, left, font-size

WILL-CHANGE:
  Tells browser to promote element to own compositor layer.
  Use BEFORE the animation starts.
  Remove after animation completes.
  Do NOT apply to everything — creates excessive memory.

CONTAINMENT (see lesson 30):
  contain: layout paint  — isolates reflow/repaint impact

💻 CODE:
/* ─── CHEAP ANIMATION (GPU-accelerated) ─── */
/* GOOD: Only changes transform and opacity — compositor handles it */
.slide-in {
  animation: slide-in 0.3s ease;
}

@keyframes slide-in {
  from {
    transform: translateX(-100%);
    opacity: 0;
  }
  to {
    transform: translateX(0);
    opacity: 1;
  }
}

/* BAD: Changes left/width — triggers layout on every frame */
@keyframes bad-slide {
  from { left: -100px; }  /* triggers layout every frame! */
  to   { left: 0; }
}

/* ─── WILL-CHANGE ─── */
/* Apply just before animation starts, remove after */
.animated-card {
  will-change: transform, opacity;
  /* Browser: "prepare a GPU layer for this element" */
}

/* Better: use :hover or JS to add will-change just-in-time */
.card:hover {
  will-change: transform;
}

/* Even better: toggle with a class */
.card.is-animating {
  will-change: transform;
}

/* DO NOT do this — will-change on everything wastes GPU memory */
/* * { will-change: transform; }  ← TERRIBLE */

/* ─── TRANSFORM INSTEAD OF POSITION ─── */
/* BAD: triggers layout */
.tooltip {
  position: absolute;
  top: calc(100% + 8px);
  left: 50%;
  margin-left: -75px;  /* layout trigger */
}

/* GOOD: use transform to center */
.tooltip {
  position: absolute;
  top: calc(100% + 8px);
  left: 50%;
  transform: translateX(-50%);  /* compositor only */
}

/* ─── OPACITY ANIMATION ─── */
/* GOOD: opacity is cheap */
.fade {
  transition: opacity 0.3s ease;
}
.fade.hidden { opacity: 0; }

/* BAD: visibility + display changes trigger layout/paint */
.bad-fade {
  transition: visibility 0.3s; /* can't animate visibility */
  display: none;               /* not animatable at all */
}

/* ─── CONTAIN FOR PERFORMANCE ─── */
/* Each widget repaints independently */
.dashboard-widget {
  contain: layout paint;
  /* Changes inside don't trigger reflow outside */
}

/* ─── FONT LOADING PERFORMANCE ─── */
body {
  font-display: swap;  /* in @font-face — show text immediately */
}

/* ─── CONTENT-VISIBILITY FOR LONG PAGES ─── */
.lazy-section {
  content-visibility: auto;
  contain-intrinsic-block-size: 500px;
  /* Skip rendering until near viewport */
}

/* ─── COMPOSITING LAYERS ─── */
/* translateZ(0) or translate3d(0,0,0) force GPU layer */
/* Use sparingly — same as will-change: transform */
.gpu-accelerated {
  transform: translateZ(0);
}

/* ─── CSS SELECTOR PERFORMANCE ─── */
/* Selectors are matched right-to-left by browser */

/* GOOD: specific */
.card-title { color: #333; }

/* OK */
.card .title { color: #333; }

/* BAD: very broad right-most selector */
div > * + * .icon { color: #333; }
/* Browser checks every .icon against the whole chain */

/* ALSO BAD: universal selector in chain */
.sidebar * { margin: 0; }  /* matches EVERYTHING in sidebar */

/* ─── CRITICAL CSS PATTERN ─── */
/* Inline above-the-fold CSS in <style> tag */
/* Load rest of CSS asynchronously */
/* <link rel="preload" href="styles.css" as="style">
   <link rel="stylesheet" href="styles.css" media="print" onload="this.media='all'"> */

/* ─── LAYER MANAGEMENT ─── */
/* Use @layer to organize CSS loading order */
@layer base, components, utilities;
/* Load utilities last so they always win */

📝 KEY POINTS:
✅ Use transform and opacity for animations — they are GPU-accelerated
✅ will-change: transform tells the browser to prepare a GPU layer
✅ Apply will-change just before animation, remove it after
✅ contain: layout paint isolates an element's repaint from the rest of the page
✅ content-visibility: auto dramatically speeds up long page rendering
✅ Selectors are matched right-to-left — the rightmost selector is most critical
❌ NEVER apply will-change to many elements at once — each layer uses GPU memory
❌ Animating width, height, top, left triggers expensive layout on every frame
❌ Don't use translateZ(0) as a general performance trick — use will-change instead
''',
  quiz: [
    Quiz(question: 'Which CSS properties are the cheapest to animate?', options: [
      QuizOption(text: 'transform and opacity — handled by the GPU compositor', correct: true),
      QuizOption(text: 'width and height — hardware accelerated', correct: false),
      QuizOption(text: 'margin and padding — simple box model changes', correct: false),
      QuizOption(text: 'color and background-color — only affect paint', correct: false),
    ]),
    Quiz(question: 'What does will-change tell the browser?', options: [
      QuizOption(text: 'To promote the element to its own GPU layer in preparation for upcoming changes', correct: true),
      QuizOption(text: 'That the element\'s styles will be changed by JavaScript', correct: false),
      QuizOption(text: 'To cache the element\'s current state', correct: false),
      QuizOption(text: 'To skip painting the element until needed', correct: false),
    ]),
    Quiz(question: 'Why should you NOT apply will-change to all elements?', options: [
      QuizOption(text: 'Each will-change element gets its own GPU layer — too many layers exhausts GPU memory', correct: true),
      QuizOption(text: 'will-change disables CSS animations on the element', correct: false),
      QuizOption(text: 'will-change only works on positioned elements', correct: false),
      QuizOption(text: 'The browser ignores will-change when too many elements use it', correct: false),
    ]),
  ],
);
