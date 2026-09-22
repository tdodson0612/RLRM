// lib/lessons/css/css_31_css_counters.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cssLesson31 = Lesson(
  language: 'CSS',
  title: 'CSS Counters',
  content: '''
🎯 METAPHOR:
CSS counters are like an automated numbering machine.
You tell it "start a new sequence here" (counter-reset),
"increment whenever you see one of these" (counter-increment),
and "show the current number here" (counter()).
The machine tracks counts automatically — numbered headings,
figure captions, steps in a process — without you manually
writing "Step 1:", "Step 2:" in your HTML.
When you add a new step in the middle, the numbers
automatically adjust. The machine doesn't care.

📖 EXPLANATION:
CSS counters maintain automatic counts across elements.

counter-reset: name initial-value
  Create (or reset) a counter with optional starting value.
  Typically placed on a parent element.

counter-increment: name amount
  Increment the named counter by amount (default: 1).
  Placed on the elements you want to count.

counter(name)
  Output the current counter value as a string.
  Used inside content: property.

counter(name, style)
  Output in a specific list style: decimal, upper-roman, etc.

counters(name, separator)
  Nested counters — outputs "1.2.3" style numbering.

💻 CODE:
/* ─── BASIC COUNTER ─── */
/* Number headings automatically */
body {
  counter-reset: section;     /* create counter, start at 0 */
}

h2 {
  counter-increment: section;  /* increment on each h2 */
}

h2::before {
  content: "Section " counter(section) ": ";
  color: #6c63ff;
  font-weight: normal;
}

/* ─── NESTED COUNTERS ─── */
article {
  counter-reset: h2-counter;
}

article h2 {
  counter-increment: h2-counter;
  counter-reset: h3-counter;   /* reset sub-counter on each h2 */
}

article h2::before {
  content: counter(h2-counter) ". ";
}

article h3 {
  counter-increment: h3-counter;
}

article h3::before {
  content: counter(h2-counter) "." counter(h3-counter) " ";
}

/* Output: 1. Intro, 1.1 Background, 1.2 Goals, 2. Methods... */

/* ─── CUSTOM LIST COUNTER ─── */
ol.custom {
  counter-reset: custom-counter;
  list-style: none;
  padding: 0;
}

ol.custom li {
  counter-increment: custom-counter;
  position: relative;
  padding-left: 3rem;
  margin-bottom: 1rem;
}

ol.custom li::before {
  content: counter(custom-counter);
  position: absolute;
  left: 0;
  top: 0;
  width: 2rem;
  height: 2rem;
  background: #6c63ff;
  color: white;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: bold;
  font-size: 0.875rem;
}

/* ─── FIGURE CAPTIONS ─── */
figure {
  counter-increment: figures;
}

figure figcaption::before {
  content: "Figure " counter(figures) ": ";
  font-weight: bold;
}

/* Start at different number */
.gallery {
  counter-reset: figures 0;  /* reset to 0 (first increment = 1) */
}

/* ─── COUNTER STYLES ─── */
h2::before {
  content: counter(section, upper-roman) ". ";
  /* Outputs: I. II. III. IV. */
}

h2::before {
  content: counter(section, upper-alpha) ". ";
  /* Outputs: A. B. C. D. */
}

/* ─── COUNTERS() FOR NESTED LISTS ─── */
ol {
  counter-reset: list-counter;
  list-style: none;
}

li {
  counter-increment: list-counter;
}

li::before {
  content: counters(list-counter, ".") " ";
  /* Nested lists output: 1 / 1.1 / 1.1.1 */
}

/* ─── STEP INDICATOR ─── */
.steps {
  counter-reset: step-counter;
  display: flex;
  gap: 0;
}

.step {
  counter-increment: step-counter;
  flex: 1;
  position: relative;
  text-align: center;
  padding: 1rem;
}

.step::before {
  content: counter(step-counter);
  display: block;
  width: 2.5rem;
  height: 2.5rem;
  border-radius: 50%;
  background: #eee;
  color: #666;
  line-height: 2.5rem;
  margin: 0 auto 0.5rem;
  font-weight: bold;
}

.step.active::before {
  background: #6c63ff;
  color: white;
}

.step.done::before {
  content: "✓";
  background: #4caf50;
  color: white;
}

/* ─── COUNT ELEMENTS WITHOUT JAVASCRIPT ─── */
.count-wrapper {
  counter-reset: item-count;
}

.count-item {
  counter-increment: item-count;
}

.count-total::after {
  content: counter(item-count) " items";
}

📝 KEY POINTS:
✅ counter-reset on the parent, counter-increment on the items
✅ Use counters() (plural) for nested numbering like 1.2.3
✅ Counter values are reset per ancestor — nesting works naturally
✅ CSS counters automatically renumber when items are added or removed
✅ Use counter styles (upper-roman, upper-alpha) for custom numbering formats
❌ Counters only work in the content property of ::before/::after pseudo-elements
❌ CSS counters cannot be read by JavaScript — they are purely presentational
''',
  quiz: [
    Quiz(question: 'Where should counter-reset typically be placed?', options: [
      QuizOption(text: 'On the parent/container element to initialize the counter', correct: true),
      QuizOption(text: 'On each element being counted', correct: false),
      QuizOption(text: 'On the ::before pseudo-element', correct: false),
      QuizOption(text: 'On the body element always', correct: false),
    ]),
    Quiz(question: 'What is the difference between counter() and counters()?', options: [
      QuizOption(text: 'counters() outputs nested numbering like "1.2.3"; counter() just outputs the current value', correct: true),
      QuizOption(text: 'counters() counts backward; counter() counts forward', correct: false),
      QuizOption(text: 'counter() is for lists; counters() is for headings', correct: false),
      QuizOption(text: 'They are identical — just different syntax', correct: false),
    ]),
    Quiz(question: 'How do you display Roman numerals with a CSS counter?', options: [
      QuizOption(text: 'content: counter(name, upper-roman)', correct: true),
      QuizOption(text: 'counter-style: roman', correct: false),
      QuizOption(text: 'counter-format: roman', correct: false),
      QuizOption(text: 'content: counter(name, "I II III")', correct: false),
    ]),
  ],
);
