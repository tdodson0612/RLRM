// lib/lessons/css/css_34_color_level4.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cssLesson34 = Lesson(
  language: 'CSS',
  title: 'CSS Color Level 4: oklch, color-mix, and Modern Color',
  content: '''
🎯 METAPHOR:
Old CSS colors (hex, rgb) are like mixing paint on a
16-bit monitor from 1990 — technically works, but the
color space is cramped. Modern screens can display millions
more colors than sRGB allows. CSS Color Level 4 opens the
windows to the wider color spaces modern hardware supports.

oklch is like describing a color by HOW HUMANS SEE IT —
lightness, chroma (saturation), and hue angle. Unlike HSL,
oklch is PERCEPTUALLY UNIFORM: changing the L value by
the same amount produces the same perceived change in
brightness regardless of hue. Red, green, and blue all
look equally "50% bright" at L=50. HSL cannot do that.

📖 EXPLANATION:
CSS COLOR LEVEL 4 FEATURES:

oklch(L C H / alpha)
  L = lightness 0-100% (or 0-1)
  C = chroma (saturation) 0-0.4 typical
  H = hue angle 0-360
  Most perceptually uniform — best for design systems

lch(L C H)
  Similar to oklch but in CIE LCH color space

lab(L a b)
  CIE Lab — perceptually uniform

oklab(L a b)
  OK version of Lab — better perceptual uniformity

display-p3
  Wide color gamut (Apple, modern screens)
  25% more colors than sRGB

color(space r g b / alpha)
  Access named color spaces: srgb, display-p3, rec2020, a98-rgb

color-mix(in colorspace, color1 percent, color2 percent)
  Mix two colors in a specific color space

color-contrast()
  (Coming) Automatically pick the more readable color

Relative color syntax
  oklch(from blue calc(l + 10%) c h)
  Modify channels relative to an existing color

💻 CODE:
/* ─── OKLCH ─── */
/* Format: oklch(lightness chroma hue) */
.oklch-examples {
  /* Vivid red */
  color: oklch(50% 0.22 27);

  /* Vivid green */
  color: oklch(70% 0.2 145);

  /* Purple */
  color: oklch(60% 0.25 290);

  /* With alpha */
  background: oklch(50% 0.22 27 / 50%);
}

/* Design system with perceptually uniform palette */
:root {
  --brand-100: oklch(97% 0.02 290);
  --brand-200: oklch(90% 0.05 290);
  --brand-300: oklch(80% 0.10 290);
  --brand-400: oklch(70% 0.15 290);
  --brand-500: oklch(60% 0.20 290);  /* base brand */
  --brand-600: oklch(50% 0.20 290);
  --brand-700: oklch(40% 0.18 290);
  --brand-800: oklch(30% 0.15 290);
  --brand-900: oklch(20% 0.10 290);
  /* Each step changes L by 10% — perceptually even steps */
}

/* ─── DISPLAY-P3 (wide gamut) ─── */
.vivid {
  /* Fallback for older browsers */
  color: rgb(0, 200, 100);

  /* Wide gamut for supporting devices */
  color: color(display-p3 0 0.78 0.39);
}

/* ─── COLOR-MIX ─── */
/* Mix two colors in oklch space */
.mixed {
  /* 50% blue, 50% red */
  background: color-mix(in oklch, blue 50%, red 50%);

  /* 30% white = lighten */
  background: color-mix(in oklch, var(--brand-500) 70%, white 30%);

  /* 20% black = darken */
  background: color-mix(in oklch, var(--brand-500) 80%, black 20%);

  /* sRGB mixing (old-school) */
  background: color-mix(in srgb, blue, red);

  /* Percentages don't need to sum to 100% */
  background: color-mix(in oklch, blue 30%, red);  /* red fills the rest */
}

/* ─── RELATIVE COLOR SYNTAX ─── */
/* Modify channels of an existing color */
.relative-colors {
  --brand: oklch(60% 0.2 290);

  /* Lighter version */
  --lighter: oklch(from var(--brand) calc(l + 15%) c h);

  /* More saturated */
  --vivid: oklch(from var(--brand) l calc(c + 0.05) h);

  /* Complement (opposite hue) */
  --complement: oklch(from var(--brand) l c calc(h + 180));

  /* 50% transparent */
  --translucent: oklch(from var(--brand) l c h / 50%);
}

/* ─── PROGRESSIVE ENHANCEMENT ─── */
/* Always provide sRGB fallback first */
button {
  /* sRGB fallback */
  background: hsl(260, 70%, 55%);

  /* Modern wide-gamut */
  @supports (color: oklch(0 0 0)) {
    background: oklch(55% 0.2 290);
  }
}

/* ─── HWB COLOR ─── */
/* Hue, Whiteness, Blackness — intuitive mixing */
.hwb-example {
  color: hwb(220 20% 10%);  /* blue with 20% white, 10% black */
}

/* ─── PRACTICAL DARK MODE WITH OKLCH ─── */
:root {
  --primary-h: 290;  /* purple hue */
  --primary: oklch(60% 0.2 var(--primary-h));
  --primary-light: oklch(85% 0.1 var(--primary-h));
  --primary-dark: oklch(35% 0.2 var(--primary-h));
}

@media (prefers-color-scheme: dark) {
  :root {
    /* Just change L and C — hue stays consistent */
    --primary: oklch(75% 0.2 var(--primary-h));
    --primary-light: oklch(90% 0.08 var(--primary-h));
  }
}

/* ─── BROWSER SUPPORT CHECK ─── */
@supports (color: oklch(0% 0 0)) {
  /* oklch is supported */
  :root { --use-oklch: 1; }
}

📝 KEY POINTS:
✅ oklch is the most perceptually uniform color space for design systems
✅ Changing L by the same amount gives the same perceived brightness change in oklch
✅ color-mix() blends two colors in any color space — great for tints and shades
✅ Always provide an sRGB fallback before wide-gamut colors
✅ Relative color syntax lets you derive variations from a base color
✅ display-p3 unlocks vivid colors modern screens can actually display
❌ HSL looks perceptually uniform but isn't — oklch is the correct choice for even steps
❌ Wide-gamut colors (display-p3, oklch) are clipped to sRGB on older screens
''',
  quiz: [
    Quiz(question: 'What makes oklch better than HSL for creating color palettes?', options: [
      QuizOption(text: 'oklch is perceptually uniform — equal L changes look equally different to human eyes', correct: true),
      QuizOption(text: 'oklch supports more hues than HSL', correct: false),
      QuizOption(text: 'oklch colors are smaller in file size', correct: false),
      QuizOption(text: 'oklch automatically generates accessible contrast ratios', correct: false),
    ]),
    Quiz(question: 'What does color-mix(in oklch, blue 30%, red) produce?', options: [
      QuizOption(text: 'A color that is 30% blue and 70% red, mixed in oklch color space', correct: true),
      QuizOption(text: 'A color that is 30% blue and 30% red with 40% transparent', correct: false),
      QuizOption(text: 'A compile error — percentages must add to 100%', correct: false),
      QuizOption(text: 'Pure red — the smaller percentage is ignored', correct: false),
    ]),
    Quiz(question: 'What does the relative color syntax oklch(from var(--brand) l c calc(h + 180)) produce?', options: [
      QuizOption(text: 'The complementary color of --brand (opposite hue, same lightness and chroma)', correct: true),
      QuizOption(text: 'A color 180% lighter than --brand', correct: false),
      QuizOption(text: 'A color rotated 180 degrees in the image', correct: false),
      QuizOption(text: 'A 50% transparent version of --brand', correct: false),
    ]),
  ],
);
