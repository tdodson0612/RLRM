// lib/lessons/html/html_16_structure_divs_spans.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final htmlLesson16 = Lesson(
  language: 'HTML',
  title: 'Structure: div, span, and Layout Containers',
  content: '''
🎯 METAPHOR:
If semantic elements are the named rooms of a house
(kitchen, bedroom, bathroom), then <div> and <span>
are like the internal walls, shelves, and boxes inside
those rooms. They create structure and grouping without
adding meaning. The kitchen (main) might have several
divs inside it: a counter area, a prep station, a storage
unit. The semantic label is on the room. The divs just
organize the furniture.

<span> is the world's smallest invisible container —
a tiny wrapper that touches only what it directly surrounds.
"The word <span class="highlight">coffee</span> is wonderful."
No line breaks, no spacing. Just an invisible hook for CSS
or JavaScript to grab onto.

📖 EXPLANATION:
<div>:
  Generic BLOCK container.
  Creates a new block — like a paragraph break.
  No semantic meaning whatsoever.
  Perfect for grouping elements for CSS/JS purposes.
  Use when no semantic element fits.

<span>:
  Generic INLINE container.
  Wraps inline content — no block created.
  Use for targeting words or characters with CSS/JS.
  No semantic meaning.

THE HIERARCHY:
  Structural (semantic):   header, main, footer, nav, aside
  Content (semantic):      article, section, figure, blockquote
  Non-semantic:            div (block), span (inline)

WHEN TO USE EACH:
  header/main/footer      → page structure
  article/section         → content organization
  nav                     → navigation
  aside                   → supplementary content
  figure/figcaption       → captioned content
  div                     → CSS grouping, layout containers
  span                    → inline CSS/JS targeting

COMMON DIV PATTERNS:
  .container — max-width centering wrapper
  .wrapper   — general wrapper
  .card      — content card component
  .grid      — CSS Grid container
  .flex      — Flexbox container
  .sr-only   — screen reader only text

💻 CODE:
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Structure Demo</title>
  <style>
    .container {
      max-width: 1200px;
      margin: 0 auto;
      padding: 0 1rem;
    }

    .card-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
      gap: 1.5rem;
    }

    .card {
      background: white;
      border-radius: 12px;
      padding: 1.5rem;
      box-shadow: 0 2px 12px rgba(0,0,0,0.08);
    }

    .badge {
      display: inline-block;
      padding: 0.2em 0.6em;
      border-radius: 999px;
      font-size: 0.75rem;
      font-weight: 700;
      text-transform: uppercase;
      letter-spacing: 0.05em;
    }

    .badge--new     { background: #e8f5e9; color: #2e7d32; }
    .badge--popular { background: #fff3e0; color: #e65100; }
    .badge--sale    { background: #fce4ec; color: #880e4f; }

    .price-old {
      text-decoration: line-through;
      color: #999;
    }

    .price-new {
      font-size: 1.5rem;
      font-weight: 700;
      color: #6c63ff;
    }

    .highlight {
      background: linear-gradient(120deg, #fff176 0%, #fff59d 100%);
      padding: 0 0.2em;
      border-radius: 3px;
    }

    .visually-hidden {
      position: absolute;
      width: 1px;
      height: 1px;
      padding: 0;
      margin: -1px;
      overflow: hidden;
      clip: rect(0, 0, 0, 0);
      white-space: nowrap;
      border-width: 0;
    }
  </style>
</head>
<body>

  <!-- FULL PAGE STRUCTURE -->
  <header>
    <!-- div: centering wrapper (semantic doesn't matter here) -->
    <div class="container">
      <a href="/" aria-label="Home">
        <img src="/logo.svg" alt="BeanCo Coffee" width="120" height="40">
      </a>
      <nav aria-label="Main">
        <ul>
          <li><a href="/shop">Shop</a></li>
          <li><a href="/about">About</a></li>
        </ul>
      </nav>
    </div>
  </header>

  <main>
    <div class="container">

      <h1>Our Coffee Collection</h1>

      <!-- CARD GRID: divs for layout -->
      <div class="card-grid" role="list">

        <!-- CARD: div for component grouping -->
        <div class="card" role="listitem">
          <img
            src="/images/espresso.jpg"
            alt="Dark roasted espresso beans in a white bowl"
            width="280" height="180" loading="lazy"
          >

          <!-- span: inline badge, no semantic meaning -->
          <span class="badge badge--popular">⭐ Popular</span>

          <h2>Dark Roast Espresso</h2>

          <p>
            Our signature blend is
            <span class="highlight">intensely bold</span>
            with notes of dark chocolate and cherry.
          </p>

          <div class="price">
            <!-- span: target old/new price independently -->
            <span class="price-old">\$14.99</span>
            <span class="price-new">\$11.99</span>
            <!-- visually hidden text for screen readers -->
            <span class="visually-hidden">
              On sale — was \$14.99, now \$11.99
            </span>
          </div>

          <button type="button">Add to Cart</button>
        </div>

        <div class="card" role="listitem">
          <img
            src="/images/latte.jpg"
            alt="Latte art in a ceramic cup showing a leaf pattern"
            width="280" height="180" loading="lazy"
          >
          <span class="badge badge--new">✨ New</span>
          <h2>Oat Milk Latte Blend</h2>
          <p>
            Creamy and smooth, this blend is
            <span class="highlight">specially crafted</span>
            to pair perfectly with plant milks.
          </p>
          <div class="price">
            <span class="price-new">\$13.99</span>
          </div>
          <button type="button">Add to Cart</button>
        </div>

        <div class="card" role="listitem">
          <img
            src="/images/cold-brew.jpg"
            alt="Cold brew coffee in a tall glass with ice"
            width="280" height="180" loading="lazy"
          >
          <span class="badge badge--sale">🔥 Sale</span>
          <h2>Cold Brew Concentrate</h2>
          <p>
            Steep for 24 hours for the
            <span class="highlight">smoothest cold brew</span>
            you've ever tasted.
          </p>
          <div class="price">
            <span class="price-old">\$18.99</span>
            <span class="price-new">\$14.99</span>
            <span class="visually-hidden">
              Sale — was \$18.99, now \$14.99
            </span>
          </div>
          <button type="button">Add to Cart</button>
        </div>

      </div><!-- .card-grid -->

    </div><!-- .container -->
  </main>

  <footer>
    <div class="container">
      <p>
        <small>© 2024 BeanCo. Made with
          <span aria-label="love">❤️</span>
          and <span aria-label="coffee">☕</span>
        </small>
      </p>
    </div>
  </footer>

</body>
</html>

📝 KEY POINTS:
✅ <div> is the go-to wrapper for CSS layout (grid, flex, containers)
✅ <span> targets inline content for CSS classes or JS hooks
✅ .container with max-width + margin: auto is the universal centering pattern
✅ visually-hidden class provides context for screen readers invisible on screen
✅ Use semantic elements first — reach for <div> when nothing semantic fits
✅ Class names should describe PURPOSE not appearance (.card, not .blue-box)
❌ Don't wrap everything in divs — use semantic elements where they exist
❌ <div> inside <p> is invalid HTML — paragraphs can only contain inline content
''',
  quiz: [
    Quiz(question: 'What is the key difference between <div> and <span>?', options: [
      QuizOption(text: '<div> is a block-level container; <span> is an inline container', correct: true),
      QuizOption(text: '<div> has semantic meaning; <span> does not', correct: false),
      QuizOption(text: '<span> creates a new line; <div> does not', correct: false),
      QuizOption(text: 'They are identical — just different conventions', correct: false),
    ]),
    Quiz(question: 'When should you use a <div> instead of a semantic element?', options: [
      QuizOption(text: 'When no semantic element fits the purpose — purely for CSS/JS grouping', correct: true),
      QuizOption(text: 'Always — divs are more flexible than semantic elements', correct: false),
      QuizOption(text: 'When the content is not important to search engines', correct: false),
      QuizOption(text: 'Only inside <main> elements', correct: false),
    ]),
    Quiz(question: 'Why is <div> inside <p> invalid HTML?', options: [
      QuizOption(text: 'Paragraphs can only contain inline elements — div is block-level', correct: true),
      QuizOption(text: 'Divs cannot be nested inside any other element', correct: false),
      QuizOption(text: 'It is valid HTML but bad practice', correct: false),
      QuizOption(text: 'Paragraphs cannot have children at all', correct: false),
    ]),
  ],
);
