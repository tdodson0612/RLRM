// lib/lessons/css/css_30_css_containment.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cssLesson30 = Lesson(
  language: 'CSS',
  title: 'CSS Containment and content-visibility',
  content: '''
🎯 METAPHOR:
CSS containment is like isolating departments in a building.
Without containment, changing one department's furniture
(layout) requires checking every other department for impact.
With containment, each department is sealed: "changes inside
here don't affect anything outside." The browser stops
checking the rest of the building, making repaints and
reflows dramatically faster for isolated components.

content-visibility is even more aggressive — it's like
closing the blinds on floors you can't see from the street.
If a section is far off screen, skip rendering it entirely.
The browser still knows it takes up space (layout is
preserved), but doesn't actually render the content until
it scrolls into view. Huge performance win for long pages.

📖 EXPLANATION:
CONTAIN PROPERTY — isolation levels:

contain: layout
  Changes inside don't affect layout outside.
  Positioned elements are contained (like position: relative).

contain: paint
  Contents are clipped to the border box.
  Painted independently (like overflow: hidden + isolation).

contain: size
  Element's size doesn't depend on its contents.
  Must provide explicit dimensions.

contain: style
  Counter scope and CSS custom properties are isolated.

contain: strict
  Shorthand for layout paint size style.

contain: content
  Shorthand for layout paint style (most practical).

content-visibility: auto
  Browser skips rendering off-screen content.
  Must pair with contain-intrinsic-size for layout stability.

contain-intrinsic-size
  Placeholder size while content-visibility skips rendering.

💻 CODE:
/* ─── BASIC CONTAIN ─── */
/* Good for independent widget components */
.widget {
  contain: content;
  /* layout + paint + style containment
     Widget is isolated: no layout bleed in or out */
}

/* For components with known dimensions */
.fixed-card {
  contain: strict;
  width: 300px;
  height: 200px;
  /* Full isolation — fastest possible */
}

/* Layout containment only */
.component {
  contain: layout;
  /* Positioned children are contained within this element
     like position: relative, even without being relative */
}

/* Paint containment */
.paint-isolated {
  contain: paint;
  /* Contents cannot visually overflow
     Browser can optimize repaints independently */
}

/* ─── CONTENT-VISIBILITY ─── */
/* Apply to repeated off-screen sections */
.article-section {
  content-visibility: auto;
  /* Browser skips rendering when off-screen */

  contain-intrinsic-size: 0 500px;
  /* Placeholder height: 500px while section is not rendered
     Prevents layout shift when scrolling rapidly */
}

/* Hide completely (like display: none but preservable) */
.hidden-panel {
  content-visibility: hidden;
  /* Removed from rendering tree
     Unlike display: none, the state is preserved
     (e.g. scroll position inside, focus state) */
}

/* Always render (default behavior) */
.always-visible {
  content-visibility: visible;
}

/* ─── PRACTICAL EXAMPLE: LONG ARTICLE PAGE ─── */
article > section {
  content-visibility: auto;
  contain-intrinsic-block-size: 600px;
  /* Each section is rendered only when near viewport
     Only first few sections render on page load
     Remaining load as user scrolls */
}

/* ─── CONTAIN-INTRINSIC-SIZE VARIANTS ─── */
.section {
  contain-intrinsic-size: 300px 500px;     /* width height */
  contain-intrinsic-size: auto 500px;      /* auto width, 500px height */
  contain-intrinsic-block-size: 500px;     /* height (block direction) */
  contain-intrinsic-inline-size: 300px;    /* width (inline direction) */
}

/* The "auto" keyword remembers actual size after first render */
.smart-section {
  content-visibility: auto;
  contain-intrinsic-size: auto 400px;
  /* First render: placeholder 400px
     After scroll into view: browser remembers actual size
     No layout shift on subsequent renders */
}

/* ─── PERFORMANCE PATTERN ─── */
/* Main content area — always render */
.hero, .above-fold { content-visibility: visible; }

/* Long-form content below the fold */
.blog-post section,
.product-list .product,
.comment-thread .comment {
  content-visibility: auto;
  contain-intrinsic-block-size: 200px;
}

/* ─── CONTAIN AND STACKING CONTEXTS ─── */
/* contain: layout creates a new formatting context
   contain: paint creates a new stacking context */

.contained-modal-host {
  contain: layout paint;
  position: relative;
  /* Modals and dropdowns inside are contained
     z-index only competes within this element */
}

📝 KEY POINTS:
✅ content-visibility: auto is one of the biggest CSS performance wins for long pages
✅ Always pair content-visibility: auto with contain-intrinsic-size to prevent layout shift
✅ contain: content is the most practical containment for reusable components
✅ contain: layout means positioned children are contained like position: relative
✅ The "auto" value in contain-intrinsic-size remembers actual size after rendering
❌ Don't use content-visibility: auto on above-the-fold content — it delays initial render
❌ contain: strict requires explicit dimensions — without them the element collapses
''',
  quiz: [
    Quiz(question: 'What does content-visibility: auto do?', options: [
      QuizOption(text: 'Skips rendering off-screen content, improving performance on long pages', correct: true),
      QuizOption(text: 'Automatically adjusts content to fit the container', correct: false),
      QuizOption(text: 'Hides content until it is clicked', correct: false),
      QuizOption(text: 'Enables auto-sizing based on content', correct: false),
    ]),
    Quiz(question: 'Why is contain-intrinsic-size needed with content-visibility: auto?', options: [
      QuizOption(text: 'It provides a placeholder size so skipped sections don\'t cause layout shift', correct: true),
      QuizOption(text: 'It is required for content-visibility to activate', correct: false),
      QuizOption(text: 'It sets the maximum size of the content', correct: false),
      QuizOption(text: 'It controls how fast content fades in when scrolled into view', correct: false),
    ]),
    Quiz(question: 'What does contain: content include?', options: [
      QuizOption(text: 'Layout + paint + style containment', correct: true),
      QuizOption(text: 'Layout + paint + size + style (strict) containment', correct: false),
      QuizOption(text: 'Only layout containment', correct: false),
      QuizOption(text: 'Only paint containment', correct: false),
    ]),
  ],
);
