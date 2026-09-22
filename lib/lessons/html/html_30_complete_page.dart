// lib/lessons/html/html_30_complete_page.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final htmlLesson30 = Lesson(
  language: 'HTML',
  title: 'HTML + CSS: Building a Complete Landing Page',
  content: '''
🎯 METAPHOR:
A landing page is a one-shot conversation with a stranger.
You have 8 seconds. They will either stay or leave forever.
The hero captures attention ("this is for you").
The social proof calms skepticism ("others trust this").
The features section explains the value ("here's why").
The CTA closes the deal ("do this now").
Every section serves a purpose. Every word earns its place.
The HTML is the script. The CSS is the performance.
When both are done perfectly, the audience never notices
either — they only feel the result: confidence, desire,
and the urge to click.

📖 EXPLANATION:
LANDING PAGE SECTIONS:
  1. <header>  Sticky navigation
  2. Hero      Main headline + CTA (above the fold)
  3. Logos     Social proof / as-seen-in
  4. Features  What makes it special
  5. How it works  Process steps
  6. Testimonials  Social proof quotes
  7. Pricing   Plans and CTAs
  8. FAQ       Overcome objections
  9. Final CTA Last chance to convert
  10. <footer> Links and legal

CSS PATTERNS USED:
  CSS Grid for all layouts
  clamp() for fluid typography
  CSS custom properties for theming
  Smooth scroll for anchor links
  Intersection Observer (CSS version via view())
  Dark/light mode support

💻 CODE:
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>BeanCo — Exceptional Coffee, Delivered Fresh ☕</title>

  <!-- SEO -->
  <meta name="description" content="Single-origin coffee sourced directly from farmers, roasted to order, and delivered to your door in 24 hours.">
  <meta property="og:title" content="BeanCo — Exceptional Coffee, Delivered Fresh">
  <meta property="og:description" content="Single-origin coffee sourced directly from farmers.">
  <meta property="og:image" content="https://beancocoffee.com/og.jpg">

  <!-- Preload hero font -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">

  <style>
    /* ─── DESIGN SYSTEM ─── */
    :root {
      --brand:       #6c63ff;
      --brand-dark:  #5a52d5;
      --accent:      #f472b6;
      --dark:        #0f0f1a;
      --surface:     #1a1a2e;
      --surface-2:   #252540;
      --text:        #f0f0ff;
      --muted:       rgba(240,240,255,0.6);
      --border:      rgba(240,240,255,0.1);
      --glow:        0 0 40px rgba(108,99,255,0.3);
    }

    *, *::before, *::after { box-sizing: border-box; margin: 0; }
    html { scroll-behavior: smooth; }

    body {
      font-family: 'Inter', system-ui, sans-serif;
      background: var(--dark);
      color: var(--text);
      overflow-x: hidden;
    }

    /* ─── SKIP LINK ─── */
    .skip-link {
      position: absolute;
      top: -100%;
      left: 1rem;
      background: var(--brand);
      color: white;
      padding: 0.5rem 1rem;
      text-decoration: none;
      font-weight: 700;
      border-radius: 0 0 8px 8px;
      z-index: 999;
    }
    .skip-link:focus { top: 0; }

    /* ─── NAV ─── */
    .nav {
      position: sticky;
      top: 0;
      z-index: 100;
      background: rgba(15,15,26,0.85);
      backdrop-filter: blur(16px);
      border-bottom: 1px solid var(--border);
    }

    .nav-inner {
      max-width: 1200px;
      margin: 0 auto;
      padding: 0 1.5rem;
      height: 64px;
      display: flex;
      align-items: center;
      justify-content: space-between;
    }

    .nav-logo {
      font-size: 1.25rem;
      font-weight: 900;
      color: white;
      text-decoration: none;
      letter-spacing: -0.02em;
    }

    .nav-links {
      display: flex;
      gap: 0.25rem;
      list-style: none;
    }

    .nav-links a {
      color: var(--muted);
      text-decoration: none;
      padding: 0.5rem 0.875rem;
      border-radius: 8px;
      font-size: 0.9rem;
      font-weight: 500;
      transition: color 0.15s, background 0.15s;
    }

    .nav-links a:hover { color: white; background: rgba(255,255,255,0.07); }

    .nav-cta {
      background: var(--brand);
      color: white !important;
      padding: 0.5rem 1.25rem;
      border-radius: 999px;
      font-weight: 700 !important;
    }
    .nav-cta:hover { background: var(--brand-dark) !important; }

    /* ─── SHARED ─── */
    .container {
      max-width: 1200px;
      margin: 0 auto;
      padding: 0 1.5rem;
    }

    section { padding: clamp(4rem, 8vw, 8rem) 1.5rem; }

    .eyebrow {
      display: inline-block;
      font-size: 0.75rem;
      font-weight: 700;
      text-transform: uppercase;
      letter-spacing: 0.12em;
      color: var(--brand);
      margin-bottom: 1rem;
    }

    .section-title {
      font-size: clamp(2rem, 5vw, 3.5rem);
      font-weight: 900;
      line-height: 1.1;
      letter-spacing: -0.02em;
      text-wrap: balance;
      margin-bottom: 1rem;
    }

    .section-desc {
      font-size: clamp(1rem, 2.5vw, 1.15rem);
      color: var(--muted);
      max-width: 560px;
      line-height: 1.7;
    }

    /* ─── HERO ─── */
    .hero {
      min-height: 100svh;
      display: flex;
      align-items: center;
      padding: 6rem 1.5rem;
      background:
        radial-gradient(ellipse 80% 60% at 50% 0%, rgba(108,99,255,0.25), transparent),
        var(--dark);
    }

    .hero-inner {
      max-width: 1200px;
      margin: 0 auto;
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 4rem;
      align-items: center;
    }

    .hero-tag {
      display: inline-flex;
      align-items: center;
      gap: 0.5rem;
      background: rgba(108,99,255,0.15);
      border: 1px solid rgba(108,99,255,0.3);
      color: #a78bfa;
      padding: 0.35rem 0.875rem;
      border-radius: 999px;
      font-size: 0.8rem;
      font-weight: 600;
      margin-bottom: 1.5rem;
    }

    .hero-title {
      font-size: clamp(2.5rem, 7vw, 5rem);
      font-weight: 900;
      line-height: 1.05;
      letter-spacing: -0.03em;
      margin-bottom: 1.25rem;
    }

    .hero-title .gradient-text {
      background: linear-gradient(135deg, #a78bfa, var(--accent));
      -webkit-background-clip: text;
      background-clip: text;
      -webkit-text-fill-color: transparent;
    }

    .hero-desc {
      font-size: 1.15rem;
      color: var(--muted);
      line-height: 1.7;
      margin-bottom: 2rem;
    }

    .hero-btns {
      display: flex;
      gap: 1rem;
      flex-wrap: wrap;
    }

    .btn {
      display: inline-flex;
      align-items: center;
      gap: 0.5rem;
      padding: 0.875rem 1.875rem;
      border-radius: 999px;
      font-size: 1rem;
      font-weight: 700;
      text-decoration: none;
      cursor: pointer;
      border: none;
      font-family: inherit;
      transition: transform 0.2s, box-shadow 0.2s, background 0.15s;
    }
    .btn:hover { transform: translateY(-2px); }
    .btn:active { transform: scale(0.97); }
    .btn:focus-visible { outline: 3px solid rgba(108,99,255,0.5); outline-offset: 4px; }

    .btn-primary {
      background: var(--brand);
      color: white;
      box-shadow: 0 8px 24px rgba(108,99,255,0.4);
    }
    .btn-primary:hover { box-shadow: 0 12px 32px rgba(108,99,255,0.55); background: var(--brand-dark); }

    .btn-ghost {
      background: rgba(255,255,255,0.08);
      color: white;
      border: 1px solid rgba(255,255,255,0.15);
    }
    .btn-ghost:hover { background: rgba(255,255,255,0.13); }

    .hero-img-wrap {
      position: relative;
      border-radius: 24px;
      overflow: hidden;
      aspect-ratio: 4/5;
    }

    .hero-img-wrap::before {
      content: "";
      position: absolute;
      inset: 0;
      background: linear-gradient(to top, var(--dark) 0%, transparent 50%);
      z-index: 1;
    }

    .hero-img {
      width: 100%;
      height: 100%;
      object-fit: cover;
    }

    /* ─── LOGO STRIP ─── */
    .logos-section {
      padding: 2rem 1.5rem;
      border-top: 1px solid var(--border);
      border-bottom: 1px solid var(--border);
    }

    .logos-inner {
      max-width: 1200px;
      margin: 0 auto;
      display: flex;
      align-items: center;
      gap: 3rem;
      flex-wrap: wrap;
      justify-content: center;
    }

    .logo-label {
      font-size: 0.75rem;
      text-transform: uppercase;
      letter-spacing: 0.1em;
      color: var(--muted);
      flex-shrink: 0;
    }

    .logo-img {
      opacity: 0.4;
      filter: brightness(10);
      height: 24px;
      transition: opacity 0.2s;
    }

    .logo-img:hover { opacity: 0.7; }

    /* ─── FEATURES ─── */
    .features-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
      gap: 1.5rem;
      margin-top: 3rem;
    }

    .feature-card {
      background: var(--surface);
      border: 1px solid var(--border);
      border-radius: 16px;
      padding: 2rem;
      transition: border-color 0.2s, box-shadow 0.2s;
    }

    .feature-card:hover {
      border-color: var(--brand);
      box-shadow: var(--glow);
    }

    .feature-icon {
      font-size: 2.5rem;
      margin-bottom: 1rem;
    }

    .feature-title {
      font-size: 1.15rem;
      font-weight: 700;
      margin-bottom: 0.5rem;
    }

    .feature-desc {
      color: var(--muted);
      font-size: 0.95rem;
      line-height: 1.6;
    }

    /* ─── TESTIMONIALS ─── */
    .testimonials-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
      gap: 1.5rem;
      margin-top: 3rem;
    }

    .testimonial {
      background: var(--surface);
      border: 1px solid var(--border);
      border-radius: 16px;
      padding: 1.75rem;
    }

    .testimonial__stars {
      color: #fbbf24;
      font-size: 1.1rem;
      margin-bottom: 1rem;
      letter-spacing: 0.1em;
    }

    .testimonial__text {
      color: var(--muted);
      line-height: 1.6;
      margin-bottom: 1.25rem;
      font-size: 0.95rem;
    }

    .testimonial__author {
      display: flex;
      align-items: center;
      gap: 0.75rem;
    }

    .testimonial__avatar {
      width: 40px;
      height: 40px;
      border-radius: 50%;
      object-fit: cover;
      background: var(--surface-2);
    }

    .testimonial__name { font-weight: 700; font-size: 0.9rem; }
    .testimonial__role { font-size: 0.8rem; color: var(--muted); }

    /* ─── FAQ ─── */
    .faq-list {
      max-width: 720px;
      margin: 3rem auto 0;
    }

    .faq-item {
      border-bottom: 1px solid var(--border);
    }

    .faq-item summary {
      padding: 1.25rem 0;
      cursor: pointer;
      font-weight: 600;
      list-style: none;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }

    .faq-item summary::-webkit-details-marker { display: none; }
    .faq-item summary::after { content: "+"; font-size: 1.25rem; color: var(--brand); }
    .faq-item[open] summary::after { content: "−"; }

    .faq-item p {
      padding-bottom: 1.25rem;
      color: var(--muted);
      line-height: 1.7;
    }

    /* ─── FINAL CTA ─── */
    .cta-section {
      text-align: center;
      background:
        radial-gradient(ellipse 60% 80% at 50% 50%, rgba(108,99,255,0.25), transparent),
        var(--dark);
    }

    /* ─── FOOTER ─── */
    footer {
      border-top: 1px solid var(--border);
      padding: 3rem 1.5rem;
    }

    .footer-inner {
      max-width: 1200px;
      margin: 0 auto;
      display: flex;
      justify-content: space-between;
      align-items: center;
      flex-wrap: wrap;
      gap: 1rem;
    }

    footer p { color: var(--muted); font-size: 0.875rem; }

    /* ─── RESPONSIVE ─── */
    @media (max-width: 768px) {
      .hero-inner { grid-template-columns: 1fr; }
      .hero-img-wrap { display: none; }
      .nav-links { display: none; }
    }

    /* ─── SCROLL REVEAL ─── */
    @keyframes revealUp {
      from { opacity: 0; transform: translateY(30px); }
      to   { opacity: 1; transform: translateY(0); }
    }

    .reveal {
      animation: revealUp linear both;
      animation-timeline: view();
      animation-range: entry 0% entry 35%;
    }

    @media (prefers-reduced-motion: reduce) {
      .reveal { animation: none; }
    }
  </style>
</head>
<body>

<a href="#main" class="skip-link">Skip to content</a>

<!-- NAV -->
<header role="banner">
  <nav class="nav" aria-label="Primary navigation">
    <div class="nav-inner">
      <a href="/" class="nav-logo">☕ BeanCo</a>
      <ul class="nav-links">
        <li><a href="#features">Features</a></li>
        <li><a href="#testimonials">Reviews</a></li>
        <li><a href="#faq">FAQ</a></li>
        <li><a href="/shop" class="nav-cta">Order Now</a></li>
      </ul>
    </div>
  </nav>
</header>

<main id="main">

  <!-- HERO -->
  <section class="hero" aria-labelledby="hero-h1">
    <div class="hero-inner container">
      <div>
        <p class="hero-tag">🌍 Direct Trade · 23 Farms</p>
        <h1 class="hero-title" id="hero-h1">
          Coffee That<br>
          <span class="gradient-text">Actually Matters</span>
        </h1>
        <p class="hero-desc">
          Single-origin beans. Roasted to order.
          At your door in 24 hours. Every bag
          directly funds the families who grew it.
        </p>
        <div class="hero-btns">
          <a href="/shop" class="btn btn-primary">Start My Subscription ✨</a>
          <a href="#features" class="btn btn-ghost">Learn More →</a>
        </div>
      </div>
      <div class="hero-img-wrap" aria-hidden="true">
        <img
          class="hero-img"
          src="/images/hero-coffee.jpg"
          alt=""
          width="600" height="750"
          fetchpriority="high"
        >
      </div>
    </div>
  </section>

  <!-- LOGOS -->
  <div class="logos-section" aria-label="As featured in">
    <div class="logos-inner">
      <span class="logo-label">As seen in</span>
      <img class="logo-img" src="/logos/nyt.svg" alt="New York Times" height="24">
      <img class="logo-img" src="/logos/wired.svg" alt="Wired" height="24">
      <img class="logo-img" src="/logos/forbes.svg" alt="Forbes" height="24">
      <img class="logo-img" src="/logos/epicurious.svg" alt="Epicurious" height="24">
    </div>
  </div>

  <!-- FEATURES -->
  <section id="features" aria-labelledby="features-h2">
    <div class="container" style="text-align:center">
      <span class="eyebrow">Why BeanCo</span>
      <h2 class="section-title" id="features-h2">Everything You Want<br>in a Coffee Company</h2>
      <p class="section-desc" style="margin: 0 auto">
        We built the coffee company we always wanted to
        find but couldn't.
      </p>
    </div>
    <div class="features-grid container reveal">
      <div class="feature-card">
        <div class="feature-icon">🌱</div>
        <h3 class="feature-title">Direct Trade</h3>
        <p class="feature-desc">We pay farmers 30–50% above Fair Trade prices. No middlemen. Better coffee, better lives.</p>
      </div>
      <div class="feature-card">
        <div class="feature-icon">🔥</div>
        <h3 class="feature-title">Roasted to Order</h3>
        <p class="feature-desc">We never roast until you order. Your beans ship within 24 hours of roasting, guaranteed.</p>
      </div>
      <div class="feature-card">
        <div class="feature-icon">📦</div>
        <h3 class="feature-title">Zero Waste Packaging</h3>
        <p class="feature-desc">Fully compostable bags. Carbon-neutral shipping. We obsess over our environmental impact.</p>
      </div>
      <div class="feature-card">
        <div class="feature-icon">🎓</div>
        <h3 class="feature-title">Brew Guides Included</h3>
        <p class="feature-desc">Every bag comes with a custom brew guide for that specific bean's ideal extraction.</p>
      </div>
      <div class="feature-card">
        <div class="feature-icon">🔄</div>
        <h3 class="feature-title">Flexible Subscription</h3>
        <p class="feature-desc">Pause, skip, or cancel anytime. No hoops, no fees, no guilt trips. We mean it.</p>
      </div>
      <div class="feature-card">
        <div class="feature-icon">⭐</div>
        <h3 class="feature-title">4.9 Star Rating</h3>
        <p class="feature-desc">Over 18,000 verified reviews. Our customers stay for years because the coffee is just that good.</p>
      </div>
    </div>
  </section>

  <!-- TESTIMONIALS -->
  <section id="testimonials" style="background:var(--surface)" aria-labelledby="testimonials-h2">
    <div class="container" style="text-align:center">
      <span class="eyebrow">Real Reviews</span>
      <h2 class="section-title" id="testimonials-h2">18,000+ Happy Coffee Drinkers</h2>
    </div>
    <div class="testimonials-grid container reveal">
      <article class="testimonial">
        <div class="testimonial__stars" aria-label="5 out of 5 stars">★★★★★</div>
        <p class="testimonial__text">"I've been a coffee snob for 15 years and BeanCo is genuinely the best coffee I've ever had delivered at home."</p>
        <div class="testimonial__author">
          <img class="testimonial__avatar" src="/images/alice.jpg" alt="Alice K." width="40" height="40">
          <div>
            <div class="testimonial__name">Alice K.</div>
            <div class="testimonial__role">Software Engineer, Seattle</div>
          </div>
        </div>
      </article>
      <article class="testimonial">
        <div class="testimonial__stars" aria-label="5 out of 5 stars">★★★★★</div>
        <p class="testimonial__text">"Cancelled my Blue Bottle subscription after my first BeanCo order. No comparison — fresher, better flavor, lower price."</p>
        <div class="testimonial__author">
          <img class="testimonial__avatar" src="/images/marcus.jpg" alt="Marcus D." width="40" height="40">
          <div>
            <div class="testimonial__name">Marcus D.</div>
            <div class="testimonial__role">Chef, New York</div>
          </div>
        </div>
      </article>
      <article class="testimonial">
        <div class="testimonial__stars" aria-label="5 out of 5 stars">★★★★★</div>
        <p class="testimonial__text">"The Ethiopian Yirgacheffe is transcendent. I make pour-over every morning now instead of going to the café."</p>
        <div class="testimonial__author">
          <img class="testimonial__avatar" src="/images/sarah.jpg" alt="Sarah M." width="40" height="40">
          <div>
            <div class="testimonial__name">Sarah M.</div>
            <div class="testimonial__role">Designer, London</div>
          </div>
        </div>
      </article>
    </div>
  </section>

  <!-- FAQ -->
  <section id="faq" aria-labelledby="faq-h2">
    <div class="container" style="text-align:center">
      <span class="eyebrow">Questions</span>
      <h2 class="section-title" id="faq-h2">Everything You Want to Know</h2>
    </div>
    <div class="faq-list">
      <details class="faq-item">
        <summary>How fresh is the coffee when it arrives?</summary>
        <p>We roast your coffee within 24 hours of your order and ship immediately. Most US customers receive their coffee within 2–4 days of roasting — far fresher than anything on a grocery store shelf.</p>
      </details>
      <details class="faq-item">
        <summary>Can I cancel my subscription at any time?</summary>
        <p>Absolutely. Cancel, pause, or skip deliveries anytime from your account page with no fees and no waiting periods. We believe in earning your loyalty every delivery.</p>
      </details>
      <details class="faq-item">
        <summary>What grind options do you offer?</summary>
        <p>We offer whole bean, coarse (French press/cold brew), medium (drip/pour over), and fine (espresso). You can also change your grind preference with each order.</p>
      </details>
      <details class="faq-item">
        <summary>Do you offer decaf options?</summary>
        <p>Yes! We use Swiss Water Process decaffeination, which uses no chemicals and preserves the full flavor profile of the original bean.</p>
      </details>
    </div>
  </section>

  <!-- FINAL CTA -->
  <section class="cta-section" aria-labelledby="cta-h2">
    <div class="container" style="text-align:center;max-width:640px">
      <span class="eyebrow">Start Today</span>
      <h2 class="section-title" id="cta-h2">Your Best Cup of Coffee<br>Starts Here</h2>
      <p class="section-desc" style="margin:1rem auto 2rem">
        Join 18,000+ subscribers. Free shipping on first order.
        Cancel anytime.
      </p>
      <a href="/shop/subscribe" class="btn btn-primary" style="font-size:1.1rem;padding:1rem 2.5rem">
        ☕ Start My Subscription — Free First Bag
      </a>
    </div>
  </section>

</main>

<!-- FOOTER -->
<footer role="contentinfo">
  <div class="footer-inner">
    <p>© 2024 BeanCo Coffee Company · All rights reserved.</p>
    <nav aria-label="Footer links">
      <ul style="list-style:none;display:flex;gap:1.5rem">
        <li><a href="/privacy" style="color:rgba(240,240,255,0.5);font-size:0.875rem;text-decoration:none">Privacy</a></li>
        <li><a href="/terms" style="color:rgba(240,240,255,0.5);font-size:0.875rem;text-decoration:none">Terms</a></li>
        <li><a href="/contact" style="color:rgba(240,240,255,0.5);font-size:0.875rem;text-decoration:none">Contact</a></li>
      </ul>
    </nav>
  </div>
</footer>

</body>
</html>

📝 KEY POINTS:
✅ Every section serves a conversion purpose — not just visual decoration
✅ Hero has one primary CTA and one secondary — never compete with yourself
✅ <article> for testimonials — they are independently meaningful content
✅ <details>/<summary> for FAQ — native accordion, no JavaScript needed
✅ Radial gradient backgrounds add depth without performance cost
✅ aria-labelledby on each <section> ties heading to landmark for screen readers
❌ Don't put multiple primary CTAs — confusion kills conversion
❌ Don't forget mobile — always test the layout at 375px width
''',
  quiz: [
    Quiz(question: 'Why is it important to have only one prominent primary CTA per section?', options: [
      QuizOption(text: 'Multiple competing CTAs cause decision paralysis — users convert less when they have too many choices', correct: true),
      QuizOption(text: 'Browsers can only style one CTA button per section', correct: false),
      QuizOption(text: 'Multiple CTAs slow down page load', correct: false),
      QuizOption(text: 'It is an HTML accessibility requirement', correct: false),
    ]),
    Quiz(question: 'Which HTML element is most appropriate for customer testimonials and why?', options: [
      QuizOption(text: '<article> — each testimonial is independently meaningful and could be syndicated', correct: true),
      QuizOption(text: '<blockquote> — they are direct quotes', correct: false),
      QuizOption(text: '<section> — they are a thematic group', correct: false),
      QuizOption(text: '<aside> — they are supplementary to the main content', correct: false),
    ]),
    Quiz(question: 'What does aria-labelledby on a section element do?', options: [
      QuizOption(text: 'Associates the section with its heading — screen readers announce the heading when entering the section', correct: true),
      QuizOption(text: 'Makes the section label visible as a tooltip', correct: false),
      QuizOption(text: 'Adds an accessible name to the section that replaces its content', correct: false),
      QuizOption(text: 'Links the section to an external label element', correct: false),
    ]),
  ],
);
