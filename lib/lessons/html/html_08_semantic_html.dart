// lib/lessons/html/html_08_semantic_html.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final htmlLesson08 = Lesson(
  language: 'HTML',
  title: 'Semantic HTML',
  content: '''
🎯 METAPHOR:
Semantic HTML is like labeling every box when you move house.
You could put everything in unmarked boxes — technically
everything gets moved. But when you arrive, nobody knows
what's what. "This is the KITCHEN box. This is the BEDROOM
box. This is the FRAGILE box." Semantic HTML labels your
content for what it MEANS, not just what it looks like.
<header> doesn't just mean "put this at the top" — it means
"this IS the header." Search engines understand it.
Screen readers navigate by it. Developers reading your code
understand it. Your future self thanks you for it.

📖 EXPLANATION:
Semantic elements describe the MEANING of content.
Non-semantic elements describe the APPEARANCE of content.

NON-SEMANTIC:
  <div>   — generic block container (no meaning)
  <span>  — generic inline container (no meaning)

SEMANTIC PAGE STRUCTURE:
  <header>    — introductory content, logo, nav
  <nav>       — navigation links
  <main>      — main content (ONE per page)
  <article>   — self-contained content (blog post, news)
  <section>   — thematic grouping with a heading
  <aside>     — tangentially related content (sidebar)
  <footer>    — footer content, copyright, links

CONTENT SEMANTICS:
  <figure>    — self-contained content (image, diagram, code)
  <figcaption> — caption for figure
  <details>   — disclosure widget (show/hide content)
  <summary>   — visible heading for <details>
  <dialog>    — modal dialog box
  <mark>      — highlighted/relevant text
  <time>      — date/time with machine-readable format

DOCUMENT OUTLINE:
  Browsers and screen readers build an outline from:
  heading levels + sectioning elements (<article>, <section>)
  Each sectioning element can restart heading hierarchy.

WHY SEMANTICS MATTER:
  ✅ Screen readers navigate by landmarks (header, main, nav)
  ✅ Search engines understand page structure for SEO
  ✅ Browser reader mode strips to semantic content
  ✅ CSS selectors become more readable
  ✅ Code is self-documenting

💻 CODE:
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>The Coffee Times</title>
</head>
<body>

  <!-- HEADER: site branding and main navigation -->
  <header>
    <a href="/" aria-label="The Coffee Times — Home">
      <img src="/logo.svg" alt="The Coffee Times">
    </a>
    <nav aria-label="Main Navigation">
      <ul>
        <li><a href="/">Home</a></li>
        <li><a href="/articles">Articles</a></li>
        <li><a href="/recipes">Recipes</a></li>
        <li><a href="/about">About</a></li>
      </ul>
    </nav>
  </header>

  <!-- MAIN: the primary content of this page -->
  <main>

    <!-- ARTICLE: self-contained content that could be syndicated -->
    <article>
      <header>
        <!-- article headers are fine! -->
        <h1>The Science of the Perfect Espresso</h1>
        <p>
          By <a href="/authors/alice" rel="author">Alice Chen</a>
          on <time datetime="2024-03-15">March 15, 2024</time>
        </p>
      </header>

      <!-- SECTION: thematic chunk of the article -->
      <section>
        <h2>The Golden Ratio</h2>
        <p>
          Professional baristas talk about the "golden ratio" —
          1 gram of coffee for every 2 grams of water output.
        </p>
        <figure>
          <img
            src="/images/espresso-ratio.jpg"
            alt="Diagram showing 18g coffee producing 36g espresso"
            width="600" height="400"
          >
          <figcaption>
            The 1:2 extraction ratio produces a balanced espresso.
          </figcaption>
        </figure>
      </section>

      <section>
        <h2>Temperature and Pressure</h2>
        <p>
          Water should be between
          <strong>90°C and 96°C</strong> — never boiling.
          Pressure should be exactly <mark>9 bars</mark>.
        </p>

        <!-- DETAILS: expandable content, no JavaScript needed -->
        <details>
          <summary>Why does temperature matter so much?</summary>
          <p>
            Water above 96°C over-extracts the coffee, pulling
            bitter compounds. Below 90°C, it under-extracts,
            producing sour, weak espresso.
          </p>
        </details>
      </section>

      <footer>
        <!-- article footer: tags, categories, related links -->
        <p>Tags: espresso, brewing, science, coffee</p>
      </footer>
    </article>

  </main>

  <!-- ASIDE: supplementary content related to main content -->
  <aside aria-label="Related Content">
    <h2>You Might Also Like</h2>
    <ul>
      <li><a href="/latte-art">The Art of Latte Art</a></li>
      <li><a href="/cold-brew">Cold Brew Science</a></li>
      <li><a href="/grind-size">Grind Size Explained</a></li>
    </ul>

    <section>
      <h2>Coffee Calculator</h2>
      <p>Enter your beans and we'll calculate the perfect ratio.</p>
      <!-- mini tool here -->
    </section>
  </aside>

  <!-- FOOTER: site-wide footer -->
  <footer>
    <nav aria-label="Footer Navigation">
      <ul>
        <li><a href="/privacy">Privacy Policy</a></li>
        <li><a href="/terms">Terms of Service</a></li>
        <li><a href="/contact">Contact Us</a></li>
      </ul>
    </nav>
    <p>
      <small>© 2024 The Coffee Times. All rights reserved.</small>
    </p>
  </footer>

</body>
</html>

─────────────────────────────────────
DIV vs SEMANTIC ELEMENT:
─────────────────────────────────────
<div class="header">     ← no meaning
<header>                 ← HEADER landmark

<div class="nav">        ← no meaning
<nav>                    ← NAVIGATION landmark

<div class="main">       ← no meaning
<main>                   ← MAIN landmark

<div class="article">    ← no meaning
<article>                ← self-contained content

Use <div> only when no semantic element fits.
─────────────────────────────────────

📝 KEY POINTS:
✅ ONE <main> per page — it is the primary content landmark
✅ <article> = could be syndicated independently (blog post, tweet, product card)
✅ <section> = thematic group with a heading; use when <article> is too specific
✅ <header> and <footer> can appear inside <article> and <section> too
✅ <details> + <summary> is a native accordion — no JavaScript required
✅ <aside> is for content tangentially related to the main content
❌ Don't use <section> as a generic wrapper — that is what <div> is for
❌ Don't use <article> for every single card — only for independently meaningful content
''',
  quiz: [
    Quiz(question: 'How many <main> elements should a page have?', options: [
      QuizOption(text: 'Exactly one — it represents the primary unique content of the page', correct: true),
      QuizOption(text: 'One per section', correct: false),
      QuizOption(text: 'As many as needed', correct: false),
      QuizOption(text: 'None — main is not a valid HTML element', correct: false),
    ]),
    Quiz(question: 'What is the difference between <article> and <section>?', options: [
      QuizOption(text: '<article> is self-contained and reusable; <section> is a thematic group within a page', correct: true),
      QuizOption(text: '<article> is for news only; <section> is for all other content', correct: false),
      QuizOption(text: '<section> has semantic meaning; <article> is just a styled div', correct: false),
      QuizOption(text: 'They are identical — just different names', correct: false),
    ]),
    Quiz(question: 'What does <details> + <summary> create without JavaScript?', options: [
      QuizOption(text: 'A native expandable/collapsible accordion — click summary to show/hide details', correct: true),
      QuizOption(text: 'A tooltip that appears on hover', correct: false),
      QuizOption(text: 'A modal dialog box', correct: false),
      QuizOption(text: 'A dropdown select menu', correct: false),
    ]),
  ],
);
