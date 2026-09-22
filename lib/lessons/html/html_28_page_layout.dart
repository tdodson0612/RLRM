// lib/lessons/html/html_28_page_layout.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final htmlLesson28 = Lesson(
  language: 'HTML',
  title: 'HTML + CSS: Full Page Layout',
  content: '''
🎯 METAPHOR:
A full-page layout is like an architect's floor plan.
Before any furniture goes in (content), the architect
defines the rooms (semantic sections) and their spatial
relationships: the lobby at the top (header), the main
living area (main), the study on the side (aside),
and the utility room at the bottom (footer). CSS Grid
is the architect's drawing tool — it turns semantic HTML
into a precise, responsive spatial arrangement.
Every pixel has a purpose. Every element knows its place.
The layout serves the content — not the other way around.

📖 EXPLANATION:
LAYOUT STRATEGIES:
  1. Sticky header + scrollable content
  2. Sidebar + main content
  3. Holy Grail (header/sidebar/main/aside/footer)
  4. Dashboard grid
  5. Magazine/editorial grid

CSS TECHNIQUES:
  grid-template-areas for named layout zones
  100dvh (dynamic viewport height) for full-screen
  min-height trick to push footer to bottom
  Sticky sidebar that scrolls with content
  Responsive collapse at mobile breakpoints

SEMANTIC STRUCTURE:
  <header> + <nav>   — top navigation
  <main>             — page-specific content
  <aside>            — supplementary sidebar
  <footer>           — page footer
  <article>          — main content piece
  <section>          — thematic groups within

💻 CODE:
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>The Coffee Times — Article Layout</title>
  <style>
    :root {
      --brand:    #6c63ff;
      --surface:  #ffffff;
      --bg:       #f5f5fc;
      --text:     #1a1a2e;
      --muted:    #6b7280;
      --border:   #e5e7eb;
      --nav-h:    64px;
      --sidebar-w: 280px;
    }

    *, *::before, *::after { box-sizing: border-box; margin: 0; }
    html { scroll-behavior: smooth; }

    body {
      font-family: system-ui, sans-serif;
      background: var(--bg);
      color: var(--text);
      /* Push footer to bottom on short pages */
      min-height: 100dvh;
      display: flex;
      flex-direction: column;
    }

    /* ─── SKIP LINK ─── */
    .skip-link {
      position: absolute;
      top: -100%;
      left: 1rem;
      background: var(--brand);
      color: white;
      padding: 0.5rem 1rem;
      border-radius: 0 0 8px 8px;
      font-weight: 700;
      text-decoration: none;
      z-index: 999;
    }
    .skip-link:focus { top: 0; }

    /* ─── HEADER ─── */
    .site-header {
      position: sticky;
      top: 0;
      z-index: 100;
      height: var(--nav-h);
      background: var(--surface);
      border-bottom: 1px solid var(--border);
      display: flex;
      align-items: center;
      padding: 0 1.5rem;
      justify-content: space-between;
      box-shadow: 0 1px 0 rgba(0,0,0,0.05);
    }

    .site-logo {
      font-size: 1.25rem;
      font-weight: 800;
      color: var(--text);
      text-decoration: none;
    }

    .site-nav {
      display: flex;
      gap: 0.25rem;
      list-style: none;
    }

    .site-nav a {
      padding: 0.5rem 0.75rem;
      color: var(--muted);
      text-decoration: none;
      border-radius: 6px;
      font-size: 0.9rem;
      font-weight: 500;
      transition: color 0.15s, background 0.15s;
    }

    .site-nav a:hover, .site-nav a[aria-current] {
      color: var(--brand);
      background: rgba(108,99,255,0.07);
    }

    /* ─── OUTER WRAPPER ─── */
    /* flex: 1 pushes footer down */
    .outer {
      flex: 1;
      width: 100%;
      max-width: 1200px;
      margin: 0 auto;
      padding: 2rem 1.5rem;
    }

    /* ─── CONTENT + SIDEBAR GRID ─── */
    .content-grid {
      display: grid;
      grid-template-columns: 1fr var(--sidebar-w);
      gap: 2.5rem;
      align-items: start;
    }

    /* ─── ARTICLE ─── */
    .article-wrap {
      background: var(--surface);
      border-radius: 16px;
      padding: clamp(1.5rem, 4vw, 3rem);
      box-shadow: 0 1px 4px rgba(0,0,0,0.06);
    }

    .article__meta {
      display: flex;
      align-items: center;
      gap: 1rem;
      font-size: 0.85rem;
      color: var(--muted);
      margin-bottom: 1.5rem;
      flex-wrap: wrap;
    }

    .article__category {
      display: inline-block;
      background: rgba(108,99,255,0.1);
      color: var(--brand);
      font-weight: 700;
      font-size: 0.75rem;
      text-transform: uppercase;
      letter-spacing: 0.1em;
      padding: 0.2rem 0.6rem;
      border-radius: 4px;
    }

    .article__title {
      font-size: clamp(1.5rem, 4vw, 2.5rem);
      font-weight: 800;
      line-height: 1.15;
      margin-bottom: 1rem;
      text-wrap: balance;
    }

    .article__lead {
      font-size: 1.1rem;
      color: var(--muted);
      line-height: 1.7;
      margin-bottom: 2rem;
      padding-bottom: 2rem;
      border-bottom: 1px solid var(--border);
    }

    .article__img {
      width: 100%;
      aspect-ratio: 16 / 9;
      object-fit: cover;
      border-radius: 10px;
      margin-bottom: 2rem;
    }

    .article__body h2 {
      font-size: 1.35rem;
      font-weight: 700;
      margin: 2rem 0 0.75rem;
    }

    .article__body p {
      line-height: 1.75;
      color: #374151;
      margin-bottom: 1.25rem;
    }

    /* ─── STICKY SIDEBAR ─── */
    .sidebar {
      position: sticky;
      top: calc(var(--nav-h) + 1rem);
      display: flex;
      flex-direction: column;
      gap: 1.5rem;
    }

    .sidebar-widget {
      background: var(--surface);
      border-radius: 12px;
      padding: 1.25rem;
      box-shadow: 0 1px 4px rgba(0,0,0,0.06);
    }

    .sidebar-widget h3 {
      font-size: 0.8rem;
      font-weight: 700;
      text-transform: uppercase;
      letter-spacing: 0.1em;
      color: var(--muted);
      margin-bottom: 1rem;
    }

    .related-list {
      list-style: none;
      display: flex;
      flex-direction: column;
      gap: 0.75rem;
    }

    .related-list a {
      text-decoration: none;
      color: var(--text);
      font-size: 0.9rem;
      font-weight: 500;
      display: block;
      transition: color 0.15s;
    }

    .related-list a:hover { color: var(--brand); }

    /* ─── TABLE OF CONTENTS ─── */
    .toc-list {
      list-style: none;
      counter-reset: toc;
    }

    .toc-list li {
      counter-increment: toc;
      padding: 0.4rem 0;
      border-bottom: 1px solid var(--border);
      font-size: 0.875rem;
    }

    .toc-list a {
      color: var(--muted);
      text-decoration: none;
      transition: color 0.15s;
    }

    .toc-list a:hover { color: var(--brand); }

    .toc-list a::before {
      content: counter(toc) ". ";
      color: var(--brand);
      font-weight: 700;
    }

    /* ─── FOOTER ─── */
    .site-footer {
      background: var(--text);
      color: rgba(255,255,255,0.7);
      padding: 3rem 1.5rem;
      margin-top: auto;
    }

    .footer-inner {
      max-width: 1200px;
      margin: 0 auto;
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
      gap: 2rem;
    }

    .footer-col h4 {
      color: white;
      font-size: 0.85rem;
      font-weight: 700;
      text-transform: uppercase;
      letter-spacing: 0.1em;
      margin-bottom: 1rem;
    }

    .footer-col ul {
      list-style: none;
      display: flex;
      flex-direction: column;
      gap: 0.5rem;
    }

    .footer-col a {
      color: rgba(255,255,255,0.6);
      text-decoration: none;
      font-size: 0.9rem;
      transition: color 0.15s;
    }

    .footer-col a:hover { color: white; }

    .footer-bottom {
      max-width: 1200px;
      margin: 2rem auto 0;
      padding-top: 1.5rem;
      border-top: 1px solid rgba(255,255,255,0.1);
      font-size: 0.85rem;
    }

    /* ─── RESPONSIVE ─── */
    @media (max-width: 900px) {
      .content-grid {
        grid-template-columns: 1fr;
      }
      .sidebar { position: static; }
    }

    @media (max-width: 640px) {
      .site-nav { display: none; }
    }
  </style>
</head>
<body>

<a href="#main" class="skip-link">Skip to content</a>

<header class="site-header" role="banner">
  <a href="/" class="site-logo">☕ The Coffee Times</a>
  <nav aria-label="Primary">
    <ul class="site-nav">
      <li><a href="/">Home</a></li>
      <li><a href="/articles" aria-current="page">Articles</a></li>
      <li><a href="/recipes">Recipes</a></li>
      <li><a href="/about">About</a></li>
    </ul>
  </nav>
</header>

<div class="outer">
  <div class="content-grid">

    <main id="main">
      <article class="article-wrap">
        <div class="article__meta">
          <span class="article__category">Brewing Science</span>
          <time datetime="2024-03-15">March 15, 2024</time>
          <span>· 8 min read</span>
        </div>

        <h1 class="article__title">
          The Science Behind the Perfect Extraction
        </h1>

        <p class="article__lead">
          Coffee extraction is the most important variable
          in brewing. Get it right and the cup sings with
          clarity and sweetness. Get it wrong and you get
          either sour underextraction or bitter overextraction.
        </p>

        <img
          class="article__img"
          src="/images/espresso-shot.jpg"
          alt="Perfect espresso shot pouring from portafilter into white demitasse"
          width="800" height="450"
          loading="lazy"
        >

        <div class="article__body">
          <h2 id="what-is-extraction">What is Extraction?</h2>
          <p>
            Extraction is the process of dissolving compounds
            from coffee grounds into water. Not all compounds
            extract at the same rate — solubles like acids
            extract first, then sugars, then bitter compounds.
          </p>

          <h2 id="golden-ratio">The Golden Ratio</h2>
          <p>
            Professional baristas target an extraction yield
            of 18–22%, with 20% widely considered optimal.
            This means 20% of the coffee's dry weight ends
            up dissolved in the cup.
          </p>
        </div>
      </article>
    </main>

    <aside aria-label="Article sidebar">
      <div class="sidebar">

        <div class="sidebar-widget">
          <h3>Table of Contents</h3>
          <ol class="toc-list">
            <li><a href="#what-is-extraction">What is Extraction?</a></li>
            <li><a href="#golden-ratio">The Golden Ratio</a></li>
            <li><a href="#temperature">Temperature</a></li>
            <li><a href="#grind-size">Grind Size</a></li>
          </ol>
        </div>

        <div class="sidebar-widget">
          <h3>Related Articles</h3>
          <ul class="related-list">
            <li><a href="/articles/grind-size">↗ Grind Size Guide</a></li>
            <li><a href="/articles/water-quality">↗ Water Quality</a></li>
            <li><a href="/articles/temperature">↗ Temperature Science</a></li>
          </ul>
        </div>

      </div>
    </aside>

  </div>
</div>

<footer class="site-footer" role="contentinfo">
  <div class="footer-inner">
    <div class="footer-col">
      <h4>The Coffee Times</h4>
      <p style="font-size:0.875rem">Passionate coffee journalism since 2018.</p>
    </div>
    <div class="footer-col">
      <h4>Explore</h4>
      <ul>
        <li><a href="/articles">Articles</a></li>
        <li><a href="/recipes">Recipes</a></li>
        <li><a href="/reviews">Reviews</a></li>
      </ul>
    </div>
    <div class="footer-col">
      <h4>Company</h4>
      <ul>
        <li><a href="/about">About Us</a></li>
        <li><a href="/contact">Contact</a></li>
        <li><a href="/advertise">Advertise</a></li>
      </ul>
    </div>
  </div>
  <div class="footer-bottom">
    <small>© 2024 The Coffee Times. All rights reserved.</small>
  </div>
</footer>

</body>
</html>

📝 KEY POINTS:
✅ body with min-height: 100dvh + flex-direction: column pushes footer down
✅ position: sticky on sidebar with top: calc(nav-height + gap) scrolls with content
✅ grid-template-columns: 1fr sidebar-width collapses naturally at mobile breakpoint
✅ 100dvh (dynamic viewport height) accounts for mobile browser chrome
✅ role="banner" and role="contentinfo" on header/footer are ARIA landmark best practice
✅ Sticky header height via CSS variable makes sidebar top calculation DRY
❌ Don't use position: fixed for sidebar on mobile — it covers content
❌ footer margin-top: auto only works when body is a flex container
''',
  quiz: [
    Quiz(question: 'How do you push a footer to the bottom of the page even when content is short?', options: [
      QuizOption(text: 'Set body to min-height: 100dvh + display: flex + flex-direction: column, then flex: 1 on main', correct: true),
      QuizOption(text: 'Set footer position: fixed; bottom: 0', correct: false),
      QuizOption(text: 'Set body height: 100vh and footer margin-top: auto', correct: false),
      QuizOption(text: 'Use JavaScript to calculate and set footer position', correct: false),
    ]),
    Quiz(question: 'What makes a sticky sidebar work correctly alongside a sticky header?', options: [
      QuizOption(text: 'top: calc(nav-height + gap) offsets the sidebar below the header', correct: true),
      QuizOption(text: 'z-index on the sidebar above the header', correct: false),
      QuizOption(text: 'position: fixed instead of sticky', correct: false),
      QuizOption(text: 'overflow: hidden on the content area', correct: false),
    ]),
    Quiz(question: 'Why use 100dvh instead of 100vh for layout height?', options: [
      QuizOption(text: 'dvh (dynamic viewport height) adjusts for mobile browser UI like address bars', correct: true),
      QuizOption(text: 'dvh is supported in more browsers than vh', correct: false),
      QuizOption(text: 'dvh accounts for CSS transforms on the body', correct: false),
      QuizOption(text: 'vh is deprecated and dvh is the replacement', correct: false),
    ]),
  ],
);
