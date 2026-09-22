// lib/lessons/css/css_29_container_queries.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final cssLesson29 = Lesson(
  language: 'CSS',
  title: 'Container Queries',
  content: '''
🎯 METAPHOR:
Media queries listen to the WINDOW. "Is the browser window
wider than 768px? OK, change the layout."
Container queries listen to the PARENT. "Is THIS card's
container wider than 400px? OK, switch to horizontal layout."

The difference is massive. With media queries, a sidebar card
and a main content card have to share the same breakpoints
even if they have completely different widths. With container
queries, each component responds to its OWN available space.
A card is narrow when its container is narrow — regardless of
screen size. Components finally become truly reusable.

📖 EXPLANATION:
CONTAINER QUERIES (widely supported since late 2023):

On the PARENT — define a named container:
  container-type: inline-size  — respond to width
  container-type: size         — respond to width AND height
  container-name: card-grid    — optional name for targeting

On the COMPONENT — query the container:
  @container (min-width: 400px) { ... }
  @container card-grid (min-width: 600px) { ... }

CONTAINER QUERY UNITS:
  cqw   1% of container width
  cqh   1% of container height
  cqi   1% of container inline size
  cqb   1% of container block size
  cqmin smaller of cqi and cqb
  cqmax larger of cqi and cqb

STYLE QUERIES (newer):
  Query a container's custom property value:
  @container style(--variant: dark) { ... }

💻 CODE:
/* ─── BASIC CONTAINER QUERY ─── */
/* Step 1: Make the parent a container */
.card-container {
  container-type: inline-size;
  container-name: card;
  /* shorthand: container: card / inline-size; */
}

/* Step 2: Style the component based on container size */
.card {
  display: flex;
  flex-direction: column;
  gap: 1rem;
  padding: 1rem;
}

/* When the CONTAINER is at least 400px wide */
@container card (min-width: 400px) {
  .card {
    flex-direction: row;  /* switch to horizontal */
  }

  .card-image {
    width: 40%;
    flex-shrink: 0;
  }
}

@container card (min-width: 600px) {
  .card {
    padding: 2rem;
    font-size: 1.125rem;
  }
}

/* ─── REAL-WORLD: COMPONENT THAT WORKS ANYWHERE ─── */
/* This product card looks right whether it's in:
   - A 3-column grid (narrow containers)
   - A sidebar (very narrow)
   - A full-width feature (wide container)
   No per-page CSS needed! */

.product-grid {
  container-type: inline-size;
}

.product-card {
  /* Default: stacked layout for narrow containers */
  display: grid;
  grid-template-areas:
    "image"
    "title"
    "price"
    "button";
  gap: 0.75rem;
}

.product-card img   { grid-area: image; width: 100%; }
.product-card h3    { grid-area: title; }
.product-card .price { grid-area: price; }
.product-card button { grid-area: button; }

/* Medium container: side-by-side */
@container (min-width: 350px) {
  .product-card {
    grid-template-columns: 120px 1fr;
    grid-template-areas:
      "image title"
      "image price"
      "image button";
  }
}

/* Wide container: full horizontal with more info */
@container (min-width: 550px) {
  .product-card {
    grid-template-columns: 200px 1fr auto;
    grid-template-areas:
      "image title  button"
      "image price  button";
    align-items: center;
  }
}

/* ─── CONTAINER QUERY UNITS ─── */
.hero-text {
  /* Font size scales with container, not viewport */
  font-size: clamp(1.5rem, 5cqw, 4rem);
  /* 5% of container width, clamped between 1.5rem and 4rem */
}

.responsive-padding {
  padding: 2cqi;  /* 2% of container inline size */
}

/* ─── NAMED CONTAINERS ─── */
.sidebar {
  container: sidebar / inline-size;
}

.main-content {
  container: main / inline-size;
}

/* Target specific container by name */
@container sidebar (min-width: 300px) {
  .widget { flex-direction: row; }
}

@container main (min-width: 600px) {
  .widget { grid-template-columns: repeat(3, 1fr); }
}

/* ─── STYLE QUERIES ─── */
/* Container defines a custom property */
.card[data-theme="dark"] {
  --card-theme: dark;
}

/* Child queries the container's style */
@container style(--card-theme: dark) {
  .card-title { color: white; }
  .card-body  { color: rgba(255,255,255,0.8); }
}

/* ─── COMBINED: MEDIA + CONTAINER ─── */
/* Media query for overall layout */
@media (min-width: 768px) {
  .layout {
    display: grid;
    grid-template-columns: 280px 1fr;
  }
}

/* Container query for component inside layout */
.card-wrapper {
  container-type: inline-size;
}

@container (min-width: 300px) {
  .feature-card {
    display: flex;
    gap: 1rem;
  }
}

📝 KEY POINTS:
✅ container-type: inline-size makes an element a container for width-based queries
✅ Container queries make components truly self-contained and reusable
✅ Use container query units (cqw, cqi) for typography that scales to the container
✅ Named containers let you query a specific ancestor, not just the nearest one
✅ Combine media queries (overall layout) with container queries (component style)
❌ You cannot query the container from within itself — only descendants can query it
❌ The container must have an explicit container-type — it is not inherited
''',
  quiz: [
    Quiz(question: 'What does container-type: inline-size do?', options: [
      QuizOption(text: 'Makes the element a container that children can query by width', correct: true),
      QuizOption(text: 'Makes the element respond to the viewport width', correct: false),
      QuizOption(text: 'Sets the container display to inline-block', correct: false),
      QuizOption(text: 'Limits the element\'s width to its inline content', correct: false),
    ]),
    Quiz(question: 'What is the main advantage of container queries over media queries?', options: [
      QuizOption(text: 'Components respond to their own available space — not the viewport', correct: true),
      QuizOption(text: 'Container queries are faster to process', correct: false),
      QuizOption(text: 'Container queries work without CSS custom properties', correct: false),
      QuizOption(text: 'Container queries replace all media queries', correct: false),
    ]),
    Quiz(question: 'What does the cqw unit represent?', options: [
      QuizOption(text: '1% of the nearest container\'s width', correct: true),
      QuizOption(text: '1% of the viewport width', correct: false),
      QuizOption(text: 'The container query width breakpoint', correct: false),
      QuizOption(text: '1% of the root element width', correct: false),
    ]),
  ],
);
