// lib/lessons/css/css_28_scroll_snap.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cssLesson28 = Lesson(
  language: 'CSS',
  title: 'Scroll Snap and Scroll Behavior',
  content: '''
🎯 METAPHOR:
Scroll snap is like a cassette tape that clicks into place.
Without it, scrolling is freeform — you can stop anywhere.
With scroll snap, as you scroll the container snaps to the
nearest defined position, like tapes clicking into the deck.
One slide at a time. One card at a time. One full screen
section at a time. Satisfying, precise, and zero JavaScript.

Scroll behavior controls whether that journey is instant
(hard cut) or smooth (gliding pan). Add smooth scrolling
and anchor links stop being jarring jumps — they become
cinematic glides to the target.

📖 EXPLANATION:
SCROLL SNAP:
  scroll-snap-type       on the CONTAINER
  scroll-snap-align      on each CHILD ITEM
  scroll-snap-stop       force stop at every snap point
  scroll-padding         offset snap position from container edge
  scroll-margin          offset snap position from item edge

SCROLL BEHAVIOR:
  scroll-behavior: smooth | auto   on container or html element

OVERSCROLL:
  overscroll-behavior: auto | contain | none
  Prevents scroll chaining to parent containers

💻 CODE:
/* ─── FULL-PAGE SECTIONS (vertical snap) ─── */
html {
  scroll-snap-type: y mandatory;
  /* y = vertical axis, mandatory = always snaps */
}

section {
  height: 100vh;
  scroll-snap-align: start;  /* snap to top of each section */
}

/* ─── HORIZONTAL CARD CAROUSEL ─── */
.carousel {
  display: flex;
  overflow-x: auto;
  scroll-snap-type: x mandatory;
  gap: 1rem;
  padding: 1rem;

  /* Hide scrollbar but keep functionality */
  scrollbar-width: none;          /* Firefox */
  -ms-overflow-style: none;       /* IE */
}
.carousel::-webkit-scrollbar { display: none; }  /* Chrome/Safari */

.carousel-card {
  flex: 0 0 280px;               /* fixed width, no shrink */
  scroll-snap-align: start;
  background: white;
  border-radius: 12px;
  padding: 1.5rem;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
}

/* ─── PROXIMITY vs MANDATORY ─── */
.gallery {
  scroll-snap-type: x proximity;
  /* proximity = only snaps if close to snap point */
  /* mandatory = ALWAYS snaps, even mid-scroll */
}

/* ─── SCROLL-SNAP-STOP ─── */
.strict-carousel .item {
  scroll-snap-align: center;
  scroll-snap-stop: always;
  /* Prevents skipping over items — must stop at each one */
}

/* ─── SCROLL PADDING (offset for sticky header) ─── */
html {
  scroll-padding-top: 80px;
  /* When jumping to anchor, stop 80px from top
     so sticky nav doesn't cover the target */
}

.snap-container {
  scroll-padding: 1rem;           /* all sides */
  scroll-padding-inline: 2rem;    /* left and right */
}

/* ─── SCROLL MARGIN (on items) ─── */
#about {
  scroll-margin-top: 80px;
  /* Item itself has an 80px margin from snap point */
}

/* ─── SMOOTH SCROLLING ─── */
html {
  scroll-behavior: smooth;
}

/* Only smooth scroll when user hasn't requested reduced motion */
@media (prefers-reduced-motion: no-preference) {
  html { scroll-behavior: smooth; }
}

/* ─── OVERSCROLL BEHAVIOR ─── */
/* Modal body: prevent scroll from escaping to page behind */
.modal-body {
  overflow-y: auto;
  overscroll-behavior-y: contain;
}

/* Chat window: prevent page scroll when at chat boundaries */
.chat-messages {
  overflow-y: auto;
  overscroll-behavior: contain;
}

/* Disable pull-to-refresh on mobile */
body {
  overscroll-behavior-y: none;
}

/* ─── COMPLETE SLIDER EXAMPLE ─── */
.slider {
  display: grid;
  grid-auto-flow: column;
  grid-auto-columns: 100%;
  overflow-x: auto;
  scroll-snap-type: x mandatory;
  scroll-behavior: smooth;
  scrollbar-width: none;
}

.slide {
  scroll-snap-align: start;
  min-height: 400px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 2rem;
}

.slide:nth-child(1) { background: #6c63ff; color: white; }
.slide:nth-child(2) { background: #e91e8c; color: white; }
.slide:nth-child(3) { background: #4caf50; color: white; }

/* Scroll indicator dots */
.dots {
  display: flex;
  gap: 8px;
  justify-content: center;
  margin-top: 1rem;
}

.dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: #ccc;
  cursor: pointer;
}

.dot.active { background: #6c63ff; }

📝 KEY POINTS:
✅ scroll-snap-type goes on the CONTAINER; scroll-snap-align goes on ITEMS
✅ mandatory always snaps; proximity only snaps when close to a snap point
✅ Use scroll-padding-top to account for sticky headers in anchor navigation
✅ scroll-snap-stop: always prevents users from skipping snap points
✅ overscroll-behavior: contain stops scroll from "escaping" to parent
✅ Always wrap scroll-behavior: smooth in prefers-reduced-motion media query
❌ scroll-snap-type: y mandatory on html can feel jarring — test carefully on mobile
❌ Don't use mandatory snap on containers with variable-height children
''',
  quiz: [
    Quiz(question: 'Where does scroll-snap-type go?', options: [
      QuizOption(text: 'On the scroll container', correct: true),
      QuizOption(text: 'On each snap item', correct: false),
      QuizOption(text: 'On the body element only', correct: false),
      QuizOption(text: 'On the html element only', correct: false),
    ]),
    Quiz(question: 'What is the difference between "mandatory" and "proximity" in scroll-snap-type?', options: [
      QuizOption(text: 'Mandatory always snaps; proximity only snaps when near a snap point', correct: true),
      QuizOption(text: 'Mandatory snaps horizontally; proximity snaps vertically', correct: false),
      QuizOption(text: 'Proximity is mandatory for all browsers; mandatory is optional', correct: false),
      QuizOption(text: 'They are identical — just different names', correct: false),
    ]),
    Quiz(question: 'What does scroll-padding-top: 80px solve?', options: [
      QuizOption(text: 'Prevents a sticky header from covering anchor link targets when scrolling', correct: true),
      QuizOption(text: 'Adds 80px of space above the scroll container', correct: false),
      QuizOption(text: 'Delays scrolling by 80 milliseconds', correct: false),
      QuizOption(text: 'Makes the scroll snap point 80px from the top of each item', correct: false),
    ]),
  ],
);
