// lib/lessons/css/css_19_filters_blend_modes.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cssLesson19 = Lesson(
  language: 'CSS',
  title: 'Filters and Blend Modes',
  content: '''
🎯 METAPHOR:
CSS filters are like Instagram filters applied to elements —
blur, brightness, contrast, grayscale, sepia — all the classics,
all in pure CSS. They process the pixels of the element and
everything inside it, producing a visual effect.

Blend modes are like Photoshop layer blending — how should
this layer interact with the pixels BENEATH it? "Multiply"
darkens. "Screen" lightens. "Overlay" increases contrast.
"Color" applies the color but keeps the luminosity of what's below.
These were Photoshop-exclusive effects for decades.
CSS brings them to the web.

📖 EXPLANATION:
CSS FILTER FUNCTIONS:
  blur(px)            Gaussian blur
  brightness(%)       0% black, 100% normal, 200% extra bright
  contrast(%)         0% grey, 100% normal, 200% high contrast
  grayscale(%)        0% color, 100% greyscale
  sepia(%)            vintage warmth
  saturate(%)         0% greyscale, 100% normal, 200% vivid
  hue-rotate(deg)     rotate colors on the wheel
  invert(%)           invert colors (0-100%)
  opacity(%)          0% transparent (prefer CSS opacity property)
  drop-shadow(...)    shadow that follows the shape

BLEND MODES:
  mix-blend-mode      how an element blends with what's behind it
  background-blend-mode  how background layers blend together

COMMON BLEND VALUES:
  normal, multiply, screen, overlay, darken, lighten,
  color-dodge, color-burn, hard-light, soft-light,
  difference, exclusion, hue, saturation, color, luminosity

BACKDROP FILTER:
  backdrop-filter     applies filter to WHAT'S BEHIND an element
  (frosted glass effect!)

💻 CODE:
/* ─── CSS FILTERS ─── */
img.grayscale { filter: grayscale(100%); }
img.sepia     { filter: sepia(80%); }
img.blur      { filter: blur(4px); }

/* Hover color reveal */
.photo {
  filter: grayscale(100%);
  transition: filter 400ms ease;
}
.photo:hover { filter: grayscale(0%); }

/* Combining filters */
.vintage {
  filter: sepia(50%) brightness(90%) contrast(110%) saturate(130%);
}

.dark-mode img {
  filter: invert(1) hue-rotate(180deg);
  /* Inverts then rotates hue back — makes images dark-mode friendly */
}

.highlighted {
  filter: brightness(110%) drop-shadow(0 4px 8px rgba(0,0,0,0.3));
}

/* Disabled state */
.disabled {
  filter: grayscale(100%) opacity(50%);
  pointer-events: none;
}

/* ─── BACKDROP FILTER (frosted glass) ─── */
.glass-card {
  background: rgba(255, 255, 255, 0.2);
  backdrop-filter: blur(12px) saturate(150%);
  -webkit-backdrop-filter: blur(12px) saturate(150%); /* Safari */
  border: 1px solid rgba(255, 255, 255, 0.3);
  border-radius: 16px;
  padding: 24px;
}

.nav-glass {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(20px);
  position: sticky;
  top: 0;
}

/* ─── MIX-BLEND-MODE ─── */
/* Text that blends with the background */
.blend-text {
  color: white;
  mix-blend-mode: difference;   /* inverts background colors */
  /* White text on dark = white, white text on light = dark */
}

/* Duotone effect */
.duotone {
  position: relative;
}
.duotone img {
  filter: grayscale(100%);
}
.duotone::after {
  content: "";
  position: absolute;
  inset: 0;
  background: linear-gradient(to right, #f093fb, #f5576c);
  mix-blend-mode: multiply;
}

/* Multiply darkens — great for overlaying color on images */
.overlay-multiply {
  mix-blend-mode: multiply;
  background: rgba(0, 102, 204, 0.5);
}

/* Screen lightens — good for light effects */
.light-leak {
  mix-blend-mode: screen;
  background: radial-gradient(circle, rgba(255,200,100,0.8), transparent);
}

/* ─── BACKGROUND-BLEND-MODE ─── */
/* How background-image and background-color blend together */
.textured {
  background-color: #0066cc;
  background-image: url('/textures/noise.png');
  background-blend-mode: multiply;
  /* Color bleeds through the texture */
}

/* ─── FILTER WITH ANIMATION ─── */
@keyframes pulse-glow {
  0%, 100% { filter: brightness(1) drop-shadow(0 0 5px rgba(0,102,204,0.5)); }
  50%       { filter: brightness(1.1) drop-shadow(0 0 20px rgba(0,102,204,0.9)); }
}
.pulse-icon { animation: pulse-glow 2s ease-in-out infinite; }

📝 KEY POINTS:
✅ filter applies to the whole element and its descendants
✅ backdrop-filter creates the "frosted glass" effect — blur what's BEHIND
✅ mix-blend-mode: difference on white text creates an inverted auto-contrast effect
✅ Combine filters with spaces in a single filter declaration
✅ drop-shadow filter follows the shape; box-shadow follows the rectangle
❌ backdrop-filter requires -webkit- prefix for Safari — add both
❌ mix-blend-mode works relative to what's visually beneath — stacking context matters
❌ Heavy filters (blur especially) are expensive — don't animate blur
''',
  quiz: [
    Quiz(question: 'What is the difference between filter: blur() and backdrop-filter: blur()?', options: [
      QuizOption(text: 'filter blurs the element itself; backdrop-filter blurs what is visible behind the element', correct: true),
      QuizOption(text: 'backdrop-filter blurs the element; filter blurs behind it', correct: false),
      QuizOption(text: 'They are identical — just different names', correct: false),
      QuizOption(text: 'filter is for images; backdrop-filter is for text', correct: false),
    ]),
    Quiz(question: 'What does mix-blend-mode: multiply do?', options: [
      QuizOption(text: 'Multiplies the element\'s colors with the background — darkens the result', correct: true),
      QuizOption(text: 'Multiplies the element\'s opacity', correct: false),
      QuizOption(text: 'Combines the element with a copy of itself', correct: false),
      QuizOption(text: 'Lightens by adding colors together', correct: false),
    ]),
    Quiz(question: 'Which filter creates a vintage warm-toned photo effect?', options: [
      QuizOption(text: 'filter: sepia(80%)', correct: true),
      QuizOption(text: 'filter: warm(80%)', correct: false),
      QuizOption(text: 'filter: hue-rotate(30deg)', correct: false),
      QuizOption(text: 'filter: contrast(80%)', correct: false),
    ]),
  ],
);
