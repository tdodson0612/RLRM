// lib/lessons/css/css_32_web_fonts.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cssLesson32 = Lesson(
  language: 'CSS',
  title: '@font-face and Web Fonts',
  content: '''
🎯 METAPHOR:
Web fonts are like shipping a custom typeface to every
visitor's browser. The font file travels from your server
(or Google's, or Adobe's) to the user's machine and gets
installed temporarily just for your page. @font-face is
the declaration that says "this is the font, here is where
to get it, this is what to call it." font-display controls
what visitors see WHILE the font is loading — do they see
a fallback first? A blank? Do they wait?

📖 EXPLANATION:
@font-face declares custom fonts. It runs BEFORE the font
is used — the browser fetches it in the background.

font-display values:
  auto       — browser decides (usually block)
  block      — invisible text → swap to custom font
  swap       — fallback text immediately → swap when ready (Google default)
  fallback   — 100ms invisible → fallback → swap if loaded within 3s
  optional   — 100ms invisible → fallback → never swap (network-friendly)

FORMAT SUPPORT:
  woff2  — modern, compressed, use first
  woff   — fallback for older browsers
  ttf    — older fallback

FONT LOADING APIs:
  document.fonts.ready  — promise resolves when fonts loaded
  CSS Font Loading API  — fine-grained control

💻 CODE:
/* ─── BASIC @FONT-FACE ─── */
@font-face {
  font-family: 'MyFont';
  src: url('/fonts/myfont.woff2') format('woff2'),
       url('/fonts/myfont.woff')  format('woff');
  font-weight: normal;
  font-style:  normal;
  font-display: swap;
}

/* Multiple weights from one font family */
@font-face {
  font-family: 'MyFont';
  src: url('/fonts/myfont-bold.woff2') format('woff2');
  font-weight: bold;
  font-style: normal;
  font-display: swap;
}

@font-face {
  font-family: 'MyFont';
  src: url('/fonts/myfont-italic.woff2') format('woff2');
  font-weight: normal;
  font-style: italic;
  font-display: swap;
}

/* Use it */
body {
  font-family: 'MyFont', Georgia, serif;
}

/* ─── VARIABLE FONTS ─── */
/* A single font file with multiple axes */
@font-face {
  font-family: 'InterVariable';
  src: url('/fonts/Inter-Variable.woff2') format('woff2');
  font-weight: 100 900;     /* entire weight range */
  font-style: normal;
  font-display: swap;
}

/* Use font-variation-settings for precise control */
.display-text {
  font-family: 'InterVariable';
  font-weight: 750;           /* any value in 100-900 range */
  font-variation-settings:
    'wght' 750,               /* weight axis */
    'GRAD' 25,                /* grade axis */
    'opsz' 32;                /* optical size axis */
}

/* ─── GOOGLE FONTS ─── */
/* In HTML <head>: */
/* <link rel="preconnect" href="https://fonts.googleapis.com">
   <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
   <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700&display=swap" rel="stylesheet"> */

/* In CSS: */
body {
  font-family: 'Inter', sans-serif;
}

/* ─── SYSTEM FONT STACK (no loading needed) ─── */
body {
  font-family:
    -apple-system,          /* macOS/iOS SF Pro */
    BlinkMacSystemFont,     /* Chrome on macOS */
    'Segoe UI',             /* Windows */
    Roboto,                 /* Android */
    Helvetica,
    Arial,
    sans-serif;
}

/* ─── FONT-DISPLAY ─── */
/* For performance-critical pages */
@font-face {
  font-family: 'LandingFont';
  src: url('/fonts/landing.woff2') format('woff2');
  font-display: optional;
  /* If not loaded in 100ms, use fallback forever
     Best for Core Web Vitals / CLS score */
}

/* For brand consistency pages */
@font-face {
  font-family: 'BrandFont';
  src: url('/fonts/brand.woff2') format('woff2');
  font-display: block;
  /* Brief invisible text, then brand font
     Worse UX but ensures brand font always shows */
}

/* ─── FONT LOADING PERFORMANCE ─── */
/* Preload critical fonts in HTML */
/* <link rel="preload" href="/fonts/inter.woff2" as="font" type="font/woff2" crossorigin> */

/* Size-adjust for fallback matching (reduces CLS) */
@font-face {
  font-family: 'InterFallback';
  src: local('Arial');
  size-adjust: 94%;           /* adjust fallback to match custom font metrics */
  ascent-override: 90%;
  descent-override: 22%;
  line-gap-override: 0%;
}

body {
  font-family: 'Inter', 'InterFallback', sans-serif;
}

/* ─── UNICODE RANGE (subsetting) ─── */
@font-face {
  font-family: 'MyFont';
  src: url('/fonts/myfont-latin.woff2') format('woff2');
  unicode-range: U+0000-00FF;  /* Only load for latin characters */
}

@font-face {
  font-family: 'MyFont';
  src: url('/fonts/myfont-cyrillic.woff2') format('woff2');
  unicode-range: U+0400-04FF;  /* Only load if cyrillic characters present */
}

/* ─── CSS FONT PROPERTIES ─── */
.text {
  font-family: 'Inter', sans-serif;
  font-size: 1rem;
  font-weight: 400;
  font-style: normal;
  font-variant: normal;
  font-stretch: normal;
  line-height: 1.5;

  /* Shorthand */
  font: 400 1rem/1.5 'Inter', sans-serif;
}

/* OpenType features */
.fancy {
  font-feature-settings: 'liga' 1, 'kern' 1, 'ss01' 1;
  font-variant-ligatures: common-ligatures;
  font-variant-numeric: oldstyle-nums proportional-nums;
}

📝 KEY POINTS:
✅ Always include woff2 first — it's the most compressed modern format
✅ font-display: swap is the most common choice — shows text immediately
✅ Preload critical fonts with <link rel="preload"> in HTML for faster loading
✅ Variable fonts pack multiple weights/styles in one file — huge bandwidth saving
✅ Use size-adjust and metric overrides to minimize CLS (Cumulative Layout Shift)
✅ unicode-range enables per-script subsetting — only loads what the page uses
❌ Don't load more font weights than you actually use — each is a network request
❌ Don't use font-display: block on body text — invisible text hurts UX
''',
  quiz: [
    Quiz(question: 'What does font-display: swap do?', options: [
      QuizOption(text: 'Shows fallback text immediately, then swaps to custom font when loaded', correct: true),
      QuizOption(text: 'Hides text until the custom font is loaded', correct: false),
      QuizOption(text: 'Swaps between two custom fonts alternately', correct: false),
      QuizOption(text: 'Uses the system font and never loads the custom font', correct: false),
    ]),
    Quiz(question: 'What is a variable font?', options: [
      QuizOption(text: 'A single font file that contains a continuous range of weights, widths, or other axes', correct: true),
      QuizOption(text: 'A font that changes size based on the viewport', correct: false),
      QuizOption(text: 'A font with multiple color variants', correct: false),
      QuizOption(text: 'A font loaded from a CSS variable', correct: false),
    ]),
    Quiz(question: 'What does unicode-range in @font-face do?', options: [
      QuizOption(text: 'Only loads the font file when the page contains characters in that range', correct: true),
      QuizOption(text: 'Limits which characters the font can display', correct: false),
      QuizOption(text: 'Sets the character encoding for the font file', correct: false),
      QuizOption(text: 'Defines the font\'s glyph count', correct: false),
    ]),
  ],
);
