// lib/lessons/css/css_20_css_functions.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cssLesson20 = Lesson(
  language: 'CSS',
  title: 'CSS Functions: calc, min, max, clamp, and More',
  content: '''
🎯 METAPHOR:
CSS functions are like a calculator built into your stylesheet.
Instead of doing the math yourself and hardcoding "I need
the width to be 300px minus two 16px gutters, so 268px,"
you write calc(300px - 32px) and let CSS compute it.
Better yet, you say calc(100% - 32px) and it works for
any container width. Functions make your CSS responsive
to context without needing JavaScript.

📖 EXPLANATION:
CSS MATH FUNCTIONS:
  calc(a op b)     arithmetic with mixed units
  min(a, b, ...)   smallest value
  max(a, b, ...)   largest value
  clamp(min, val, max)  constrain a value

OTHER FUNCTIONS:
  var(--prop, fallback)     custom property
  env(safe-area-inset-top)  environment variables (notch!)
  attr(attribute)           HTML attribute value
  url(path)                 file reference
  linear-gradient()         gradient
  rgb() / hsl() / hwb()     colors
  counter() / counters()    CSS counters
  format()                  font format hint

💻 CODE:
/* ─── CALC ─── */
/* Mixed units — impossible without calc */
.content {
  width: calc(100% - 64px);    /* full width minus margins */
  margin: 0 32px;
}

/* Sidebar layout */
:root { --sidebar: 240px; }
.layout { display: flex; }
.sidebar { width: var(--sidebar); }
.main    { width: calc(100% - var(--sidebar)); }

/* Negative values */
.full-bleed {
  width: calc(100% + 48px);
  margin-inline: -24px;  /* break out of container */
}

/* calc inside transforms */
.centered {
  position: absolute;
  top: calc(50% - 50px);   /* center minus half own height */
  left: calc(50% - 100px);
}

/* ─── MIN ─── */
/* Takes the smaller value */
.container {
  width: min(100%, 1200px);   /* full width OR 1200px, whichever smaller */
  /* Equivalent to: max-width: 1200px + width: 100% */
}

img {
  width: min(400px, 100%);   /* never wider than its container */
}

/* Font that never exceeds a size */
h1 { font-size: min(4vw, 3rem); }

/* ─── MAX ─── */
/* Takes the larger value */
.sidebar {
  width: max(200px, 20%);   /* at least 200px, or 20% if bigger */
}

.section {
  padding: max(40px, 5vh);  /* generous minimum padding */
}

/* ─── CLAMP ─── */
/* clamp(minimum, preferred, maximum) */
/* The single most powerful CSS function for responsive design */

/* Fluid font size */
h1   { font-size: clamp(1.75rem, 4vw, 3rem); }
h2   { font-size: clamp(1.25rem, 3vw, 2rem); }
p    { font-size: clamp(0.9rem, 1.5vw, 1.1rem); }

/* Fluid spacing */
section { padding: clamp(24px, 5vw, 80px); }

/* Fluid container */
.container {
  width: clamp(320px, 90%, 1200px);
  margin-inline: auto;
}

/* Fluid grid gap */
.grid {
  gap: clamp(12px, 2vw, 32px);
}

/* ─── ENV() — safe area insets (notch support) ─── */
/* Essential for iOS devices with notch/Dynamic Island */
.header {
  padding-top: env(safe-area-inset-top);
  padding-left: env(safe-area-inset-left);
  padding-right: env(safe-area-inset-right);
}

.fixed-bottom {
  bottom: env(safe-area-inset-bottom);
  /* Avoids the home indicator bar on iPhone */
}

/* With fallback */
.safe-padding {
  padding-bottom: max(16px, env(safe-area-inset-bottom));
}

/* ─── ATTR() ─── */
/* Use HTML attribute value in CSS content */
[data-label]::before {
  content: attr(data-label) ": ";
  font-weight: bold;
}

/* Progress bar from attribute */
[data-progress]::after {
  content: attr(data-progress) "%";
}

/* ─── CSS COUNTERS ─── */
ol.custom {
  counter-reset: my-counter;  /* initialize */
  list-style: none;
}
ol.custom li {
  counter-increment: my-counter;  /* increment */
}
ol.custom li::before {
  content: counter(my-counter) ". ";  /* display */
  font-weight: bold;
  color: #0066cc;
}

/* ─── COLOR FUNCTIONS ─── */
/* Modern color functions */
.oklch-color { color: oklch(70% 0.15 180); } /* perceptually uniform */
.hwb-color   { color: hwb(180 20% 10%); }   /* hue-whiteness-blackness
.lab-color   { color: lab(50% -20 30); }     /* L*a*b* color space */

/* Color-mix (CSS Color 5) */
.mixed { color: color-mix(in srgb, blue 30%, red); }

📝 KEY POINTS:
✅ calc() accepts any CSS unit — the key is you can MIX different units
✅ min(100%, 1200px) is the modern replacement for max-width + width: 100%
✅ clamp() is the cleanest solution for responsive sizing without media queries
✅ env(safe-area-inset-*) is essential for notch/Dynamic Island support on iOS
✅ CSS counters with counter-reset/counter-increment create automatic numbering
❌ calc() operators (+, -) require spaces around them: calc(100% - 20px) not calc(100%-20px)
❌ Nesting calc() is valid but limit depth — calc(calc(100% - 20px) / 2) can be written as calc((100% - 20px) / 2)
''',
  quiz: [
    Quiz(question: 'What does calc(100% - 32px) compute when the container is 500px wide?', options: [
      QuizOption(text: '468px — it subtracts the fixed 32px from the current percentage width', correct: true),
      QuizOption(text: '468% — percentage and pixels multiply', correct: false),
      QuizOption(text: 'It causes a CSS error — you cannot mix units', correct: false),
      QuizOption(text: '100% because px and % cannot be combined', correct: false),
    ]),
    Quiz(question: 'What does width: min(100%, 800px) do?', options: [
      QuizOption(text: 'The element is 100% wide on small screens and capped at 800px on large screens', correct: true),
      QuizOption(text: 'The element is always 800px wide', correct: false),
      QuizOption(text: 'The element is the minimum of 100 and 800 pixels', correct: false),
      QuizOption(text: 'It selects whichever is larger', correct: false),
    ]),
    Quiz(question: 'What is env(safe-area-inset-bottom) used for?', options: [
      QuizOption(text: 'Providing padding for the iPhone home indicator and notch area', correct: true),
      QuizOption(text: 'Setting a safe minimum bottom padding for all devices', correct: false),
      QuizOption(text: 'Reading the environment\'s CSS variable', correct: false),
      QuizOption(text: 'Adding bottom margin based on the device\'s screen size', correct: false),
    ]),
  ],
);
