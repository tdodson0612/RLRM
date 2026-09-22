// lib/lessons/html/html_25_typography_styling.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final htmlLesson25 = Lesson(
  language: 'HTML',
  title: 'HTML + CSS: Typography and Text Styling',
  content: '''
🎯 METAPHOR:
Typography is the voice of your content. Two identical
articles — same words, same HTML — can feel like a
mumbled lecture or a TED Talk depending purely on the
typography. Font choice is the accent. Font size is the
volume. Line height is the breathing room between sentences.
Letter spacing is the enunciation. The measure (line length)
is the pacing. A skilled typographer uses all of these
like a conductor uses an orchestra — each element tuned
so the words land with precision, clarity, and emotion.
Bad typography is invisible. Good typography is invisible.
But the difference is felt on every line.

📖 EXPLANATION:
TYPOGRAPHY PROPERTIES:
  font-family      — typeface stack
  font-size        — with clamp() for fluid scaling
  font-weight      — 100-900 (variable fonts: any value)
  line-height      — unitless (e.g., 1.6) is best practice
  letter-spacing   — tracking (em units)
  word-spacing     — space between words
  text-transform   — uppercase, lowercase, capitalize
  font-variant     — smallcaps, ligatures, numerics
  font-feature-settings — OpenType feature codes
  text-wrap: balance   — smart heading line breaks
  text-wrap: pretty    — avoid orphans in paragraphs
  hyphens: auto        — automatic hyphenation
  hanging-punctuation  — pull quotes/bullets into margin
  first-line, first-letter — drop caps, lead paragraphs
  color            — text color
  text-shadow      — shadow effects
  text-decoration  — underline styling

THE MODULAR SCALE:
  Type scales use ratios (1.25, 1.333, 1.5) to
  generate harmonious size steps.
  Use clamp() to make every step fluid.

💻 CODE:
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Typography Demo — The Coffee Times</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;900&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
  <style>
    /* ─── TYPE SCALE (modular, fluid) ─── */
    :root {
      /* ratio: 1.25 (Major Third) */
      --text-xs:   clamp(0.75rem,  1.5vw, 0.8rem);
      --text-sm:   clamp(0.875rem, 2vw,   0.9rem);
      --text-base: clamp(1rem,     2.5vw, 1.1rem);
      --text-md:   clamp(1.125rem, 3vw,   1.25rem);
      --text-lg:   clamp(1.25rem,  3.5vw, 1.5rem);
      --text-xl:   clamp(1.5rem,   4vw,   2rem);
      --text-2xl:  clamp(1.875rem, 5vw,   2.5rem);
      --text-3xl:  clamp(2.25rem,  6vw,   3.5rem);
      --text-4xl:  clamp(2.75rem,  8vw,   5rem);

      --font-sans:  'Inter', system-ui, sans-serif;
      --font-serif: 'Playfair Display', Georgia, serif;

      --line-height-tight:  1.2;
      --line-height-snug:   1.4;
      --line-height-normal: 1.6;
      --line-height-loose:  1.8;

      --measure: 65ch;  /* optimal line length */
    }

    *, *::before, *::after { box-sizing: border-box; margin: 0; }

    body {
      font-family: var(--font-sans);
      font-size: var(--text-base);
      line-height: var(--line-height-normal);
      color: #1a1a2e;
      background: #fafafa;
    }

    .article {
      max-width: var(--measure);
      margin: 0 auto;
      padding: clamp(1.5rem, 5vw, 4rem) 1.5rem;
    }

    /* ─── ARTICLE HEADER ─── */
    .article__category {
      font-size: var(--text-xs);
      font-weight: 700;
      text-transform: uppercase;
      letter-spacing: 0.15em;
      color: #6c63ff;
      display: block;
      margin-bottom: 1rem;
    }

    .article__title {
      font-family: var(--font-serif);
      font-size: var(--text-4xl);
      font-weight: 900;
      line-height: var(--line-height-tight);
      letter-spacing: -0.02em;
      color: #1a1a2e;
      margin-bottom: 1rem;

      /* Smart line breaking */
      text-wrap: balance;
    }

    .article__subtitle {
      font-size: var(--text-md);
      font-weight: 400;
      color: #6b7280;
      line-height: var(--line-height-normal);
      margin-bottom: 2rem;
      text-wrap: pretty;
    }

    /* ─── BYLINE ─── */
    .byline {
      display: flex;
      align-items: center;
      gap: 0.75rem;
      font-size: var(--text-sm);
      color: #6b7280;
      padding-bottom: 2rem;
      border-bottom: 1px solid #e5e7eb;
      margin-bottom: 2.5rem;
    }

    .byline__avatar {
      width: 40px;
      height: 40px;
      border-radius: 50%;
      object-fit: cover;
    }

    .byline__author { font-weight: 600; color: #1a1a2e; }

    /* ─── BODY TEXT ─── */
    .article__body p {
      margin-bottom: 1.5em;
      max-width: var(--measure);
      hyphens: auto;
      text-wrap: pretty;
    }

    /* Drop cap on first paragraph */
    .article__body > p:first-of-type::first-letter {
      font-family: var(--font-serif);
      font-size: 4.5em;
      font-weight: 900;
      float: left;
      line-height: 0.75;
      margin: 0.12em 0.08em 0 0;
      color: #6c63ff;
    }

    /* ─── HEADINGS ─── */
    .article__body h2 {
      font-family: var(--font-serif);
      font-size: var(--text-2xl);
      font-weight: 700;
      line-height: var(--line-height-tight);
      margin: 2.5rem 0 1rem;
      text-wrap: balance;
    }

    .article__body h3 {
      font-size: var(--text-lg);
      font-weight: 600;
      margin: 2rem 0 0.75rem;
    }

    /* ─── PULL QUOTE ─── */
    .pull-quote {
      font-family: var(--font-serif);
      font-size: var(--text-xl);
      font-weight: 700;
      font-style: italic;
      line-height: var(--line-height-snug);
      color: #6c63ff;
      border-left: 4px solid #6c63ff;
      padding: 1rem 0 1rem 1.5rem;
      margin: 2.5rem 0;
    }

    /* ─── LEAD PARAGRAPH ─── */
    .lead {
      font-size: var(--text-md);
      font-weight: 500;
      line-height: var(--line-height-loose);
      color: #374151;
    }

    /* ─── INLINE CODE ─── */
    code {
      font-family: 'Courier New', monospace;
      font-size: 0.875em;
      background: #f0f0f8;
      color: #6c63ff;
      padding: 0.1em 0.4em;
      border-radius: 4px;
    }

    /* ─── LINK STYLING ─── */
    .article__body a {
      color: #6c63ff;
      text-decoration: underline;
      text-decoration-color: rgba(108,99,255,0.4);
      text-underline-offset: 3px;
      transition: text-decoration-color 0.2s;
    }

    .article__body a:hover {
      text-decoration-color: #6c63ff;
    }

    /* ─── MARK / HIGHLIGHT ─── */
    mark {
      background: linear-gradient(120deg, rgba(108,99,255,0.15), rgba(244,114,182,0.15));
      color: inherit;
      padding: 0.05em 0.15em;
      border-radius: 3px;
    }

    /* ─── SMALL CAPS / NUMERICS ─── */
    .all-caps {
      font-variant: small-caps;
      letter-spacing: 0.05em;
    }

    .tabular-nums {
      font-variant-numeric: tabular-nums;
      font-feature-settings: 'tnum';
    }
  </style>
</head>
<body>
<article class="article">

  <span class="article__category">☕ Brewing Science</span>

  <h1 class="article__title">
    The Chemistry of the Perfect Cup of Coffee
  </h1>

  <p class="article__subtitle">
    Why does a \$4 gas station coffee taste nothing like
    a \$14 specialty brew? The answer is pure chemistry —
    and it is more fascinating than you might expect.
  </p>

  <div class="byline">
    <img
      class="byline__avatar"
      src="/images/alice.jpg"
      alt="Alice Chen"
      width="40" height="40"
    >
    <div>
      <span class="byline__author">Alice Chen</span>
      <br>
      <time datetime="2024-03-15">March 15, 2024</time>
      · 8 min read
    </div>
  </div>

  <div class="article__body">

    <p class="lead">
      Coffee is one of the most chemically complex beverages
      on earth. A single cup contains over <mark>1,000 distinct
      chemical compounds</mark> — more than wine, beer, or tea.
    </p>

    <p>
      When hot water hits ground coffee, it begins a race against
      time. Solubles — acids, sugars, caffeine — dissolve quickly.
      Others — bitter chlorogenic acids, harsh phenols — take longer.
      The difference between a sublime cup and a bitter disappointment
      is how many of each group you extract.
    </p>

    <blockquote class="pull-quote">
      "Extraction is everything. Hit the sweet spot and you get
      complexity, balance, and sweetness. Miss it and you get
      either sourness or bitterness."
    </blockquote>

    <h2>The Golden Ratio</h2>

    <p>
      Professional baristas work with a "golden ratio" of
      approximately <strong>1:15 to 1:17</strong> — one gram of coffee
      to 15–17 grams of water. This is not arbitrary.
      The code <code>ratio = grounds / water</code> directly predicts
      extraction yield percentage.
    </p>

  </div>
</article>
</body>
</html>

📝 KEY POINTS:
✅ Use a modular type scale with clamp() for fluid, responsive typography
✅ line-height should be unitless (1.6 not 1.6rem) — scales with font size
✅ text-wrap: balance for headings prevents awkward single-word last lines
✅ max-width: 65ch on body text ensures optimal reading line length
✅ Drop cap with ::first-letter adds editorial sophistication
✅ text-decoration-color and text-underline-offset make beautiful link underlines
❌ Never use text-transform: uppercase on long body text — kills readability
❌ Don't set line-height on headings the same as body — use tighter values
''',
  quiz: [
    Quiz(question: 'Why is it better to set line-height as a unitless number (1.6) rather than pixels (24px)?', options: [
      QuizOption(text: 'Unitless line-height scales proportionally with font size — fixed px breaks when font size changes', correct: true),
      QuizOption(text: 'Pixels are not supported for line-height', correct: false),
      QuizOption(text: 'Unitless values are faster to compute', correct: false),
      QuizOption(text: 'Pixel line-height affects the element\'s margin', correct: false),
    ]),
    Quiz(question: 'What does text-wrap: balance do for headings?', options: [
      QuizOption(text: 'Distributes text evenly across lines — prevents single orphan words on the last line', correct: true),
      QuizOption(text: 'Centers the heading text horizontally', correct: false),
      QuizOption(text: 'Balances the heading font weight across breakpoints', correct: false),
      QuizOption(text: 'Makes the heading the same size on all devices', correct: false),
    ]),
    Quiz(question: 'What does max-width: 65ch on body text accomplish?', options: [
      QuizOption(text: 'Limits the line length to about 65 characters — the optimal reading measure for most fonts', correct: true),
      QuizOption(text: 'Sets the text to exactly 65 characters per line', correct: false),
      QuizOption(text: 'Limits font size to 65px maximum', correct: false),
      QuizOption(text: 'Applies to the character count of the entire element', correct: false),
    ]),
  ],
);
