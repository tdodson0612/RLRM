// lib/lessons/html/html_10_head_metadata.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final htmlLesson10 = Lesson(
  language: 'HTML',
  title: 'The Head Element and Metadata',
  content: '''
🎯 METAPHOR:
The <head> of your HTML document is like the back-office of
a restaurant. The dining room (body) is what guests see —
the tables, the food, the ambiance. But the back office
is where the magic is organized: the bookings system
(title), the health certificate (charset), the staff
rota (scripts), the menu design (stylesheets), the
restaurant's reputation (Open Graph for social sharing),
and the GPS listing (canonical URL). Guests never see
the back office, but without it the restaurant falls apart.

📖 EXPLANATION:
ESSENTIAL HEAD ELEMENTS:

<meta charset="UTF-8">
  Character encoding — MUST be first! Ensures emoji,
  accented chars, and all scripts display correctly.

<meta name="viewport" content="width=device-width, initial-scale=1">
  Mobile responsiveness — without this, mobile browsers
  zoom out to desktop size.

<title>Page Title</title>
  Appears in browser tab, bookmarks, and search results.
  MOST IMPORTANT SEO element. 50-60 characters ideal.

<meta name="description" content="...">
  Search result snippet — 150-160 characters ideal.

<link rel="canonical" href="https://example.com/page">
  Tell search engines the preferred URL for this content.

<link rel="stylesheet" href="styles.css">
  Connect external CSS file.

<link rel="icon" href="/favicon.ico">
  Browser tab icon (favicon).

RESOURCE HINTS:
  <link rel="preload">     — start loading critical resource early
  <link rel="preconnect">  — pre-establish server connection
  <link rel="prefetch">    — load likely next-page resources
  <link rel="dns-prefetch"> — pre-resolve DNS

OPEN GRAPH (social sharing):
  <meta property="og:title">
  <meta property="og:description">
  <meta property="og:image">
  <meta property="og:url">

TWITTER CARD:
  <meta name="twitter:card" content="summary_large_image">

<script> placement:
  In <head>: add defer or async
  Before </body>: traditional approach

💻 CODE:
<!DOCTYPE html>
<html lang="en">
<head>

  <!-- ─── ESSENTIAL — MUST COME FIRST ─── -->
  <meta charset="UTF-8">
  <!-- MUST be within first 1024 bytes! -->

  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <!-- Mobile-first. initial-scale=1 prevents iOS auto-zoom -->

  <!-- ─── PAGE TITLE ─── -->
  <title>Ultimate Coffee Guide 2024 | The Coffee Times</title>
  <!-- Format: Primary Keyword | Brand Name -->
  <!-- 50-60 chars max for full display in search results -->

  <!-- ─── SEO META ─── -->
  <meta
    name="description"
    content="Your complete guide to brewing the perfect cup of coffee — from bean selection to barista techniques. Updated for 2024."
  >
  <!-- 150-160 characters — appears as search snippet -->

  <meta name="robots" content="index, follow">
  <!-- Tell search engines to index and follow links -->

  <link rel="canonical" href="https://coffeetime.com/guide">
  <!-- Preferred URL — prevents duplicate content issues -->

  <!-- ─── FAVICON ─── -->
  <link rel="icon" href="/favicon.ico" sizes="any">
  <link rel="icon" href="/favicon.svg" type="image/svg+xml">
  <link rel="apple-touch-icon" href="/apple-touch-icon.png">
  <!-- apple-touch-icon: shown when saved to iOS home screen -->

  <!-- ─── CSS ─── -->
  <link rel="stylesheet" href="/styles/main.css">

  <!-- Critical CSS inline (above-the-fold styles) -->
  <style>
    /* Only put above-fold critical styles here */
    body { margin: 0; font-family: system-ui, sans-serif; }
    header { background: #1a1a2e; color: white; padding: 1rem; }
  </style>

  <!-- ─── RESOURCE HINTS ─── -->
  <!-- Preload critical font (starts loading immediately) -->
  <link
    rel="preload"
    href="/fonts/inter.woff2"
    as="font"
    type="font/woff2"
    crossorigin
  >

  <!-- Preload hero image (LCP element) -->
  <link
    rel="preload"
    href="/images/hero.jpg"
    as="image"
  >

  <!-- Pre-connect to Google Fonts server -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

  <!-- Prefetch next likely page -->
  <link rel="prefetch" href="/guide/chapter-2">

  <!-- DNS prefetch for analytics -->
  <link rel="dns-prefetch" href="//analytics.example.com">

  <!-- ─── OPEN GRAPH (Facebook, LinkedIn, Discord) ─── -->
  <meta property="og:type"        content="article">
  <meta property="og:title"       content="Ultimate Coffee Guide 2024">
  <meta property="og:description" content="Your complete guide to brewing the perfect cup.">
  <meta property="og:image"       content="https://coffeetime.com/images/guide-og.jpg">
  <meta property="og:image:width"  content="1200">
  <meta property="og:image:height" content="630">
  <meta property="og:url"         content="https://coffeetime.com/guide">
  <meta property="og:site_name"   content="The Coffee Times">

  <!-- ─── TWITTER CARD ─── -->
  <meta name="twitter:card"        content="summary_large_image">
  <meta name="twitter:site"        content="@CoffeeTimes">
  <meta name="twitter:title"       content="Ultimate Coffee Guide 2024">
  <meta name="twitter:description" content="Your complete guide to the perfect cup.">
  <meta name="twitter:image"       content="https://coffeetime.com/images/guide-og.jpg">

  <!-- ─── THEME COLOR (mobile browser chrome) ─── -->
  <meta name="theme-color" content="#1a1a2e">
  <!-- Colors the browser chrome on mobile (address bar) -->

  <!-- ─── SCRIPTS ─── -->
  <!-- defer: load in background, execute after DOM parsed -->
  <script defer src="/scripts/main.js"></script>

  <!-- async: load in background, execute immediately when ready -->
  <!-- (good for analytics, ads — independent of DOM) -->
  <script async src="/scripts/analytics.js"></script>

  <!-- ─── STRUCTURED DATA (JSON-LD) ─── -->
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "Article",
    "headline": "Ultimate Coffee Guide 2024",
    "author": {
      "@type": "Person",
      "name": "Alice Chen"
    },
    "datePublished": "2024-03-15",
    "image": "https://coffeetime.com/images/guide-og.jpg"
  }
  </script>

</head>
<body>
  <!-- page content -->
</body>
</html>

📝 KEY POINTS:
✅ charset must be the FIRST meta tag — within first 1024 bytes of document
✅ viewport meta is required for any mobile-responsive design
✅ title is the #1 SEO factor — be descriptive and keyword-rich (50-60 chars)
✅ rel="preload" for fonts and LCP images dramatically improves performance
✅ Open Graph meta controls how your page looks when shared on social media
✅ defer on scripts is usually best — loads async, executes after DOM
❌ Don't put scripts without defer/async in <head> — they block page rendering
❌ Don't write <title> like "Home" — be specific ("About Us — Company Name")
''',
  quiz: [
    Quiz(question: 'Why must <meta charset="UTF-8"> be the very first meta tag?', options: [
      QuizOption(text: 'Browsers need it within the first 1024 bytes to correctly decode the document', correct: true),
      QuizOption(text: 'It is a CSS convention to always put it first', correct: false),
      QuizOption(text: 'It must come before the title to be valid HTML', correct: false),
      QuizOption(text: 'Search engines require it to be first', correct: false),
    ]),
    Quiz(question: 'What is the difference between defer and async on a script tag?', options: [
      QuizOption(text: 'defer executes after DOM is parsed; async executes immediately when downloaded', correct: true),
      QuizOption(text: 'async executes after DOM; defer executes immediately', correct: false),
      QuizOption(text: 'They are identical — just different names', correct: false),
      QuizOption(text: 'defer is for external scripts; async is for inline scripts', correct: false),
    ]),
    Quiz(question: 'What does rel="preload" on a link element do?', options: [
      QuizOption(text: 'Tells the browser to start downloading the resource immediately at high priority', correct: true),
      QuizOption(text: 'Loads the resource before the HTML file', correct: false),
      QuizOption(text: 'Caches the resource permanently in the browser', correct: false),
      QuizOption(text: 'Pre-renders the linked page', correct: false),
    ]),
  ],
);
