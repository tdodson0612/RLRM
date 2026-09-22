// lib/lessons/html/html_29_animations_effects.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final htmlLesson29 = Lesson(
  language: 'HTML',
  title: 'HTML + CSS: Animations and Visual Effects',
  content: '''
🎯 METAPHOR:
Animation is the difference between a photograph and a film.
Both can be beautiful. But film communicates RELATIONSHIPS:
this element appears because you scrolled here. This panel
slides in from the left because you clicked that button.
This number counts up because the data just arrived.
Animation tells the story of what is happening — it makes
cause and effect visible. Good animation is invisible in
the sense that it feels natural, not flashy. Bad animation
is a disco ball: technically impressive, practically blinding.
CSS gives you a full animation studio. Use it to communicate,
not to impress.

📖 EXPLANATION:
CSS ANIMATION TOOLS:
  transition        — smooth state changes (:hover, :focus)
  @keyframes        — defined animation sequences
  animation         — apply keyframes to elements
  transform         — move, scale, rotate, skew (GPU)
  will-change       — prep GPU layer
  animation-timeline (new) — scroll-driven animations

ENTRANCE PATTERNS:
  fadeIn, fadeUp, fadeLeft, scaleIn — appear on load
  stagger delays — sequential cascade effect

INTERACTION PATTERNS:
  hover lift     — translateY(-4px) + shadow
  press feedback — scale(0.96) on :active
  ripple effect  — expanding circle from click point
  smooth reveal  — opacity + translateY on scroll

SCROLL-DRIVEN (modern):
  animation-timeline: scroll()     — tied to page scroll
  animation-timeline: view()       — tied to element in view
  animation-range: entry 0% 100%  — when to start/end

PERFORMANCE RULES:
  ✅ Animate only transform and opacity (GPU-accelerated)
  ✅ will-change: transform before heavy animations
  ❌ Never animate width, height, top, left (layout triggers)
  ✅ prefers-reduced-motion: respect user preference

💻 CODE:
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Animation Gallery — BeanCo</title>
  <style>
    :root {
      --brand:  #6c63ff;
      --accent: #f472b6;
      --dark:   #1a1a2e;
    }

    *, *::before, *::after { box-sizing: border-box; margin: 0; }

    body {
      font-family: system-ui, sans-serif;
      background: var(--dark);
      color: white;
      overflow-x: hidden;
    }

    section {
      min-height: 100vh;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      padding: 4rem 2rem;
      gap: 2rem;
    }

    h2 {
      font-size: 0.8rem;
      text-transform: uppercase;
      letter-spacing: 0.15em;
      color: rgba(255,255,255,0.4);
      margin-bottom: 0.5rem;
    }

    /* ─── ENTRANCE ANIMATIONS ─── */
    @keyframes fadeIn {
      from { opacity: 0; }
      to   { opacity: 1; }
    }

    @keyframes fadeUp {
      from { opacity: 0; transform: translateY(32px); }
      to   { opacity: 1; transform: translateY(0); }
    }

    @keyframes fadeLeft {
      from { opacity: 0; transform: translateX(-32px); }
      to   { opacity: 1; transform: translateX(0); }
    }

    @keyframes scaleIn {
      from { opacity: 0; transform: scale(0.85); }
      to   { opacity: 1; transform: scale(1); }
    }

    @keyframes slideDown {
      from { opacity: 0; transform: translateY(-20px); }
      to   { opacity: 1; transform: translateY(0); }
    }

    /* Apply to elements */
    .animate-fade-up  { animation: fadeUp  0.6s cubic-bezier(0.22,1,0.36,1) both; }
    .animate-fade-in  { animation: fadeIn  0.5s ease both; }
    .animate-scale-in { animation: scaleIn 0.5s cubic-bezier(0.34,1.56,0.64,1) both; }

    /* Stagger: delay each child */
    .stagger > * { animation: fadeUp 0.6s cubic-bezier(0.22,1,0.36,1) both; }
    .stagger > *:nth-child(1) { animation-delay: 0.0s; }
    .stagger > *:nth-child(2) { animation-delay: 0.1s; }
    .stagger > *:nth-child(3) { animation-delay: 0.2s; }
    .stagger > *:nth-child(4) { animation-delay: 0.3s; }
    .stagger > *:nth-child(5) { animation-delay: 0.4s; }

    /* ─── SCROLL-DRIVEN REVEAL ─── */
    @keyframes revealUp {
      from { opacity: 0; transform: translateY(40px); }
      to   { opacity: 1; transform: translateY(0); }
    }

    .scroll-reveal {
      animation: revealUp linear both;
      animation-timeline: view();
      animation-range: entry 0% entry 40%;
    }

    /* ─── INFINITE ANIMATIONS ─── */
    @keyframes pulse {
      0%, 100% { transform: scale(1); opacity: 1; }
      50%       { transform: scale(1.08); opacity: 0.8; }
    }

    @keyframes float {
      0%, 100% { transform: translateY(0); }
      50%       { transform: translateY(-12px); }
    }

    @keyframes spin {
      to { transform: rotate(360deg); }
    }

    @keyframes shimmer {
      from { background-position: -200% center; }
      to   { background-position: 200% center; }
    }

    @keyframes gradientShift {
      0%   { background-position: 0% 50%; }
      50%  { background-position: 100% 50%; }
      100% { background-position: 0% 50%; }
    }

    /* ─── LOADING SKELETON ─── */
    .skeleton {
      background: linear-gradient(
        90deg,
        rgba(255,255,255,0.05) 25%,
        rgba(255,255,255,0.12) 50%,
        rgba(255,255,255,0.05) 75%
      );
      background-size: 200% 100%;
      animation: shimmer 1.5s infinite;
      border-radius: 8px;
    }

    .skeleton-line { height: 1rem; margin-bottom: 0.5rem; }
    .skeleton-line:last-child { width: 60%; }
    .skeleton-block { height: 120px; margin-bottom: 1rem; }

    /* ─── HOVER EFFECTS ─── */
    .card-hover {
      background: rgba(255,255,255,0.05);
      border: 1px solid rgba(255,255,255,0.1);
      border-radius: 16px;
      padding: 2rem;
      cursor: pointer;
      transition:
        transform 0.25s cubic-bezier(0.34, 1.56, 0.64, 1),
        box-shadow 0.25s ease,
        border-color 0.25s ease;
    }

    .card-hover:hover {
      transform: translateY(-8px);
      box-shadow: 0 20px 40px rgba(108,99,255,0.3);
      border-color: var(--brand);
    }

    /* ─── GRADIENT ANIMATED BACKGROUND ─── */
    .gradient-bg {
      background: linear-gradient(-45deg, #1a1a2e, #6c63ff, #e91e8c, #1a1a2e);
      background-size: 400% 400%;
      animation: gradientShift 8s ease infinite;
      border-radius: 16px;
      padding: 3rem;
      text-align: center;
    }

    /* ─── TYPING EFFECT ─── */
    @keyframes typing {
      from { width: 0; }
      to   { width: 100%; }
    }

    @keyframes blink {
      0%, 100% { border-color: transparent; }
      50%       { border-color: var(--brand); }
    }

    .typing-effect {
      display: inline-block;
      overflow: hidden;
      white-space: nowrap;
      border-right: 3px solid var(--brand);
      animation:
        typing 2s steps(30) 0.5s both,
        blink 0.75s step-end infinite;
      max-width: max-content;
    }

    /* ─── ROTATING BORDER ─── */
    @keyframes rotateBorder {
      to { --angle: 360deg; }
    }

    @property --angle {
      syntax: '<angle>';
      inherits: false;
      initial-value: 0deg;
    }

    .rotating-border {
      border: 3px solid transparent;
      background:
        linear-gradient(var(--dark), var(--dark)) padding-box,
        conic-gradient(from var(--angle), var(--brand), var(--accent), var(--brand)) border-box;
      border-radius: 12px;
      padding: 1.5rem;
      animation: rotateBorder 3s linear infinite;
    }

    /* ─── RESPECT REDUCED MOTION ─── */
    @media (prefers-reduced-motion: reduce) {
      *, *::before, *::after {
        animation-duration: 0.01ms !important;
        animation-iteration-count: 1 !important;
        transition-duration: 0.01ms !important;
      }
    }
  </style>
</head>
<body>

<!-- Section 1: Entrance animations -->
<section>
  <h2>Entrance Animations</h2>
  <div class="stagger" style="display:flex;gap:1rem;flex-wrap:wrap;justify-content:center">
    <div class="card-hover" style="width:160px;text-align:center">
      <div style="font-size:2rem">☕</div>
      <div style="font-weight:700;margin-top:0.5rem">Espresso</div>
    </div>
    <div class="card-hover" style="width:160px;text-align:center">
      <div style="font-size:2rem">🥛</div>
      <div style="font-weight:700;margin-top:0.5rem">Latte</div>
    </div>
    <div class="card-hover" style="width:160px;text-align:center">
      <div style="font-size:2rem">❄️</div>
      <div style="font-weight:700;margin-top:0.5rem">Cold Brew</div>
    </div>
    <div class="card-hover" style="width:160px;text-align:center">
      <div style="font-size:2rem">🌿</div>
      <div style="font-weight:700;margin-top:0.5rem">Matcha</div>
    </div>
  </div>
</section>

<!-- Section 2: Scroll reveal -->
<section>
  <h2>Scroll-Driven Reveal</h2>
  <div style="max-width:600px;display:flex;flex-direction:column;gap:1rem">
    <div class="scroll-reveal card-hover">
      <h3>Ethiopian Yirgacheffe</h3>
      <p style="color:rgba(255,255,255,0.6);margin-top:0.5rem">Blueberry and jasmine. Light roast.</p>
    </div>
    <div class="scroll-reveal card-hover">
      <h3>Colombian Huila</h3>
      <p style="color:rgba(255,255,255,0.6);margin-top:0.5rem">Caramel and citrus. Medium roast.</p>
    </div>
    <div class="scroll-reveal card-hover">
      <h3>Guatemalan Antigua</h3>
      <p style="color:rgba(255,255,255,0.6);margin-top:0.5rem">Dark chocolate. Full body.</p>
    </div>
  </div>
</section>

<!-- Section 3: Skeleton loader -->
<section>
  <h2>Loading Skeleton</h2>
  <div style="width:320px">
    <div class="skeleton skeleton-block"></div>
    <div class="skeleton skeleton-line"></div>
    <div class="skeleton skeleton-line"></div>
    <div class="skeleton skeleton-line"></div>
  </div>
</section>

<!-- Section 4: Animated gradient + typing -->
<section>
  <h2>Text and Gradient Effects</h2>
  <div class="gradient-bg" style="max-width:500px;width:100%">
    <p class="typing-effect" style="font-size:1.25rem;font-weight:700">
      The perfect cup awaits...
    </p>
  </div>
</section>

<!-- Section 5: Rotating border -->
<section>
  <h2>Rotating Border (CSS @property)</h2>
  <div class="rotating-border" style="max-width:300px;text-align:center">
    <div style="font-size:2rem">✨</div>
    <p style="margin-top:0.5rem">Powered by CSS @property</p>
  </div>
</section>

</body>
</html>

📝 KEY POINTS:
✅ Only animate transform and opacity — they are GPU-accelerated
✅ animation-timeline: view() creates scroll-triggered reveals with zero JavaScript
✅ Stagger delays (nth-child + animation-delay) create cascading entrance effects
✅ @property enables animating CSS custom properties (like gradient angles)
✅ prefers-reduced-motion: reduce must disable or minimize all animations
✅ cubic-bezier(0.34, 1.56, 0.64, 1) is a spring easing — natural and satisfying
❌ Never animate layout properties (width, height, margin, top) — they cause reflow
❌ Don't use animations as decoration without purpose — they should communicate
''',
  quiz: [
    Quiz(question: 'Why should you only animate transform and opacity properties?', options: [
      QuizOption(text: 'They are handled by the GPU compositor — no layout or paint recalculation needed', correct: true),
      QuizOption(text: 'They are the only properties that support @keyframes', correct: false),
      QuizOption(text: 'They are faster to write than other properties', correct: false),
      QuizOption(text: 'Other properties cannot be animated in CSS', correct: false),
    ]),
    Quiz(question: 'What does animation-timeline: view() do?', options: [
      QuizOption(text: 'Ties the animation progress to when the element enters and exits the viewport', correct: true),
      QuizOption(text: 'Plays the animation when the user views the page for the first time', correct: false),
      QuizOption(text: 'Loops the animation based on how many views the page has received', correct: false),
      QuizOption(text: 'Triggers the animation when the element becomes visible', correct: false),
    ]),
    Quiz(question: 'What must you always include when using CSS animations?', options: [
      QuizOption(text: 'A @media (prefers-reduced-motion: reduce) rule that disables or minimizes animations', correct: true),
      QuizOption(text: 'A JavaScript fallback for browsers that don\'t support animations', correct: false),
      QuizOption(text: 'will-change on every animated element', correct: false),
      QuizOption(text: 'A vendor prefix for all @keyframes rules', correct: false),
    ]),
  ],
);
