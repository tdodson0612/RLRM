// lib/lessons/html/html_23_cards_layouts.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final htmlLesson23 = Lesson(
  language: 'HTML',
  title: 'HTML + CSS: Cards and Grid Layouts',
  content: '''
🎯 METAPHOR:
Cards are the atoms of modern web design. Every product page,
every blog post grid, every team page, every recipe list —
they are all built from cards. A card is a contained unit
of information with an image, a heading, some body text,
and an action. Like a business card or a playing card —
a self-contained, repeatable unit.
Grid layout is the card rack that holds them — automatically
arranging however many cards there are into neat rows,
adjusting for the screen size without media queries,
because CSS Grid is smart enough to figure it out.
Together, semantic HTML structure + CSS Grid + cards
= the most common layout pattern on the modern web.

📖 EXPLANATION:
CARD HTML STRUCTURE:
  <article> for independent cards (products, blog posts)
  <div>     for dependent cards (UI components)
  Always: heading, description, and a visible action

GRID PATTERNS:
  auto-fill + minmax: responsive without media queries
  named areas: header/sidebar/main/footer layouts
  subgrid: align content ACROSS cards

CSS TECHNIQUES:
  aspect-ratio: force image proportions
  object-fit: fill images without distortion
  clamp(): fluid font sizes
  overflow: hidden + border-radius for image clips
  :hover transform + box-shadow for lift effect
  transition + cubic-bezier for easing

💻 CODE:
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Coffee Shop — Our Menu</title>
  <style>
    :root {
      --brand:    #6c63ff;
      --surface:  #ffffff;
      --bg:       #f5f5fc;
      --text:     #1a1a2e;
      --muted:    #6b7280;
      --border:   #e5e7eb;
      --shadow-sm: 0 1px 3px rgba(0,0,0,0.07), 0 1px 2px rgba(0,0,0,0.05);
      --shadow-md: 0 10px 25px rgba(108,99,255,0.12), 0 4px 6px rgba(0,0,0,0.06);
    }

    *, *::before, *::after { box-sizing: border-box; margin: 0; }

    body {
      font-family: system-ui, sans-serif;
      background: var(--bg);
      color: var(--text);
    }

    /* ─── PAGE WRAPPER ─── */
    .page {
      max-width: 1200px;
      margin: 0 auto;
      padding: 3rem 1.5rem;
    }

    /* ─── SECTION HEADER ─── */
    .section-header {
      text-align: center;
      margin-bottom: 3rem;
    }

    .section-header__eyebrow {
      display: inline-block;
      font-size: 0.8rem;
      font-weight: 700;
      text-transform: uppercase;
      letter-spacing: 0.1em;
      color: var(--brand);
      margin-bottom: 0.5rem;
    }

    .section-header__title {
      font-size: clamp(1.75rem, 4vw, 2.75rem);
      font-weight: 800;
      line-height: 1.2;
      margin-bottom: 1rem;
    }

    .section-header__desc {
      max-width: 520px;
      margin: 0 auto;
      color: var(--muted);
      font-size: 1.05rem;
      line-height: 1.6;
    }

    /* ─── RESPONSIVE CARD GRID ─── */
    .card-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(min(280px, 100%), 1fr));
      gap: 1.5rem;
    }

    /* ─── PRODUCT CARD ─── */
    .product-card {
      background: var(--surface);
      border-radius: 16px;
      overflow: hidden;
      box-shadow: var(--shadow-sm);
      transition: transform 0.25s cubic-bezier(0.34, 1.56, 0.64, 1),
                  box-shadow 0.25s ease;
      display: flex;
      flex-direction: column;
    }

    .product-card:hover {
      transform: translateY(-6px);
      box-shadow: var(--shadow-md);
    }

    /* ─── CARD IMAGE ─── */
    .product-card__img-wrap {
      position: relative;
      aspect-ratio: 4 / 3;
      overflow: hidden;
      background: #e8e8f0;
    }

    .product-card__img {
      width: 100%;
      height: 100%;
      object-fit: cover;
      transition: transform 0.4s ease;
    }

    .product-card:hover .product-card__img {
      transform: scale(1.05);
    }

    /* Badge on image */
    .product-card__badge {
      position: absolute;
      top: 0.75rem;
      left: 0.75rem;
      background: var(--brand);
      color: white;
      font-size: 0.7rem;
      font-weight: 700;
      text-transform: uppercase;
      letter-spacing: 0.05em;
      padding: 0.25rem 0.6rem;
      border-radius: 999px;
    }

    /* ─── CARD BODY ─── */
    .product-card__body {
      padding: 1.25rem;
      display: flex;
      flex-direction: column;
      gap: 0.5rem;
      flex: 1;
    }

    .product-card__category {
      font-size: 0.75rem;
      font-weight: 600;
      text-transform: uppercase;
      letter-spacing: 0.08em;
      color: var(--brand);
    }

    .product-card__title {
      font-size: 1.1rem;
      font-weight: 700;
      line-height: 1.3;
    }

    .product-card__desc {
      font-size: 0.9rem;
      color: var(--muted);
      line-height: 1.5;
      flex: 1;
    }

    /* ─── CARD FOOTER ─── */
    .product-card__footer {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 0 1.25rem 1.25rem;
      margin-top: auto;
    }

    .product-card__price {
      font-size: 1.25rem;
      font-weight: 800;
      color: var(--brand);
    }

    .product-card__price-old {
      font-size: 0.85rem;
      color: var(--muted);
      text-decoration: line-through;
    }

    .btn-card {
      padding: 0.5rem 1.1rem;
      background: var(--brand);
      color: white;
      border: none;
      border-radius: 8px;
      font-size: 0.875rem;
      font-weight: 600;
      cursor: pointer;
      transition: background 0.15s, transform 0.1s;
      font-family: inherit;
    }

    .btn-card:hover     { background: #5a52d5; }
    .btn-card:active    { transform: scale(0.96); }
    .btn-card:focus-visible {
      outline: 3px solid var(--brand);
      outline-offset: 3px;
    }

    /* ─── FEATURE CARD (horizontal layout) ─── */
    .feature-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
      gap: 1rem;
      margin-top: 3rem;
    }

    .feature-card {
      background: var(--surface);
      border-radius: 12px;
      padding: 1.5rem;
      border: 1px solid var(--border);
      text-align: center;
    }

    .feature-card__icon {
      font-size: 2.5rem;
      display: block;
      margin-bottom: 0.75rem;
    }

    .feature-card__title {
      font-weight: 700;
      margin-bottom: 0.5rem;
    }

    .feature-card__desc {
      font-size: 0.875rem;
      color: var(--muted);
      line-height: 1.5;
    }
  </style>
</head>
<body>

<main class="page" id="main">

  <div class="section-header">
    <span class="section-header__eyebrow">☕ Our Selection</span>
    <h1 class="section-header__title">Single Origin Coffees</h1>
    <p class="section-header__desc">
      Ethically sourced from small farms. Expertly roasted
      and delivered fresh to your door.
    </p>
  </div>

  <!-- Responsive card grid — no media queries needed! -->
  <div class="card-grid" role="list">

    <article class="product-card" role="listitem">
      <div class="product-card__img-wrap">
        <img
          class="product-card__img"
          src="/images/ethiopian.jpg"
          alt="Ethiopian Yirgacheffe light roast coffee in a white bag"
          width="400" height="300"
          loading="lazy"
        >
        <span class="product-card__badge">⭐ Best Seller</span>
      </div>
      <div class="product-card__body">
        <span class="product-card__category">Ethiopia · Light Roast</span>
        <h2 class="product-card__title">Yirgacheffe Natural</h2>
        <p class="product-card__desc">
          Bright and floral with pronounced blueberry and
          jasmine notes. A truly spectacular morning coffee.
        </p>
      </div>
      <div class="product-card__footer">
        <div>
          <span class="product-card__price-old">\$16.99</span>
          <span class="product-card__price">\$13.99</span>
        </div>
        <button class="btn-card" type="button">Add to Cart</button>
      </div>
    </article>

    <article class="product-card" role="listitem">
      <div class="product-card__img-wrap">
        <img
          class="product-card__img"
          src="/images/colombian.jpg"
          alt="Colombian Huila medium roast coffee beans close up"
          width="400" height="300"
          loading="lazy"
        >
        <span class="product-card__badge">🆕 New Arrival</span>
      </div>
      <div class="product-card__body">
        <span class="product-card__category">Colombia · Medium Roast</span>
        <h2 class="product-card__title">Huila Washed</h2>
        <p class="product-card__desc">
          Classic balanced cup with caramel sweetness,
          mild citrus brightness, and a clean finish.
        </p>
      </div>
      <div class="product-card__footer">
        <span class="product-card__price">\$14.99</span>
        <button class="btn-card" type="button">Add to Cart</button>
      </div>
    </article>

    <article class="product-card" role="listitem">
      <div class="product-card__img-wrap">
        <img
          class="product-card__img"
          src="/images/guatemalan.jpg"
          alt="Guatemalan Antigua dark roast coffee poured into cup"
          width="400" height="300"
          loading="lazy"
        >
      </div>
      <div class="product-card__body">
        <span class="product-card__category">Guatemala · Dark Roast</span>
        <h2 class="product-card__title">Antigua Dark</h2>
        <p class="product-card__desc">
          Bold, smoky, and intense. Dark chocolate and
          molasses character with a heavy body.
        </p>
      </div>
      <div class="product-card__footer">
        <span class="product-card__price">\$15.99</span>
        <button class="btn-card" type="button">Add to Cart</button>
      </div>
    </article>

  </div>

  <!-- Feature cards -->
  <div class="feature-grid">
    <div class="feature-card">
      <span class="feature-card__icon">🌱</span>
      <h3 class="feature-card__title">Ethically Sourced</h3>
      <p class="feature-card__desc">Direct trade with farming families for fair prices and sustainable practices.</p>
    </div>
    <div class="feature-card">
      <span class="feature-card__icon">🔥</span>
      <h3 class="feature-card__title">Roasted Fresh</h3>
      <p class="feature-card__desc">Roasted to order and shipped within 24 hours for peak freshness.</p>
    </div>
    <div class="feature-card">
      <span class="feature-card__icon">📦</span>
      <h3 class="feature-card__title">Free Shipping</h3>
      <p class="feature-card__desc">Free shipping on all orders over \$35 with our compostable packaging.</p>
    </div>
    <div class="feature-card">
      <span class="feature-card__icon">⭐</span>
      <h3 class="feature-card__title">4.9 Star Rating</h3>
      <p class="feature-card__desc">Over 12,000 verified reviews from happy coffee lovers worldwide.</p>
    </div>
  </div>

</main>
</body>
</html>

📝 KEY POINTS:
✅ repeat(auto-fill, minmax(280px, 1fr)) creates responsive grid with no media queries
✅ aspect-ratio on the image wrapper enforces consistent card proportions
✅ object-fit: cover fills the image container without distortion
✅ overflow: hidden on the image wrapper clips the zoom effect on hover
✅ flex-direction: column + flex: 1 on description pushes footer to bottom
✅ cubic-bezier(0.34, 1.56, 0.64, 1) creates a satisfying springy bounce effect
❌ Don't use <article> for every card — only for independently meaningful content
❌ Don't animate width/height — use transform: scale() for smooth GPU-accelerated zoom
''',
  quiz: [
    Quiz(question: 'What does repeat(auto-fill, minmax(280px, 1fr)) accomplish?', options: [
      QuizOption(text: 'Creates as many 280px-minimum columns as fit — automatically responsive without media queries', correct: true),
      QuizOption(text: 'Creates exactly 3 columns that are each 280px wide', correct: false),
      QuizOption(text: 'Fills the grid with items that are exactly 280px tall', correct: false),
      QuizOption(text: 'Repeats the grid layout pattern 280 times', correct: false),
    ]),
    Quiz(question: 'Why use aspect-ratio on the image wrapper instead of setting height directly?', options: [
      QuizOption(text: 'aspect-ratio maintains the correct proportions at any width — height alone is fixed and breaks responsiveness', correct: true),
      QuizOption(text: 'aspect-ratio is faster to render', correct: false),
      QuizOption(text: 'height attribute is deprecated in modern CSS', correct: false),
      QuizOption(text: 'aspect-ratio works with images; height does not', correct: false),
    ]),
    Quiz(question: 'How does flex: 1 on the card description push the footer to the bottom?', options: [
      QuizOption(text: 'It makes the description grow to fill remaining space — pushing the footer down', correct: true),
      QuizOption(text: 'It makes the description font size flexible', correct: false),
      QuizOption(text: 'It enables the description to wrap to the next line', correct: false),
      QuizOption(text: 'It sets the description width to 100%', correct: false),
    ]),
  ],
);
