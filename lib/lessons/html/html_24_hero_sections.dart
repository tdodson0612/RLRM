// lib/lessons/html/html_24_hero_sections.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final htmlLesson24 = Lesson(
  language: 'HTML',
  title: 'HTML + CSS: Hero Sections and Landing Pages',
  content: '''
🎯 METAPHOR:
The hero section is the movie poster of your website.
It has three seconds to make someone stay or leave.
It needs to communicate: what this is, why it matters,
and what to do next — all before the user even scrolls.
A great hero is not just a pretty image with text on it.
It is a precisely engineered moment: the right words,
the right visual weight, the right call-to-action button
placed exactly where the eye naturally lands.
CSS gives you the full cinematographer's toolkit —
gradients for atmosphere, typography scale for impact,
animation for dynamism, and responsive layouts so the
poster looks perfect on a phone billboard and a cinema screen.

📖 EXPLANATION:
HERO SECTION ANATOMY:
  Eyebrow text   — small label above heading (optional)
  Headline       — biggest, boldest claim
  Subheadline    — supporting details
  CTA buttons    — primary + secondary action
  Visual element — image, illustration, or video

CSS TECHNIQUES:
  CSS Grid for text + image side by side
  clamp() for fluid responsive typography
  Gradient overlay for text readability on images
  @keyframes for entrance animations
  CSS clip-path for diagonal section dividers
  mix-blend-mode for text-over-image effects

PERFORMANCE:
  Hero image: fetchpriority="high", explicit dimensions
  LCP: largest element, must load fast
  Preload hero image in <head>
  Use <picture> for responsive hero images

💻 CODE:
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>BeanCo — Coffee That Changes Everything</title>

  <!-- Preload hero image for fast LCP -->
  <link rel="preload" href="/images/hero-beans.jpg" as="image" fetchpriority="high">

  <style>
    :root {
      --brand:      #6c63ff;
      --brand-dark: #5a52d5;
      --accent:     #ff6b6b;
      --text-dark:  #1a1a2e;
      --text-light: #ffffff;
      --muted:      rgba(255,255,255,0.75);
    }

    *, *::before, *::after { box-sizing: border-box; margin: 0; }

    body { font-family: system-ui, sans-serif; overflow-x: hidden; }

    /* ─── FULL-SCREEN HERO (image background) ─── */
    .hero-full {
      min-height: 100svh; /* svh = small viewport height — mobile friendly */
      display: grid;
      place-items: center;
      position: relative;
      overflow: hidden;
    }

    .hero-full__bg {
      position: absolute;
      inset: 0;
      object-fit: cover;
      width: 100%;
      height: 100%;
      z-index: 0;
    }

    /* Gradient overlay for text readability */
    .hero-full::after {
      content: "";
      position: absolute;
      inset: 0;
      background: linear-gradient(
        135deg,
        rgba(26,26,46,0.85) 0%,
        rgba(108,99,255,0.4) 100%
      );
      z-index: 1;
    }

    .hero-full__content {
      position: relative;
      z-index: 2;
      max-width: 800px;
      margin: 0 auto;
      padding: 2rem;
      text-align: center;
      color: var(--text-light);
    }

    /* ─── TYPOGRAPHY ─── */
    .eyebrow {
      display: inline-flex;
      align-items: center;
      gap: 0.5rem;
      font-size: 0.8rem;
      font-weight: 700;
      text-transform: uppercase;
      letter-spacing: 0.15em;
      color: #a78bfa;
      margin-bottom: 1.25rem;
      animation: fadeUp 0.6s ease both;
    }

    .hero-title {
      font-size: clamp(2.5rem, 7vw, 5rem);
      font-weight: 900;
      line-height: 1.05;
      letter-spacing: -0.02em;
      margin-bottom: 1.25rem;
      animation: fadeUp 0.6s 0.1s ease both;
    }

    .hero-title span {
      background: linear-gradient(90deg, #a78bfa, #f472b6);
      -webkit-background-clip: text;
      background-clip: text;
      -webkit-text-fill-color: transparent;
    }

    .hero-desc {
      font-size: clamp(1rem, 2.5vw, 1.2rem);
      color: var(--muted);
      max-width: 560px;
      margin: 0 auto 2rem;
      line-height: 1.7;
      animation: fadeUp 0.6s 0.2s ease both;
    }

    /* ─── CTA BUTTONS ─── */
    .hero-buttons {
      display: flex;
      gap: 1rem;
      justify-content: center;
      flex-wrap: wrap;
      animation: fadeUp 0.6s 0.3s ease both;
    }

    .btn {
      display: inline-flex;
      align-items: center;
      gap: 0.5rem;
      padding: 0.875rem 2rem;
      border-radius: 999px;
      font-size: 1rem;
      font-weight: 700;
      text-decoration: none;
      transition: transform 0.2s, box-shadow 0.2s;
      cursor: pointer;
      border: none;
      font-family: inherit;
    }

    .btn:hover    { transform: translateY(-2px); }
    .btn:active   { transform: translateY(0); }
    .btn:focus-visible { outline: 3px solid white; outline-offset: 4px; }

    .btn--primary {
      background: var(--brand);
      color: white;
      box-shadow: 0 8px 20px rgba(108,99,255,0.5);
    }
    .btn--primary:hover { box-shadow: 0 12px 28px rgba(108,99,255,0.6); }

    .btn--ghost {
      background: rgba(255,255,255,0.1);
      color: white;
      border: 1.5px solid rgba(255,255,255,0.3);
      backdrop-filter: blur(8px);
    }
    .btn--ghost:hover { background: rgba(255,255,255,0.2); }

    /* ─── SCROLL INDICATOR ─── */
    .scroll-hint {
      position: absolute;
      bottom: 2rem;
      left: 50%;
      transform: translateX(-50%);
      z-index: 2;
      color: rgba(255,255,255,0.5);
      font-size: 0.8rem;
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 0.5rem;
      animation: bounce 2s infinite;
    }

    /* ─── SPLIT HERO (text left, image right) ─── */
    .hero-split {
      display: grid;
      grid-template-columns: 1fr 1fr;
      min-height: 85vh;
      overflow: hidden;
    }

    .hero-split__text {
      display: flex;
      flex-direction: column;
      justify-content: center;
      padding: clamp(2rem, 8vw, 6rem);
      background: var(--text-dark);
      color: white;
    }

    .hero-split__image {
      overflow: hidden;
    }

    .hero-split__image img {
      width: 100%;
      height: 100%;
      object-fit: cover;
      transition: transform 8s ease;
    }

    .hero-split:hover .hero-split__image img {
      transform: scale(1.05);
    }

    @media (max-width: 768px) {
      .hero-split {
        grid-template-columns: 1fr;
      }
      .hero-split__image { min-height: 300px; }
    }

    /* ─── ANIMATIONS ─── */
    @keyframes fadeUp {
      from { opacity: 0; transform: translateY(24px); }
      to   { opacity: 1; transform: translateY(0); }
    }

    @keyframes bounce {
      0%, 100% { transform: translateX(-50%) translateY(0); }
      50%       { transform: translateX(-50%) translateY(-8px); }
    }

    /* Respect reduced motion */
    @media (prefers-reduced-motion: reduce) {
      *, *::before, *::after {
        animation: none !important;
        transition-duration: 0.01ms !important;
      }
    }
  </style>
</head>
<body>

  <!-- FULL-SCREEN HERO -->
  <section class="hero-full" aria-labelledby="hero-heading">
    <img
      class="hero-full__bg"
      src="/images/hero-beans.jpg"
      alt=""
      aria-hidden="true"
      width="1920" height="1080"
      fetchpriority="high"
    >

    <div class="hero-full__content">
      <p class="eyebrow">☕ Single Origin · Direct Trade</p>

      <h1 class="hero-title" id="hero-heading">
        Coffee That<br>
        <span>Changes Everything</span>
      </h1>

      <p class="hero-desc">
        From the highlands of Ethiopia to your morning cup.
        Ethically sourced, expertly roasted, delivered fresh.
      </p>

      <div class="hero-buttons">
        <a href="/shop" class="btn btn--primary">
          Shop Now ✨
        </a>
        <a href="/our-story" class="btn btn--ghost">
          Our Story →
        </a>
      </div>
    </div>

    <div class="scroll-hint" aria-hidden="true">
      <span>Scroll</span>
      <span>↓</span>
    </div>
  </section>

  <!-- SPLIT HERO -->
  <section class="hero-split" aria-labelledby="split-heading">
    <div class="hero-split__text">
      <p class="eyebrow" style="color:#a78bfa">🌍 Origin Story</p>
      <h2 id="split-heading" style="font-size:clamp(1.75rem,4vw,3rem);font-weight:900;line-height:1.1;margin:0.75rem 0 1rem">
        From Farm to Cup in 48 Hours
      </h2>
      <p style="color:rgba(255,255,255,0.7);line-height:1.7;margin-bottom:2rem;font-size:1.05rem">
        We work directly with 23 farming families across
        Ethiopia, Colombia, and Guatemala. Every bag is
        roasted to order and ships the same day.
      </p>
      <a href="/our-farms" class="btn btn--primary" style="align-self:flex-start">
        Meet Our Farmers →
      </a>
    </div>
    <div class="hero-split__image">
      <img
        src="/images/farmer.jpg"
        alt="Coffee farmer in Ethiopia inspecting ripe coffee cherries"
        width="800" height="600"
        loading="lazy"
      >
    </div>
  </section>

</body>
</html>

📝 KEY POINTS:
✅ Use 100svh (small viewport height) for full-screen heroes — avoids mobile browser chrome issues
✅ Gradient overlay on hero image ensures text is readable regardless of image content
✅ clamp() for fluid typography that scales between breakpoints seamlessly
✅ gradient text uses background-clip: text + -webkit-text-fill-color: transparent
✅ Stagger animation delays (0.1s, 0.2s, 0.3s) create elegant sequential entrance
✅ Always respect prefers-reduced-motion — disable or minimize animations
❌ Don't put important text information in the background image alt — use real text
❌ aria-hidden="true" on background images is correct — they are decorative
''',
  quiz: [
    Quiz(question: 'Why use 100svh instead of 100vh for hero sections?', options: [
      QuizOption(text: 'svh accounts for mobile browser UI — 100vh can cause overflow on mobile with address bars', correct: true),
      QuizOption(text: 'svh is faster to render than vh', correct: false),
      QuizOption(text: 'vh is deprecated in modern CSS', correct: false),
      QuizOption(text: 'svh works in older browsers that don\'t support vh', correct: false),
    ]),
    Quiz(question: 'How do you create gradient text in CSS?', options: [
      QuizOption(text: 'background: gradient + background-clip: text + -webkit-text-fill-color: transparent', correct: true),
      QuizOption(text: 'color: linear-gradient()', correct: false),
      QuizOption(text: 'text-fill: gradient()', correct: false),
      QuizOption(text: 'font-color: linear-gradient()', correct: false),
    ]),
    Quiz(question: 'Why should the hero background image have alt="" and aria-hidden="true"?', options: [
      QuizOption(text: 'It is purely decorative — the real text content is in HTML elements, not the image', correct: true),
      QuizOption(text: 'Background images never need alt text', correct: false),
      QuizOption(text: 'aria-hidden prevents the image from being lazy loaded', correct: false),
      QuizOption(text: 'It is required for the gradient overlay to work', correct: false),
    ]),
  ],
);
