// lib/lessons/html/html_22_navigation_styling.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final htmlLesson22 = Lesson(
  language: 'HTML',
  title: 'HTML + CSS: Navbars and Navigation',
  content: '''
🎯 METAPHOR:
A navigation bar is the front door and lobby of your website.
It is the first thing visitors see, the thing they return
to when they are lost, and the map of everything your site
offers. A bad navbar is like a lobby with unmarked doors,
a flickering ceiling light, and a reception desk pointed
at the wall. A great navbar is like a luxury hotel lobby:
clean sight lines, clear wayfinding, a welcoming desk
perfectly positioned, and a hamburger menu drawer that
slides open like a silk curtain when needed on mobile.
The HTML is the walls and doors — the CSS is the interior
design that makes visitors feel immediately at ease.

📖 EXPLANATION:
NAVBAR COMPONENTS:
  <header> + <nav> — semantic wrapper
  <ul> <li> <a>   — navigation links (always a list!)
  active state    — aria-current="page" + CSS class
  mobile menu     — checkbox hack or <details> or JS

TECHNIQUES COVERED:
  Flexbox for horizontal layout
  Responsive hamburger menu (CSS-only using <details>)
  Active link highlighting
  Dropdown submenus
  Sticky navigation with scroll shadow
  CSS transitions for smooth mobile drawer

PATTERNS:
  Inline nav     — links side by side (desktop)
  Hamburger nav  — stacked links in drawer (mobile)
  Mega menu      — large dropdown with multiple columns
  Breadcrumb     — current location path
  Tab bar        — icon + label (mobile bottom nav)

💻 CODE:
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>BeanCo — Navigation Demo</title>
  <style>
    :root {
      --nav-bg:       #1a1a2e;
      --nav-text:     rgba(255,255,255,0.85);
      --nav-hover:    rgba(255,255,255,1);
      --nav-active:   #6c63ff;
      --nav-border:   rgba(255,255,255,0.1);
      --nav-height:   64px;
    }

    *, *::before, *::after { box-sizing: border-box; margin: 0; }
    body { font-family: system-ui, sans-serif; }

    /* ─── STICKY HEADER ─── */
    .site-header {
      position: sticky;
      top: 0;
      z-index: 100;
      background: var(--nav-bg);
      border-bottom: 1px solid var(--nav-border);
      /* Scroll shadow added by JavaScript — or use scroll-driven animation */
    }

    .nav-container {
      max-width: 1200px;
      margin: 0 auto;
      padding: 0 1.5rem;
      height: var(--nav-height);
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 2rem;
    }

    /* ─── LOGO ─── */
    .nav-logo {
      text-decoration: none;
      color: white;
      font-size: 1.35rem;
      font-weight: 700;
      display: flex;
      align-items: center;
      gap: 0.5rem;
      flex-shrink: 0;
    }

    /* ─── PRIMARY NAV (desktop) ─── */
    .nav-links {
      display: flex;
      list-style: none;
      gap: 0.25rem;
      align-items: center;
    }

    .nav-links a {
      color: var(--nav-text);
      text-decoration: none;
      padding: 0.5rem 0.875rem;
      border-radius: 8px;
      font-size: 0.95rem;
      font-weight: 500;
      transition: color 0.15s, background 0.15s;
      display: block;
    }

    .nav-links a:hover {
      color: var(--nav-hover);
      background: rgba(255,255,255,0.1);
    }

    /* Active state — aria-current="page" */
    .nav-links a[aria-current="page"] {
      color: white;
      background: var(--nav-active);
    }

    /* ─── CTA BUTTON ─── */
    .nav-cta {
      background: #6c63ff;
      color: white !important;
      padding: 0.5rem 1.25rem !important;
      border-radius: 999px !important;
    }

    .nav-cta:hover {
      background: #5a52d5 !important;
    }

    /* ─── DROPDOWN ─── */
    .nav-item--dropdown {
      position: relative;
    }

    .dropdown-menu {
      position: absolute;
      top: calc(100% + 0.5rem);
      left: 0;
      background: white;
      border-radius: 12px;
      padding: 0.5rem;
      min-width: 200px;
      box-shadow: 0 8px 32px rgba(0,0,0,0.15);
      list-style: none;
      opacity: 0;
      pointer-events: none;
      transform: translateY(-8px);
      transition: opacity 0.2s, transform 0.2s;
    }

    .nav-item--dropdown:hover .dropdown-menu,
    .nav-item--dropdown:focus-within .dropdown-menu {
      opacity: 1;
      pointer-events: auto;
      transform: translateY(0);
    }

    .dropdown-menu a {
      display: block;
      padding: 0.625rem 1rem;
      color: #333;
      text-decoration: none;
      border-radius: 8px;
      font-size: 0.9rem;
      transition: background 0.15s;
    }

    .dropdown-menu a:hover { background: #f0f0f8; }

    /* ─── HAMBURGER (CSS-ONLY using <details>) ─── */
    .nav-toggle {
      display: none;
    }

    .nav-toggle summary {
      list-style: none;
      cursor: pointer;
      color: white;
      font-size: 1.5rem;
      padding: 0.5rem;
      border-radius: 8px;
      line-height: 1;
      user-select: none;
    }

    .nav-toggle summary::-webkit-details-marker { display: none; }

    .nav-toggle summary::before { content: "☰"; }
    .nav-toggle[open] summary::before { content: "✕"; }

    /* ─── MOBILE NAV ─── */
    @media (max-width: 768px) {
      .nav-links { display: none; }
      .nav-toggle { display: block; }

      .mobile-nav {
        background: var(--nav-bg);
        border-top: 1px solid var(--nav-border);
        padding: 1rem;
        animation: slideDown 0.2s ease;
      }

      .mobile-nav ul {
        list-style: none;
        display: flex;
        flex-direction: column;
        gap: 0.25rem;
      }

      .mobile-nav a {
        color: var(--nav-text);
        text-decoration: none;
        display: block;
        padding: 0.75rem 1rem;
        border-radius: 8px;
        font-weight: 500;
        transition: background 0.15s, color 0.15s;
      }

      .mobile-nav a:hover { background: rgba(255,255,255,0.1); color: white; }
      .mobile-nav a[aria-current="page"] { background: var(--nav-active); color: white; }

      @keyframes slideDown {
        from { opacity: 0; transform: translateY(-8px); }
        to   { opacity: 1; transform: translateY(0); }
      }
    }

    /* ─── SKIP LINK ─── */
    .skip-link {
      position: absolute;
      top: -100%;
      left: 1rem;
      padding: 0.5rem 1rem;
      background: var(--nav-active);
      color: white;
      border-radius: 0 0 8px 8px;
      font-weight: 600;
      text-decoration: none;
      z-index: 200;
      transition: top 0.2s;
    }
    .skip-link:focus { top: 0; }
  </style>
</head>
<body>

<!-- Skip link — keyboard/screen reader users -->
<a href="#main-content" class="skip-link">Skip to main content</a>

<header class="site-header">
  <div class="nav-container">

    <!-- Logo -->
    <a href="/" class="nav-logo" aria-label="BeanCo Coffee — Home">
      ☕ BeanCo
    </a>

    <!-- Desktop navigation -->
    <nav aria-label="Primary navigation">
      <ul class="nav-links">
        <li><a href="/" aria-current="page">Home</a></li>
        <li><a href="/shop">Shop</a></li>

        <!-- Dropdown -->
        <li class="nav-item--dropdown">
          <a href="/learn" aria-haspopup="true">
            Learn ▾
          </a>
          <ul class="dropdown-menu" role="menu">
            <li><a href="/learn/brewing" role="menuitem">Brewing Guides</a></li>
            <li><a href="/learn/origins" role="menuitem">Bean Origins</a></li>
            <li><a href="/learn/roasting" role="menuitem">Roasting Process</a></li>
          </ul>
        </li>

        <li><a href="/blog">Blog</a></li>
        <li><a href="/about">About</a></li>
        <li><a href="/shop/subscribe" class="nav-cta">Subscribe</a></li>
      </ul>
    </nav>

    <!-- Mobile hamburger (CSS-only using details) -->
    <details class="nav-toggle" aria-label="Menu">
      <summary aria-controls="mobile-nav"></summary>
      <nav id="mobile-nav" class="mobile-nav" aria-label="Mobile navigation">
        <ul>
          <li><a href="/" aria-current="page">Home</a></li>
          <li><a href="/shop">Shop</a></li>
          <li><a href="/learn">Learn</a></li>
          <li><a href="/blog">Blog</a></li>
          <li><a href="/about">About</a></li>
          <li><a href="/shop/subscribe">Subscribe ☕</a></li>
        </ul>
      </nav>
    </details>

  </div>
</header>

<main id="main-content">
  <h1 style="padding:2rem">Page Content Here</h1>
</main>

</body>
</html>

📝 KEY POINTS:
✅ Navigation links should always be a <ul> inside a <nav>
✅ aria-current="page" marks the active link for screen readers and CSS
✅ <details> + <summary> creates a CSS-only hamburger with zero JavaScript
✅ position: sticky + z-index keeps the navbar above scrolling content
✅ :focus-within on dropdown parent opens it via keyboard (not just hover)
✅ Skip links let keyboard users bypass the repeated navigation
❌ Don't use hover-only dropdowns — keyboard users need :focus-within too
❌ Don't forget aria-label on multiple <nav> elements to differentiate them
''',
  quiz: [
    Quiz(question: 'Why should navigation links always use a <ul> list structure?', options: [
      QuizOption(text: 'Screen readers announce the number of items in a list — helping users understand the nav scope', correct: true),
      QuizOption(text: 'Lists are the only way to make horizontal navigation work', correct: false),
      QuizOption(text: 'It is required by the HTML specification for nav elements', correct: false),
      QuizOption(text: 'Only list items can be styled with CSS flexbox', correct: false),
    ]),
    Quiz(question: 'How does :focus-within on a dropdown parent improve accessibility?', options: [
      QuizOption(text: 'Opens the dropdown when keyboard focus moves inside it — not just on mouse hover', correct: true),
      QuizOption(text: 'Highlights the focused element inside the dropdown', correct: false),
      QuizOption(text: 'Prevents the dropdown from closing when tabbing through items', correct: false),
      QuizOption(text: 'Adds an ARIA role to the focused element', correct: false),
    ]),
    Quiz(question: 'What does aria-current="page" communicate to screen readers?', options: [
      QuizOption(text: 'This link represents the currently active/visible page', correct: true),
      QuizOption(text: 'This is the current position in a multi-step form', correct: false),
      QuizOption(text: 'This link opens the current tab', correct: false),
      QuizOption(text: 'This is the most recently clicked link', correct: false),
    ]),
  ],
);
