// lib/lessons/html/html_20_performance_best_practices.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final htmlLesson20 = Lesson(
  language: 'HTML',
  title: 'HTML Performance and Best Practices',
  content: '''
🎯 METAPHOR:
A slow website is like a restaurant with magnificent food
but a 45-minute wait to be seated. The food might be
extraordinary but most people will leave. Google has the
data: 53% of mobile users abandon sites that take more
than 3 seconds to load. Performance IS user experience.
HTML has a massive role in performance — how you load
scripts, images, fonts, and stylesheets can be the
difference between a 1-second page and a 6-second page
with identical visual results. The skeleton's posture
(HTML structure) determines how fast the body (page)
can stand up and be ready.

📖 EXPLANATION:
CORE WEB VITALS:
  LCP (Largest Contentful Paint)
    — time until main content is visible
    — target: < 2.5 seconds

  INP (Interaction to Next Paint)
    — responsiveness to user input
    — target: < 200 milliseconds

  CLS (Cumulative Layout Shift)
    — visual stability (no jumping content)
    — target: < 0.1

HTML PERFORMANCE TECHNIQUES:
  1. Script loading:    defer and async attributes
  2. Resource hints:    preload, preconnect, prefetch
  3. Image optimization: lazy loading, width/height, srcset
  4. Font performance:  font-display, preload, subsetting
  5. Critical CSS:      inline above-fold styles
  6. Avoiding layout shift: width/height on images/media
  7. Priority hints:    fetchpriority="high" on LCP image

HTML BEST PRACTICES:
  ✅ Valid, well-formed HTML
  ✅ Semantic elements
  ✅ Accessible markup
  ✅ Minimal DOM size (<1500 nodes)
  ✅ No deprecated elements or attributes

DEPRECATED ELEMENTS (avoid):
  <font>, <center>, <strike>, <big>, <s>, <u> (mostly)
  <frame>, <frameset>, <noframe>
  <marquee>, <blink>
  <basefont>, <dir>

💻 CODE:
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <!-- charset must be first! -->

  <meta name="viewport" content="width=device-width, initial-scale=1.0">

  <title>BeanCo Coffee — Ethically Sourced, Expertly Roasted</title>

  <!-- ─── CRITICAL CSS (inline for zero render-blocking) ─── -->
  <!-- Only put above-fold styles here — rest in external file -->
  <style>
    *,*::before,*::after{box-sizing:border-box}
    body{margin:0;font-family:system-ui,sans-serif}
    header{background:#1a1a2e;color:#fff;padding:1rem}
    .hero{min-height:60vh;display:flex;align-items:center}
  </style>

  <!-- ─── PRECONNECT TO CRITICAL ORIGINS ─── -->
  <!-- Do this for Google Fonts, CDNs, API servers -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

  <!-- ─── PRELOAD CRITICAL RESOURCES ─── -->
  <!-- Hero image — LCP element — load ASAP -->
  <link
    rel="preload"
    href="/images/hero.jpg"
    as="image"
    fetchpriority="high"
  >

  <!-- Critical font — prevents FOIT (Flash of Invisible Text) -->
  <link
    rel="preload"
    href="/fonts/inter-variable.woff2"
    as="font"
    type="font/woff2"
    crossorigin
  >

  <!-- ─── NON-CRITICAL CSS (loaded asynchronously) ─── -->
  <!-- The media="print" trick: loads async, then applies -->
  <link
    rel="stylesheet"
    href="/styles/non-critical.css"
    media="print"
    onload="this.media='all'"
  >
  <noscript>
    <link rel="stylesheet" href="/styles/non-critical.css">
  </noscript>

  <!-- Main stylesheet (critical — loads synchronously) -->
  <link rel="stylesheet" href="/styles/main.css">

  <!-- ─── PREFETCH FOR NEXT PAGE ─── -->
  <link rel="prefetch" href="/shop" as="document">

  <!-- ─── FAVICON ─── -->
  <link rel="icon" href="/favicon.svg" type="image/svg+xml">

  <!-- ─── SCRIPTS: DEFER (recommended for most scripts) ─── -->
  <!-- defer: load in background, run after DOM ready -->
  <script defer src="/scripts/main.js"></script>

  <!-- async: load in background, run immediately (for analytics) -->
  <script async src="https://analytics.example.com/track.js"></script>

  <!-- Module scripts are deferred by default -->
  <script type="module" src="/scripts/app.js"></script>
</head>
<body>

  <!-- ─── HERO IMAGE: CLS PREVENTION ─── -->
  <!-- width + height prevent layout shift -->
  <!-- fetchpriority="high" for LCP -->
  <div class="hero">
    <img
      src="/images/hero.jpg"
      alt="Freshly roasted coffee beans poured into a burlap sack"
      width="1920"
      height="1080"
      fetchpriority="high"
      decoding="async"
    >
  </div>

  <!-- ─── BELOW-FOLD IMAGES: LAZY LOADING ─── -->
  <section class="products">
    <img
      src="/images/product-1.jpg"
      alt="Ethiopian Light Roast Coffee bag"
      width="400"
      height="400"
      loading="lazy"
      decoding="async"
    >
    <img
      src="/images/product-2.jpg"
      alt="Colombian Medium Roast Coffee bag"
      width="400"
      height="400"
      loading="lazy"
      decoding="async"
    >
  </section>

  <!-- ─── VIDEO: LAZY AND NO AUTOPLAY AUDIO ─── -->
  <video
    width="800"
    height="450"
    controls
    preload="none"
    poster="/images/video-thumb.jpg"
  >
    <source src="/videos/roasting.mp4" type="video/mp4">
  </video>

  <!-- ─── RESPONSIVE IMAGES ─── -->
  <picture>
    <source
      type="image/avif"
      srcset="/images/coffee-400.avif 400w, /images/coffee-800.avif 800w"
      sizes="(max-width: 600px) 100vw, 50vw"
    >
    <source
      type="image/webp"
      srcset="/images/coffee-400.webp 400w, /images/coffee-800.webp 800w"
      sizes="(max-width: 600px) 100vw, 50vw"
    >
    <img
      src="/images/coffee-800.jpg"
      alt="Barista pouring latte art"
      width="800"
      height="533"
      loading="lazy"
    >
  </picture>

</body>
</html>

─────────────────────────────────────
HTML PERFORMANCE CHECKLIST:
─────────────────────────────────────
□ charset is first meta tag
□ viewport meta tag present
□ Scripts use defer or async
□ Images have width + height attributes
□ Hero/LCP image has fetchpriority="high"
□ Below-fold images have loading="lazy"
□ Critical CSS is inline in <style>
□ Font preloaded with crossorigin
□ Preconnect to critical third-party origins
□ NO inline styles on individual elements
□ NO deprecated elements (font, center, marquee)
□ HTML validates at validator.w3.org
─────────────────────────────────────

📝 KEY POINTS:
✅ defer on scripts is almost always the right choice — non-blocking
✅ Always set width and height on images — prevents CLS (layout shift)
✅ fetchpriority="high" on the LCP image improves Core Web Vitals
✅ loading="lazy" on below-fold images reduces initial page load
✅ preconnect warms up connections to external origins
✅ Inline critical CSS eliminates render-blocking stylesheet request
❌ Never put scripts without defer/async before </body> or in <head>
❌ Missing image dimensions are the most common cause of poor CLS scores
''',
  quiz: [
    Quiz(question: 'What does the defer attribute on a script tag do?', options: [
      QuizOption(text: 'Downloads in the background and executes after the HTML is fully parsed — non-blocking', correct: true),
      QuizOption(text: 'Delays the script execution by 1 second', correct: false),
      QuizOption(text: 'Loads the script only if the user scrolls down', correct: false),
      QuizOption(text: 'Executes the script before any CSS loads', correct: false),
    ]),
    Quiz(question: 'What HTML change has the biggest impact on preventing Cumulative Layout Shift (CLS)?', options: [
      QuizOption(text: 'Adding width and height attributes to all images and media elements', correct: true),
      QuizOption(text: 'Adding loading="lazy" to images', correct: false),
      QuizOption(text: 'Using defer on all scripts', correct: false),
      QuizOption(text: 'Inlining all CSS', correct: false),
    ]),
    Quiz(question: 'What does fetchpriority="high" on the hero image tell the browser?', options: [
      QuizOption(text: 'Download this image at the highest priority — it is the Largest Contentful Paint element', correct: true),
      QuizOption(text: 'Display this image before all other content', correct: false),
      QuizOption(text: 'Cache this image permanently', correct: false),
      QuizOption(text: 'Skip lazy loading and load immediately', correct: false),
    ]),
  ],
);
