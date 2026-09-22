// lib/lessons/html/html_14_canvas_svg.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final htmlLesson14 = Lesson(
  language: 'HTML',
  title: 'Canvas and SVG',
  content: '''
🎯 METAPHOR:
Canvas is like a blank canvas for a painter — you get a
rectangular area of raw pixels and a paintbrush (JavaScript).
Every mark you make is immediate and permanent. Paint over it
and the old paint is gone. It remembers PIXELS, not shapes.
Perfect for games, particle effects, and photo filters.

SVG is like a set of geometric blueprints. The browser
remembers every shape, every path, every element as a
mathematical description. Scale it up, scale it down —
it stays perfectly crisp. Click on a circle and it's
a real DOM element you can animate and style with CSS.
Perfect for icons, charts, diagrams, and logos.

📖 EXPLANATION:
<canvas>:
  Pixel-based drawing surface
  Scripted entirely with JavaScript (2D or WebGL)
  Raster — pixels, not shapes
  Not accessible by default — add fallback content
  Use for: games, visualizations, image processing, WebGL 3D

<svg>:
  Vector graphics in HTML
  Scalable — crisp at any size
  Each shape is a DOM element (selectable, styleable)
  Can be inline (full CSS/JS access) or as <img src="...svg">
  Use for: icons, logos, charts, maps, diagrams

SVG ELEMENTS:
  <circle cx cy r>           — circle
  <rect x y width height rx> — rectangle (rx = rounded corners)
  <line x1 y1 x2 y2>        — straight line
  <polyline points>          — open polygon
  <polygon points>           — closed polygon
  <path d>                   — any shape (bezier, arcs, lines)
  <text x y>                 — text
  <g>                        — group of elements
  <defs>                     — reusable definitions
  <use href="#id">           — clone a defined element
  <symbol>                   — reusable template
  <linearGradient>           — gradient fill
  <radialGradient>           — radial gradient
  <clipPath>                 — clip shape
  <mask>                     — mask shape
  <filter>                   — visual filter

💻 CODE:
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Canvas and SVG</title>
</head>
<body>

<!-- ─── CANVAS ─── -->
<canvas
  id="myCanvas"
  width="500"
  height="300"
  aria-label="Animated star field"
  role="img"
>
  <!-- Fallback for no-JS / screen readers -->
  A visualization of the night sky with animated stars.
</canvas>

<script>
const canvas = document.getElementById('myCanvas');
const ctx = canvas.getContext('2d');

// Background
ctx.fillStyle = '#0a0a2e';
ctx.fillRect(0, 0, 500, 300);

// Stars
for (let i = 0; i < 200; i++) {
  const x = Math.random() * 500;
  const y = Math.random() * 300;
  const r = Math.random() * 2;
  ctx.beginPath();
  ctx.arc(x, y, r, 0, Math.PI * 2);
  ctx.fillStyle = 'white';
  ctx.fill();
}

// Moon
ctx.beginPath();
ctx.arc(400, 80, 40, 0, Math.PI * 2);
ctx.fillStyle = '#fffde7';
ctx.fill();

// Crescent cutout
ctx.beginPath();
ctx.arc(415, 75, 35, 0, Math.PI * 2);
ctx.fillStyle = '#0a0a2e';
ctx.fill();

// Text
ctx.font = 'bold 20px Arial';
ctx.fillStyle = 'white';
ctx.fillText('The Night Sky 🌙', 20, 280);
</script>

<!-- ─── INLINE SVG ─── -->
<svg
  xmlns="http://www.w3.org/2000/svg"
  viewBox="0 0 400 300"
  width="400"
  height="300"
  role="img"
  aria-labelledby="svg-title svg-desc"
>
  <title id="svg-title">Colorful geometric shapes</title>
  <desc id="svg-desc">
    A purple circle, teal rectangle, and decorative path
    illustrating SVG shapes.
  </desc>

  <!-- Background -->
  <rect width="400" height="300" fill="#1a1a2e" rx="12"/>

  <!-- Circle -->
  <circle cx="100" cy="150" r="70" fill="#6c63ff" opacity="0.9"/>

  <!-- Rectangle with rounded corners -->
  <rect x="180" y="80" width="160" height="100" rx="12" ry="12"
    fill="#00bcd4" opacity="0.85"/>

  <!-- Line -->
  <line x1="0" y1="0" x2="400" y2="300"
    stroke="white" stroke-width="1" opacity="0.2"/>

  <!-- Path (star shape) -->
  <path
    d="M 340 30 L 350 10 L 360 30 L 380 35 L 363 48 L 367 70 L 350 57 L 333 70 L 337 48 L 320 35 Z"
    fill="#ffeb3b"
  />

  <!-- Text -->
  <text x="20" y="280" font-family="Arial" font-size="16"
    font-weight="bold" fill="white">
    SVG Shapes 🎨
  </text>

  <!-- Group with transform -->
  <g transform="translate(200, 200)">
    <circle cx="0" cy="0" r="20" fill="#e91e8c"/>
    <text x="0" y="5" text-anchor="middle"
      font-size="14" fill="white">CSS</text>
  </g>
</svg>

<!-- ─── SVG ICONS (SPRITE PATTERN) ─── -->
<!-- Define once in a hidden SVG -->
<svg xmlns="http://www.w3.org/2000/svg" hidden>
  <symbol id="icon-heart" viewBox="0 0 24 24">
    <path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5
             2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09
             C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5
             c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/>
  </symbol>
  <symbol id="icon-star" viewBox="0 0 24 24">
    <path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2
             9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/>
  </symbol>
</svg>

<!-- Use icons anywhere, styled with CSS -->
<button type="button" aria-label="Like this post">
  <svg width="24" height="24" aria-hidden="true" focusable="false">
    <use href="#icon-heart"/>
  </svg>
  Like
</button>

<button type="button">
  <svg width="24" height="24" aria-hidden="true" focusable="false">
    <use href="#icon-star"/>
  </svg>
  Favorite
</button>

<!-- ─── SVG GRADIENT ─── -->
<svg viewBox="0 0 200 100" width="200" height="100">
  <defs>
    <linearGradient id="grad1" x1="0%" y1="0%" x2="100%" y2="0%">
      <stop offset="0%"   stop-color="#6c63ff"/>
      <stop offset="100%" stop-color="#e91e8c"/>
    </linearGradient>
  </defs>
  <rect width="200" height="100" rx="10" fill="url(#grad1)"/>
  <text x="100" y="60" text-anchor="middle"
    font-size="20" font-weight="bold" fill="white">
    Gradient!
  </text>
</svg>

</body>
</html>

─────────────────────────────────────
CANVAS vs SVG:
─────────────────────────────────────
Canvas     pixels, JS-only, games, filters, WebGL
SVG        vectors, CSS+JS, icons, charts, logos

Use Canvas for: particle effects, games, image manipulation
Use SVG for:    icons, logos, infographics, interactive charts
─────────────────────────────────────

📝 KEY POINTS:
✅ Canvas needs JavaScript to draw anything — provide a fallback text description
✅ SVG inline gives full CSS and JavaScript access to every shape
✅ SVG sprite pattern (<symbol> + <use>) keeps icon code DRY and efficient
✅ viewBox on SVG enables responsive scaling
✅ Add role="img" and aria-labelledby to SVG for accessibility
❌ Canvas has no DOM elements — you can't click a shape without manual hit detection
❌ Don't use SVG for photos/complex images — use img with JPEG/WebP
''',
  quiz: [
    Quiz(question: 'What is the key difference between Canvas and SVG?', options: [
      QuizOption(text: 'Canvas draws pixels (raster); SVG describes shapes (vector) that scale without quality loss', correct: true),
      QuizOption(text: 'SVG requires JavaScript; Canvas does not', correct: false),
      QuizOption(text: 'Canvas is for static images; SVG is for animations', correct: false),
      QuizOption(text: 'They are identical — just different syntax', correct: false),
    ]),
    Quiz(question: 'What does the SVG sprite pattern with <symbol> and <use> accomplish?', options: [
      QuizOption(text: 'Defines icons once and reuses them anywhere on the page without duplication', correct: true),
      QuizOption(text: 'Creates animated SVG icons', correct: false),
      QuizOption(text: 'Loads SVG icons from an external file', correct: false),
      QuizOption(text: 'Groups related SVG elements for styling', correct: false),
    ]),
    Quiz(question: 'What does viewBox on an SVG element do?', options: [
      QuizOption(text: 'Defines the coordinate system and enables responsive scaling of the SVG', correct: true),
      QuizOption(text: 'Sets the visible viewport of the SVG in the browser', correct: false),
      QuizOption(text: 'Creates a scrollable box around the SVG', correct: false),
      QuizOption(text: 'Limits which part of the SVG is drawn', correct: false),
    ]),
  ],
);
